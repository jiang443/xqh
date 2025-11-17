//
//  AboutVersionView.swift
//  Rent
//
//  Created by jiang 2019/2/28.
//  Copyright © 2019年 jiang. All rights reserved.
//

import UIKit
import SwiftEventBus
import BSCommon

class AboutVersionView: UIView {

    lazy var iconBgView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 24
        view.layer.masksToBounds = true
//        view.layer.borderWidth = 1
//        view.layer.borderColor = UIColor.color(withHexString: "#EEEEEE").cgColor
        return view
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        label.text = IOSUtils.getAppName()
        label.textColor = UIColor.color(withHexString: "#6A6A6A")
        return label
    }()
    
    lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = UIColor.color(withHexString: "#6A6A6A")
        label.text = "1.0.0"
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.darkGray.cgColor
        label.layer.cornerRadius = 11
        label.layer.masksToBounds = true
        return label
    }()
    
    lazy var companyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.textColor = UIColor.color(withHexString: "#C4C4C4")
        label.text = "***公司"
        return label
    }()
    
    lazy var rightsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.textColor = UIColor.color(withHexString: "#C4C4C4")
        label.text = "2023 All Rights Reserved." + " (" + IOSUtils.getAppBundleVersion() + ")"
        return label
    }()
    
    lazy var devVersionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = UIColor.color(withHexString: "#6A6A6A")
        label.text = ""
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    ///指示当前版本使用哪个环境 added by jiang
    let typeLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = UIColor.clear
        label.text = ""
        label.backgroundColor = UIColor.clear
        return label
    }()
    
    ///触发Debug模式 added by jiang
    let touchLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = UIColor.clear
        label.text = "Debug"
        label.backgroundColor = UIColor.clear
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// UI
    func setupUI() {
        self.addSubview(self.iconBgView)
        self.iconBgView.addSubview(self.iconImageView)
        self.addSubview(self.nameLabel)
        self.addSubview(self.versionLabel)
        self.addSubview(self.companyLabel)
        self.addSubview(self.rightsLabel)
        self.addSubview(self.devVersionLabel)

        self.iconBgView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
            make.top.equalToSuperview().offset(36)
        }
        
        self.iconImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.iconBgView.snp.bottom).offset(22)
            make.height.equalTo(22)
        }
        
        self.versionLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.nameLabel.snp.bottom).offset(9)
            make.height.equalTo(22)
            make.width.equalTo(68)
        }
        
        self.rightsLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-14)
            make.height.equalTo(21)
        }
        
        self.companyLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-33)
            make.height.equalTo(21)
        }
        
        self.devVersionLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-54)
        }

        self.addSubview(typeLabel)
        self.typeLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(versionLabel.snp.bottom).offset(40)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        if NetWorkConfig.allowDebug{
            let press = UILongPressGestureRecognizer(target: self, action: #selector(touchDebug(_:)))
            press.minimumPressDuration = 3.0
            self.touchLabel.isUserInteractionEnabled = true
            self.touchLabel.addGestureRecognizer(press)
            self.touchLabel.backgroundColor = UIColor.clear
            
            self.addSubview(self.touchLabel)
            self.touchLabel.snp.makeConstraints { (make) in
                make.left.top.equalTo(self)
                make.width.height.equalTo(64)
            }
        }
        
    }
    
    @objc func touchDebug(_ sender:UILongPressGestureRecognizer){
        if sender.state == .began{
            let alert = UIAlertController(title: "调试模式", message: "非技术人员请不要进入调试模式，修改其中配置信息可能对APP功能与数据造成不可恢复的影响！", preferredStyle: .actionSheet)
            UIUtils.addActionTarget(alert, title: "确定进入", color: UIUtils.getRedColor()) { (action) in
                SwiftEventBus.post(Event.System.setConfig.rawValue)
            }
            UIUtils.addCancelActionTarget(alert, title: "取消")
            UIUtils.getCurrentVC()?.present(alert, animated: true, completion: nil)
        }
    }
}
