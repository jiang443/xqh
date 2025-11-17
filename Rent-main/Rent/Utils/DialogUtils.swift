//
//  DialogUtils.swift
//  Rent
//
//  Created by jiang on 19/4/20.
//  Copyright © 2019年 tmpName. All rights reserved.
//

import Foundation
import UIKit

class DialogUtils{
    
    //自定义弹窗  传入内容  代理 确定键说明   tag
    static func showCustomTextDialog(_ delegate:UIAlertViewDelegate?,tag:Int,msg:String,otherBtnTitle:String){
        dialog("提醒", msg: msg, delegate: delegate, cancelButtonTitle: "取消", otherButtonTitles:otherBtnTitle, tag: tag)
    }
    
    //删除提醒
    static func showDeleteDailog(_ delegate:UIAlertViewDelegate?,tag:Int){
        dialog("提醒", msg: "删除后不可恢复，确认删除？", delegate: delegate, cancelButtonTitle: "取消", otherButtonTitles: "删除", tag: tag)
    }
    
    //重新登录
    static func showReLoginDailog(_ delegate:UIAlertViewDelegate?,tag:Int){
        dialog("提醒", msg: "当前用户已失效，请重新登录", delegate: delegate, cancelButtonTitle: nil, otherButtonTitles: "重新登录", tag: tag)
    }
    
    
    fileprivate static func dialog(_ title:String,msg:String,delegate:UIAlertViewDelegate?,cancelButtonTitle: String?,otherButtonTitles: String,tag:Int){
        
        let alert = UIAlertView(
            title: title,
            message: msg,
            delegate: delegate,
            cancelButtonTitle: cancelButtonTitle,
            otherButtonTitles: otherButtonTitles)
        alert.tag = tag
        alert.show()
    }
    
    static func showMessage(_ message:String){
        dialog("提示",
               msg:message,
               delegate: nil,
               cancelButtonTitle: nil,
               otherButtonTitles: "确定",
               tag: 0)
    }
    
    static func showMessage(_ message:String,title:String){
        dialog(title,
               msg: message,
               delegate: nil,
               cancelButtonTitle: nil,
               otherButtonTitles: "确定",
               tag: 0)
    }
    
    
    static func showMessage(_ title:String,message:String,delegate:UIAlertViewDelegate?,tag:Int){
        dialog(title,
               msg: message,
               delegate: delegate,
               cancelButtonTitle: nil,
               otherButtonTitles: "确定",
               tag: tag)
    }
    
    /*!
     退出当前账号
     */
    static func showExitConfirm(_ delegate:UIAlertViewDelegate?,tag:Int){
        dialog("退出登录",
               msg: "您确定要退出当前账号吗？",
               delegate: delegate,
               cancelButtonTitle: "取消",
               otherButtonTitles: "退出",
               tag: tag)
    }
    
    static func confirm(_ title:String,message:String,tag:Int,delegate:UIAlertViewDelegate?){
        dialog(title,
               msg: message,
               delegate: delegate,
               cancelButtonTitle: "取消",
               otherButtonTitles: "确定",
               tag: tag)
    }
    
    
    
    fileprivate static func editDialog(_ title:String,text:String,delegate:UIAlertViewDelegate?,textdelegate:UITextFieldDelegate,cancelButtonTitle: String?,otherButtonTitles: String,tag:Int){
        
        let alert = UIAlertView(
            title: title,
            message: "",
            delegate: delegate,
            cancelButtonTitle: cancelButtonTitle,
            otherButtonTitles: otherButtonTitles)
        alert.tag = tag
        alert.alertViewStyle = UIAlertViewStyle.plainTextInput
        alert.textField(at: 0)?.text = text
        alert.textField(at: 0)?.delegate = textdelegate
        alert.show()
        
    }
    
    static func phoneNoConfirm(_ delegate:UIAlertViewDelegate?,phoneNo:String,tag:Int){
        dialog("提醒",
               msg: "我们将发送验证码到这个手机号码：\(phoneNo)",
            delegate: delegate,
            cancelButtonTitle: "取消",
            otherButtonTitles: "确定",
            tag: tag)
    }
    
    static func getVerifyCodeFail(){
        let msg = "获取验证码失败，请重新获取。"
        dialog("提醒",
               msg:msg,
               delegate: nil,
               cancelButtonTitle: nil,
               otherButtonTitles: "确定",
               tag: 0)
    }
    
    
    
}


