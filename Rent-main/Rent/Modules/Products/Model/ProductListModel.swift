//
//  ProductListModel.swift
//  Rent
//
//  Created by jiang on 2020/4/25.
//  Copyright © 2020 jiang. All rights reserved.
//

import HandyJSON

struct ProductListModel: HandyJSON {
    var totalCount = 0
    var pageIndex = 0
    var pageSize = 0
    var pageCount = 0
    var pagedList = [PrudoctModel]()
}

struct PrudoctModel: HandyJSON {
    var productName = ""
    var productNo = ""
    var price = 0
    var productPic = ""
    var picture = 0
    var secondTypeName = ""
    var deviceType = ""
    var firstTypeName = ""
    var id = 0
}
