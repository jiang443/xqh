//
//  OrderProductModel.swift
//  Rent
//
//  Created by jiang on 2020/11/28.
//  Copyright © 2020 jiang. All rights reserved.
//

import HandyJSON

struct OrderProductModel: HandyJSON {
    
    var buyOutPrice = ""
    var companyName = ""
    var deposit = 0
    var discount = 0
    var id = 0
    var isInstallmentPayment = 0
    var monthlyRentPrice = ""
    var mountingCost = 0
    var noMountingCostMonth = 0
    var optionalFittingsIds = ""
    var packageId = 0
    var packageName = ""
    var productBuyOutPrice = ""
    var productId = 0
    var productImg = ""
    var productImgId = 0
    var productMonthlyRentPrice = ""
    var productName = ""
    var quantity = 0
    var remark = ""
    var rentTime = 0
    /// 1=只租  2=只买  3=先租后买断
    var saleType = 0
    var startTime = ""
    var totalPrice = 0
    
}
