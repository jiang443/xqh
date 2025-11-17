//
//  OrderConfirmViewController.swift
//  Rent
//
//  Created by jiang on 2020/9/12.
//  Copyright © 2020 jiang. All rights reserved.
//

import DZNEmptyDataSet

class OrderViewController: BSBaseViewController {
    
    var productIds = ""

    let cellBuyId = "cellBuyId"
    
    let cellRentId = "cellRentId"
    
    var dataList = [OrderProductModel]()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.register(CartRentCell.self, forCellReuseIdentifier: cellRentId)
        tableView.register(CartBuyCell.self, forCellReuseIdentifier: cellBuyId)
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
//        tableView.mj_header = mj_refreshHeader(action: #selector(refreshData))
//        tableView.mj_footer = mj_refreshFooter(action: #selector(loadMoreData))
//        tableView.mj_footer.isHidden = true
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    lazy var viewModel: OrderViewModel = {
        return OrderViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "购物车"
        setupUI()
        self.getData()
    }
    
    /// UI
    func setupUI() {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func getData() {
        YYHUD.showStatus("请稍候")
        self.viewModel.orderProducts(ids: self.productIds) { (list: [OrderProductModel]) in
            YYHUD.dismiss()
            self.dataList = list
            self.tableView.reloadData()
        } failureCallBack: { (msg, code) in
            YYHUD.dismiss()
            YYHUD.showToast(msg)
        }
    }

}

extension OrderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.dataList[indexPath.row]
        if model.saleType == 2{     //只买
            return 240
        }
        return 285
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.dataList[indexPath.row]
        if model.saleType == 2{ //只买
            let cell = tableView.dequeueReusableCell(withIdentifier: cellBuyId, for: indexPath) as! CartBuyCell
            cell.index = indexPath.row
            cell.delegate = self
            cell.model = self.dataList[indexPath.row]
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellRentId, for: indexPath) as! CartRentCell
            cell.index = indexPath.row
            cell.delegate = self
            cell.model = self.dataList[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let detailVc = PatientsDetailViewController()
//        detailVc.patientId = (self.dataList[indexPath.row].id)
//        self.navigationController?.pushViewController(detailVc, animated: true)
    }
    
}

extension OrderViewController: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, CartRentCellDelegate, CartBuyCellDelegate {
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
    
    func deleteProduct(index: Int) {
        print("delete product index = \(index)")
    }
}
