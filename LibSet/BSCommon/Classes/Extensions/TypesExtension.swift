//
//  DataSetExtension.swift
//  AfterDoctor
//
//  Created by jiang on 2018/9/11.
//  Copyright © 2018年 tmpName. All rights reserved.
//

import Foundation

public extension NSObject{
//    public class var nameOfClass: String{
//        return NSStringFromClass(self).components(separatedBy: ".").last!
//    }
    
    func nameOfClass() -> String{
        let nameStr = "\(self.classForCoder)"
        return nameStr.components(separatedBy: ".").last!
    }
}


public extension Dictionary{
    func toJson() -> String{
        var res = ""
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: []){
            if let jsonStr = String(data: jsonData, encoding: .utf8){
                res = jsonStr
            }
        }
        return res
    }
    
    ///是否包含字符串类型的特定Key
    func hasKey(_ key:String) -> Bool{
        if let dict = self as? [String:Any]{
             return dict[key] != nil
        }
        return false
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
    
    ///获取一个Double类型的值
    func doubleValue(key:String) -> Double{
        var res = 0.0
        if let dict = self as? [String:Any]{
            if let value = dict[key] as? Double{
                res = value
            }
            else if let valStr = dict[key] as? String{
                res = valStr.doubleValue()
            }
        }
        return res
    }
    
    /// 把目标字典合并到当前字典
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
    
    /// 把String类型的key首字母改为小写
    mutating func lowerKesHead(){
        for (k, v) in self{
            if let key = (k as? String)?.lowerHead(){
                updateValue(v, forKey: key as! Key)
                removeValue(forKey: k)
            }
        }//end of for
    }
    
}

public extension UIImage{
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

public extension Data{
    
    ///获取DeviceToken
    func getDeviceToken() -> String{
        var tokenStr = NSString.localizedStringWithFormat("%@", self as CVarArg) as String
        tokenStr = tokenStr.replace(oldStr: " ", newStr: "")
        tokenStr = tokenStr.replace(oldStr: "<", newStr: "")
        tokenStr = tokenStr.replace(oldStr: ">", newStr: "")
        return tokenStr
    }
}

public extension Date{
    /**
     获取指定时间的时间戳(秒/10位)
     */
    func interval() -> Int {
        return Int(self.timeIntervalSince1970)
    }
}

public extension Int{
    ///获取角标，大于99返回...
    func getBadge() -> String?{
        if self > 99{
            return "···"
        }
        else if self == 0{
            return nil
        }
        return self == nil ? nil : "\(self)"
    }
}

