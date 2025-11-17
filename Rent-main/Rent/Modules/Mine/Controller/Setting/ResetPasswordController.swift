//
//  ResetPasswordController.swift
//  Rent
//
//  Created by jiang 2019/3/4.
//  Copyright © 2019年 jiang. All rights reserved.
//

import UIKit

class ResetPasswordController: BSBaseViewController {
    
    let cellId = "cellId"
    
    var confirmBtn = UIButton()
    
    var oldPasswordTextField: UITextField!
    var newPasswordTextField: UITextField!
    var confirmPasswordTextField: UITextField!

    lazy var viewModel: SettingViewModel = {
        return SettingViewModel()
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIUtils.getBackgroundColor()
        tableView.register(ResetPasswordCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        tableView.tableFooterView = tableFooterView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "修改密码"

        setupUI()
        addObserver()
    }
    
    /// Observer
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        YYLog("deinit")
    }
    
    /// UI
    func setupUI() {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func tableFooterView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 45))
        footerView.backgroundColor = UIColor.clear
        confirmBtn = UIButton(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 45))
        confirmBtn.setTitle("确定", for: .normal)
        confirmBtn.setTitleColor(UIColor.darkGray, for: .normal)
//        confirmBtn.backgroundColor = UIColor.color(withHexString: "#AAAAAA")
        confirmBtn.backgroundColor = UIColor.lightGray
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        confirmBtn.addTarget(self, action: #selector(confirmBtnClicked), for: .touchUpInside)
        confirmBtn.isUserInteractionEnabled = false
        footerView.addSubview(confirmBtn)
        return footerView
    }
    
    /// Action
    @objc func confirmBtnClicked() {
        self.view.endEditing(true)
        
        let oldStr = oldPasswordTextField.text!
        let newStr = newPasswordTextField.text!
        let confirmStr = confirmPasswordTextField.text!
        
        if oldStr.isEmpty {
            YYHUD.showToast("请输入旧密码！")
            return
        } else if newStr.isEmpty {
            YYHUD.showToast("请输入新密码！")
            return
        } else if confirmStr.isEmpty || confirmStr != newStr {
            YYHUD.showToast("两次新密码输入不一致！")
            return
        }

        let alert = UIAlertController(title: "提示", message: "您确定要修改密码吗？", preferredStyle: .alert)
        UIUtils.addActionTarget(alert, title: "取消", color: UIColor.darkGray)
        { (action) in
            
        }
        UIUtils.addActionTarget(alert, title: "确定", color: UIUtils.getTextBlueColor()) {[unowned self] (action) in
            self.changePassword()
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func changePassword() {
        
        SettingViewModel().changePassword(oldPassword: oldPasswordTextField.text!, newPassword: newPasswordTextField.text!) {
            let alert = UIAlertController(title: "说明", message: "修改密码成功，请重新登录", preferredStyle: .alert)
            UIUtils.addActionTarget(alert, title: "确定", color: UIUtils.getTextBlueColor()) { (action) in
//                UIUtils.getAppDelegate().logout()
//                SettingUserDefault.setFirstLogin(isFirstLogin: "0") //已修改密码，修改缓存 1:首次 0:非首次
//                if self.isSinglePage{
//                    self.dismiss(animated: true, completion: nil)
//                }
//                else{
//                    MainManager.getInstance().logout(needLogin: true)
//                }
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func textFieldDidChange() {
        let oldStr = self.oldPasswordTextField.text!
        let newStr = self.newPasswordTextField.text!
        let confirmStr = self.confirmPasswordTextField.text!
        
        var flag = true
        
        if oldStr.count < 6 || oldStr.count > 16 {
            flag = false
        }
        
        if newStr.count < 6 || newStr.count > 16 {
            flag = false
        }
        else if confirmStr.count < 6 || confirmStr.count > 16 {
            flag = false
        }
        
        if flag {
            self.confirmBtn.isUserInteractionEnabled = true
            self.confirmBtn.setTitleColor(UIColor.white, for: .normal)
            self.confirmBtn.backgroundColor = UIUtils.getLightBlueColor()
        }
        else{
            self.confirmBtn.isUserInteractionEnabled = false
            self.confirmBtn.setTitleColor(UIColor.darkGray, for: .normal)
            self.confirmBtn.backgroundColor = UIColor.lightGray
        }
    }
}

extension ResetPasswordController: UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return UIView()
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "旧密码"
        } else if section == 1 {
            return "新密码"
        } else {
            return "确认新密码"
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.01
        } else if section == 1 {
            return 0.01
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ResetPasswordCell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ResetPasswordCell
        
        if indexPath.section == 0 {
            self.oldPasswordTextField = cell.textField
        } else if indexPath.section == 1 {
            self.newPasswordTextField = cell.textField
        } else if indexPath.section == 2 {
            self.confirmPasswordTextField = cell.textField
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
//        if alertView.tag == 1 && buttonIndex == 1 {
//            UserViewModel().logout {
//                UIUtils.getAppDelegate().logout()
//                YYHUD.showSuccess("退出成功")
//            }
//        }
    }
    
    
}


