//
//  ResearchChatAPI.swift
//  Alamofire
//
//  Created by jiang on 2019/4/27.
//

import UIKit

import Foundation
import Moya
import BSCommon

/// 消息模块接口
let ResearchChatProvider = MoyaProvider<ResearchChatAPI>()

enum ResearchChatAPI {
    case convState(patientId: String )  // 获取用户最新会话信息
    case replyPatient(patientId: String )  // 回复消息完成
    case replyStaff(staffId: String )  // 回复消息完成
    case homeUnreadCount     //
    case createConv(patientId: String )  // 创建用户会话
    case assistList //我的助手成员列表
    case getStaffImAccount(staffId:String)  //查询某个员工的im账号
}

extension ResearchChatAPI: TargetType {
    var baseURL: URL {
        return URL(string: NetWorkConfig.BASE_URL)!
    }
    
    var path: String {
        switch self {
        //case .login(_, _):
        case .convState(_):
            return "vm/patient/conv/get"
        case .replyPatient(_):
            return "vm/patient/conv/reply"
        case .replyStaff(_):
            return "org/staff/conv/reply"
        case .homeUnreadCount:
            return "homePage/countUnread"
        case .createConv(_):
            return "vm/patient/conv/create"
        case .assistList:
            return "org/staff/myAssistant"
        case .getStaffImAccount(_):
            return "im/getByStaff"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .convState(_),.homeUnreadCount, .assistList, .getStaffImAccount(_):
            return .get
        case .replyPatient(_), .replyStaff(_):
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
        case .replyPatient(let patientId):
            parameters = ["patientId":patientId]
            return .requestData(StringUtils.jsonToData(jsonDic: parameters)!)
        case .replyStaff(let staffId):
            parameters = ["staffId":staffId]
            return .requestData(StringUtils.jsonToData(jsonDic: parameters)!)
        case .homeUnreadCount,.assistList:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .createConv(let patientId):
            parameters = ["patientId":patientId]
            return .requestData(StringUtils.jsonToData(jsonDic: parameters)!)
        case .getStaffImAccount(let staffId):
            parameters = ["staffId":staffId]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .convState(_):
            return ["token": UserInfoManager.shareManager().token]
    case .replyPatient(_),.replyStaff(_),.homeUnreadCount,.createConv(_), .assistList,.getStaffImAccount(_):
            return ["Content-Type": "application/json","token": UserInfoManager.shareManager().token]
        }
    }
}

