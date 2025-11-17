//
//  MineViewModel.swift
//  BSNurse
//
//  Created by jiang 2019/3/27.
//  Copyright © 2019年 tmpName. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON
import BSCommon

class MineViewModel: BaseViewModel {
    
    /// 未读系统消息数
    var unreadSystemNoticeCount = 0
    
    /// 用户模糊手机号
    var maskMobile = ""
}

extension MineViewModel {
    
    /// 系统消息未读数
    func countUnread(successCallBack: RequestSuccess?, failureCallBack: RequestFailed?) {
        MineProvider.request(.countUnread) { result in
            self.checkJson(resp: result, onFail: failureCallBack, success: { (json) in
                self.unreadSystemNoticeCount = json["data"]["unreadSystemNoticeCount"].intValue
                successCallBack?()
            })
        }
    }
    
    /// 首次设置二级密码
    func setPassword(password: String, successCallBack: RequestSuccess?, failureCallBack: RequestFailed?) {
        MineProvider.request(.setPassword(password: password)) { result in
            self.checkJson(resp: result, onFail: failureCallBack, success: { (json) in
                successCallBack?()
            })
        }
    }
    
    /// 二级密码验证
    func validatePassword(password: String, successCallBack: RequestSuccess?, failureCallBack: RequestFailed?) {
        MineProvider.request(.validatePassword(password: password)) { result in
            self.checkJson(resp: result, onFail: failureCallBack, success: { (json) in
                successCallBack?()
            })
        }
    }
    
    /// 获取用户模糊手机号
    func getMaskMobile(successCallBack: RequestSuccess?, failureCallBack: RequestFailed?) {
        MineProvider.request(.getMaskMobile) { result in
            self.checkJson(resp: result, onFail: failureCallBack, success: { (json) in
                self.maskMobile = json["data"].stringValue
                successCallBack?()
            })
        }
    }
    
    /// 发送短信验证码
    func getSMSCode(successCallBack: RequestSuccess?, failureCallBack: RequestFailed?) {
        MineProvider.request(.getSMSCode) { result in
            self.checkJson(resp: result, onFail: failureCallBack, success: { (json) in
                successCallBack?()
            })
        }
    }
    
    /// 重置APP的二级密码
    func resetPassword(veriCode: String, password: String, successCallBack: RequestSuccess?, failureCallBack: RequestFailed?) {
        MineProvider.request(.resetPassword(veriCode: veriCode, password: password)) { result in
            self.checkJson(resp: result, onFail: failureCallBack, success: { (json) in
                successCallBack?()
            })
        }
    }
    
}
