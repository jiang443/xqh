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

/// 登录模块接口
let UserProvider = MoyaProvider<UserAPI>()

enum UserAPI {
    case login(phone: String, code: String)  // 登录接口
    case wxLogin(unionId:String,openId:String,accessToken:String)
    case logout     // 退出接口
    case loginInfo  // 获取用户信息
    case sendCode(phone:String) //发送验证码
}

extension UserAPI: TargetType {
    var baseURL: URL {
        return URL(string: NetWorkConstant.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .login(_, _):
            return "/api/app/clt/client/LoginByCellphone"
        case .wxLogin(_, _, _):
            return "/api/app/clt/client/LoginByWxAuthorize"
        case .logout:
            return "/logout"
        case .loginInfo:
            return "/api/app/clt/client/GetClientInfo"
        case .sendCode(_):
            return "/api/app/clt/client/SendCode"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login(_, _),.wxLogin(_, _, _):
            return .post
        case .logout:
            return .post
        case .loginInfo,.sendCode(_):
            return .get
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        var parameters: [String:Any] = [:]
        
        switch self {
        case .login(let phone, let code):
            // LoginSide: 0-APP 1-小程序； LoginClientDevice客户端设备 0-安卓 1-ios
            parameters = ["CellPhone":phone, "CheckCode": code, "LoginSide": "0", "LoginClientDevice": "1"]
            return .requestData(StringUtils.jsonToData(jsonDic: parameters)!)
        case .wxLogin(let unionId, let openId, let accessToken):
            // LoginSide: 0-APP 1-小程序； LoginClientDevice客户端设备 0-安卓 1-ios
            parameters = ["UnionId":unionId, "OpenId": openId, "AccessToken":accessToken, "LoginSide": "0", "LoginClientDevice": "1"]
        case .logout:
            parameters.removeAll()
        case .loginInfo:
            parameters.removeAll()
        case .sendCode(let phone):
            parameters = ["Phone":phone]
        }
        
        if self.method == .post{
            return .requestData(StringUtils.jsonToData(jsonDic: parameters)!)
        }
        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        if self.method == .post{
            return ["token": UserInfoManager.shareManager().token,
                    "Content-Type": "application/json"]
        }
        return ["token": UserInfoManager.shareManager().token]
    }
}

