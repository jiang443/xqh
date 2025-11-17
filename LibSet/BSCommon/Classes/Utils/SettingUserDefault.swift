//
//  SettingUserDefault.swift
//  Rent
//
//  Created by jiang on 19/3/15.
//  Copyright © 2019年 tmpName. All rights reserved.
//


import Foundation
import SwiftyUserDefaults


public class SettingUserDefault {
    
    fileprivate static let groupDefaults = UserDefaults(suiteName: "com.temp")
    
    public class func getGroupInstance() -> UserDefaults{
        return groupDefaults!
    }
    
    /**
     * 数据库的版本号
     */
    public static func setDatabaseVersion(_ userId:String,version:Int){
        Defaults["DatabaseVersion_" + userId] = version
    }
    
    /**
     * 数据库的版本号
     */
    public static func getDatabaseVersion(_ userId:String) ->Int{
        let has = Defaults.hasKey("DatabaseVersion_" + userId)
        if has {
            let version = Defaults["DatabaseVersion_" + userId].intValue
            return version > 0 ? version : 0
        }else{
            return 0
        }
    }
    
    
    public static func setValue(_ name:String,value:String){
        Defaults[name] = value
    }
    
    public static func getValue(_ name:String)->String{
        let has = Defaults.hasKey(name)
        if has {
            return Defaults[name].stringValue
        }else{
            return ""
        }
    }
    
    public static func setDeviceToken(_ token:String){
        Defaults["DeviceToken"] = token
    }
    
    public static func getDeviceToken()->String{
        let has = Defaults.hasKey("DeviceToken")
        if has {
            return Defaults["DeviceToken"].stringValue
        }else{
            return ""
        }
    }
    
    public static func setShowShare(_ isShow:String){
        Defaults["IsShowShare"] = isShow
    }
    
    public static func getShowShare()->String{
        let has = Defaults.hasKey("IsShowShare")
        if has {
            return Defaults["IsShowShare"].stringValue
        }else{
            return ""
        }
    }
    
    public static func setFistLaunchTime(_ time:String){
        Defaults["FistLaunchTime"] = time
    }
    
    public static func getFistLaunchTime()->String{
        let has = Defaults.hasKey("FistLaunchTime")
        if has {
            return Defaults["FistLaunchTime"].stringValue
        }else{
            return ""
        }
    }
    
    public static func setBSUnreadMessage(_ count:String){
        Defaults["BSUnreadMessage"] = count
    }
    
    public static func getBSUnreadMessage()->String{
        let has = Defaults.hasKey("BSUnreadMessage")
        if has {
            return Defaults["BSUnreadMessage"].stringValue
        }else{
            return ""
        }
    }

    
    public static func setLoginTime(_ time:String){
        Defaults["LoginTime"] = time
    }
    
    public static func getLoginTime()->String{
        let has = Defaults.hasKey("LoginTime")
        if has {
            return Defaults["LoginTime"].stringValue
        }else{
            return ""
        }
    }
    
    public static func setBSUnreadRecord(_ count:Int){
        Defaults["BSUnreadRecord"] = count
    }
    
    public static func getBSUnreadRecord()->Int{
        let has = Defaults.hasKey("BSUnreadRecord")
        if has {
            return Defaults["BSUnreadRecord"].intValue
        }else{
            return 0
        }
    }
    
    public static func setArticleUnreadMessage(_ count:Int){
        let user = UserInfoManager.shareManager().getUserInfo()
        Defaults["ArticleUnreadMessage_\(user.account)"] = count
    }
    
    public static func getArticleUnreadMessage()->Int{
        let user = UserInfoManager.shareManager().getUserInfo()
        let has = Defaults.hasKey("ArticleUnreadMessage_\(user.account)")
        if has {
            return Defaults["ArticleUnreadMessage_\(user.account)"].intValue
        }else{
            return 0
        }
    }
    
    ///助手列表
    public static func setAssistAccIds(_ idStr:String){
        let account = UserInfoManager.shareManager().getUserInfo()
        Defaults["AssistAccIds_\(account.account)"] = idStr
    }
    
    ///助手列表
    public static func getAssistAccIds()->String{
        let account = UserInfoManager.shareManager().getUserInfo()
        let has = Defaults.hasKey("AssistAccIds_\(account.account)")
        if has {
            return Defaults["AssistAccIds_\(account.account)"].stringValue
        }else{
            return ""
        }
    }
    
    ///上级员工列表
    public static func setUpperAccIds(_ idStr:String){
        let account = UserInfoManager.shareManager().getUserInfo()
        Defaults["UpperAccIds_\(account.account)"] = idStr
    }
    
    ///上级员工列表
    public static func getUpperAccIds()->String{
        let account = UserInfoManager.shareManager().getUserInfo()
        let has = Defaults.hasKey("UpperAccIds_\(account.account)")
        if has {
            return Defaults["UpperAccIds_\(account.account)"].stringValue
        }else{
            return ""
        }
    }
    
    /**
     * App活动状态
     */
    public static func setIsActive(_ tag:Bool){
        Defaults["AppIsActive"] = tag
    }
    
    /**
     * App活动状态
     */
    public static func getIsActive()->Bool{
        let has = Defaults.hasKey("AppIsActive")
        if has {
            return Defaults["AppIsActive"].boolValue
        }else{
            return false
        }
    }
    
    public static func setCacheAccount(_ account:String){
        Defaults["CacheAccount"] = account
    }
    
    public static func getCacheAccount()->String{
        let has = Defaults.hasKey("CacheAccount")
        if has {
            return Defaults["CacheAccount"].stringValue
        }else{
            return ""
        }
    }
    
    public static func setCachePassword(_ pwd:String){
        Defaults["CachePassword"] = pwd
    }
    
