//
//  AboutVersionViewController.swift
//  Rent
//
//  Created by jiang 2019/2/28.
//  Copyright © 2019年 jiang. All rights reserved.
//

import UIKit
import BSCommon

class AboutVersionViewController: BSBaseViewController {

    let versionView = AboutVersionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "关于版本"
        setupUI()
    }
    /// UI
    func setupUI() {
        self.view.addSubview(versionView)
        
        versionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let infoDictionary = Bundle.main.infoDictionary
        let name :AnyObject? = infoDictionary!["CFBundleDisplayName"] as AnyObject
        versionView.nameLabel.text = name as? String
        
        versionView.versionLabel.text = IOSUtils.getAppVersion()
        
//        #if DEBUG
//        versionView.devVersionLabel.text = "测试版本：" + IOSUtils.getAppBundleVersion()
//        #endif

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if NetWorkConfig.onDebug{
            versionView.touchLabel.backgroundColor = UIUtils.getRedColor()
            versionView.touchLabel.textColor = UIColor.white
        }
        else{
            versionView.touchLabel.backgroundColor = UIColor.clear
            versionView.touchLabel.textColor = UIColor.clear
        }
        switch NetWorkConfig.configType {
        case .dev:
            versionView.typeLabel.backgroundColor = UIUtils.getRedColor()
            versionView.typeLabel.textColor = UIColor.white
            versionView.typeLabel.text = "开发环境"
        case .test:
            versionView.typeLabel.backgroundColor = UIColor.brown
            versionView.typeLabel.textColor = UIColor.white
            versionView.typeLabel.text = "测试环境"
        case .pro:
            if NetWorkConfig.onDebug == true{
                versionView.typeLabel.backgroundColor = UIColor.color(hex: "#9933ff")
                versionView.typeLabel.textColor = UIColor.white
                versionView.typeLabel.text = "生产环境"
            }
            else{
                versionView.typeLabel.backgroundColor = UIColor.clear
                versionView.typeLabel.textColor = UIColor.clear
                versionView.typeLabel.text = ""
            }
        default:
            break
        }
        
    }
    
    
}

