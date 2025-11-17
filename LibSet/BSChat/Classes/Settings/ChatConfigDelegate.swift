//
//  ChatConfigDelegate.swift
//  AfterDoctor
//
//  Created by jiang on 2018/8/20.
//  Copyright © 2018年 jiang. All rights reserved.
//

import UIKit

class ChatConfigDelegate: NSObject,NIMSDKConfigDelegate {
    
    ///是否需要忽略某类型的通知
    func shouldIgnoreNotification(_ notification: NIMNotificationObject) -> Bool {
        var ignore = false
        let content = notification.content
        if (content is NIMTeamNotificationContent) {
            let typesIgnore = [0,1,2,3]
            let type = (content as! NIMTeamNotificationContent).operationType
            for item in typesIgnore {
                if type.rawValue == item {
                    ignore = true
                    break
                }
            }
        }
        return ignore
    }
    

}
