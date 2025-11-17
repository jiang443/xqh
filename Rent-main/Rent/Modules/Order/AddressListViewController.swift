//
//  AddressListViewController.swift
//  Rent
//
//  Created by jiang on 2021/5/19.
//  Copyright © 2021 jiang. All rights reserved.
//

import BSCommon
import DZNEmptyDataSet

class AddressListViewController: BSBaseViewController {
    
    var productIds = ""

    let cellId = "cellId"
        
    var dataList = [AddressModel]()
    
    var selectedModel = AddressModel()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIUtils.getBackgroundColor()
        tableView.separatorStyle = .none
        tableView.register(AddressListCell.self, forCellReuseIdentifier: cellId)
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    lazy var viewModel: OrderViewModel = {
        return OrderViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择地址"
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getData()
    }
    
    /// UI
    func setupUI() {
        self.view.backgroundColor = UIUtils.getBackgroundColor()
        let footerView = getFooterView()
        self.view.addSubview(footerView)
        footerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-TabBarBottomHeight)
            make.height.equalTo(50)
        }
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(footerView.snp.top)
        }
    }
    
    func getData() {
        YYHUD.showStatus("请稍候")
        self.viewModel.getAddressList { list in
            YYHUD.dismiss()
            self.dataList = list
            self.tableView.reloadData()
        } failureCallBack: { (msg, code) in
            YYHUD.dismiss()
            YYHUD.showToast(msg)
        }
    }

}

extension AddressListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AddressListCell
        cell.index = indexPath.row
        var model = self.dataList[indexPath.row]
        model.isSelected = false
        if model.id == self.selectedModel.id{
            model.isSelected = true
        }
        cell.model = model
        cell.delegate = self        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let backVc = self.backViewController as? OrderConfirmViewController{
            backVc.address = self.dataList[indexPath.row]
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func getFooterView() -> UIView{
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 50)
        
        let button = UIButton()
        button.backgroundColor = UIUtils.getThemeColor()
        button.setTitle("+ 新建收货地址", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(addAddress), for: .touchUpInside)
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        return view
    }
    
    @objc func addAddress(){
        let editAddressVc = EditAddressViewController()
        self.navigationController?.pushViewController(editAddressVc, animated: true)
    }
    
}

extension AddressListViewController: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, AddressListCellDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "icon_empty")
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -NavHeight
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        self.getData()
    }
    
    func editAddress(index: Int){
        let model = self.dataList[index]
        let editVc = EditAddressViewController()
        editVc.model = model
        self.navigationController?.pushViewController(editVc, animated: true)
    }
    
}

