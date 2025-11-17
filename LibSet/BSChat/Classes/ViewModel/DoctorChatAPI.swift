//
//  UserAPI.swift
//  Rent
//
//  Created by jiang 2019/2/26.
//  Copyright © 2019年 jiang. All rights reserved.
//

import Foundation
import Moya
import BSCommon

/// 消息模块接口
let DoctorChatProvider = MoyaProvider<DoctorChatAPI>()

enum DoctorChatAPI {
    case convState(patientId: String )  // 获取用户最新会话信息
    case replyPatient(patientId: String, task:[String:String]?)  // 回复消息完成
    case replyStaff(staffId: String )  // 回复消息完成
    case homeUnreadCount     //
    case createConv(patientId: String)  // 创建用户会话
    case assistList //我的助手成员列表
    case upperList  //上级员工列表
    case unreadCount  // 获取我的用户圈评论回复数
    case countUnhandleMeasure
    case getUnusualTaskCount    //待处理的血糖报警任务数量
    case getComNurseCompleteDataCount(beginDate:String, endDate:String)   //社区Careleader完善资料任务数量
    case topContacts
}

extension DoctorChatAPI: TargetType {
    var baseURL: URL {
        return URL(string: NetWorkConfig.BASE_URL)!
    }
    
    var path: String {
        switch self {
        //case .login(_, _):
        case .convState(_):
            return "vm/patient/conv/get"
        case .replyPatient(_,_):
            return "vm/patient/conv/reply"
        case .replyStaff(_):
            return "org/staff/conv/reply"
        case .homeUnreadCount:
            return "homePage/countUnread"
        case .createConv(_):
            return "vm/patient/conv/create"
        case .assistList:
            return "org/doctor/myAssistant"
        case .upperList:
            return "org/director/getByLogin"
        case .unreadCount:
            return "org/dynamicNotice/unreadCount"
        case .countUnhandleMeasure:
            return "bs/countUnHandleMeasure"
        case .getUnusualTaskCount:
            return "tc/bloodSugarWarning/countUnProcessedTask"
        case .getComNurseCompleteDataCount(_, _):
            return "cmnt/careleader/getCompleteDataCount"
        case .topContacts:
            return "org/staff/cmnt/topContacts"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .convState(_),.homeUnreadCount, .assistList, .upperList, .unreadCount, .countUnhandleMeasure,.getUnusualTaskCount,.getComNurseCompleteDataCount(_, _),.topContacts:
            return .get
        case .replyPatient(_,_), .replyStaff(_):
            return .post
        case .createConv(_):
            return .post
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        var parameters: [String:Any] = [:]
        
        switch self {
        case .convState(let patientId):
            parameters = ["patientId":patientId]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .replyPatient(let patientId, let task):
            parameters = ["patientId":patientId, "task":task]
            return .requestData(StringUtils.jsonToData(jsonDic: parameters)!)
        case .replyStaff(let staffId):
            parameters = ["staffId":staffId]
            return .requestData(StringUtils.jsonToData(jsonDic: parameters)!)
        case .homeUnreadCount,.assistList,.upperList:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .createConv(let patientId):
            parameters = ["patientId":patientId]
            return .requestData(StringUtils.jsonToData(jsonDic: parameters)!)
        case .unreadCount, .countUnhandleMeasure, .getUnusualTaskCount:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .getComNurseCompleteDataCount(let beginDate, let endDate):
            parameters = ["beginDate":beginDate, "endDate":endDate]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .topContacts:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .convState(_), .unreadCount, .countUnhandleMeasure,.getUnusualTaskCount,.getComNurseCompleteDataCount(_, _),.topContacts:
            return ["token": UserInfoManager.shareManager().token]
        case .replyPatient(_,_),.replyStaff(_),.homeUnreadCount,.createConv(_), .assistList, .upperList :
            return ["Content-Type": "application/json","token": UserInfoManager.shareManager().token]
        }
    }
}

