//
//  IMProductAttachment.swift
//  AfterDoctor
//
//  Created by jiang on 2018/9/14.
//  Copyright © 2018年 tmpName. All rights reserved.
//

import UIKit
import BSCommon

class IMProductAttachment : NSObject,NIMCustomAttachment,IMCustomAttachmentInfo {
    
    var imageUrl = ""
    
    var text = ""
    
    var title = ""
    
    var isFromMe = false
    
    //var model = RecipeModel()
    
    func cellContent(_ message:NIMMessage?) -> String{
        return "BSChat.IMProductContentView"
    }
    
    func contentSize(_ message: NIMMessage?, cellWidth width: CGFloat) -> CGSize {
        if message != nil{
            isFromMe = message!.isOutgoingMsg
        }
        if UIUtils.isIphone5(){
            return CGSize(width: 180, height: 100)
        }
        return CGSize(width: 200, height: 110)
    }
    
    func contentViewInsets(_ message: NIMMessage?) -> UIEdgeInsets {
        let bubblePadding: CGFloat = 3.0
        let bubbleArrowWidth: CGFloat = -4.0
        if message != nil && message!.isOutgoingMsg {
            return UIEdgeInsets(top: bubblePadding, left: bubblePadding, bottom: bubblePadding, right: bubblePadding + bubbleArrowWidth)
        } else {
            return UIEdgeInsets(top: bubblePadding, left: bubblePadding + bubbleArrowWidth, bottom: bubblePadding, right: bubblePadding)
        }
    }
    
    func canBeForwarded() -> Bool {
        return false
    }
    
    func canBeRevoked() -> Bool {
        return true
    }
    
    func encode() -> String {
        var res = ""
//        var dict = [String:Any]()
//        var data = [String:Any]()
//        dict[EncodeKeys.CMType] = IMCustomMessageType.product.rawValue
//        data[EncodeKeys.kContent] = model.toJson().rawString()
//        dict[EncodeKeys.CMData] = data
//        if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []){
//            if let jsonStr = String(data: jsonData, encoding: .utf8){
//                res = jsonStr
//            }
//        }
        return res
    }
    
    
    
    
    
}
