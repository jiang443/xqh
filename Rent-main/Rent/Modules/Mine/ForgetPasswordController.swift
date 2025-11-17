//
//  ForgetPasswordController.swift
//  BSNurse
//
//  Created by jiang 2019/4/4.
//  Copyright © 2019年 iDoctor. All rights reserved.
//

import UIKit

class ForgetPasswordController: BSBaseViewController {

    /// 手机号
    //    lazy var phoneTextField: BorderTextField = {
    //        let textField = BorderTextField()
    //        textField.placeholder = "请输入手机号"
    //        textField.keyboardType = .numberPad
    //        return textField
    //    }()
    /// 定时器
    //    var codeTimer = DispatchSource.makeTimerSource(flags: .init(rawValue: 0), queue: DispatchQueue.global())
    var codeTimer: DispatchSourceTimer?
    
    /// 手机号
    lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.text = "手机号："
        label.textColor = TextColor_6
        label.font = TextFont_13
        return label
    }()
    
    /// 验证码
    lazy var codeTextField: BorderTextField = {
        let textField = BorderTextField()
        textField.placeholder = "请输入验证码"
        textField.keyboardType = .numberPad
        textField.isOnlyNumber = true
        return textField
    }()
    
    /// 新密码
    lazy var pswTextField: BorderTextField = {
        let textField = BorderTextField()
        textField.placeholder = "请输入新的二级密码，6位数字"
        textField.keyboardType = .numberPad
        textField.isSecureTextEntry = true
        textField.isOnlyNumber = true
        textField.limitCount = 6
        return textField
    }()
    
    /// 确认新密码
    lazy var confirmPswTextField: BorderTextField = {
        let textField = BorderTextField()
        textField.placeholder = "请确认密码"
        textField.keyboardType = .numberPad
        textField.isSecureTextEntry = true
        textField.isOnlyNumber = true
        textField.limitCount = 6
        return textField
    }()
    
    /// 获取验证码
    lazy var codeBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("获取验证码", for: .normal)
        button.titleLabel?.font = TextFont_13
        button.backgroundColor = UIColor.color(withHexString: "#2BA8FF")
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(codeBtnClicked(_:)), for: .touchUpInside)
        return button
    }()
    
    /// 重置密码
    lazy var resetBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("重置密码", for: .normal)
        button.titleLabel?.font = TextFont_15
        button.backgroundColor = UIColor.color(withHexString: "#2BA8FF")
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(resetBtnClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var viewModel: MineViewModel = {
        return MineViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "忘记密码"
        
        setupUI()
        getData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.codeTimer?.cancel()
        self.codeTimer = nil
    }
    
    /// Data
    func getData() {
        self.viewModel.getMaskMobile(successCallBack: {
            self.phoneLabel.text = "手机号：\(self.viewModel.maskMobile)"
        }) { (msg, code) in
            YYHUD.showToast(msg)
        }
    }
    
    /// UI
    func setupUI() {
        self.view.addSubview(self.phoneLabel)
        self.phoneLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(45)
            make.left.equalToSuperview().offset(36)
            make.right.equalToSuperview().offset(-36)
            make.height.equalTo(15)
        }
        
        self.view.addSubview(self.codeTextField)
        self.codeTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self.phoneLabel.snp.bottom).offset(24)
            make.left.equalTo(self.phoneLabel)
            make.width.equalTo(ScreenWidth - 92 - 36 - 36 - 18)
            make.height.equalTo(42)
        }
        
        self.view.addSubview(self.codeBtn)
        self.codeBtn.snp.makeConstraints { (make) in
            make.top.height.equalTo(self.codeTextField)
            make.right.equalToSuperview().offset(-36)
            make.width.equalTo(92)
        }
        
        self.view.addSubview(self.pswTextField)
        self.pswTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self.codeTextField.snp.bottom).offset(24)
            make.left.height.equalTo(self.codeTextField)
            make.right.equalToSuperview().offset(-36)
        }
        
        self.view.addSubview(self.confirmPswTextField)
        self.confirmPswTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self.pswTextField.snp.bottom).offset(24)
            make.left.right.height.equalTo(self.pswTextField)
        }
        
        self.view.addSubview(self.resetBtn)
        self.resetBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.confirmPswTextField.snp.bottom).offset(45)
            make.left.right.equalTo(self.pswTextField)
            make.height.equalTo(45)
        }
        
    }
    
    /// Action
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /// 获取验证码的点击
    @objc func codeBtnClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        
        sender.isUserInteractionEnabled = false
        
        sender.backgroundColor = TextColor_9
        
        var time = 60
        
        self.codeTimer = DispatchSource.makeTimerSource(flags: .init(rawValue: 0), queue: DispatchQueue.global())
        
        self.codeTimer?.schedule(deadline: .now(), repeating: .milliseconds(1000))  //此处方法与Swift 3.0 不同
        self.codeTimer?.setEventHandler {
            
            time = time - 1
            
            YYLog("time = \(time)")
            
            if time < 0 {
                self.codeTimer?.cancel()
                self.codeTimer = nil
                DispatchQueue.main.async {
                    self.codeBtn.isUserInteractionEnabled = true
                    self.codeBtn.setTitle("重新发送", for: .normal)
                    self.codeBtn.backgroundColor = UIUtils.getThemeColor()
                }
                return
            }
            
            DispatchQueue.main.async {
                self.codeBtn.setTitle("\(time)", for: .normal)
            }
            
        }
        // 开启定时器
        self.codeTimer?.resume()
        
        self.viewModel.getSMSCode(successCallBack: {
            
        }) { (msg, code) in
            YYHUD.showToast(msg)
        }
    }
    
    /// 重置密码的点击
    @objc func resetBtnClicked() {
        self.view.endEditing(true)
        
        let code = self.codeTextField.content
        let psw1 = self.pswTextField.content
        let psw2 = self.confirmPswTextField.content
        
        if code.isEqualTo(str: "") {
            YYHUD.showToast("请输入验证码")
            return
        }
        if psw1.isEqualTo(str: "") {
            YYHUD.showToast("请输入新的二级密码")
            return
        }
        if psw2.isEqualTo(str: "") {
            YYHUD.showToast("请确认密码")
            return
        }
        if psw1.count != 6 || psw2.count != 6 {
            YYHUD.showToast("请输入6位二级密码")
            return
        }
        if psw1 != psw2 {
            YYHUD.showToast("两次输入的密码不一致，请重新输入")
            return
        }
        
        self.viewModel.resetPassword(veriCode: code, password: psw1, successCallBack: {
            YYHUD.showToast("重置密码成功")
            ThreadUtils.delay(0.75, closure: {
                YYHUD.dismiss()
                self.navigationController?.popViewController(animated: true)
            })
        }) { (msg, code) in
            YYHUD.showToast(msg)
        }
    }
}
