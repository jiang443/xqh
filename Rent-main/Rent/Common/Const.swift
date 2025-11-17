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
import ZYCornerRadius
@_exported import BSCommon

let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height

let UI_IS_IPHONEX = ScreenHeight == 812.0 ? true : false
let UI_IS_IPHONEXR = ScreenHeight == 896.0 ? true : false
let UI_IS_NewSccreen = UIUtils.isIPhoneX()
let UI_IS_IPHONE5 = ScreenWidth == 320.0 ? true : false
let UI_IS_IPHONEPLUS = ScreenHeight == 736.0 ? true : false
let NavHeight: CGFloat = UI_IS_NewSccreen ? 88 : 64
let TabBarHeight: CGFloat = UI_IS_NewSccreen ? 49 + 34 : 49
let TabBarBottomHeight: CGFloat = UI_IS_NewSccreen ? 34 : 0

typealias RequestSuccess = () ->Void
typealias RequestFailed = (_ msg: String, _ code: Int) ->Void

// 随机颜色
var RandomColor: UIColor {
    return UIColor.init(red: CGFloat(arc4random_uniform(255)) / 255.0, green: CGFloat(arc4random_uniform(255)) / 255.0, blue: CGFloat(arc4random_uniform(255)) / 255.0, alpha: 1.0)
}

// 字体大小
let TextFont_10 = UIFont.systemFont(ofSize: 10)
let TextFont_11 = UIFont.systemFont(ofSize: 11)
let TextFont_12 = UIFont.systemFont(ofSize: 12)
let TextFont_13 = UIFont.systemFont(ofSize: 13)
let TextFont_14 = UIFont.systemFont(ofSize: 14)
let TextFont_15 = UIFont.systemFont(ofSize: 15)
let TextFont_16 = UIFont.systemFont(ofSize: 16)

// 字体颜色
let TextColor_3 = UIColor.color(withHexString: "#333333")
let TextColor_6 = UIColor.color(withHexString: "#666666")
let TextColor_9 = UIColor.color(withHexString: "#999999")

// APP下载URL
let APPDOWNLOADURL = "http://www.baidu.com/"

/// 显示启动视频引导页的最大版本
let ShowGuidePageMaxVersion = "1.3.0"

let mockBaseUrl = "http://"


/**************************************网络请求**************************************/

/**     常规定义    */
// 每页请求页数
let PageSize = 10
let PageSize_10 = 10
/**     常规定义    */

/**     返回码    */
// 请求成功
let Request_Success_Code = 0
// 请求失败
let Request_Failed_Code = 1
// token失效
let Request_Token_Expired_Code = -1
/**     返回码    */

/**************************************网络请求**************************************/


//************* KEYS ********
let kWechatAppKey = "wx-tmp"    //暂无分享需求
let kWechatAppSecret = ""

let kBuglyAppId = ""
let kBuglyAppKey = ""

let kUmengAppKey = ""
let kUmengChannelId = "PRODUCTION"

let kJPushKey = ""
let kJPushSecret = ""

let kNIMAppKey = ""
let kNIMAppSecret = ""
let kNIMCerName = ""

let kMTA = ""
 
 //******** KEYS *************





/************************************** NotificationName **************************************/

// 添加银行卡成功的通知
let AddBankCardNotificationName = "AddBankCardNotificationName"
// 发表文章成功的通知
let PublishCircleSuccessNotificationName = "PublishCircleSuccessNotificationName"
// 备注成功的通知
let PatientRemarkSuccessNotificationName = "PatientRemarkSuccessNotificationName"
// 兑换服务费选择银行卡的通知
let SelectedBankCardSuccessNotificationName = "SelectedBankCardSuccessNotificationName"
// 设置测量建议方案成功的通知
let SettingSchemaSuccessNotificationName = "SettingSchemaSuccessNotificationName"
// 审核随访方案成功的通知
let ReviewFollowUpSuccessNotificationName = "ReviewFollowUpSuccessNotificationName"
// 一键审查成功的通知
let OneClickReviewSuccessNotificationName = "OneClickReviewSuccessNotificationName"
// 一键展开/收起的通知
let OneClickExpandNotificationName = "OneClickExpandNotificationName"

/************************************** NotificationName **************************************/





/************************************** enum **************************************/
// 用户列表类型
enum PatientListType: Int {
    case all = 0                 // 所有用户
    case compareGroup = 1        // 对照组
    case observedGroup = 2       // 观察组
    case quitGroup = 3           // 脱组
    case other = 4               // 其他
    case isOnlyToday = 5         // 今日新增
    case binded = 6             // 已绑定
    case notBinded = 7          // 未绑定
}

// 产品租赁类型
enum SaleType: Int {
    case rent = 1           // 租赁
    case buy = 2            // 买断
    case rentBuy = 3        // 先租后买
}


/************************************** enum **************************************/
