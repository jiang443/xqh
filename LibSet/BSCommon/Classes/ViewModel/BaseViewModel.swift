//
//  BaseViewModel.swift
//  Alamofire
//
//  Created by jiang on 2019/3/28.
//

import SwiftyJSON
import HandyJSON
import Moya
import Result
import SwiftEventBus

open class BaseViewModel: NSObject {
    
    public typealias Completion = (_ result: Result<Moya.Response, MoyaError>) -> Void
    
    //从Response中提取JSON，检查错误
    public func checkJson(resp:Result<Moya.Response, MoyaError>,onFail failBlock: RequestFailed?,success:(_ json:JSON)->Void){
        switch resp{
        case let .success(response):
            var url = "URL was NULL"
            if let tempUrl = response.request?.url{
                url = tempUrl.absoluteString
            }
            YYLog("Request = \(url)")
            // 解析数据
            if let data = try? response.mapJSON(){
                //let json = JSON(data)
                let json = lowerKeys(json: JSON(data))
                YYLog("json = \(json)")
                if json["code"].intValue == Request_Success_Code {
                    success(json)
                }
                else if json["code"].intValue == Request_Token_Expired_Code { // token过期
                    SwiftEventBus.post(Event.System.logout.rawValue)
                }
                else {
                    failBlock?(json["message"].description, json["code"].intValue)
                    YYLog(json["message"].description)
                    YYLog("🚫接口响应代码错误：ResCode=\(json["code"].intValue) \nURL=\(url) \nErrMsg::\(json["message"].description)")
                    
                    let detail = "◆ Type: 01.接口响应代码错误 (\(json["code"].intValue):\(json["message"].description)) "
                        + "◆ Config: \(self.getConfigType()) "
                        + "◆ URL: \(url) "
                        + "◆ Params: \(self.getParams(request: response.request)) "
                    DebugUtils.reportError(name: "Resp Error", detail: detail)
                }
            }
            else{
                failBlock?("数据请求出错", 0)
                YYLog("🚫数据转JSON出错：StatusCode=\(response.statusCode) \nURL=\(url)")
                
                let detail = "◆ Type: 02.响应数据转JSON出错 "
                    + "◆ Config: \(self.getConfigType()) "
                    + "◆ URL: \(url) "
                    + "◆ Params: \(self.getParams(request: response.request)) "
                DebugUtils.reportError(name: "Resp Error", detail: detail)
            }
            
        case let .failure(error):
            failBlock?(error.localizedDescription, 0)
            YYLog(error.localizedDescription)
            
            if let resp = error.response{   //如果有响应信息，则上报错误
                YYLog("🚫网络请求失败：StatusCode=\(resp.statusCode) \nURL=\(error.response?.request?.url)")
                var url = "URL = NULL"
                if let tempUrl = resp.request?.url{
                    url = tempUrl.absoluteString
                }
                let detail = "◆ Type: 03.网络请求失败 "
                    + "◆ HttpResCode: \(resp.statusCode) "
                    + "◆ Config: \(self.getConfigType()) "
                    + "◆ URL: \(url) "
                    + "◆ Params: \(self.getParams(request: resp.request)) "
                DebugUtils.reportError(name: "Resp Error", detail: detail)
            }
            else{
                YYLog("🚫网络请求失败：无响应。 \nURL=\(error.response?.request?.url)")
            }
        }
    }
    
    //从Response中提取Model，检查错误
    public func checkModel<T:HandyJSON>(resp:Result<Moya.Response, MoyaError>,onFail failBlock: RequestFailed?,success:(_ model:T)->Void){
        self.checkJson(resp: resp, onFail: failBlock) { (json:JSON) in
            if let model = JSONDeserializer<T>.deserializeFrom(json: json["data"].description) {
                success(model)
            }
            else if let model = JSONDeserializer<T>.deserializeFrom(json: json.description) {
                success(model)
            }
            else if !json.dictionaryObject!.keys.contains("data"){
                success(T())    //无data字段，返回一个空对象
            }
            else{
                //let resopnse = resp as? Result<Moya.Response, MoyaError>.Success
                var url = "URL = NULL"
                var params = ""
                let config = self.getConfigType()
                if case let .success(response) = resp {
                    if let tempUrl = response.request?.url{
                        url = tempUrl.absoluteString
                    }
                    params = self.getParams(request: response.request)
                }
                if json["status"].intValue == 404{
                    failBlock?("数据请求错误", 404)
                    YYLog("⭕️接口地址错误（404）：\nURL=\(url)")
                    let detail = "◆ Type: 04.接口地址错误 "
                        + "◆ Code: 404 "
                        + "◆ Config: \(config) "
                        + "◆ URL: \(url) "
                        + "◆ Params: \(params) "
                    DebugUtils.reportError(name: "Resp Error", detail: detail)
                }
                else{
                    failBlock?("数据请求错误", 0)
                    YYLog("⭕️数据转实体出错：\nURL=\(url)")
                    let detail = "◆ Type: 05.数据转实体出错 "
                        + "◆ Code: \(json["code"].intValue) "
                        + "◆ Msg: \(json["message"].description) "
                        + "◆ Config: \(config) "
                        + "◆ URL: \(url) "
                        + "◆ Params: \(params) "
                    DebugUtils.reportError(name: "Resp Error", detail: detail)
                }
            }
            
        }
    }
    
