//
//  NetWorkConstant.swift
//  Rent
//
//  Created by jiang 2019/2/26.
//  Copyright © 2019年 jiang. All rights reserved.
//

import UIKit
import BSCommon

// 网络请求代码
enum RequestCode: Int {
    case successCode = 0         // 请求成功
    case failedCode = 1    // 请求失败
    case tokenExpired = -1       // token过期
}

class NetWorkConstant: NSObject {
    
    ///网络环境配置
    static var configType = NetConfigType.dev
    
    /**
     * 接口地址
     */
    static var BASE_URL:String{
        get{
            return NetWorkConfig.BASE_URL
        }
        set{
            NetWorkConfig.BASE_URL = newValue
        }
    }
    
    
    /**
     * H5地址
     */
    static var H5_BASE_URL:String{
        get{
            return NetWorkConfig.H5_BASE_URL
        }
        set{
            NetWorkConfig.H5_BASE_URL = newValue
        }
    }

    

}
