//
//  ProductDetailController.swift
//  Rent
//
//  Created by jiang on 2020/5/5.
//  Copyright © 2020 jiang. All rights reserved.
//

import UIKit
import BSBase
import WebViewJavascriptBridge
import BSCommon

class ProductDetailWebController: WebViewController {

    override func viewDidLoad(){
        super.viewDidLoad()
    }

    override func initData() {
        self.interfaces = ["didBuyImmediately","didShoppingCar","didProductShare","didBrand"]
    }
    
    override func didReceiveCall(name: String, params: Any?, callback: WVJBResponseCallback?) {
        if name == "didBuyImmediately" { // 立即购买
            if let dict = params as? [String:Any]{
                print("data dict = \(dict)")
                let productId = dict.stringValue(key: "id")
                let orderVc = OrderConfirmViewController()
                orderVc.productIds = productId
                self.navigationController?.pushViewController(orderVc, animated: true)
            }
           
        } else if name == "didShoppingCar" { // 跳转购物车
           
        } else if name == "didProductShare" { // 分享
                  
        } else if name == "didBrand" { // 品牌
                 
        }
    }

}
