//
//  ProductsViewModel.swift
//  Rent
//
//  Created by jiang on 2020/1/19.
//  Copyright © 2020 jiang. All rights reserved.
//

import BSCommon

class ProductsViewModel: BaseViewModel {
    
    /// 获取产品分类树
    func categorylist(onSuccess: @escaping (_ list:[CategoryModel]) -> Void, failureCallBack: RequestFailed?) {
        ProductsProvider.request(.categorylist) { result in
            self.checkList(resp: result, onFail: failureCallBack, success: { (list:[CategoryModel]) in
                onSuccess(list)
            })
//            self.checkModel(resp: result, onFail: failureCallBack, success: { (model:STSModel) in
//                self.stsModel = model
//                onSuccess(model)
//            })
        }
    }
    
    /// 获取产品列表
    func productList(typeId:String, labelId:String, productName:String, categoryName:String, brandName:String, pageNum:Int, onSuccess: @escaping (_ model: ProductListModel) -> Void, failureCallBack: RequestFailed?) {
        ProductsProvider.request(.productList(typeId: typeId, labelId: labelId, productName: productName, categoryName: categoryName, brandName: brandName, pageNum: pageNum, pageSize: 50)) { result in
            self.checkModel(resp: result, onFail: failureCallBack, success: { (model: ProductListModel) in
                onSuccess(model)
            })
        }
    }

}
