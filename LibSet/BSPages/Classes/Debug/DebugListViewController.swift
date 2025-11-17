//
//  DebugListViewController.swift
//  Rent
//
//  Created by jiang on 2018/5/26.
//  Copyright © 2018年 sanxin. All rights reserved.
//

import UIKit
import BSBase
import BSCommon

class DebugListViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    var tableView = UITableView()
    let cellIdentifier = "cellIdentifier"
    var ismodal = false
    
    override func initUI() {
        super.initUI()
        self.title = "调试模式"
        setNavTheme()
        
        if ismodal{
            self.navigationItem.leftBarButtonItem = nil
            self.rightButton.setTitle("完成", for:.normal)
            self.rightButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        }
        
        self.tableView.backgroundColor = UIColor.white
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(CommonTableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        self.tableView.tableFooterView = UIView()
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints {[unowned self] (make) in
            make.left.right.top.bottom.equalTo(self.view)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0{
            if UserInfoManager.shareManager().isLogin(){
                DialogUtils.showMessage("请在退出登录后修改环境", title: "提示")
                return
            }
            let apiSetting = APISettingsViewController()
            self.navigationController?.pushViewController(apiSetting, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! CommonTableViewCell
        
        cell.textLabel?.text = "*"
        if indexPath.row == 0{
            cell.textLabel?.text = "环境配置"
        }
        
        return cell
    }
    
    override func handleBack() {
        self.cancel()
    }
    
    @objc func cancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
