//
//  UserViewModel.swift
//  Rent
//
//  Created by jiang 2019/2/26.
//  Copyright © 2019年 jiang. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON
import BSPush
import Bugly
import BSCommon

class UserViewModel: BaseViewModel {

}

extension UserViewModel {
    /// 登录接口
    func login(phone: String, code: String, successCallBack: RequestSuccess?, failureCallBack: RequestFailed?) {
        UserProvider.request(.login(phone: phone, code: code)) { result in
            self.checkJson(resp: result, onFail: failureCallBack, success: { (json) in
                YYHUD.showSuccess("登录成功")
                UserInfoManager.shareManager().token = json["data"]["token"].stringValue
                UserInfoManager.shareManager().pushAlias = json["data"]["jpushAlias"].stringValue
                UserInfoManager.shareManager().userInfo.account = phone
                UserInfoManager.shareManager().saveUserInfo(UserInfoManager.shareManager().userInfo)
                // 获取用户信息
                UserViewModel().loginInfo(callBack: {
                    successCallBack?()
                    Bugly.setUserIdentifier(phone)
                    PushManager.getInstance().setAliasTags()
                    MainManager.getInstance().setupIM()
//                    MobClick.profileSignIn(withPUID: account)
                })
            })
        }
    }
    
    /// 微信登录接口
    func wxLogin(unionId:String,openId:String,accessToken:String, successCallBack: RequestSuccess?, failureCallBack: RequestFailed?) {
        UserProvider.request(.wxLogin(unionId: unionId, openId: openId, accessToken: accessToken)) { result in
            self.checkJson(resp: result, onFail: failureCallBack, success: { (json) in
                YYHUD.showSuccess("微信登录成功")
            })
        }
    }
    
    func logout(callBack: RequestSuccess?) {
        UserProvider.request(.logout) { result in
            self.checkJson(resp: result, onFail: { (msg, code) in
                YYHUD.showToast(msg)
            }, success: { (json) in
                callBack?()
            })
        }
    }
    
    func loginInfo(callBack: RequestSuccess?) {
        UserProvider.request(.loginInfo) { result in
            self.checkJson(resp: result, onFail: { (msg, code) in
                print(StringUtils.ERROR + msg)
            }, success: { (json) in
                if let model = JSONDeserializer<UserInfoModel>.deserializeFrom(json: json["data"].description) {
                    UserInfoManager.shareManager().userInfo = model
                    UserInfoManager.shareManager().saveUserInfo(model)
                }
                callBack?()
            })
        }
    }
    
    func sendCode(phone:String, successCallBack: RequestSuccess?, failureCallBack: RequestFailed?) {
        UserProvider.request(.sendCode(phone: phone)) { result in
            self.checkJson(resp: result, onFail: failureCallBack, success: { (json) in
//                if let model = JSONDeserializer<UserInfoModel>.deserializeFrom(json: json["data"].description) {
//                }
                successCallBack?()
            })
        }
    }
    
}
