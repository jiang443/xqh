//
//版权所属：jiang
//文件名称：ChatManager.swift
//代码描述：***
//编程记录：
//[创建][2018/1/8][jiang]:新增文件

import Foundation
import BSCommon
import SwiftEventBus

class ChatManager:NSObject {
    fileprivate static let mInstance = ChatManager()
    fileprivate var aliasReqCount = 0
    fileprivate var tagsReqCount = 0
    let busyCode = [6002,6021,6022,6011,6014,6020]
    
    weak var manager = MainManager.getInstance()
    weak var imConvManager = IMConversationManager.getInstance()
    weak var imSubscribeManager = IMSubscribeManager.getInstance()
    weak var imNotiManager = IMNotificationManager.getInstance()
    
    static func getInstance() -> ChatManager{
        return mInstance
    }
    
    lazy var viewModel: BSChatViewModel = {
        return BSChatViewModel()
    }()
    
    ///从Session中获取User信息
    func getSessionUser(session:NIMSession?) -> NIMKitInfo?{
        let option = NIMKitInfoFetchOption()
        option.session = session
        if let info = NIMKit.shared().info(byUser: session?.sessionId, option: option){
            return info
        }
        return nil
    }
    
    ///创建空白会话
    func createSilentConv(accounts:[String]) {
        for account in accounts{
            let tipMessage = IMSessionMsgConverter.getTipMessgae(tip: "暂无未读消息")
            let setting = NIMMessageSetting()
            setting.shouldBeCounted = false
            tipMessage.setting = setting
            tipMessage.timestamp = TimeInterval(0)
            let session = NIMSession(account, type: .P2P)
            NIMSDK.shared().conversationManager.save(tipMessage, for: session, completion: { (error) in
                if error != nil{
                    print("保存消息错误:: \(accounts.count) \(session.sessionId)" + error!.localizedDescription)
                }
                else{
                    NIMSDK.shared().conversationManager.delete(tipMessage)
                }
            })
            
        }
    }

    ///请求助手列表并创建会话。
    ///共3处调用：1，登录IM账号 2，应用启动  3，应用切换到活动状态
    func createAssistConvs(){
        let manager = UserInfoManager.shareManager()
        if !manager.isLogin(){
            return
        }
        self.viewModel.assistList(callBack: { list in
            self.createConvs(type:0)
        }, failureCallBack: { msg, code in
            YYHUD.showToast(msg)
        })
        
        if manager.getType() == .doctor{
            self.viewModel.upperList(callBack: { list in
                self.createConvs(type: 1)
                SettingUserDefault.setHasUpperDoctor(list.count > 0)
                MainManager.getInstance().chat?.refreshHeader()
            }, failureCallBack: { msg, code in
                YYHUD.showToast(msg)
            })
        }
    }
    
    fileprivate func createConvs(type:Int){
        var accounts = [String]()
        var ids = ""
        var list = [AssistModel]()
        if type == 0{
            list = self.viewModel.assistList
        }
        else if type == 1{
            list = self.viewModel.supperList
        }
        for staff in list{
            if staff.accId.isEmpty{
                self.viewModel.getStaffImAccount(staffId: staff.staffId, callBack: { (imAccId) in
                    var idstr = SettingUserDefault.getAssistAccIds()
                    if idstr.isEmpty{
                        idstr = staff.accId
                    }
                    else{
                        idstr = idstr + "," + staff.accId
                    }
                    if type == 0{
                        SettingUserDefault.setAssistAccIds(idstr)
                    }
                    else if type == 1{
                        SettingUserDefault.setUpperAccIds(idstr)
                    }
                    self.createSilentConv(accounts:[imAccId])
                }) { (msg, code) in
                    YYHUD.showToast(msg)
                }
            }
            else{
                accounts.append(staff.accId)
                if ids.isEmpty{
                    ids = staff.accId
                }
                else{
                    ids = ids + "," + staff.accId
                }
            }
        }
        if type == 0{
            SettingUserDefault.setAssistAccIds(ids)
        }
        else if type == 1{
            SettingUserDefault.setUpperAccIds(ids)
        }
//        self.countUnreadMessage()
        createSilentConv(accounts:accounts)
    }
    
    func createComDirectorConvs(){
        self.viewModel.topContacts(callBack:{ (list:[TopContactModel]) in
            var ids = ""
            for staff in list{
                if staff.staffId.isEmpty{
                    YYLog( StringUtils.ERROR + "staffId不能为空")
                }
                else{
                    self.createSilentConv(accounts:[staff.accId])
                    if ids.isEmpty{
                        ids = staff.staffId
                    }
                    else{
                        ids = ids + ",\(staff.staffId)"
                    }
                }
            }
            SettingUserDefault.setComContactIds(ids)
        }) { (msg, code) in
            YYHUD.showToast(msg)
        }
    }
    
    
    
    ///查询某个员工的im账号
    func getStaffImAccount(staffId:String){
        YYHUD.showStatus("请稍候")
        self.viewModel.getStaffImAccount(staffId: staffId, callBack: { (imAccId) in
            YYHUD.dismiss()
            let accId = imAccId.isEmpty ? "faildId" : imAccId
            SwiftEventBus.post(Event.Chat.openConv.rawValue, userInfo: ["accId":accId,
                                                                        "staffId":staffId])
        }) { (msg, code) in
            YYHUD.dismiss()
            YYHUD.showToast(msg)
        }
    }
    
    ///获取隐藏会话消息数量
    func countHiddenBage() -> Int{
        var res = 0
        if let convs = NIMSDK.shared().conversationManager.allRecentSessions(){
            let assistIds:[String] = SettingUserDefault.getAssistAccIds().components(separatedBy: ",")
            var upperIds:[String] = SettingUserDefault.getUpperAccIds().components(separatedBy: ",")
            upperIds.append(contentsOf: assistIds)
            let ids = upperIds
            let appType = UserInfoManager.shareManager().getType()
            for item:NIMRecentSession in convs{     //只显示用户
                let dict = IMMainManager.getInstance().getUserCard(accId: item.session!.sessionId)
                if dict.intValue(key: "isDeleted") == 1{  //已删除用户
                    res = res + item.unreadCount
                }
                else if (appType == .director) && dict.intValue(key: "userType") != 2 && dict.intValue(key: "businessRoleId") != 5{    //只显示成员员工列表、用户组
                    if !ids.contains(where: { $0 == item.session!.sessionId }){
                        res = res + item.unreadCount
                    }
                }
                else if (appType == .pi) && dict.intValue(key: "businessRoleId") != 5{    //只显示成员员工的列表
                    if !ids.contains(where: { $0 == item.session!.sessionId }){
                        res = res + item.unreadCount
                    }
                }
                else if (appType == .doctor || appType == .nurse) && dict.intValue(key: "userType") != 2 {   //只显示用户的列表
                    if !ids.contains(where: { $0 == item.session!.sessionId }){
                        res = res + item.unreadCount
                    }
                }
            } //end of for
            SettingUserDefault.setHiddenUnreadCount(res)
            //print("Time = \(TimeUtils.getCurrentTimeInterval())")
        }
        return res
    }
    
    
}
