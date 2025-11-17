//
//  IOSUtils.swift
//  Rent
//
//  Created by jiang on 19/3/14.
//  Copyright © 2019年 tmpName. All rights reserved.
//


import Foundation
import UIKit

public class IOSUtils {
    public static let MAX_INT = 2147483647
    
    public static func getAppVersion() ->String {
        let infoDictionary = Bundle.main.infoDictionary
        let majorVersion :AnyObject? = infoDictionary!["CFBundleShortVersionString"] as AnyObject
        
        return majorVersion as! String
    }
    
    public static func getAppName() ->String {
        let infoDictionary = Bundle.main.infoDictionary
        let name :AnyObject? = infoDictionary!["CFBundleName"] as AnyObject
        return name as! String
    }
    
    public static func getAppBundleVersion() ->String {
        let infoDictionary = Bundle.main.infoDictionary
        let name :AnyObject? = infoDictionary!["CFBundleVersion"] as AnyObject
        if name == nil{
            return ""
        }
        return name as! String
    }

    /// App Bundle ID
    public static func getAppBundleId() ->String {
        let infoDictionary = Bundle.main.infoDictionary
        let str :AnyObject? = infoDictionary!["CFBundleIdentifier"] as AnyObject
        if str == nil{
            return ""
        }
        return str as! String
    }

    
    public static func createUUID() ->String{
        return String(CFStringCreateCopy(nil, CFUUIDCreateString(nil , CFUUIDCreate(nil))))
    }
    
    static func md5String(_ str:String) ->String{
        let cStr = str.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(strlen(cStr!))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen);

        CC_MD5(cStr!, strLen, result);

        let hash = NSMutableString();
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i]);
        }

        return String(format: hash as String)
    }
    
    /**
     从字典获取Json字符串
     */
    public static func getJsonString(_ dict:[String:AnyObject]) -> String{
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
    public static func sendNotification(_ name:String){
        let noti = Notification(name: Notification.Name(rawValue: name), object: nil)
        NotificationCenter.default.post(noti)
    }
    
    /**
     退出程序
     */
    public static func exit(){
        //SVProgressHUD.show(nil, status: "APP即将自动退出")
        YYHUD.showToast("APP即将自动退出")
        if let window: UIWindow? = UIApplication.shared.delegate?.window{
            UIView.animate(withDuration: 1, animations: {() -> Void in
                window?.alpha = 0.2
                if let aWidth = window?.bounds.size.width {
                    window?.frame = CGRect(x: 0, y: aWidth, width: 0, height: 0)
                }
            }, completion: {(_ finished: Bool) -> Void in
                Darwin.exit(0)
            })
        }
        else{
             Darwin.exit(0)
        }
    }
    
    
}
