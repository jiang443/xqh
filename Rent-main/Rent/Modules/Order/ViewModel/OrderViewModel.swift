//
//  OrderViewModel.swift
//  Rent
//
//  Created by jiang on 2020/11/28.
//  Copyright © 2020 jiang. All rights reserved.
//

import BSCommon

class OrderViewModel: BaseViewModel {
    
    /// 购物车产品
    func shoppingCart(onSuccess: @escaping (_ list:[OrderProductModel]) -> Void, failureCallBack: RequestFailed?) {
        OrderProvider.request(.shoppingCart) { result in
            self.checkList(resp: result, onFail: failureCallBack, success: { (list:[OrderProductModel]) in
                onSuccess(list)
            })
        }
    }

    /// 订单产品列表（订单创建前）。ids:产品id以逗号分隔
    func orderProducts(ids: String, onSuccess: @escaping (_ list:[OrderProductModel]) -> Void, failureCallBack: RequestFailed?) {
        OrderProvider.request(.orderProducts(ids: ids)) { result in
            self.checkList(resp: result, onFail: failureCallBack, success: { (list:[OrderProductModel]) in
                onSuccess(list)
            })
        }
    }
    
    func getAddressList(onSuccess: ((_ list: [AddressModel]) -> Void)?, failureCallBack: RequestFailed?) {
        OrderProvider.request(.getAddressList) { result in
            self.checkList(resp: result, onFail: failureCallBack, success: {(list: [AddressModel]) in
                onSuccess?(list)
            })
        }
    }
    
    func saveAddress(city: String, id: String, receivePhone: String, address: String, clientId: String, area: String, province: String, receiveName: String, successCallBack: RequestSuccess?, failureCallBack: RequestFailed?) {
        OrderProvider.request(.saveAddress(city: city, id: id, receivePhone: receivePhone, address: address, clientId: clientId, area: area, province: province, receiveName: receiveName)) { result in
            self.checkJson(resp: result, onFail: failureCallBack, success: { (json) in
                successCallBack?()
            })
        }
    }

    func deleteAddress(id: String, successCallBack: RequestSuccess?, failureCallBack: RequestFailed?) {
        OrderProvider.request(.deleteAddress(id: id)) { result in
            self.checkJson(resp: result, onFail: failureCallBack, success: { (json) in
                successCallBack?()
            })
        }
    }
    
    func submitOrder(clientId: String, addressId: String, shippingCartIds: String, successCallBack: RequestSuccess?, failureCallBack: RequestFailed?) {
        OrderProvider.request(.submitOrder(clientId: clientId, addressId: addressId, shippingCartIds: shippingCartIds, channel: "0")) { result in
            self.checkJson(resp: result, onFail: failureCallBack, success: { (json) in
                successCallBack?()
            })
        }
    }



}
