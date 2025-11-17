//
//  SettingUserDefault.swift
//  Rent
//
//  Created by jiang on 19/3/15.
//  Copyright © 2019年 tmpName. All rights reserved.
//


import Foundation
import SwiftyUserDefaults
import BSCommon

class SettingUserDefault {
    
    fileprivate static let groupDefaults = UserDefaults(suiteName: "com.temp")
    
    class func getGroupInstance() -> UserDefaults{
        return groupDefaults!
    }
    
    /**
     * 数据库的版本号
     */
    static func setDatabaseVersion(_ userId:String,version:Int){
        Defaults["DatabaseVersion_" + userId] = version
    }
    
    /**
     * 数据库的版本号
     */
    static func getDatabaseVersion(_ userId:String) ->Int{
        let has = Defaults.hasKey("DatabaseVersion_" + userId)
        if has {
            let version = Defaults["DatabaseVersion_" + userId].intValue
            return version > 0 ? version : 0
        }else{
            return 0
        }
    }
    
    
    static func setValue(_ name:String,value:String){
        Defaults[name] = value
    }
    
    static func getValue(_ name:String)->String{
        let has = Defaults.hasKey(name)
        if has {
            return Defaults[name].stringValue
        }else{
            return ""
        }
    }
    
    static func setDeviceToken(_ token:String){
        Defaults["DeviceToken"] = token
    }
    
    static func getDeviceToken()->String{
        let has = Defaults.hasKey("DeviceToken")
        if has {
            return Defaults["DeviceToken"].stringValue
        }else{
            return ""
        }
    }
    
    
    static func setShowShare(_ isShow:String){
        Defaults["IsShowShare"] = isShow
    }
    
    static func getShowShare()->String{
        let has = Defaults.hasKey("IsShowShare")
        if has {
            return Defaults["IsShowShare"].stringValue
        }else{
            return ""
        }
    }
    
    static func setFistLaunchTime(_ time:String){
        Defaults["FistLaunchTime"] = time
    }
    
    static func getFistLaunchTime()->String{
        let has = Defaults.hasKey("FistLaunchTime")
        if has {
            return Defaults["FistLaunchTime"].stringValue
        }else{
            return ""
        }
    }
    
    static func setProtocolAgreed(_ str:String){
        Defaults["ProtocolAgreed"] = str
    }
    
    static func getProtocolAgreed()->String{
        let has = Defaults.hasKey("ProtocolAgreed")
        if has {
            return Defaults["ProtocolAgreed"].stringValue
        }else{
            return ""
        }
    }
    
    static func setLoginTime(_ time:String){
        Defaults["LoginTime"] = time
    }
    
    static func getLoginTime()->String{
        let has = Defaults.hasKey("LoginTime")
        if has {
            return Defaults["LoginTime"].stringValue
        }else{
            return ""
        }
    }
    
    
    static func setBSUnreadRecord(_ count:Int){
        Defaults["BSUnreadRecord"] = count
    }
    
    static func getBSUnreadRecord()->Int{
        let has = Defaults.hasKey("BSUnreadRecord")
        if has {
            return Defaults["BSUnreadRecord"].intValue
        }else{
            return 0
        }
    }
    
    static func setArticleUnreadMessage(_ count:Int){
        Defaults["ArticleUnreadMessage"] = count
    }
    
    static func getArticleUnreadMessage()->Int{
        let has = Defaults.hasKey("ArticleUnreadMessage")
        if has {
            return Defaults["ArticleUnreadMessage"].intValue
        }else{
            return 0
        }
    }
    
    public static func setSystemMsgCount(_ count:Int){
        let user = UserInfoManager.shareManager().getUserInfo()
        Defaults["SystemMsgCount_\(user.phone)"] = count
    }
    
    public static func getSystemMsgCount()->Int{
        let user = UserInfoManager.shareManager().getUserInfo()
        let has = Defaults.hasKey("SystemMsgCount_\(user.phone)")
        if has {
            return Defaults["SystemMsgCount_\(user.phone)"].intValue
        }else{
            return 0
        }
    }
    
    /**
     * App活动状态
     */
    static func setIsActive(_ tag:Bool){
        Defaults["AppIsActive"] = tag
    }
    
    /**
     * App活动状态
     */
    static func getIsActive()->Bool{
        let has = Defaults.hasKey("AppIsActive")
        if has {
            return Defaults["AppIsActive"].boolValue
        }else{
            return false
        }
    }
    
    static func setCacheAccount(_ account:String){
        Defaults["CacheAccount"] = account
    }
    
    static func getCacheAccount()->String{
        let has = Defaults.hasKey("CacheAccount")
        if has {
            return Defaults["CacheAccount"].stringValue
        }else{
            return ""
        }
    }
    
    static func setCachePassword(_ pwd:String){
        Defaults["CachePassword"] = pwd
    }
    
    static func getCachePassword()->String{
        let has = Defaults.hasKey("CachePassword")
        if has {
            return Defaults["CachePassword"].stringValue
        }else{
            return ""
        }
    }
    
    static func setGuideShowed(_ val:Bool){
        Defaults["GuideShowed_\(IOSUtils.getAppVersion())"] = val
    }
    
    static func getGuideShowed()->Bool{
        let key = "GuideShowed_\(IOSUtils.getAppVersion())"
        let has = Defaults.hasKey(key)
        if has {
            return Defaults[key].boolValue
        }else{
            return false
        }
    }
    
    
}



