//
//  NIMConversationManager.swift
//  AfterDoctor
//
//  Created by jiang on 2018/8/30.
//  Copyright © 2018年 jiang. All rights reserved.
//

import UIKit
import BSCommon

class IMConversationManager: NSObject,NIMConversationManagerDelegate {
    
    fileprivate static let thisInstance = IMConversationManager()
    
    static func getInstance() -> IMConversationManager{
        return thisInstance
    }
    
    override init() {
        super.init()
        self.setConfig()
    }
    
    func setConfig(){
        NIMSDK.shared().conversationManager.add(self)
    }
    
    // MARK: - NIMConversationManagerDelegate
    func didAdd(_ recentSession: NIMRecentSession, totalUnreadCount: Int) {
        SettingUserDefault.setSessionUnreadCount(totalUnreadCount)
        MainManager.getInstance().updateHomeBadge()
    }
    
    func didUpdate(_ recentSession: NIMRecentSession, totalUnreadCount: Int) {
        MainManager.getInstance().chat?.refresh()
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
    }

}
