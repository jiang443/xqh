//
//  SettingTwoPasswordView.swift
//  BSNurse
//
//  Created by jiang 2019/4/4.
//  Copyright © 2019年 iDoctor. All rights reserved.
//

import UIKit

class SettingTwoPasswordView: UIView {

    /// 确认密码
    var confirmPassword: ((_ text: String) -> Void)?
    
    /// 弹框
    lazy var alertView: UIView = {
        var alertY = 90
        if UI_IS_IPHONEX || UI_IS_IPHONEXR {
            alertY = 150
        }
        let view = UIView(frame: CGRect(x: 15, y: alertY, width: Int(ScreenWidth - 30), height: 310))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    /// 标题
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "设置二级密码"
        label.textColor = TextColor_3
        label.font = TextFont_16
        return label
    }()
    
    /// 子标题1
    lazy var subTitleLabel1: UILabel = {
        let label = UILabel()
        label.text = "请输入二级密码"
        label.textColor = TextColor_6
        label.font = TextFont_12
        return label
    }()
    
    /// 密码框1
    lazy var passwordView1: PasswordView = {
        let view = PasswordView()
        return view
    }()
    
    /// 子标题2
    lazy var subTitleLabel2: UILabel = {
        let label = UILabel()
        label.text = "请输入二级密码"
        label.textColor = TextColor_6
        label.font = TextFont_12
        return label
    }()
    
    /// 密码框2
    lazy var passwordView2: PasswordView = {
        let view = PasswordView()
        return view
    }()
    
    /// 提示
    lazy var tipsLabel: UILabel = {
        let label = UILabel()
        label.text = "*为了您的账户安全，首次进入个人中心需设置二次密码"
        label.textColor = UIColor.color(withHexString: "#D1D1D1")
        label.font = TextFont_12
        return label
    }()
    
    /// 确定按钮
    lazy var confirmBtn: UIButton = {
        let button = UIButton()
        button.setTitle("确定", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.backgroundColor = UIColor.color(withHexString: "#2BA8FF")
        button.layer.cornerRadius = 21
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(confirmBtnClicked), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        self.backgroundColor = UIColor.color(withHexString: "#000000").withAlphaComponent(0.5)
        
        self.passwordView1.textDidBeginEditing = {
            UIView.animate(withDuration: 0.25, animations: {
                self.wy_y = -50
            })
        }
        
        self.passwordView1.textDidEndEditing = {
            UIView.animate(withDuration: 0.25, animations: {
                self.wy_y = 0
            })
        }
        
        self.passwordView2.textDidBeginEditing = {
            UIView.animate(withDuration: 0.25, animations: {
                self.wy_y = -50
            })
        }
        
        self.passwordView2.textDidEndEditing = {
            UIView.animate(withDuration: 0.25, animations: {
                self.wy_y = 0
            })
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// UI
    func setupUI() {
        self.addSubview(self.alertView)
        
        self.alertView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(24)
            make.height.equalTo(17)
        }
        
        self.alertView.addSubview(self.subTitleLabel1)
        self.subTitleLabel1.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(70)
            make.height.equalTo(13)
        }
        
        self.alertView.addSubview(self.passwordView1)
        self.passwordView1.snp.makeConstraints { (make) in
            make.top.equalTo(self.subTitleLabel1.snp.bottom).offset(12)
            make.left.equalTo(self.subTitleLabel1)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(45)
        }
        
        self.alertView.addSubview(self.subTitleLabel2)
        self.subTitleLabel2.snp.makeConstraints { (make) in
            make.left.height.equalTo(self.subTitleLabel1)
            make.top.equalToSuperview().offset(165)
        }
        
        self.alertView.addSubview(self.passwordView2)
        self.passwordView2.snp.makeConstraints { (make) in
            make.top.equalTo(self.subTitleLabel2.snp.bottom).offset(12)
            make.left.right.height.equalTo(self.passwordView1)
        }
        
        self.alertView.addSubview(self.tipsLabel)
        self.tipsLabel.snp.makeConstraints { (make) in
            make.left.height.equalTo(self.subTitleLabel1)
            make.top.equalToSuperview().offset(245)
        }
        
        self.addSubview(self.confirmBtn)
        self.confirmBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.alertView.snp.bottom).offset(-21)
            make.width.equalTo(150)
            make.height.equalTo(42)
        }
    }
    
    /// Action
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    @objc func confirmBtnClicked() {
        self.endEditing(true)
        
        let psw1 = self.passwordView1.password
        let psw2 = self.passwordView2.password
        
        if psw1.count == 0 || psw2.count == 0 {
            YYHUD.showToast("请输入二级密码")
            return
        }
        if psw1.count != 6 || psw2.count != 6 {
            YYHUD.showToast("请输入6位二级密码")
            return
        }
        
        if !psw1.isEqualTo(str: psw2) {
            YYHUD.showToast("密码不一致，请重新输入")
            return
        }

        confirmPassword?(psw1)
    }
}
