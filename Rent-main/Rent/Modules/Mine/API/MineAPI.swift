//
//  MineAPI.swift
//  BSNurse
//
//  Created by jiang 2019/4/27.
//  Copyright © 2019年 tmpName. All rights reserved.
//

import Foundation
import Moya
import HandyJSON
import BSCommon

/// 个人中心功能接口
let MineProvider = MoyaProvider<MineAPI>()

enum MineAPI {
    case countUnread  // 未读系统消息数查询
    case setPassword(password: String)  // 首次设置二级密码
    case validatePassword(password: String)     // 二级密码验证
    case getMaskMobile  // 获取用户模糊手机号
    case getSMSCode     // 发送短信验证码
    case resetPassword(veriCode: String, password: String)  // 重置APP的二级密码
}

extension MineAPI: TargetType {
    var baseURL: URL {
        return URL(string: NetWorkConstant.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .countUnread:
            return "homePage/countUnread"
        case .setPassword(_):
            return "org/staffAppPassword/setPassword"
        case .validatePassword(_):
            return "org/staffAppPassword/validate"
        case .getMaskMobile:
            return "org/staff/getMaskMobile"
        case .getSMSCode:
            return "org/staffAppPassword/sms/code"
        case .resetPassword(_, _):
            return "org/staffAppPassword/reset"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .countUnread, .getMaskMobile:
            return .get
        case .setPassword(_), .validatePassword(_), .getSMSCode, .resetPassword(_, _):
            return .post
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        var parameters: [String:Any] = [:]
        
        switch self {
        case .countUnread:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .setPassword(let password):
            parameters = ["password": password]
            return .requestData(StringUtils.jsonToData(jsonDic: parameters)!)
        case .validatePassword(let password):
            parameters = ["password": password]
            return .requestData(StringUtils.jsonToData(jsonDic: parameters)!)
        case .getMaskMobile:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .getSMSCode:
            return .requestData(StringUtils.jsonToData(jsonDic: parameters)!)
        case .resetPassword(let veriCode, let password):
            parameters = ["veriCode": veriCode, "password": password]
            return .requestData(StringUtils.jsonToData(jsonDic: parameters)!)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .countUnread, .getMaskMobile:
            return ["token": UserInfoManager.shareManager().token]
        case .setPassword(_), .validatePassword(_), .getSMSCode, .resetPassword(_, _):
            return ["token": UserInfoManager.shareManager().token, "Content-Type": "application/json"]
        }
    }
}
