//
//  EditAddressViewController.swift
//  Rent
//
//  Created by jiang on 2021/5/19.
//  Copyright © 2021 jiang. All rights reserved.
//

import DZNEmptyDataSet

class EditAddressViewController: BSBaseViewController {
    
    var productIds = ""

    let cellId = "cellId"
        
    var model = AddressModel()
    
    let picker = BRAddressPickerView()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIUtils.getBackgroundColor()
        //tableView.separatorStyle = .none
        tableView.register(EditAddressCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = getFooterView()
        return tableView
    }()
    
    lazy var viewModel: OrderViewModel = {
        return OrderViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "编辑收货地址"
        setupUI()
    }
    
    /// UI
    func setupUI() {
        self.view.backgroundColor = UIUtils.getBackgroundColor()
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        picker.pickerMode = .area
        picker.title = "请选择地区"
        picker.isAutoSelect = true
        picker.resultBlock = { provience, city, area in
            if let cell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? EditAddressCell{
                self.model.province = provience?.name ?? ""
                self.model.city = city?.name ?? ""
                self.model.area = area?.name ?? ""
                let str = "\(self.model.province)\(self.model.city)\(self.model.area)"
                cell.textView.text = str
                self.tableView.endEditing(true)
            }
        }
    }
}

extension EditAddressViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3{
            return 70
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EditAddressCell
        cell.indexPath = indexPath
        cell.model = self.model
        cell.textView.isUserInteractionEnabled = true
        cell.textView.delegate = self
        cell.textView.tag = indexPath.row
        if indexPath.row == 2{
            cell.textView.isUserInteractionEnabled = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2{
            picker.show()
        }
    }
    
    func getFooterView() -> UIView{
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 80)
        let centerX = ScreenWidth/2
        
        let deleteBtn = UIButton()
        deleteBtn.backgroundColor = UIColor.lightGray
        deleteBtn.setTitle("删除", for: .normal)
        deleteBtn.setTitleColor(UIColor.white, for: .normal)
        deleteBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        deleteBtn.addTarget(self, action: #selector(deleteAddress), for: .touchUpInside)
        view.addSubview(deleteBtn)
        deleteBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-centerX - 15)
            make.width.equalTo(120)
            make.height.equalTo(45)
        }
        
        let button = UIButton()
        button.backgroundColor = UIUtils.getThemeColor()
        button.setTitle("保存", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(saveAddress), for: .touchUpInside)
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(centerX + 15)
            make.width.equalTo(120)
            make.height.equalTo(45)
        }
        return view
    }
    
    @objc func saveAddress() {
        YYHUD.showStatus("请稍候")
        let user = UserInfoManager.shareManager().getUserInfo()
        self.viewModel.saveAddress(city: self.model.city,
                                   id: model.id,
                                   receivePhone: model.receivePhone,
                                   address: model.address,
                                   clientId: "\(user.id)",
                                   area: self.model.area,
                                   province: self.model.province,
                                   receiveName: model.receiveName) {
            YYHUD.dismiss()
            YYHUD.showToast("保存成功")
            self.navigationController?.popViewController(animated: true)
        } failureCallBack: { msg, code in
            YYHUD.dismiss()
            YYHUD.showToast(msg)
        }
    }
    
    @objc func deleteAddress(){
        if self.model.id.isEmpty{
            return
        }
        let msg = "是否确定删除这条地址？"
        let alert = UIAlertController(title: "提示", message: msg, preferredStyle: .alert)
        alert.addAction(title: "取消", color: UIColor.gray, action: { (action) in
            ///
        })
        alert.addAction(title: "确认", color: UIUtils.getThemeColor(), action: { action in
            YYHUD.showStatus("请稍候")
            self.viewModel.deleteAddress(id: self.model.id) {
                YYHUD.dismiss()
                YYHUD.showToast("地址删除")
                self.navigationController?.popViewController(animated: true)
            } failureCallBack: { msg, code in
                YYHUD.dismiss()
                YYHUD.showToast(msg)
            }
        })
        self.present(alert, animated: true, completion: nil)
    }
}

extension EditAddressViewController: UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.picker.dismiss()
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        switch textView.tag {
        case 0:
            model.receiveName = textView.text
        case 1:
            model.receivePhone = textView.text
        case 3:
            model.address = textView.text
        default:
            break
        }
    }
}

