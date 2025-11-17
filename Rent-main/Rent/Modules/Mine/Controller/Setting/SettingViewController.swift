//
//  SettingViewController.swift
//  Rent
//
//  Created by jiang 2019/2/28.
//  Copyright © 2019年 jiang. All rights reserved.
//

import UIKit

class SettingViewController: BSBaseViewController {

    let cellId = "cellId"
    
    lazy var viewModel: SettingViewModel = {
        return SettingViewModel()
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIUtils.getBackgroundColor()
        tableView.register(SettingListCell.self, forCellReuseIdentifier: cellId)
        tableView.register(SettingLogoutCell.self, forCellReuseIdentifier: "logout")
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置"

        setupUI()
        
    }
    /// UI
    func setupUI() {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    /// 检查更新
    func checkVersion() {
        ThreadUtils.delay(1) {
            YYLog("开始检查更新")
            YYHUD.dismiss()
            UIUtils.getAppDelegate().checkVersion(isShowTips: true)
        }
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.datasource.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 1
        }
        return self.viewModel.datasource[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 2 {
            let cell: SettingLogoutCell = tableView.dequeueReusableCell(withIdentifier: "logout", for: indexPath) as! SettingLogoutCell
            return cell
        }
        let cell: SettingListCell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SettingListCell
        cell.title = self.viewModel.datasource[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 { // 退出
            DialogUtils.showExitConfirm(self, tag: 1)
        } else if indexPath.section == 0 && indexPath.row == 0 { // 修改密码
            self.navigationController?.pushViewController(ResetPasswordController(), animated: true)
        } else if indexPath.section == 1 && indexPath.row == 0 { // 关于版本
            self.navigationController?.pushViewController(AboutVersionViewController(), animated: true)
        } else if indexPath.section == 1 && indexPath.row == 1 { // 检查更新
            YYHUD.showToast("正在检查更新")
            self.checkVersion()
        }
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if alertView.tag == 1 && buttonIndex == 1 {
            UserViewModel().logout {
                UIUtils.getAppDelegate().logout()
                YYHUD.showSuccess("退出成功")
            }
        }
    }
}
