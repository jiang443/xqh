//
//  ProductsAPI.swift
//  Rent
//
//  Created by jiang on 2020/1/19.
//  Copyright © 2020 jiang. All rights reserved.
//

import Foundation
import Moya
import HandyJSON

/// 产品模块接口
let ProductsProvider = MoyaProvider<ProductsAPI>()

enum ProductsAPI {
    case productList(typeId:String, labelId:String, productName:String, categoryName:String, brandName:String, pageNum:Int, pageSize:Int)  //获取产品列表
    case categorylist //获取产品分类树

}

extension ProductsAPI: TargetType {
    var baseURL: URL {
//        switch self {
//        case .productList(_, _, _, _, _, _, _):
//            return URL(string: mockBaseUrl)!
//        default: break
//        }
        return URL(string: NetWorkConstant.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .productList(_, _, _, _, _, _, _):
            return "/api/app/prd/product/List"
        case .categorylist:
            return "/api/app/prd/ProductCategory/List"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .categorylist,.productList(_, _, _, _, _, _, _):
            return .get
//        case .deleteFile(_):
//            return .post
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        var parameters: [String:Any] = [:]
        
        switch self {
        case .categorylist:
            parameters.removeAll()
        case .productList(let typeId, let labelId, let productName, let categoryName, let brandName, let pageNum, let pageSize):
            parameters = ["typeId": typeId, "labelId": labelId, "productName": productName, "categoryName": categoryName, "brandName": brandName, "pageNum": pageNum, "pageSize": pageSize]
        }
        
        if self.method == .post{
            return .requestData(StringUtils.jsonToData(jsonDic: parameters)!)
        }
        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        if self.method == .post{
            return ["token": UserInfoManager.shareManager().token,
                    "Content-Type": "application/json"]
        }
        return ["token": UserInfoManager.shareManager().token]
    }
    
    
}
