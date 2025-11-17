//
//  IMNotificationManager.swift
//  AfterDoctor
//
//  Created by jiang on 2018/9/5.
//  Copyright © 2018年 jiang. All rights reserved.
//

import UIKit
import SwiftyJSON
import BSCommon

class IMNotificationManager: NSObject,NIMSystemNotificationManagerDelegate,NIMChatManagerDelegate,NIMBroadcastManagerDelegate {
    
    fileprivate static let thisInstance = IMNotificationManager()
    
    static func getInstance() -> IMNotificationManager{
        return thisInstance
    }
    
    override init() {
        super.init()
        self.setConfig()
    }
    
    func setConfig(){
        NIMSDK.shared().chatManager.add(self)
        NIMSDK.shared().systemNotificationManager.add(self)
        NIMSDK.shared().broadcastManager.add(self)
    }
    
    func onRecvMessages(_ messages: [NIMMessage]) {
        if messages.count > 0{
            self.checkMessage(at: messages)
        }
    }
    
    func checkMessage(at messages: [NIMMessage]) {
        if messages.count == 0{
            return
        }
//        if UIUtils.getCurrentVC() is NIMSessionViewController{
//            return
//        }
        //一定是同个session 的消息
        if let session = messages.first?.session{
            if let recent = NIMSDK.shared().conversationManager.recentSession(by: session) as? NIMRecentSession{
                NIMSDK.shared().conversationManager.updateRecentLocalExt(nil, recentSession: recent)
            }
        }
    }



    
    //MARK: NIMBroadcastManagerDelegate
    func onReceive(_ broadcastMessage: NIMBroadcastMessage) {
        if broadcastMessage.content != nil{
            YYHUD.showToast(broadcastMessage.content!)
        }
    }
    
    //MARK: NIMSystemNotificationManagerDelegate
    func onReceive(_ notification: NIMCustomSystemNotification) {
        if let content = notification.content as? String{
            let json = JSON.init(parseJSON: content)
            //NTESCommandTyping:1   NTESCustom:2    NTESTeamMeetingCall:3
            let notifyId = json["id"].intValue
            if notifyId == 2{
                print("==== IM CustomSystemNoti 自定义消息:\n \(notification.content)")
            }
            else if notifyId == 1{
                print("==== IM CustomSystemNoti 正在输入中:\n \(notification.content)")
            }
        }
    }
    
    func onRecvRevokeMessageNotification(_ notification: NIMRevokeMessageNotification) {
        let tipMessage = IMSessionMsgConverter.getTipMessgae(tip: IMUtil.tip(onMessageRevoked: notification))
        let setting = NIMMessageSetting()
        setting.shouldBeCounted = false
        tipMessage.setting = setting
        tipMessage.timestamp = notification.timestamp
        
        if let sessionVc =  UIUtils.getCurrentVC() as? NIMSessionViewController{
            if sessionVc.session.sessionId == notification.session.sessionId{
                if (sessionVc.uiDelete(notification.message)) != nil{
                    sessionVc.uiInsertMessages([tipMessage])
                }
            }
        }
        // saveMessage 方法执行成功后会触发 onRecvMessages: 回调，但是这个回调上来的 NIMMessage 时间为服务器时间，和界面上的时间有一定出入，所以要提前先在界面上插入一个和被删消息的界面时间相符的 Tip, 当触发 onRecvMessages: 回调时，组件判断这条消息已经被插入过了，就会忽略掉。
        NIMSDK.shared().conversationManager.save(tipMessage, for: notification.session, completion: nil)
    }
    
//    func send(_ message: NIMMessage, didCompleteWithError error: Error?) {
//        print("hello")
//    }
    

}
