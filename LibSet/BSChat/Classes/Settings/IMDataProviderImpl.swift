//
//  IMDataProviderImpl.swift
//  AfterDoctor
//
//  Created by jiang on 2018/11/12.
//  Copyright © 2018年 tmpName. All rights reserved.
//

import UIKit
import BSCommon
import SwiftyJSON

class IMDataProviderImpl: NIMKitDataProviderImpl {
    
    override func info(byUser userId: String!, option: NIMKitInfoFetchOption!) -> NIMKitInfo! {
        let info = super.info(byUser: userId, option: option)
        var img = "员工默认头像"
        let dict = IMMainManager.getInstance().getUserCard(accId: userId)
        let userType = dict.intValue(key: "userType")
        info?.showName = dict.stringValue(key: "showName")  //userType: 用户2，员工1
        if userType == 1 && dict.hasKey("businessRoleId"){
            let businessRoleId = dict.intValue(key:"businessRoleId")
            if let role = BussinessRole(rawValue: businessRoleId){
                info?.showName = "\(role.getName())_\(dict.stringValue(key:"name"))"
                if businessRoleId == 5 && dict.intValue(key:"orgSystemType") == 4{
                    info?.showName = "社区员工_\(dict.stringValue(key:"name"))"
                }
                switch dict.intValue(key: "businessRoleId") {
                case 1,2:
                    img = "默认头像A"
                case 3:
                    img = "地区经理默认头像"
                case 4:
                    img = "联络官默认头像"
                case 10:
                    img = "pi默认头像"
                case 11:
                    img = "默认头像B"
                case 12:
                    img = "默认头像C"
                default:
                    break
                }
            }
        }
        info?.avatarImage = UIImage(named:img) //占位图像
        return info
    }

}
