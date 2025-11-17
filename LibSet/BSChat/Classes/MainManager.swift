///
//  MainManager.swift
//  XQH
//  公共函数管理类
//
//  Created by jiang on 2019/8/8.
//  Copyright © 2020年 tmpName. All rights reserved.
//

import UIKit
import SwiftyJSON
import BSCommon
import SwiftEventBus
import MGJRouter
import Alamofire
import YYReach
import BSPush

public class MainManager:NSObject {
    fileprivate static let thisInstance = MainManager()
    var chat:BaseChatListViewController?
    var user = UserInfoManager.shareManager().getUserInfo()
    
    lazy var viewModel: BSChatViewModel = {
        return BSChatViewModel()
    }()
    
    public override init() {
        super.init()
    }

    public class func getInstance() -> MainManager{
        return thisInstance
    }
    
    func register(){
        self.registerEvents()
        
        NIMSessionMsgDatasource.yy_swizzle()
    }
    
    func registerEvents(){
        MGJRouter.registerURLPattern("bsm://chatList") { (routerParameters:[AnyHashable:Any]?) -> Any? in
            var listVc = BaseChatListViewController()
            switch UserInfoManager.shareManager().getType(){
                case .doctor:
                    listVc = DoctorChatListViewController()
                case .nurse:
                    listVc = NurseChatListViewController()
                case .director:
                    listVc = DirectorChatListViewController()
                case .pi:
                    listVc = PIChatListViewController()
                case .comDirector:
                    listVc = ComDirectorChatListViewController()
                case .comNurse:
                    listVc = ComNurseChatListViewController()
                default:break
            }

            self.chat = listVc
            return listVc
        }
        
        SwiftEventBus.onMainThread(self, name: Event.Chat.setup.rawValue) { (notification) in
            if let dict = notification?.userInfo as? [String:Any]{
                let appSecret = dict.stringValue(key: "AppSecret")
                let appKey = dict.stringValue(key: "AppKey")
                //let cerName = dict.stringValue(key: "CerName")
                let instance = IMMainManager.getInstance()
                instance.kNIMAppKey = appKey
                instance.kNIMAppSecret = appSecret
                instance.setupNIMSDK()
            }
        }
        
        SwiftEventBus.onMainThread(self, name: Event.Chat.autoLogin.rawValue) { (notification) in
            IMMainManager.getInstance().autoLogin()
        }
        
        SwiftEventBus.onMainThread(self, name: Event.Chat.imLogout.rawValue) { (notification) in
            IMMainManager.getInstance().imLogout()
        }
        
        SwiftEventBus.onMainThread(self, name: Event.Chat.openConv.rawValue) { (notification) in
            if let dict = notification?.userInfo as? [String:Any]{
                let accId = dict.stringValue(key: "accId")
                if accId.isEmpty {
                    let staffId = dict.stringValue(key: "staffId")
                    if !staffId.isEmpty{    //只有员工Id，无AccId
                        ChatManager.getInstance().getStaffImAccount(staffId:staffId)
                        return
                    }
                    else{
                        YYHUD.showToast("imAccId为空，请重试")
                        return
                    }
                }
                else if accId == "failedId"{
                    YYHUD.showToast("获取imAccId失败，请重试")
                    return
                }
                var model = ConvStateModel()
                model.getDataFrom(dict)

                if dict.hasKey("userType"){
                    SessionManager.getInstance().openSession(model: model)
                }
                else{
                    YYHUD.showStatus("请稍候")
                    IMMainManager.getInstance().fetchUserInfo(userIds: [accId], complete:{
                        YYHUD.dismiss()
                        SessionManager.getInstance().openSession(model: model)
                    })
                }
            }
        }
        
        SwiftEventBus.onMainThread(self, name: Event.System.timerFired.rawValue) { (noti) in
//            ThreadUtils.delay(0.5, closure: {
//                self.getMessageUnreadCount()
//            })
        }
        
        SwiftEventBus.onMainThread(self, name: Event.Message.getMineUnreadCount.rawValue) { (noti) in
//            self.getMessageUnreadCount()
        }

        SwiftEventBus.onMainThread(self, name: Event.System.appWillLaunch.rawValue) { (notification) in
            ChatManager.getInstance().createAssistConvs()
            ChatManager.getInstance().createComDirectorConvs()
        }

    }
    
    func updateHomeBadge(){
        let account = UserInfoManager.shareManager().getUserInfo()
        let sysCount = SettingUserDefault.getSystemMsgCount()
        let taskCount = SettingUserDefault.getTaskCount()
        let bsAlarmCount = SettingUserDefault.getAlarmMsgCount()
        let messageCount = SettingUserDefault.getSessionUnreadCount()
        let researchPlanCount = SettingUserDefault.getResearchPlanCount()
        let completeDataTaskCount = SettingUserDefault.getCompleteDataTaskCount()
        let articleCount = SettingUserDefault.getArticleUnreadMessage()
        let hiddenCount = ChatManager.getInstance().countHiddenBage()
        let bsUnhandledCount = SettingUserDefault.getBSUnreadRecord()
        let unusualTaskCount = SettingUserDefault.getUnusualTaskCount()
        //NIMSDK.shared().conversationManager.allUnreadCount()
        var totalcount = 0
        totalcount = messageCount + taskCount + bsAlarmCount + researchPlanCount + completeDataTaskCount + unusualTaskCount - hiddenCount
        
        self.chat?.navigationController?.tabBarItem.badgeValue = totalcount.getBadge()
        if UserInfoManager.shareManager().getType() == .doctor{
            if let vcs = UIUtils.getCurrentVC()?.tabBarController?.viewControllers{
                var count = sysCount + articleCount
                vcs.last?.tabBarItem.badgeValue = count.getBadge()
                if vcs.count > 3{
                    vcs[3].tabBarItem.badgeValue = bsUnhandledCount.getBadge()
                }
            }
            PushManager.setAppBadge(count: totalcount + sysCount + articleCount)
        }
        else{
            if let vc = UIUtils.getCurrentVC()?.tabBarController?.viewControllers?.last{
                vc.tabBarItem.badgeValue = sysCount.getBadge()
            }
            PushManager.setAppBadge(count: totalcount + sysCount)
        }
        
    }
    
