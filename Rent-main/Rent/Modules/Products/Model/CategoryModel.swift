//
//  CategoryModel.swift
//  Rent
//
//  Created by jiang on 2020/4/25.
//  Copyright © 2020 jiang. All rights reserved.
//

import HandyJSON

struct CategoryModel: HandyJSON {
    
    var id = 0
    var categoryPic = ""
    var categoryName = ""
    var childList = [CategoryModel]()

}
