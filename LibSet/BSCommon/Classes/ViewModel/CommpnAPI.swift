//
//  CommpnAPI.swift
//  BSChat-Images
//
//  Created by jiang on 2019/9/9.
//

import Foundation
import Moya

/// 公共模块接口
public let CommonProvider = MoyaProvider<CommonAPI>()

public enum CommonAPI {
    //case uploadImage(data: Data) // 上传图片
    case getStsToken    // 申请stsToken
}

extension CommonAPI: TargetType {
    public var baseURL: URL {
        return URL(string: NetWorkConfig.BASE_URL)!
    }
    
    public var path: String {
        switch self {
        case .getStsToken:
            return "sys/file/stsToken"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getStsToken:
            return .get
//        case .submitPlanModification(_, _, _, _):
//            return .post
        }
    }
    
    public var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        var parameters: [String:Any] = [:]
        
        switch self {
        case .getStsToken:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
//        case .countByScene(let scene):
//            parameters = ["scene":scene]
//            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
//            parameters = ["patientId":patientId, "medicationPlanList": medicationPlanList]
//            return .requestData(StringUtils.jsonToData(jsonDic: parameters)!)
        
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .getStsToken:
            return ["token": UserInfoManager.shareManager().token]
//        case .submitPlanModification(_, _, _, _):
//            return ["token": UserInfoManager.shareManager().token, "Content-Type": "application/json"]
        }
    }
}