    //未读消息数量(alert/system)
    public func getMessageUnreadCount(){
        self.updateHomeBadge()
        if UserInfoManager.shareManager().isLogin(){
            // 1.首页未读任务、消息数量
            self.viewModel.homeUnreadCount(callBack: { (model) in
                SettingUserDefault.setAlarmMsgCount(model.unHandleSugarWarningCount)
                SettingUserDefault.setTaskCount(model.completableTaskCount)
                SettingUserDefault.setSystemMsgCount(model.unreadSystemNoticeCount)
                SettingUserDefault.setResearchPlanCount(model.unHandleFollowupPlanCount)
                SettingUserDefault.setCompleteDataTaskCount(model.unCompleteDataTaskCount)
                SettingUserDefault.setUnusualTaskCount(model.unHandleSugarWarningTaskCount)
                self.updateHomeBadge()
                if let listVc = self.chat as? DoctorChatListViewController{
                    listVc.updateAlarmBadge(model.unHandleSugarWarningCount, time: model.lastMeasureTime)
                    listVc.updateTaskBadge(model.completableTaskCount, time: model.lastCompletableTaskStartTime)
                    SwiftEventBus.post(Event.Message.mineUnreadCount.rawValue)
                }
                else if let listVc = self.chat as? NurseChatListViewController{
                    listVc.updateCompleteDataBadge(model.unCompleteDataTaskCount, time: model.lastCompleteDataTaskCreateTime)
                    listVc.updateNursingPlanBadge(model.unHandleFollowupPlanCount, time: model.lastFollowupPlanSubmitTime)
                    SwiftEventBus.post(Event.Message.mineUnreadCount.rawValue)
                }
                else if let listVc = self.chat as? DirectorChatListViewController{
                    listVc.updateUnusualTaskBadge(model.unHandleSugarWarningTaskCount, time: self.nimTimeStr(timeStr: model.lastSugarWarningTaskTime))
                    listVc.updateResearchPlanBadge(model.unHandleFollowupPlanCount, time: self.nimTimeStr(timeStr: model.lastFollowupPlanSubmitTime))
                    SwiftEventBus.post(Event.Message.mineUnreadCount.rawValue)
                }
                else if let listVc = self.chat as? PIChatListViewController{
                    listVc.updateResearchPlanBadge(model.unHandleFollowupPlanCount, time: model.lastFollowupPlanSubmitTime)
                    SwiftEventBus.post(Event.Message.mineUnreadCount.rawValue)
                }
                else if let listVc = self.chat as? ComDirectorChatListViewController{
                    listVc.updateResearchPlanBadge(model.unHandleFollowupPlanCount, time: model.lastFollowupPlanSubmitTime)
                    SwiftEventBus.post(Event.Message.mineUnreadCount.rawValue)
                }
                else if let listVc = self.chat as? NurseChatListViewController{
                    listVc.updateCompleteDataBadge(model.unCompleteDataTaskCount, time: model.lastCompleteDataTaskCreateTime)
                    listVc.updateNursingPlanBadge(model.unHandleFollowupPlanCount, time: model.lastFollowupPlanSubmitTime)
                    SwiftEventBus.post(Event.Message.mineUnreadCount.rawValue)
                }
            }) { (msg, code) in
                YYLog(StringUtils.ERROR + msg)
            }
        }
        
        if UserInfoManager.shareManager().getType() == .doctor{
            // 2.用户圈未读消息
            self.viewModel.unreadCount(callBack: { (count) in
                //YYLog("\(self.circleViewModel.unreadCount)")
                SettingUserDefault.setArticleUnreadMessage(count)
                self.updateHomeBadge()
                SwiftEventBus.post(Event.Message.mineUnreadCount.rawValue)
            }) { (msg, code) in
                YYHUD.showToast(msg)
            }
            
            // 3.未处理记录数量
            self.viewModel.countUnhandleMeasure(successCallBack: {
                SettingUserDefault.setBSUnreadRecord(self.viewModel.unHandleMeasureCount)
                self.updateHomeBadge()
            }) { (msg,code) in
                YYHUD.showToast(msg)
            }
        }
        else if UserInfoManager.shareManager().getType() == .comNurse{
            // 待处理的报警任务数量
            let endDate = TimeUtils.getCurrentTimeString("yyyy-MM-dd HH:mm:ss")
            self.viewModel.getComNurseCompleteDataCount(beginDate: "2019-01-01 00:00:00", endDate: endDate, callBack: { (count) in
                SettingUserDefault.setCompleteDataTaskCount(count)
                self.updateHomeBadge()
                if let listVc = self.chat as? ComNurseChatListViewController{
                    listVc.updateCompleteDataBadge(count, time: "")
                }
            }) { (msg, code) in
                YYHUD.showToast(msg)
            }
        }
        
    }
    
    /// NIM格式时间
    func nimTimeStr(timeStr:String) -> String{
        let interval = TimeUtils.getTimeInterval(dataStr: timeStr, format: "yyyy-MM-dd HH:mm:ss")
        return NIMKitUtil.showTime(TimeInterval(interval), showDetail: false)
    }
}


