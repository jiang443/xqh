//
//  OrderConfirmViewController.swift
//  Rent
//
//  Created by jiang on 2021/5/18.
//  Copyright © 2021 jiang. All rights reserved.
//

import DZNEmptyDataSet

class OrderConfirmViewController: BSBaseViewController {
    
    var productIds = ""

    let cellBuyId = "cellBuyId"
    
    let cellRentId = "cellRentId"
        
    var dataList = [OrderProductModel]()
    
    var address = AddressModel(){
        didSet{
            self.headerView.model = address
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIUtils.getBackgroundColor()
        tableView.separatorStyle = .none
        tableView.register(OrderConfirmRentCell.self, forCellReuseIdentifier: cellRentId)
        tableView.register(OrderConfirmBuyCell.self, forCellReuseIdentifier: cellBuyId)
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        //tableView.tableHeaderView = self.headerView
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    lazy var viewModel: OrderViewModel = {
        return OrderViewModel()
    }()
    
    lazy var headerView: AddressHeaderView = {
        let header = AddressHeaderView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 80))
        header.delegate = self
        return header
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "购物车"
        self.setNavTheme()
        setupUI()
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
        
        self.view.backgroundColor = UIUtils.getBackgroundColor()
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(footerView.snp.top)
        }
    }
    
    func getData() {
        YYHUD.showStatus("请稍候")
        self.viewModel.orderProducts(ids: self.productIds) { (list: [OrderProductModel]) in
            YYHUD.dismiss()
            self.dataList = list
            if self.dataList.count == 0{
                self.tableView.tableHeaderView = nil
            }
            else{
                self.tableView.tableHeaderView = self.headerView
            }
            self.tableView.reloadData()
        } failureCallBack: { (msg, code) in
            YYHUD.dismiss()
            YYHUD.showToast(msg)
        }
    }

}

extension OrderConfirmViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.dataList[indexPath.row]
        if model.saleType == 2{     //只买
            return 245
        }
        return 355
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.dataList[indexPath.row]
        if model.saleType == 2{ //只买
            let cell = tableView.dequeueReusableCell(withIdentifier: cellBuyId, for: indexPath) as! OrderConfirmBuyCell
            cell.index = indexPath.row
            //cell.delegate = self
            cell.model = self.dataList[indexPath.row]
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellRentId, for: indexPath) as! OrderConfirmRentCell
            cell.index = indexPath.row
            //cell.delegate = self
            cell.model = self.dataList[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let detailVc = PatientsDetailViewController()
//        detailVc.patientId = (self.dataList[indexPath.row].id)
//        self.navigationController?.pushViewController(detailVc, animated: true)
    }
    
    func getFooterView() -> UIView{
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 50)
        
        let button = UIButton()
        button.backgroundColor = UIUtils.getThemeColor()
        button.setTitle("提交订单", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(submit), for: .touchUpInside)
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        return view
    }
    
    @objc func submit(){
        if self.dataList.count > 0{
            YYHUD.showStatus("请稍候")
            let user = UserInfoManager.shareManager().getUserInfo()
            self.viewModel.submitOrder(clientId: "\(user.id)",
                                       addressId: self.address.id,
                                       shippingCartIds: self.productIds) {
                YYHUD.dismiss()
                
                let board = UIStoryboard(name: "OrderStoryboard", bundle: nil)
                if let editAddressVc = board.instantiateViewController(withIdentifier: "order_submit_res") as? SubmitOrderResultController{
                    editAddressVc.orderNo = "NO.007"
                    self.navigationController?.pushViewController(editAddressVc, animated: true)
                }
                
            } failureCallBack: { msg, code in
                YYHUD.dismiss()
                YYHUD.showToast(msg)
            }

            
            
        }
        else{
            YYHUD.showToast("没有产品，无法提交")
        }
    }
    
}

extension OrderConfirmViewController: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, AddressHeaderViewDelegate {
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
    
    func onTouchAddressEdit() {
        let listVc = AddressListViewController()
        listVc.selectedModel = self.address
        self.navigationController?.pushViewController(listVc, animated: true)
    }
}
