//
//  JHUD.swift
//  AfterDoctor
//
//  Created by jiang on 2018/7/19.
//  Copyright © 2018年 jiang. All rights reserved.
//

import UIKit
import Toast
import SVProgressHUD

public class YYHUD: NSObject {
    
    public class func showToast(_ message:String){
        if message.isEmpty{
            return
        }
        if let style = CSToastStyle.init(defaultStyle: ()){
            style.backgroundColor = UIColor(white: 0.2, alpha: 0.8)
            style.verticalPadding = 5
            style.cornerRadius = 0
            style.maxHeightPercentage = 0.6
            style.messageFont = UIFont.systemFont(ofSize: StringUtils.FONT_NORMAL)
            CSToastManager.setSharedStyle(style)
            CSToastManager.setTapToDismissEnabled(true)
            CSToastManager.setQueueEnabled(true)
            ThreadUtils.threadOnMain {
                UIUtils.getCurrentVC()?.view.endEditing(true)
                if message.count > 10{
                    UIApplication.shared.keyWindow?.makeToast(message, duration: 3, position: CSToastPositionBottom, style: style)
                }
                else{
                    UIApplication.shared.keyWindow?.makeToast(message, duration: 2, position: CSToastPositionBottom, style: style)
                }
            }
        }
        //UIUtils.getMainViewController().view.makeToast(message)
    }
    
    public class func showStatus(_ message:String){
        if message.isEmpty{
            return
        }
        SVProgressHUD.show(withStatus: message)
    }
    
    public class func dismiss(){
        SVProgressHUD.dismiss()
        //UIUtils.getMainViewController().view.hideToasts()
    }
    
    public class func showInfo(_ message:String){
        if message.isEmpty{
            return
        }
        SVProgressHUD.showInfo(withStatus: message)
    }
    
    public class func showSuccess(_ message: String) {
        SVProgressHUD.showSuccess(withStatus: message)
    }
    
    public class func showError(_ message: String) {
        SVProgressHUD.showError(withStatus: message)
    }

}
