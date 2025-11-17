//
//  Event.swift
//  Rent
//
//  Created by jiang on 2019/3/15.
//  Copyright © 2019 com.tmpName. All rights reserved.
//


public class Event: NSObject {
    public enum Chat:String {
        ///初始化IM
        case setup = "event_chat_setup"
        ///自动登录IM
        case autoLogin = "event_chat_autoLogin"
        ///退出IM
        case imLogout = "event_chat_logout"
        ///打开会话
        case openConv = "event_chat_openConv"
        ///任务积分奖励
        case taskReward = "event_chat_taskReward"
        ///IM状态变化，修改标题提示文字
        case setStatusTip = "event_chat_setStatusTip"
        
    }
    
    public enum Patient:String {
        ///用户详情
        case detail = "event_patient_detail"
        ///用户设置页
        case settings = "event_patient_settings"
    }
    
    public enum Message:String {
        ///打开系统消息模块
        case sysMsg = "event_message_sysMsg"
        ///打开报警模块
        case bsAlert = "event_message_bsAlert"
        ///打开任务中心模块
        case task = "event_message_task"
        ///打开我的助手模块
        case assist = "event_message_assist"
        ///打开完善资料模块
        case completeData = "event_message_completeData"
        case nursingPlan = "event_message_nursingPlan"
        case researchPlan = "event_message_researchPlan"
        case mineUnreadCount = "event_message_mineUnreadCount"
        case getMineUnreadCount = "event_message_getMineUnreadCount"
        ///打开异常用户指导任务
        case unusual = "event_message_unusual"
    }
    
    public enum System:String {
        case timerFired = "event_system_timerFired"
        case timerEnd = "event_system_timerEnd"
        case openUrl = "event_system_openUrl"
        case logout = "event_system_logout"
        case appWillResignActive = "event_system_appWillResignActive"
        case appWillLaunch = "event_system_appWillLaunch"
        case refresUserInfo = "event_system_refresUserInfo"
        case setConfig = "event_system_setConfig"
        
    }
 
}
