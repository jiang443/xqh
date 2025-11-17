//
//  YYHUD.swift
//  Rent
//
//  Created by jiang 2019/2/25.
//  Copyright © 2019年 jiang. All rights reserved.
//

import UIKit
import Toast
import SVProgressHUD

class YYHUD: NSObject {
    
    class func showToast(_ message:String){
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
                UIApplication.shared.keyWindow?.makeToast(message, duration: 2, position: CSToastPositionBottom, style: style)
            }
        }
        //UIUtils.getMainViewController().view.makeToast(message)
    }
    
    class func initHUDStyle() {
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setBackgroundColor(UIColor.gray)
        SVProgressHUD.setMinimumSize(CGSize(width: 100, height: 100))
        SVProgressHUD.setMinimumDismissTimeInterval(1)
    }
    
    class func show(){
        SVProgressHUD.show()
    }

    class func showStatus(_ message:String){
        if message.isEmpty{
            return
        }
        SVProgressHUD.show(withStatus: message)
    }
    
    class func dismiss(){
        SVProgressHUD.dismiss()
        UIApplication.shared.keyWindow?.hideToast()
        //UIUtils.getMainViewController().view.hideToasts()
    }
    
    class func showInfo(_ message:String){
        if message.isEmpty{
            return
        }
        SVProgressHUD.showInfo(withStatus: message)
    }
    
    class func showSuccess(_ message: String) {
        SVProgressHUD.showSuccess(withStatus: message)
    }

    class func showError(_ message: String) {
        SVProgressHUD.showError(withStatus: message)
    }
}
