//
//  NetWorkConfig.swift
//  Rent
//
//  Created by jiang 2019/2/26.
//  Copyright © 2019年 jiang. All rights reserved.
//

import UIKit

/// 网络请求代码
public enum RequestCode: Int {
    case successCode = 0         // 请求成功
    case failedCode = 1    // 请求失败
    case tokenExpired = -1       // token过期
}

/// 网络环境类型
public enum NetConfigType: String {
    case other = "other"
    case dev = "devConfig"
    case test = "testConfig"
    case pro = "proConfig"
}

public class NetWorkConfig: NSObject {
    fileprivate static let thisInstance = NetWorkConfig()
    public static var configDict = [String:Any]()
    public static var allowDebug = false
    public static var onDebug = false
    public static var configType = NetConfigType.pro
    
    public static func getInstance() -> NetWorkConfig{
        if configDict.count == 0{
            configDict = getConfigs(type: configType)
        }
        if configDict.count == 0{
            YYLog(StringUtils.ERROR + "获取网络环境配置失败")
        }
        return thisInstance
    }
    
    public static func getConfigs(type:NetConfigType) -> [String:Any]{
        var resDict = [String:Any]()
        let thisBundle = Bundle(for: self)   //类所在的Bundle
        var bundle: Bundle? = nil
        //查找main.bundle
        if let bundleURL = thisBundle.url(forResource: "main", withExtension: "bundle") {
            bundle = Bundle(url: bundleURL)
            if let plistPath = bundle?.path(forResource: "NetworkConfig", ofType: "plist"){
                if let dictionary = NSDictionary(contentsOfFile: plistPath) as? [String:[String:Any]]{
                    if let configs = dictionary["main"]?[type.rawValue] as? [String:Any]{
                        resDict = configs
                    }
                    else{
                        print(StringUtils.ERROR + "获取接口地址配置信息失败！")
                    }
                } //full Dictionary
            }
        } // main bundle
        
        return resDict
    }

    /**
     * 接口基本地址
     */
    public static var BASE_URL:String{
        get{
            getInstance()
            return configDict.stringValue(key: "api")
        }
        set{
            configDict["api"] = newValue
        }
    }
    
    /**
     * H5页面
     */
    public static var H5_BASE_URL:String{
        get{
            getInstance()
            return configDict.stringValue(key: "h5")
        }
        set{
            configDict["h5"] = newValue
        }
    }
    
    ///H5域名（暂时无用）
    public static var H5_DOMAIN:String{
        get{
            getInstance()
            return configDict.stringValue(key: "h5_domain")
        }
        set{
            configDict["h5_domain"] = newValue
        }
    }
    
    ///H5微信页面
    public static var H5_WX_DOMAIN:String{
        get{
            getInstance()
            return configDict.stringValue(key: "wx")
        }
        set{
            configDict["wx"] = newValue
        }
    }
    
    
}
