//
//  LoginViewController.swift
//  Rent
//
//  Created by jiang 2019/2/26.
//  Copyright © 2019年 jiang. All rights reserved.
//

import UIKit
import BSCommon

class LoginViewController: BSBaseViewController {

    let loginView = LoginView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))

    lazy var viewModel: UserViewModel = {
        return UserViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "登录"
        self.setNavTheme()
        addObserver()
        setupUI()
        initData()
    }

    /// UI
    func setupUI() {
        self.view.addSubview(loginView)
        loginView.delegate = self
        
        loginView.sendCodeButton.addTarget(self, action: #selector(sendCode), for: .touchUpInside)
    }
    
    @objc func sendCode(){
        let phone = loginView.userTextField.text!
        if phone.isEmpty{
            YYHUD.showToast("请输入手机号")
            return
        }
        self.viewModel.sendCode(phone: phone, successCallBack: {
            
        }) { (msg, code) in
            
        }
    }

    /// Data
    override func initData() {
        loginView.userTextField.text = SettingUserDefault.getCacheAccount()
        loginView.codeTextField.text = SettingUserDefault.getCachePassword()
    }

    /// observer
    func addObserver() {

        // 监听键盘的出现
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        // 监听键盘的消失
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        YYLog("viewDidAppear")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    // 键盘弹出
    @objc func keyboardWillShow(_ aNotifivation: Notification) {
        print("show")
        let info: NSDictionary? = aNotifivation.userInfo! as NSDictionary
        // 键盘尺寸
        let kbSize = (info?.object(forKey: UIResponder.keyboardFrameEndUserInfoKey) as AnyObject).cgRectValue.size
        
        if UI_IS_IPHONEX || UI_IS_IPHONEXR {
            return
        }
        if UI_IS_IPHONE5 {
            loginView.frame = CGRect.init(x: 0, y: -kbSize.height + 100, width: ScreenWidth, height: ScreenHeight)
        } else {
            loginView.frame = CGRect.init(x: 0, y: -kbSize.height + 200, width: ScreenWidth, height: ScreenHeight)
        }
    }
    
    // 键盘消失
    @objc func keyboardWillHide(_ aNotifivation: Notification) {
        print("hide")
        if UI_IS_IPHONEX || UI_IS_IPHONEXR {
            return
        }
        loginView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
    }

    deinit {
        YYLog("deinit")
    }
}

extension LoginViewController: LoginViewDelegate {
    func doLogin(phone: String?, code: String?) {

        guard let account = phone else {
            YYHUD.showToast("请输入手机号")
            return
        }
        
        guard let vCode = code else {
            YYHUD.showToast("请输入验证码")
            return
        }
        // 不用去掉前后空格 trimmingCharacters
        //        userAccount = userAccount.trimmingCharacters(in: .whitespaces)
        //        pwd = pwd.trimmingCharacters(in: .whitespaces)

        if account.isEmpty {
            YYHUD.showToast("请输入账号/手机号")
            return
        }

        if vCode.isEmpty {
            YYHUD.showToast("请输入验证码")
            return
        }
        loginView.loginBtn.breakFor(3)

        self.viewModel.login(phone: account, code: vCode, successCallBack: {
            let manager = UserInfoManager.shareManager()
            print(StringUtils.LOG + "Token = \(manager.token)")
            SettingUserDefault.setCacheAccount(account)
            SettingUserDefault.setCachePassword(vCode)
            UIUtils.getAppDelegate().login()
        }) { (msg, code) in
            YYHUD.showToast(msg)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if NetWorkConfig.onDebug{
            loginView.configLabel.backgroundColor = UIUtils.getRedColor()
            loginView.configLabel.textColor = UIColor.white
        }
        else{
            loginView.configLabel.backgroundColor = UIColor.clear
            loginView.configLabel.textColor = UIColor.clear
        }
        switch NetWorkConfig.configType {
        case .dev:
            loginView.configLabel.backgroundColor = UIUtils.getRedColor()
            loginView.configLabel.textColor = UIColor.white
            loginView.configLabel.text = "开发环境"
        case .test:
            loginView.configLabel.backgroundColor = UIColor.brown
            loginView.configLabel.textColor = UIColor.white
            loginView.configLabel.text = "测试环境"
        case .pro:
            if NetWorkConfig.onDebug == true{
                loginView.configLabel.backgroundColor = UIColor.color(hex: "#9933ff")
                loginView.configLabel.textColor = UIColor.white
                loginView.configLabel.text = "生产环境"
            }
            else{
                loginView.configLabel.backgroundColor = UIColor.clear
                loginView.configLabel.textColor = UIColor.clear
                loginView.configLabel.text = ""
            }
            
        default:
            break
        }
        
    }
    
}

