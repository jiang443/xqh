//
//  HomeUnreadCountModel.swift
//  Alamofire
//
//  Created by jiang on 2019/3/28.
//

import Foundation
import HandyJSON

struct HomeUnreadCountModel: HandyJSON {
    ///未处理的报警记录数
    var unHandleSugarWarningCount = 0
    ///最后一条未处理的报警记录的测量时间
    var lastMeasureTime = ""
    ///今日可完成的任务数
    var completableTaskCount = 0
    //今日可完成任务的最大开始时间
    var lastCompletableTaskStartTime = ""
    ///未读的系统消息记录数
    var unreadSystemNoticeCount = 0
    ///最后一条未读的系统消息创建时间
    var lastSystemNoticeTime = ""
    
    ///待处理随访方案数
    var unHandleFollowupPlanCount = 0
    ///最后一条待处理的随访方案的提交时间
    var lastFollowupPlanSubmitTime = ""
    ///待完善资料任务数
    var unCompleteDataTaskCount = 0
    ///最后一条待完善资料任务的创建时间
    var lastCompleteDataTaskCreateTime = ""
    
    /// 报警任务数量
    var unHandleSugarWarningTaskCount = 0
    /// 最后一条报警任务时间
    var lastSugarWarningTaskTime = ""
    
}
