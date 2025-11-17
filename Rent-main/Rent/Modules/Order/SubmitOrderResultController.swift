//
//  SubmitOrderResultController.swift
//  Rent
//
//  Created by jiang on 2021/5/28.
//  Copyright © 2021 jiang. All rights reserved.
//

class SubmitOrderResultController: UITableViewController {
    
    @IBOutlet weak var orderNoLabel: UILabel!
    
    var orderNo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "提交成功"
        self.setNavTheme()
        setupUI()
    }
    
    /// UI
    func setupUI() {
        self.view.backgroundColor = UIUtils.getBackgroundColor()
        self.orderNoLabel.text = "订单号：\(self.orderNo)"
    }
        
    @IBAction func goOrderDetail(_ sender: Any) {
        YYHUD.showToast("goDetail")
    }
    
    
    @IBAction func goOthers(_ sender: Any) {
        YYHUD.showToast("goOthers")
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}



