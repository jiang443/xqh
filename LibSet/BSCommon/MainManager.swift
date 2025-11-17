///
//  MainManager.swift
//  XQH
//  公共函数管理类
//
//  Created by jiang on 2019/8/8.
//  Copyright © 2017年 tmpName. All rights reserved.
//

import UIKit
import SwiftyJSON
import BSCommon
import SwiftEventBus
import MGJRouter
import YYReach

public class MainManager:NSObject {
    fileprivate static let thisInstance = MainManager()
    var user = UserInfoManager.shareManager().getUserInfo()
    weak fileprivate var timer:Timer?
    
    public override init() {
        super.init()
    }

    public static func getInstance() -> MainManager{
        return thisInstance
    }
    
    func register(){
        self.registerEvents()
        self.startNetMonitor()
        
        ThreadUtils.delay(0.5) {
            self.startUpdate()
        }
    }
    
    func registerEvents(){
        SwiftEventBus.onMainThread(self, name: Event.System.appWillLaunch.rawValue) { (notification) in
            NetWorkConfig.getInstance()
        }
    }
    
    func startUpdate(){
        if self.timer == nil{
            let timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(fireTimer(_:)), userInfo: nil, repeats: true)
            self.fireTimer(timer)
        }
        else{
            self.timer?.fireDate = Date()
        }
    }
    
    func stopUpdate(){
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc func fireTimer(_ sender:Timer){
        if !UserInfoManager.shareManager().isLogin(){
            self.stopUpdate()
            return
        }
        if sender != self.timer{
            self.timer?.invalidate()
        }
        self.timer = sender
        SwiftEventBus.post(Event.System.timerFired.rawValue)
    }
   
    
    ///开启网络状态监控
    func startNetMonitor(){
        let reacher = ReachManager.sharedInstance()
        reacher.start()
        reacher.listener = { (status:ReachStatus) in
            switch status {
            case .offLine:
                print("##### 网络连接已断开")
                if reacher.connectionRequired{
                    DialogUtils.showMessage("网络连接失败，请检查网络配置")
                }
                YYHUD.showToast("网络连接已断开")
            case .onWiFi:
                print("##### 已连接蜂窝移动网络")
            case .onWWAN:
                print("##### 已连接WiFi网络")
            }
        }
    }
    
}


