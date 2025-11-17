//
//  Const.swift
//  Rent
//
//  Created by jiang 2019/2/25.
//  Copyright © 2019年 jiang. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import SnapKit
import SwiftyJSON
import HandyJSON
//import ZYCornerRadius

public let ScreenWidth = UIScreen.main.bounds.size.width
public let ScreenHeight = UIScreen.main.bounds.size.height

public let UI_IS_IPHONEX = ScreenHeight == 812.0 ? true : false
public let UI_IS_IPHONEXR = ScreenHeight == 896.0 ? true : false
public let NavHeight: CGFloat = (UI_IS_IPHONEX || UI_IS_IPHONEXR) ? 88 : 64
public let TabBarHeight: CGFloat = (UI_IS_IPHONEX || UI_IS_IPHONEXR) ? 49 + 34 : 49
public let TabBarBottomHeight: CGFloat = (UI_IS_IPHONEX || UI_IS_IPHONEXR) ? 34 : 0

public typealias RequestSuccess = () ->Void
public typealias RequestFailed = (_ msg: String, _ code:Int) ->Void

/**************************************网络请求**************************************/

/**     常规定义    */
// 每页请求页数
public let PageSize = 10
/**     常规定义    */

/**     返回码    */
// 请求成功
public let Request_Success_Code = 0
// 请求失败,暂无使用
public let Request_Failed_Code = 1
// token失效
public let Request_Token_Expired_Code = 2001
/**     返回码    */

/**************************************网络请求**************************************/



// 身份证件类型
public enum IdCardType: Int {
    case other = 0      //其他类型
    case identity = 1            // 身份证
    case officer = 2             // 军官证
    case passport = 3               // 护照
    case hk_macao = 4          // 港澳通行证
    
    public func getName() -> String{
        switch self {
        case .identity:
            return "身份证"
        case .officer:
            return "军官证"
        case .passport:
            return "护照"
        case .hk_macao:
            return "港澳通行证"
        default:
            return ""
        }
    }
}