    //从Response中提取List，检查错误
    public func checkList<T:HandyJSON>(resp:Result<Moya.Response, MoyaError>,onFail failBlock: RequestFailed?,success:(_ list:[T])->Void){
        self.checkJson(resp: resp, onFail: failBlock) { (json:JSON) in
            if let array = JSONDeserializer<T>.deserializeModelArrayFrom(json: json["data"]["content"].description) as? [T] {
                success(array)
            }
            else if let array = JSONDeserializer<T>.deserializeModelArrayFrom(json: json["data"].description) as? [T] {
                success(array)
            }
            else if !json.dictionaryObject!.keys.contains("data"){
                success([T]())    //无data字段，返回一个空list
            }
            else{
                var url = "URL = NULL"
                var params = ""
                let config = self.getConfigType()
                if case let .success(response) = resp {
                    if let tempUrl = response.request?.url{
                        url = tempUrl.absoluteString
                    }
                    params = self.getParams(request: response.request)
                }
                if json["status"].intValue == 404{
                    failBlock?("数据请求错误", 404)
                    YYLog("⭕️接口地址错误（404）：\nURL=\(url)")
                    let detail = "◆ Type: 04.接口地址错误 "
                        + "◆ Code: 404 "
                        + "◆ Config: \(config) "
                        + "◆ URL: \(url) "
                        + "◆ Params: \(params) "
                    DebugUtils.reportError(name: "Resp Error", detail: detail)
                }
                else{
                    failBlock?("数据请求错误", 0)
                    YYLog("⭕️数据转实体出错：\nURL=\(url)")
                    let detail = "◆ Type: 05.数据转实体出错 "
                        + "◆ Code: \(json["code"].intValue) "
                        + "◆ Msg: \(json["message"].description) "
                        + "◆ Config: \(config) "
                        + "◆ URL: \(url) "
                        + "◆ Params: \(params) "
                    DebugUtils.reportError(name: "Resp Error", detail: detail)
                }
            }
        }
    }
    
    ///获取请求参数字符串
    fileprivate func getParams(request:URLRequest?) -> String{
        var headStr = ""
        var bodyStr = ""
        if let head = request?.allHTTPHeaderFields as? NSDictionary{
            headStr = StringUtils.toJson(head) as String
        }
        if let body = request?.httpBody{
            headStr = String(data:body, encoding: String.Encoding.utf8) ?? ""
        }
        return "Head:\(headStr) Body:\(bodyStr)"
    }
    
    ///获取当前环境配置
    fileprivate func getConfigType() -> String{
        var type = "null"
        switch NetWorkConfig.configType {
        case .dev:
            type = "dev"
        case .test:
            type = "test"
        case .pro:
            type = "pro"
        default: break
        }
        return type
    }
    
    /// key首字母统一改为小写
    fileprivate func lowerKeys(json:JSON) -> JSON{
        //let t1 = TimeUtils.msCurrentTimeInterval()
        var res = JSON()
        var arr = [JSON]()
        var dict = [String:JSON]()
        arr.append(contentsOf: json.arrayValue)
        dict.merge(dict: json.dictionaryValue)
        if dict.count > 0{  //对象类型
            for (k,v) in dict{
                if let key = (k as? String)?.lowerHead(){
                    var tmpV = v
                    if var valueJson = v as? JSON{
                        if valueJson.count > 0{
                            tmpV = lowerKeys(json: valueJson)
                        }
                    }
                    dict.removeValue(forKey: k)
                    dict.updateValue(tmpV, forKey: key)
                }
            }
            res.dictionaryObject = dict
        }
        else if arr.count > 0{  //数组类型
            for idx in 0..<arr.count{
                if let jsonObject = arr[idx] as? JSON{
                    if jsonObject.count > 0{
                        arr[idx] = lowerKeys(json: jsonObject)
                    }
                }
            }
            res.arrayObject = arr
        }
        //print(StringUtils.LOG + "Time = \(TimeUtils.msCurrentTimeInterval() - t1)")
        return res
    }
    
}


