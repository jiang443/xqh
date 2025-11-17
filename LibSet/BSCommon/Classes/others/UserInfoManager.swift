//
//  UserInfoManager.swift
//  Rent
//
//  Created by jiang 2019/2/27.
//  Copyright © 2019年 jiang. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

public enum UserType: String {
    case other = "other"
    case doctor = "doctor"
    case manager = "manager"
    case contact = "contact"
    case nurse = "nurse"
    case director = "director"
    case pi = "pi"
    case comDirector = "comDirector"
    case comNurse = "comNurse"
}

public class UserInfoManager: NSObject {
    
    fileprivate static let instance = UserInfoManager()
    
    public var token = ""
    public var pushAlias = ""
    public var userInfo = UserInfoModel()
    
    /// 标记是否已检查更新
    public var haveCheckVersion = false
    
    public override init() {
        super.init()
    }

    public static func shareManager() -> UserInfoManager {
        return instance
    }
    
    public func isLogin() -> Bool {
        let token = Defaults["token"].stringValue
        if token.isEmpty {
            self.token = ""
            return false
        } else {
            //print("token = \(token)")
            self.userInfo = getUserInfo()
            return true
        }
    }
    
    /**
     * 获取用户信息
     */
    public func getUserInfo() -> UserInfoModel {
        
        self.token = Defaults["token"].stringValue
        self.pushAlias = Defaults["pushAlias"].stringValue
        
        var model = UserInfoModel()
        model.id                = Defaults["id"].intValue
        model.orgName           = Defaults["orgName"].stringValue
        model.unionId           = Defaults["unionId"].stringValue
        model.phone             = Defaults["phone"].stringValue
        model.address           = Defaults["address"].stringValue
        model.isBindWx          = Defaults["isBindWx"].intValue
        model.businessLicense   = Defaults["businessLicense"].stringValue
        model.headPic           = Defaults["headPic"].stringValue
        model.area              = Defaults["area"].stringValue
        model.nickName          = Defaults["nickName"].stringValue
        model.orgType           = Defaults["orgType"].stringValue
        model.userType          = Defaults["userType"].intValue
        model.email             = Defaults["email"].stringValue
        model.name              = Defaults["name"].stringValue
        model.accId             = Defaults["imAccId"].stringValue
        model.token             = Defaults["imToken"].stringValue
        model.pushAlias         = Defaults["pushAlias"].stringValue
        return model
    }
    
    /**
     * 存储用户信息
     */
    public func saveUserInfo(_ model: UserInfoModel) {
        Defaults["token"] = self.token
        Defaults["pushAlias"] = self.pushAlias
        Defaults["imAccId"]            = model.accId
        Defaults["imToken"]            = model.token
        
        Defaults["id"]                 = model.id
        Defaults["orgName"]            = model.orgName
        Defaults["unionId"]            = model.unionId
        Defaults["phone"]              = model.phone
        Defaults["address"]            = model.address
        Defaults["isBindWx"]           = model.isBindWx
        Defaults["businessLicense"]    = model.businessLicense
        Defaults["headPic"]            = model.headPic
        Defaults["area"]               = model.area
        Defaults["nickName"]           = model.nickName
        Defaults["orgType"]            = model.orgType
        Defaults["userType"]           = model.userType
        Defaults["email"]              = model.email
        Defaults["name"]               = model.name
    }
    
    ///获取当前APP类型
    public func getType() -> UserType{
        if let name = IOSUtils.getAppBundleId().components(separatedBy: ".").last{
            switch name{
                case "doctor":
                    return .doctor
                case "director":
                    return .director
                case "nurse":
                    return .nurse
                case "pi":
                    return .pi
                case "comNurse":
                    return .comNurse
                case "comDirector":
                    return .comDirector
                default:
                    return .other
            }
        }
        return .other
    }
    
    
    
    /**
     * 退出登录
     */
    public func logout() {
        self.token = ""
        self.userInfo.account = ""
        saveUserInfo(self.userInfo)
    }
}
