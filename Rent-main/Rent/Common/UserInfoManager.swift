//
//  UserInfoManager.swift
//  Rent
//
//  Created by jiang 2019/2/27.
//  Copyright © 2019年 jiang. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class UserInfoManager: NSObject {
    
    fileprivate static let instance = UserInfoManager()
    
    var token = ""
    /// 极光推送用户别名
    var pushAlias = ""
    
    var userInfo = UserInfoModel()
    
    /// 标记是否已检查更新
    var haveCheckVersion = false

    /// 标记个人中心是否已经输入过二级密码
    var haveEnterPassword = false
    
    static func shareManager() -> UserInfoManager {
        return instance
    }
    
    
    /**
     * 判断是否登录
     */
    func isLogin() -> Bool {
        let token = Defaults["token"].stringValue
        if token.isEmpty {
            self.token = ""
            return false
        } else {
            YYLog("token = \(token)")
            self.userInfo = getUserInfo()
            return true
        }
    }
    
    /**
     * 获取用户信息
     */
    func getUserInfo() -> UserInfoModel {
        
        self.token                      = Defaults["token"].stringValue
        self.pushAlias                  = Defaults["pushAlias"].stringValue
        
        var model = UserInfoModel()
//        model.staffId                   = Defaults["staffId"].stringValue
//        model.account                   = Defaults["account"].stringValue
//        model.name                      = Defaults["name"].stringValue
//        model.mobile                    = Defaults["mobile"].stringValue
//        model.todayScanCount            = Defaults["todayScanCount"].intValue
//        model.allScanCount              = Defaults["allScanCount"].intValue
//        model.hospitalDepartmentName    = Defaults["hospitalDepartmentName"].stringValue
//        model.uuid                      = Defaults["uuid"].stringValue
//        model.points                    = Defaults["points"].intValue
//        model.certificate               = Defaults["certificate"].stringValue
//        model.qrCode                    = Defaults["qrCode"].stringValue
//        model.headImg                   = Defaults["headImg"].stringValue
//        model.introduce                 = Defaults["introduce"].stringValue
//        model.jobTitleName              = Defaults["jobTitleName"].stringValue
//        model.hospitalName              = Defaults["hospitalName"].stringValue
//        model.nurse.id                  = Defaults["nurseId"].stringValue
//        model.nurse.name                = Defaults["nurseName"].stringValue
//        model.nurse.headImg             = Defaults["nurseHeadImg"].stringValue
//        model.agent.id                  = Defaults["agentId"].stringValue
//        model.agent.name                = Defaults["agentName"].stringValue
//        model.agent.headImg             = Defaults["agentHeadImg"].stringValue
//        model.im.accId                  = Defaults["imAccId"].stringValue
//        model.im.token                  = Defaults["imToken"].stringValue
//
//        model.roleId                    = Defaults["roleId"].stringValue
//        model.roleName                  = Defaults["roleName"].stringValue
//        model.identityType              = Defaults["identityType"].intValue
//        model.identityNumber            = Defaults["identityNumber"].stringValue
        
        self.userInfo = model
        return model
    }
    
    /**
     * 存储用户信息
     */
    func saveUserInfo(_ model: UserInfoModel) {
        Defaults["token"]                   = self.token
        Defaults["pushAlias"]              = self.pushAlias
        
//        Defaults["staffId"]                 = model.staffId
//        Defaults["mobile"]                  = model.mobile
//        Defaults["todayScanCount"]          = model.todayScanCount
//        Defaults["allScanCount"]            = model.allScanCount
//        Defaults["hospitalDepartmentName"]  = model.hospitalDepartmentName
//        Defaults["uuid"]                    = model.uuid
//        Defaults["points"]                  = model.points
//        Defaults["certificate"]             = model.certificate
//        Defaults["qrCode"]                  = model.qrCode
//        Defaults["headImg"]                 = model.headImg
//        Defaults["introduce"]               = model.introduce
//        Defaults["jobTitleName"]            = model.jobTitleName
//        Defaults["hospitalName"]            = model.hospitalName
//        Defaults["nurseId"]                 = model.nurse.id
//        Defaults["nurseName"]               = model.nurse.name
//        Defaults["nurseHeadImg"]            = model.nurse.headImg
//        Defaults["agentId"]                 = model.agent.id
//        Defaults["agentName"]               = model.agent.name
//        Defaults["agentHeadImg"]            = model.agent.headImg
//        Defaults["imAccId"]                 = model.im.accId
//        Defaults["imToken"]                 = model.im.token
//
//        Defaults["account"]                 = model.account
//        Defaults["name"]                    = model.name
//        Defaults["roleId"]                  = model.roleId
//        Defaults["roleName"]                = model.roleName
//        Defaults["identityType"]            = model.identityType
//        Defaults["identityNumber"]          = model.identityNumber
        
        self.userInfo = model
        
        // 保存到 GroupDefaults
        saveGroupUserInfo(model)
    }
    
    /**
     * 退出登录
     */
    func logout() {
        self.token = ""
        self.userInfo.phone = ""
        saveUserInfo(self.userInfo)
    }
    
    /**
     * Group共享数据
     */
    func saveGroupUserInfo(_ model: UserInfoModel) {
        GroupDefaults["token"]                   = self.token
        GroupDefaults["pushAlias"]              = self.pushAlias
        
//        GroupDefaults["staffId"]                 = model.staffId
//        GroupDefaults["mobile"]                  = model.mobile
//        GroupDefaults["todayScanCount"]          = model.todayScanCount
//        GroupDefaults["allScanCount"]            = model.allScanCount
//        GroupDefaults["hospitalDepartmentName"]  = model.hospitalDepartmentName
//        GroupDefaults["uuid"]                    = model.uuid
//        GroupDefaults["points"]                  = model.points
//        GroupDefaults["certificate"]             = model.certificate
//        GroupDefaults["qrCode"]                  = model.qrCode
//        GroupDefaults["headImg"]                 = model.headImg
//        GroupDefaults["introduce"]               = model.introduce
//        GroupDefaults["jobTitleName"]            = model.jobTitleName
//        GroupDefaults["hospitalName"]            = model.hospitalName
//        GroupDefaults["nurseId"]                 = model.nurse.id
//        GroupDefaults["nurseName"]               = model.nurse.name
//        GroupDefaults["nurseHeadImg"]            = model.nurse.headImg
//        GroupDefaults["agentId"]                 = model.agent.id
//        GroupDefaults["agentName"]               = model.agent.name
//        GroupDefaults["agentHeadImg"]            = model.agent.headImg
//        GroupDefaults["imAccId"]                 = model.im.accId
//        GroupDefaults["imToken"]                 = model.im.token
//
//        GroupDefaults["account"]                 = model.account
//        GroupDefaults["name"]                    = model.name
//        GroupDefaults["roleId"]                  = model.roleId
//        GroupDefaults["roleName"]                = model.roleName
        
    }
    
}
