//
//  MineViewController.swift
//  BSNurse
//
//  Created by jiang 2019/3/27.
//  Copyright © 2019年 tmpName. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SwiftEventBus
import BSCommon
import BSBase

class MineViewController: BSBaseViewController {

    let cellId = "cellId"
    let firstCellId = "firstCellId"
    
    static let buyerData = [["icon": "mine_审核", "title": "审核中"], ["icon": "mine_待确认", "title": "待确认"],
            ["icon": "mine_待支付", "title": "待支付"], ["icon": "mine_待验收", "title": "待验收"],
            ["icon": "mine_使用中", "title": "使用中"], ["icon": "mine_待续费", "title": "待续费"],
            ["icon": "mine_待归还", "title": "待归还"], ["icon": "mine_已结束", "title": "已结束"]]
    static let sellerData = [["icon": "mine_审核", "title": "审核中"], ["icon": "mine_待确认", "title": "待确认"],
            ["icon": "mine_待发货", "title": "待发货"], ["icon": "mine_待实施", "title": "待实施"],
            ["icon": "mine_使用中", "title": "使用中"], ["icon": "mine_待续费", "title": "待续费"],
            ["icon": "mine_待结束", "title": "待结束"], ["icon": "mine_已结束", "title": "已结束"]]
    static let serviceData = [["icon": "mine_我的发布", "title": "我的发布"], ["icon": "mine_我的需求", "title": "我的需求"],
            ["icon": "mine_地址管理", "title": "地址管理"], ["icon": "mine_平台客服", "title": "平台客服"],
            ["icon": "mine_个人信息", "title": "个人信息"], ["icon": "mine_常见问题", "title": "常见问题"]]
    let dataList = [buyerData, sellerData, serviceData]

    lazy var viewModel: MineViewModel = {
        return MineViewModel()
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIUtils.getBackgroundColor()
        tableView.register(MineCenterCell.self, forCellReuseIdentifier: cellId)
        tableView.register(MineFirstSectionCell.self, forCellReuseIdentifier: firstCellId)
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 获取用户信息
        UserViewModel().loginInfo {
            self.tableView.reloadData()
        }
    }

    /// Nav
    func setupNav() {
        let settingBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        settingBtn.setImage(UIImage(named: "config"), for: .normal)
//        settingBtn.setTitleColor(UIColor.white, for: .normal)
//        settingBtn.titleLabel?.font = TextFont_15
//        settingBtn.sizeToFit()
        YYLog(settingBtn.frame)
        settingBtn.addTarget(self, action: #selector(goTest), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: settingBtn)
    }

    /// UI
    func setupUI() {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
///调用测试功能专用方法
    @objc func goTest(){
        let vc = OrderConfirmViewController()
        vc.productIds = "205"
        self.navigationController?.pushViewController(vc, animated: true)
        
//        let loginVc = LoginViewController()
//        let nav = UINavigationController(rootViewController: loginVc)
//        nav.modalPresentationStyle = .fullScreen
//        self.present(nav, animated: true, completion: nil)
        
//        let publishVc = WebViewController()
//        publishVc.url = "http://119.23.143.240:9004/Release/index"
//        self.navigationController?.pushViewController(publishVc, animated: true)
    }
    
    /// Action
    @objc func settingBtnClicked() {
        let settingVc = SettingViewController()
        self.navigationController?.pushViewController(settingVc, animated: true)
    }
}

extension MineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 220
        }
        return ScreenWidth * 0.58
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: firstCellId, for: indexPath) as! MineFirstSectionCell
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MineCenterCell
            cell.index = indexPath.row
            cell.dataList = self.dataList[indexPath.row]
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = "我是买家"
            case 1:
                cell.titleLabel.text = "我是卖家"
            case 2:
                cell.titleLabel.text = "我的服务"
            default:
                break
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    
}

