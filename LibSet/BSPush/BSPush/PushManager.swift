//
//  PushManager.swift
//  Rent
//
//  Created by jiang on 2019/3/14.
//  Copyright © 2019 com.tmpName. All rights reserved.
//

import UIKit
import KeychainManager
import BSCommon
import UserNotifications
import SwiftEventBus

public class PushManager: NSObject {
    fileprivate static let mInstance = PushManager()
    fileprivate var aliasReqCount = 0
    fileprivate var tagsReqCount = 0
    let busyCode = [6002,6021,6022,6011,6014,6020]
    
    public static func getInstance() -> PushManager{
        mInstance.aliasReqCount = 0
        mInstance.tagsReqCount = 0
        return mInstance
    }
    
    public class func setupPush(key:String,launchOptions: [AnyHashable: Any]?){
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil))
        UIApplication.shared.registerForRemoteNotifications()
        
//        let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: UIUserNotificationType.badge, categories: nil)
//        UIApplication.shared.registerUserNotificationSettings(settings)
        
        if #available(iOS 8, *) {
            // 可以自定义 categories
            JPUSHService.register(
                forRemoteNotificationTypes: UIUserNotificationType.badge.rawValue |
                    UIUserNotificationType.sound.rawValue |
                    UIUserNotificationType.alert.rawValue,
                categories: nil)
        } else {
            // ios 8 以前 categories 必须为nil
            JPUSHService.register(
                forRemoteNotificationTypes: UIRemoteNotificationType.badge.rawValue |
                    UIRemoteNotificationType.sound.rawValue |
                    UIRemoteNotificationType.alert.rawValue,
                categories: nil)
        }
        
        JPUSHService.setup(withOption: launchOptions, appKey: key, channel: "Production", apsForProduction: true)
    }
    
    public class func removeAllNotifications(){
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            // To remove all pending notifications which are not delivered yet but scheduled.
            center.removeAllPendingNotificationRequests()
            center.removeAllDeliveredNotifications() // To remove all delivered notifications
        } else {
            UIApplication.shared.cancelAllLocalNotifications()
        }
        PushManager.setAppBadge(count: 0)
    }
    
    ///设置APP外部角标
    public class func setAppBadge(count:Int){
        let application = UIApplication.shared
        if application.applicationIconBadgeNumber != count{
            JPUSHService.setBadge(count)
            application.applicationIconBadgeNumber = count
            //SwiftEventBus.post("updateJPushBadge", sender: ["number":count])
        }
    }
    
    ///设置DeviceToken
    public class func registerDeviceToken(_ token:Data){
        JPUSHService.registerDeviceToken(token)
    }
    
    public class func handleRemoteNotification(_ userInfo: [AnyHashable: Any]){
        JPUSHService.handleRemoteNotification(userInfo)
    }
    
    ///设置别名与标签
    public func setAliasTags(){
        let user = UserInfoManager.shareManager().getUserInfo()
        self.setTags(tags: [user.account,"doctor"])
        ThreadUtils.delay(1) {
            //self.setAlias(alias: self.getAliasStr())
            self.setAlias(alias: UserInfoManager.shareManager().pushAlias)
        }
    }
    
    public func getAliasStr() -> String{
        let deviceId = AMKeychainManager.default().getDeviceID()
        return "iOS" + StringUtils.replace(deviceId, oldStr: "-", newStr: "")
    }
    
    ///清空别名与标签
    public func removeAliasTags(){
        self.setAlias(alias: "0")
        self.setTags(tags: ["0"])
    }
    
    ///设置别名
    public func setAlias(alias:String){
        if alias.isEmpty{
            return
        }
        JPUSHService.setAlias(alias, completion: { (resCode, resAlias, seq) in
            self.aliasReqCount = self.aliasReqCount + 1
            if resCode == 0{
                self.aliasReqCount = 0
                print("Set JPush Alias = \(String(describing: resAlias!))")
            }
            else if self.aliasReqCount < 5 && self.busyCode.contains(resCode){
                var timeInterval = 3.0    //若不成功，3秒重复请求一次
                if self.aliasReqCount > 2{
                    timeInterval = 5
                }
                ThreadUtils.delay(timeInterval, closure: {
                    self.setAlias(alias: alias)
                })
            }
            else{
                YYLog(StringUtils.ERROR + "推送消息注册失败")
            }
        }, seq: 0)
    }
    
    ///设置标签
    public func setTags(tags:Set<AnyHashable>){
        if tags.count == 0{
            return
        }
        
        if let validTags = JPUSHService.filterValidTags(tags) as? Set<String>{
            if validTags.count > 0{
                JPUSHService.setTags(validTags, completion: { (resCode, resSet, seq) in
                    self.tagsReqCount = self.tagsReqCount + 1
                    if resCode == 0{
                        self.tagsReqCount = 0
                        print("Set JPush Tags = \(String(describing: resSet!))")
                    }
                    else if self.tagsReqCount < 3 && self.busyCode.contains(resCode){
                        ThreadUtils.delay(3, closure: {
                            self.setTags(tags: tags)
                        })
                    }
                }, seq: 0)
            }
        } //end of validTags
    }
    
    
}


