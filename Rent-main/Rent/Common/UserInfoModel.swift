//
//  UserInfoModel.swift
//  Rent
//
//  Created by jiang 2019/2/27.
//  Copyright © 2019年 jiang. All rights reserved.
//

import UIKit
import HandyJSON
import BSCommon

struct UserInfoModel: HandyJSON {
    /// 员工类型
    var userType = 0
    /// 手机
    var phone = ""
    /// 地区
    var area = ""
    /// 姓名
    var name = ""
    /// 机构类型
    var orgType = ""
    /// 机构名
    var orgName = ""
    ///
    var password = ""
    /// 昵称
    var nickName = ""
    /// 地址
    var address = ""
    /// 头像
    var headPic = ""
    /// 编号
    var id = 0
    /// wx-UnionId
    var unionId = ""
    /// 电邮
    var email = ""
    /// 营业执照
    var businessLicense = ""

    
}
