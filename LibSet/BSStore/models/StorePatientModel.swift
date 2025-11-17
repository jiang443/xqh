//
//  PatientModel.swift
//  XQH
//
//  Created by jiang on 2019/5/2.
//  Copyright © 2017年 tmpName. All rights reserved.
//

import UIKit

public class StorePatientModel: NSObject {
    
    public var id = ""        //用户id
    public var headImg = ""   //头像
    public var gender = 0          //性别 1男2女
    public var displayName = ""    //展示名称
    public var nickname = ""    //昵称
    public var userName = ""    //姓名
    public var scanTime = ""    //扫码时间
    public var comfirmTime = "" //报到时间
    public var deviceNo = ""
    public var schemaName = ""        //测量方案名称
    public var schemaRemark = ""      //测量方案备注
    public var address = ""       //地址
    public var mobile = ""        //手机
    public var remarkName = ""    //备注名
    public var isComfirmed = 0   //是否已报到 1是0否
    public var isSign = 0        //是否与员工签约
    public var isSignLogin = 0   //是否与登录员工签约 1是0否
    public var imAccId = ""      //用户im账号
    public var unionId = ""
    public var tbUpdateTime = 0
    public var tbAddTime = 0
    public var tbIsMember = 0     //是否会员
    
    public func getName()->NSString{
        var resName = self.nickname
        if !displayName.isEmpty{
            if !self.nickname.isEmpty{
                resName = "\(displayName)(\(nickname))"
            }
            else{
                resName = "\(displayName)"
            }
        }
        return resName as NSString
    }
    
}