    public static func getCachePassword()->String{
        let has = Defaults.hasKey("CachePassword")
        if has {
            return Defaults["CachePassword"].stringValue
        }else{
            return ""
        }
    }
    
    public static func setAlarmMsgCount(_ count:Int){
        let user = UserInfoManager.shareManager().getUserInfo()
        Defaults["AlarmMsgCount_\(user.account)"] = count
    }
    
    public static func getAlarmMsgCount()->Int{
        let user = UserInfoManager.shareManager().getUserInfo()
        let has = Defaults.hasKey("AlarmMsgCount_\(user.account)")
        if has {
            return Defaults["AlarmMsgCount_\(user.account)"].intValue
        }else{
            return 0
        }
    }
    
    ///今日可完成的任务数
    public static func setTaskCount(_ count:Int){
        let user = UserInfoManager.shareManager().getUserInfo()
        Defaults["TaskCount_\(user.account)"] = count
    }
    
    ///今日可完成的任务数
    public static func getTaskCount()->Int{
        let user = UserInfoManager.shareManager().getUserInfo()
        let has = Defaults.hasKey("TaskCount_\(user.account)")
        if has {
            return Defaults["TaskCount_\(user.account)"].intValue
        }else{
            return 0
        }
    }
    
    
    public static func setSessionUnreadCount(_ count:Int){
        let user = UserInfoManager.shareManager().getUserInfo()
        Defaults["SessionUnreadCount_\(user.account)"] = count
    }
    
    public static func getSessionUnreadCount()->Int{
        let user = UserInfoManager.shareManager().getUserInfo()
        let has = Defaults.hasKey("SessionUnreadCount_\(user.account)")
        if has {
            return Defaults["SessionUnreadCount_\(user.account)"].intValue
        }else{
            return 0
        }
    }
    
    public static func setHiddenUnreadCount(_ count:Int){
        let user = UserInfoManager.shareManager().getUserInfo()
        Defaults["HiddenUnreadCount_\(user.account)"] = count
    }
    
    public static func getHiddenUnreadCount()->Int{
        let user = UserInfoManager.shareManager().getUserInfo()
        let has = Defaults.hasKey("HiddenUnreadCount_\(user.account)")
        if has {
            return Defaults["HiddenUnreadCount_\(user.account)"].intValue
        }else{
            return 0
        }
    }
    
    public static func setSystemMsgCount(_ count:Int){
        let user = UserInfoManager.shareManager().getUserInfo()
        Defaults["SystemMsgCount_\(user.account)"] = count
    }
    
    public static func getSystemMsgCount()->Int{
        let user = UserInfoManager.shareManager().getUserInfo()
        let has = Defaults.hasKey("SystemMsgCount_\(user.account)")
        if has {
            return Defaults["SystemMsgCount_\(user.account)"].intValue
        }else{
            return 0
        }
    }
    
    ///待处理随访方案数
    public static func setResearchPlanCount(_ count:Int){
        let user = UserInfoManager.shareManager().getUserInfo()
        Defaults["ResearchPlanCount_\(user.account)"] = count
    }
    
    //待处理随访方案数
    public static func getResearchPlanCount()->Int{
        let user = UserInfoManager.shareManager().getUserInfo()
        let has = Defaults.hasKey("ResearchPlanCount_\(user.account)")
        if has {
            return Defaults["ResearchPlanCount_\(user.account)"].intValue
        }else{
            return 0
        }
    }
    
    ///待完善资料任务数
    public static func setCompleteDataTaskCount(_ count:Int){
        let user = UserInfoManager.shareManager().getUserInfo()
        Defaults["CompleteDataTaskCount_\(user.account)"] = count
    }
    
    ///待完善资料任务数
    public static func getCompleteDataTaskCount()->Int{
        let user = UserInfoManager.shareManager().getUserInfo()
        let has = Defaults.hasKey("CompleteDataTaskCount_\(user.account)")
        if has {
            return Defaults["CompleteDataTaskCount_\(user.account)"].intValue
        }else{
            return 0
        }
    }
    
    ///是否有上级员工
    public static func setHasUpperDoctor(_ val:Bool){
        let user = UserInfoManager.shareManager().getUserInfo()
        Defaults["HasUpperDoctor_\(user.account)"] = val
    }
    
    ///是否有上级员工
    public static func getHasUpperDoctor()->Bool{
        let user = UserInfoManager.shareManager().getUserInfo()
        let has = Defaults.hasKey("HasUpperDoctor_\(user.account)")
        if has {
            return Defaults["HasUpperDoctor_\(user.account)"].boolValue
        }else{
            return false
        }
    }
    
    ///待处理的报警任务数量
    public static func setUnusualTaskCount(_ count:Int){
        let user = UserInfoManager.shareManager().getUserInfo()
        Defaults["UnusualTaskCount\(user.account)"] = count
    }
    
    ///待处理的报警任务数量
    public static func getUnusualTaskCount()->Int{
        let user = UserInfoManager.shareManager().getUserInfo()
        let has = Defaults.hasKey("UnusualTaskCount\(user.account)")
        if has {
            return Defaults["UnusualTaskCount\(user.account)"].intValue
        }else{
            return 0
        }
    }

    /// 社区联系人列表
    public static func setComContactIds(_ idStr:String){
        let account = UserInfoManager.shareManager().getUserInfo()
        Defaults["ComContactIds_\(account.account)"] = idStr
    }

    ///社区联系人列表
    public static func getComContactIds()->String{
        let account = UserInfoManager.shareManager().getUserInfo()
        let has = Defaults.hasKey("ComContactIds_\(account.account)")
        if has {
            return Defaults["ComContactIds_\(account.account)"].stringValue
        }else{
            return ""
        }
    }
    
}

