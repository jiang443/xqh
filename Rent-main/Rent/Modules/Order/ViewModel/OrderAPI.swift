//
//  OrderAPI.swift
//  Rent
//
//  Created by jiang on 2020/11/28.
//  Copyright © 2020 jiang. All rights reserved.
//

import Foundation
import Moya
import HandyJSON

/// 产品模块接口
let OrderProvider = MoyaProvider<OrderAPI>()

enum OrderAPI {
    case orderProducts(ids:String)  //已提交的订单产品。ids: 一个或者多个产品ID
    case shoppingCart //购物车产品
    case getAddressList
    case saveAddress(city: String, id: String, receivePhone: String, address: String, clientId: String, area: String, province: String, receiveName: String)
    case deleteAddress(id: String)
    case submitOrder(clientId: String, addressId: String, shippingCartIds: String, channel: String)

}

extension OrderAPI: TargetType {
    var baseURL: URL {
        switch self {
        case .orderProducts(_):
            return URL(string: mockBaseUrl)!
        default: break
        }
        return URL(string: NetWorkConstant.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .orderProducts(_):
            return "/api/app/sale/shoppingCart/GetSettlementList"
        case .shoppingCart:
            return "/api/app/sale/shoppingCart/List"
        case .getAddressList:
            return "/api/app/clt/clientAddress/GetAddressList"
        case .saveAddress(_, _, _, _, _, _, _, _):
            return "/api/app/clt/clientAddress/SaveAddress"
        case .deleteAddress(_):
            return "/api/app/clt/clientAddress/DeleteAddress"
        case .submitOrder(_, _, _, _):
            return "/api/app/sale/SaleProductOrder/SubmitOrder"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .shoppingCart,.orderProducts(_),.getAddressList:
            return .get
        case .saveAddress(_, _, _, _, _, _, _, _),.deleteAddress(_),.submitOrder(_, _, _, _):
            return .post
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        var parameters: [String:Any] = [:]
        
        switch self {
        case .shoppingCart, .getAddressList:
            parameters.removeAll()
        case .orderProducts(let ids):
            parameters = ["ids": ids]
        case .saveAddress(let city, let id, let receivePhone, let address, let clientId, let area, let province, let receiveName):
            parameters = ["city": city, "id": id, "receivePhone": receivePhone, "address": address, "clientId": clientId, "area": area, "province": province, "receiveName": receiveName]
        case .deleteAddress(let id):
            parameters = ["id": id]
        case .submitOrder(let clientId, let addressId, let shippingCartIds, let channel):
            parameters = ["ClientId": clientId, "AddressId": addressId, "ShippingCartIds": shippingCartIds, "Channel": channel]
        }
        
        if self.method == .post{
            return .requestData(StringUtils.jsonToData(jsonDic: parameters)!)
        }
        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        return ["token": UserInfoManager.shareManager().token,
                "Content-Type": "application/json"]
    }
    
    
}

