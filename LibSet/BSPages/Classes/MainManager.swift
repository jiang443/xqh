///
//  MainManager.swift
//  XQH
//  公共函数管理类
//
//  Created by jiang on 2019/8/8.
//  Copyright © 2017年 tmpName. All rights reserved.
//

import UIKit
import BSBase
import BSCommon
import SwiftEventBus
import MGJRouter

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
    }
    
    func registerEvents(){
        SwiftEventBus.onMainThread(self, name: Event.System.openUrl.rawValue) { (notification) in
            if let dict = notification?.userInfo as? [String:Any]{
                let webView = WebViewController()
                webView.url = dict.stringValue(key: "url")
                webView.title = dict.stringValue(key: "title")
                UIUtils.getCurrentVC()?.navigationController?.pushViewController(webView, animated: true)
            }
        }
        
        SwiftEventBus.onMainThread(self, name: Event.System.setConfig.rawValue) { (notification) in
            if let currentVc = UIUtils.getCurrentVC(){
                let debugList = DebugListViewController()
                let nav = UINavigationController(rootViewController: debugList)
                debugList.setModalNavTheme()
                currentVc.present(nav, animated: true, completion: nil)
            }
        }
        
    }

   

    
}


