//
//  InputTwoPasswordView.swift
//  BSNurse
//
//  Created by jiang 2019/4/4.
//  Copyright © 2019年 iDoctor. All rights reserved.
//

import UIKit

class InputTwoPasswordView: UIView {

    /// 确认密码
    var confirmPassword: ((_ text: String) -> Void)?
    
    /// 忘记密码
    var forgetPassword: (() -> Void)?

    /// 弹框
    lazy var alertView: UIView = {
        var alertY = 90
        if UI_IS_IPHONEX || UI_IS_IPHONEXR {
            alertY = 150
        }
        let view = UIView(frame: CGRect(x: 15, y: alertY, width: Int(ScreenWidth - 30), height: 260))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    /// 标题
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "请输入二级密码"
        label.textColor = TextColor_3
        label.font = TextFont_16
        return label
    }()
    
    /// 密码框1
    lazy var passwordView1: PasswordView = {
        let view = PasswordView()
        return view
    }()
    
    /// 提示
    lazy var tipsLabel: UILabel = {
        let label = UILabel()
        label.text = "*为了您的账户安全，进入个人中心需输入二级密码"
        label.textColor = UIColor.color(withHexString: "#D1D1D1")
        label.font = TextFont_12
        return label
    }()
    
    /// 忘记密码按钮
    lazy var forgetBtn: UIButton = {
        let button = UIButton()
        button.setTitle("忘记密码？", for: .normal)
        button.setTitleColor(UIColor.color(withHexString: "#2BA8FF"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(forgetBtnClicked), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        self.backgroundColor = UIColor.color(withHexString: "#000000").withAlphaComponent(0.5)
        
        self.passwordView1.inputFinish = { password in
            self.confirmPassword?(password)
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
        
        self.alertView.addSubview(self.passwordView1)
        self.passwordView1.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(77)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(45)
        }
        
        self.alertView.addSubview(self.tipsLabel)
        self.tipsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.passwordView1)
            make.height.equalTo(12)
            make.top.equalTo(self.passwordView1.snp.bottom).offset(12)
        }
        
        self.alertView.addSubview(self.forgetBtn)
        self.forgetBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.tipsLabel.snp.bottom).offset(30)
            make.width.equalTo(80)
            make.height.equalTo(25)
        }
    }
    
    /// Action
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    @objc func forgetBtnClicked() {
        self.endEditing(true)
        
        forgetPassword?()
    }
}
