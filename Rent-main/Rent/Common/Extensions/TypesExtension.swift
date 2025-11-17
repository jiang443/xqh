//
//  DataSetExtension.swift
//  AfterDoctor
//
//  Created by jiang on 2018/9/11.
//  Copyright © 2018年 tmpName. All rights reserved.
//

import Foundation
import UIKit

extension NSObject{
//    class var nameOfClass: String{
//        return NSStringFromClass(self).components(separatedBy: ".").last!
//    }
    
    func nameOfClass() -> String{
        let nameStr = "\(self.classForCoder)"
        return nameStr.components(separatedBy: ".").last!
    }
}


extension Dictionary{
    func toJson() -> String{
        var res = ""
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: []){
            if let jsonStr = String(data: jsonData, encoding: .utf8){
                res = jsonStr
            }
        }
        return res
    }
    
    ///获取一个String类型的值
    func stringValue(key:String) -> String{
        var res = ""
        if let dict = self as? [String:Any]{
            if let value = dict[key] as? String{
                res = value
            }
            else if let value = dict[key] as? Int{
                res = "\(value)"
            }
        }
        return res
    }
    
    ///获取一个Int类型的值
    func intValue(key:String) -> Int{
        var res = 0
        if let dict = self as? [String:Any]{
            if let value = dict[key] as? Int{
                res = value
            }
            else if let valStr = dict[key] as? String{
                res = valStr.intValue()
            }
        }
        return res
    }
    
}

extension UIImage{
    ///从网络地址获取图像
    class func imageFrom(url:String) -> UIImage?{
        var resImage:UIImage?
        if !url.isEmpty{
            if let thisUrl = URL(string: url){
                let imageView = UIImageView()
                imageView.kf.setImage(with: thisUrl, placeholder: nil, options: nil, progressBlock: nil) { (image, error, cacheType, url) in
                    if error != nil{
                        resImage = image
                    }
                }
            }
        }
        return resImage
    }
}

