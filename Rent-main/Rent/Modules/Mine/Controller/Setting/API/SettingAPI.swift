//
//  SettingAPI.swift
//  Rent
//
//  Created by jiang 2019/3/4.
//  Copyright © 2019年 jiang. All rights reserved.
//

import Foundation
import Moya
import HandyJSON
import BSCommon

/// 设置功能接口
let SettingProvider = MoyaProvider<SettingAPI>()

enum SettingAPI {
    case changePassword(oldPassword: String, newPassword: String)  // 修改密码
    case checkVersion  // 检查版本
}

extension SettingAPI: TargetType {
    var baseURL: URL {
        return URL(string: NetWorkConstant.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .changePassword(_, _):
            return "org/staff/changePassword"
        case .checkVersion:
            return "sys/clientVersion/latest"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .changePassword(_, _):
            return .post
        case .checkVersion:
            return .get
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        var parameters: [String:Any] = [:]
        
        switch self {
        case .changePassword(let oldPassword, let newPassword):
            parameters = ["oldPassword": oldPassword, "newPassword": newPassword]
            return .requestData(StringUtils.jsonToData(jsonDic: parameters)!)
        case .checkVersion:
            parameters = ["platform": "2", "clientAppId":"5"]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .changePassword(_ , _):
            return ["token": UserInfoManager.shareManager().token, "Content-Type": "application/json"]
        case .checkVersion:
            return ["token": UserInfoManager.shareManager().token, "Content-Type": "application/json"]
        }
    }    
}
