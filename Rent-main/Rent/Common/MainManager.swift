//
//  MainManager.swift
//  Rent
//
//  Created by jiang on 2019/3/19.
//  Copyright © 2019 com.tmpName. All rights reserved.
//

import UIKit
import SwiftEventBus
import BSCommon
import BSStore
import BSPages
import BSChat

class MainManager: NSObject {
    fileprivate static let mInstance = MainManager()
    
    static func getInstance() -> MainManager{
        return mInstance
    }
    
    func register(){
        //同步环境配置
        NetWorkConfig.configType = NetWorkConstant.configType
        NetWorkConfig.allowDebug = NetWorkConstant.configType != .pro
        
        SwiftEventBus.onMainThread(self, name: Event.Message.researchPlan.rawValue) { (notification) in
//            let reviewVc = FollowUpReviewController()
//            UIUtils.getCurrentVC()?.navigationController?.pushViewController(reviewVc, animated: true)
        }
        
        SwiftEventBus.onMainThread(self, name: Event.System.logout.rawValue) { (notification) in
            UIUtils.getAppDelegate().logout()
        }
        
    }
    
    func loadLibs(){
        BSCommonLoader.load()
        BSChatLoader.load()
        BSPagesLoader.load()
    }
    
    func setupIM(){
        SwiftEventBus.post(Event.Chat.setup.rawValue, userInfo: ["AppKey":kNIMAppKey,"AppSecret":kNIMAppSecret,"CerName":kNIMCerName])
    }
    
    ///IM自动登录
    func imAutoLogin(){
        SwiftEventBus.post(Event.Chat.autoLogin.rawValue)
    }
    
    ///IM账号退出
    func imLogout(){
        SwiftEventBus.post(Event.Chat.imLogout.rawValue)
    }
    
    ///缓存用户信息
    func storePatients(){
        //        let patientVM = PatientViewModel()
        //        patientVM.getPatientList(bind: true, successCallBack: nil, failureCallBack: nil)
        //        ThreadUtils.delay(3) {
        //            patientVM.getPatientList(bind: false, successCallBack: nil, failureCallBack: nil)
        //        }
    }
    
}





