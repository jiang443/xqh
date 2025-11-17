//
//  LoginView.swift
//  Rent
//
//  Created by jiang 2019/2/26.
//  Copyright © 2019年 jiang. All rights reserved.
//

import UIKit
import SwiftEventBus
import BSCommon

protocol LoginViewDelegate: NSObjectProtocol {
    func doLogin(phone: String?, code: String?)
}

class LoginView: UIView {
    // 代理
    weak var delegate: LoginViewDelegate?
    
    /// logo
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    
    /// 提示信息
    lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.text = "为了您的账户安全，请绑定您的手机号码"
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.font = TextFont_14
        return label
    }()
    
    // 浮框
    lazy var centerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    // 第一条横线
    lazy var hLine1: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.color(withHexString: "#EBEBEB")
        return label
    }()
    
    // 第二条分割线
    lazy var hLine2: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.color(withHexString: "#EBEBEB")
        return label
    }()

    // 账号输入框
    lazy var userTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入账号/手机号"
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.clearButtonMode = .whileEditing
        textField.addLeftView()
        return textField
    }()
    
    // 验证码输入框
    lazy var codeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入密码"
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.isSecureTextEntry = true
        textField.clearButtonMode = .whileEditing
        textField.addLeftView()
        return textField
    }()
    
    // 发送验证码按钮
    lazy var sendCodeButton: UIButton = {
        let button = UIButton()
        button.setTitle("发送验证码", for: .normal)
        button.backgroundColor = UIColor(white: 0.9, alpha: 1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        return button
    }()
    
    // 登录按钮
    lazy var loginBtn: UIButton = {
        let button = UIButton()
        button.setTitle("登录", for: .normal)
        button.backgroundColor = UIColor.color(withHexString: "#2BA8FF")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 22.5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(loginBtnClicked), for: .touchUpInside)
        return button
    }()
    
    /// copyRight
    lazy var copyRightButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        let attrTitle = StringUtils.getColoredString("登录即代表已经同意", coloredStr: "《新起航用户服务协议》", color: UIUtils.getLightBlueColor())
        btn.setAttributedTitle(attrTitle, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.addTarget(self, action: #selector(goAgreement), for: .touchUpInside)
        return btn
    }()
    
    ///指示当前版本使用哪个环境
    lazy var configLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = UIColor.clear
        label.text = ""
        label.backgroundColor = UIColor.clear
        return label
    }()
    
    /// Debug模式是否开启
    lazy var debugLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = UIColor.clear
        label.text = "Debug"
        label.backgroundColor = UIColor.clear
        return label
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.color(withHexString: "#F6F6F6")
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// UI
    func setupUI() {
        
        self.addSubview(self.logoImageView)
        self.logoImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(100)
            make.top.equalToSuperview().offset(80)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(centerView)
        self.centerView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(logoImageView.snp.bottom).offset(15)
            make.height.equalTo(300)
        }
        
        self.centerView.addSubview(self.tipLabel)
        self.tipLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.right.equalToSuperview()
            make.height.equalTo(20)
        }
        
        self.centerView.addSubview(self.configLabel)
        self.configLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(20)
            make.top.equalTo(self.tipLabel.snp.bottom).offset(10)
        }

        self.centerView.addSubview(self.userTextField)
        
        self.userTextField.snp.makeConstraints { (make) in
            make.top.equalTo(tipLabel.snp.bottom).offset(50)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(30)
        }
        
        self.centerView.addSubview(self.hLine1)
        self.hLine1.snp.makeConstraints { (make) in
            make.bottom.equalTo(userTextField)
            make.left.right.equalTo(userTextField)
            make.height.equalTo(1)
        }
        
        self.centerView.addSubview(self.codeTextField)
        self.codeTextField.snp.makeConstraints { (make) in
            make.top.equalTo(userTextField.snp.bottom).offset(20)
            make.left.width.height.equalTo(self.userTextField)
        }
        
        self.centerView.addSubview(self.hLine2)
        self.hLine2.snp.makeConstraints { (make) in
            make.bottom.equalTo(codeTextField)
            make.left.right.equalTo(codeTextField)
            make.height.equalTo(1)
        }
        
        self.centerView.addSubview(self.sendCodeButton)
        self.sendCodeButton.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.right.equalTo(codeTextField)
            make.bottom.equalTo(codeTextField.snp.bottom).offset(-5)
        }
        
        self.centerView.addSubview(self.loginBtn)
        self.loginBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(45)
            make.bottom.equalTo(self.centerView.snp.bottom).offset(-15)
        }
        
        self.addSubview(self.copyRightButton)
        self.copyRightButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(25)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.bottom.equalToSuperview().offset(-12 - (TabBarBottomHeight > 0 ? 15 : 0))
        }
        
        if NetWorkConfig.allowDebug{
            let press = UILongPressGestureRecognizer(target: self, action: #selector(touchDebug(_:)))
            press.minimumPressDuration = 3.0
            self.logoImageView.isUserInteractionEnabled = true
            self.logoImageView.addGestureRecognizer(press)
            
            self.addSubview(self.debugLabel)
            self.debugLabel.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(logoImageView.snp.bottom).offset(-5)
                make.width.equalTo(100)
                make.height.equalTo(35)
            }
        }
        
    }
    
    @objc func loginBtnClicked() {
        self.endEditing(true)
        print("login")
        delegate?.doLogin(phone: self.userTextField.text, code: self.codeTextField.text)
    }
    
    @objc func goAgreement(){
        YYHUD.showToast("Agreement")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    @objc func touchDebug(_ sender:UILongPressGestureRecognizer){
        ///
    }
}




