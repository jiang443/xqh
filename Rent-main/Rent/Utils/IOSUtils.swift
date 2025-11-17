//
//  IOSUtils.swift
//  Rent
//
//  Created by jiang on 19/3/14.
//  Copyright © 2019年 tmpName. All rights reserved.
//


import Foundation
import UIKit

class IOSUtils {
    static let MAX_INT = 2147483647
    
    static func getAppVersion() ->String {
        let infoDictionary = Bundle.main.infoDictionary
        let majorVersion :AnyObject? = infoDictionary!["CFBundleShortVersionString"] as AnyObject
        
        return majorVersion as! String
    }
    
    static func getAppName() ->String {
        let infoDictionary = Bundle.main.infoDictionary
        let name :AnyObject? = infoDictionary!["CFBundleName"] as AnyObject
        return name as! String
    }
    
    static func getAppBundleVersion() ->String {
        let infoDictionary = Bundle.main.infoDictionary
        let name :AnyObject? = infoDictionary!["CFBundleVersion"] as AnyObject
        if name == nil{
            return ""
        }
        return name as! String
    }

    
    static func createUUID() ->String{
        return String(CFStringCreateCopy(nil, CFUUIDCreateString(nil , CFUUIDCreate(nil))))
    }
    
//    static func md5String(str:String) ->String{
//        let cStr = (str as NSString).UTF8String
//        let buffer = UnsafeMutablePointer<UInt8>.alloc(16)
//        CC_MD5(cStr,(CC_LONG)(strlen(cStr)), buffer)
//        let md5String:NSMutableString = NSMutableString();
//        for _ in 0 ..< 16{
//            md5String.appendFormat("%X2", buffer)
//        }
//        free(buffer)
//        return String(md5String);
//    }
    
//    static func md5String(_ str:String) ->String{
//        let cStr = str.cString(using: String.Encoding.utf8)
//        let strLen = CC_LONG(strlen(cStr!))
//        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
//        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen);
//
//        CC_MD5(cStr!, strLen, result);
//
//        let hash = NSMutableString();
//        for i in 0 ..< digestLen {
//            hash.appendFormat("%02x", result[i]);
//        }
//        result.deinitialize();
//
//        return String(format: hash as String)
//    }
    
    /**
     从字典获取Json字符串
     */
    static func getJsonString(_ dict:[String:AnyObject]) -> String{
        var jsondata:Data?
        do{
            jsondata = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        }catch{
        }
        let jsonStr = NSString(data: jsondata!, encoding: String.Encoding.utf8.rawValue)
        return jsonStr! as String

    }
    
    /**
     发出通知
     */
    static func sendNotification(_ name:String){
        let noti = Notification(name: Notification.Name(rawValue: name), object: nil)
        NotificationCenter.default.post(noti)
    }
    
    /**
     退出程序
     */
    static func exit(){
        //SVProgressHUD.show(nil, status: "APP即将自动退出")
        YYHUD.showToast("APP即将自动退出")
        let app = UIApplication.shared.delegate as? AppDelegate
        let window: UIWindow? = app?.window
        UIView.animate(withDuration: 1, animations: {() -> Void in
            window?.alpha = 0.2
            if let aWidth = window?.bounds.size.width {
                window?.frame = CGRect(x: 0, y: aWidth, width: 0, height: 0)
            }
        }, completion: {(_ finished: Bool) -> Void in
            Darwin.exit(0)
        })
    }
    
    
}
