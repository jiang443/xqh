//
//  IMSubscribeManager.swift
//  AfterDoctor
//
//  Created by jiang on 2018/8/30.
//  Copyright © 2018年 jiang. All rights reserved.
//

import UIKit
import BSCommon
import Alamofire
import SwiftEventBus

class IMSubscribeManager: NSObject,
    NIMEventSubscribeManagerDelegate,
    NIMConversationManagerDelegate,
    NIMLoginManagerDelegate,
    NIMUserManagerDelegate {
    
    var events = [Int:[NIMSubscribeEvent:String]]()
    var tempSubscribeIds = NSMutableSet()
    
    fileprivate static let thisInstance = IMSubscribeManager()
    
    static func getInstance() -> IMSubscribeManager{
        return thisInstance
    }
    
    override init() {
        super.init()
        self.setConfig()
    }
    
    deinit {
        NIMSDK.shared().subscribeManager.remove(self)
        NIMSDK.shared().conversationManager.remove(self)
        NIMSDK.shared().userManager.remove(self)
    }
    
    func cleanCache() {
        //        subscribeIds.removeAll()
        //        tempSubscribeIds.removeAll()
        events.removeAll()
    }
    
    func setConfig(){
        NIMSDK.shared().conversationManager.add(self)
        NIMSDK.shared().subscribeManager.add(self)
        NIMSDK.shared().loginManager.add(self)
        NIMSDK.shared().userManager.add(self)
    }
    
    func events(forType type: Int) -> [NIMSubscribeEvent : String]? {
        return events[type]
    }
    
    func subscribeTempUserOnlineState(_ userId: String) {
        let isRobot = NIMSDK.shared().robotManager.isValidRobot(userId)
        let isMe = NIMSDK.shared().loginManager.currentAccount() == userId
        if isRobot || isMe {
            print("user can not subscribe temp publisher: %@", userId)
            //自己或者机器人，则不需要订阅
            return
        }
        let request: NIMSubscribeRequest = generateRequest()
        request.publishers = [userId]
        tempSubscribeIds.add(userId)
        NIMSDK.shared().subscribeManager.subscribeEvent(request) { error, failedPublishers in
            print("subscribe temp publisher:%@ error: %@  failed publishers: %@", request.publishers, error, failedPublishers)
        }
        
    }
    
    func unsubscribeTempUserOnlineState(_ userId: String) {
        if !tempSubscribeIds.contains(userId) {
            //如果这个人没有订阅
            let request: NIMSubscribeRequest = generateRequest()
            request.publishers = [userId]
            NIMSDK.shared().subscribeManager.unSubscribeEvent(request) { error, failedPublishers in
                print("unSubscribe temp publisher:%@ error: %@  failed publishers: %@", request.publishers, error, failedPublishers)
            }
            self.tempSubscribeIds.remove(userId)
        }
    }
    
    
    
    // MARK: - NIMConversationManagerDelegate
    func didAdd(_ recentSession: NIMRecentSession, totalUnreadCount: Int) {
        if recentSession.session!.sessionType == NIMSessionType.P2P {
            let request = generateRequest()
            request.publishers = [recentSession.session!.sessionId]
            NIMSDK.shared().subscribeManager.subscribeEvent(request) { error, failedPublishers in
                print("subscribe publisher: %@ error: %@", request.publishers, error)
            }
        }
        
        SettingUserDefault.setSessionUnreadCount(totalUnreadCount)
        MainManager.getInstance().updateHomeBadge()
    }
    
    func didUpdate(_ recentSession: NIMRecentSession, totalUnreadCount: Int) {
        SettingUserDefault.setSessionUnreadCount(totalUnreadCount)
        MainManager.getInstance().updateHomeBadge()
    }
    
    func didRemove(_ recentSession: NIMRecentSession, totalUnreadCount: Int) {
        SettingUserDefault.setSessionUnreadCount(totalUnreadCount)
        MainManager.getInstance().updateHomeBadge()
    }
    
    func messagesDeleted(in session: NIMSession) {
        let count = NIMSDK.shared().conversationManager.allUnreadCount()
        SettingUserDefault.setSessionUnreadCount(count)
        MainManager.getInstance().updateHomeBadge()
    }
    
    func allMessagesDeleted() {
        SettingUserDefault.setSessionUnreadCount(0)
        MainManager.getInstance().updateHomeBadge()
    }
    
    func allMessagesRead() {
        SettingUserDefault.setSessionUnreadCount(0)
        MainManager.getInstance().updateHomeBadge()
        //s
    }
    
    
    // MARK: - NIMLoginManagerDelegate
    func onLogin(_ step: NIMLoginStep) {
        if step == NIMLoginStep.linking {   //开始连接服务器
            cleanCache()
        }
        if step == NIMLoginStep.syncOK {    //同步服务器数据完成
            MainManager.getInstance().chat?.refresh()
            IMMainManager.getInstance().refreshRecentUserInfo()
            ChatManager.getInstance().createAssistConvs()
        }
        self.refreshNetStatus(step)
    }
    
    func refreshNetStatus(_ step: NIMLoginStep){
        var text = ""
        switch step {
        case NIMLoginStep.linkFailed, .loseConnection, .loginFailed:
            text = "未连接"
        case NIMLoginStep.linking:
            text = "连接中..."
        case NIMLoginStep.netChanged:
            let reachable = NetworkReachabilityManager(host: "https://www.baidu.com")!.isReachable
            if reachable {
                text = "连接中..."
            } else {
                text = "当前网络不可用"
            }
        case NIMLoginStep.logining, .linkOK, .syncing:
            text = "登录中..."
        default:
            break
        }
        SwiftEventBus.post(Event.Chat.setStatusTip.rawValue, userInfo: ["text":text])
    }
    
    func onAutoLoginFailed(_ error: Error) {
        print(StringUtils.ERROR + "IM AutoLogin Failed!\t" + error.localizedDescription)
    }
    
    //    // MARK: - NIMUserManagerDelegate
    //    func onFriendChanged(_ user: NIMUser) {
    //        let isMyFriend = NIMSDK.sharedSDK().userManager.isMyFriend(user.userId!)
    //        if let anId = user.userId {
    //            if isMyFriend && !subscribeIds.contains(anId) {
    //                //是好友却没订阅，订阅一下
    //                let request: NIMSubscribeRequest? = generateRequest()
    //                request?.publishers = [user?.userId]
    //                NIMSDK.sharedSDK().subscribeManager.subscribeEvent(request) { error, failedPublishers in
    //                    if error == nil {
    //                        self.subscribeIds.append(anId)
    //                    }
    //                    DDLogInfo("subscribe publisher: %@ error: %@", request?.publishers, error)
    //                }
    //            }
    //        }
    //        if let anId = user?.userId {
    //            if !isMyFriend && !recentSessionUserIds.contains(anId) {
    //                //不再是好友，从订阅集里删掉，等到下次服务器下发订阅事件，再反订阅即可
    //                while let elementIndex = subscribeIds.index(of: anId) { subscribeIds.remove(at: elementIndex) }
    //            }
    //        }
    //    }
    
    //// MARK: - NIMEventSubscribeManagerDelegate
    //func onRecvSubscribeEvents(_ events: [Any]) {
    //    var unSubscribeUsers: [AnyHashable] = []
    //    for event: NIMSubscribeEvent in events as! [NIMSubscribeEvent] {
    //        if let aFrom = event.from {
    //            if subscribeIds.contains(aFrom) || tempSubscribeIds.contains(aFrom) {
    //                let type = event.type
    //                var eventsDict = self.events[type] as! [AnyHashable : Any]
    //                if eventsDict == nil {
    //                    eventsDict = [AnyHashable : Any]()
    //                    self.events[type] = eventsDict
    //                }
    //                let oldEvent = eventsDict[event.from] as! NIMSubscribeEvent
    //                if oldEvent?.timestamp > event.timestamp {
    //
    //
    
    
    // MARK: - Private
    func generateRequest() -> NIMSubscribeRequest {
        let request = NIMSubscribeRequest()
        request.type = NIMSubscribeSystemEventType.online.rawValue
        request.expiry = 60 * 60 * 24 * 1   //1 day
        request.syncEnabled = true
        return request
    }
    
    func recentSessionUserIds() -> Set<AnyHashable>? {
        var ids: Set<AnyHashable> = []
        let me = NIMSDK.shared().loginManager.currentAccount()
        if let sessions = NIMSDK.shared().conversationManager.allRecentSessions(){
            for recent: NIMRecentSession in sessions {
                let isRobot = NIMSDK.shared().robotManager.isValidRobot(recent.session!.sessionId)
                if recent.session!.sessionType == NIMSessionType.P2P && !isRobot && !(recent.session!.sessionId == me) {
                    ids.insert(recent.session!.sessionId)
                }
            }
        }
        return ids
    }
    
    func contactUserIds() -> Set<AnyHashable> {
        var ids: Set<AnyHashable> = []
        if let friends = NIMSDK.shared().userManager.myFriends(){
            for user: NIMUser in friends{
                ids.insert(user.userId!)
            }
        }
        return ids
    }
    
}

//extension NIMSessionMsgDatasource{
//    //- (void)resetMessages:(void(^)(NSError *error)) handler;
//    open func resetMessages(handler:@escaping ((Error) -> Void)){
//        //- (void)loadHistoryMessagesWithComplete:(void(^)(NSInteger index, NSArray *messages , NSError *error))handler
//        let v = self.items
//        self.loadHistoryMessages { (index, messages, error) in
//            if error != nil{
//                handler(error!)
//            }
//        }
//    }
//}

