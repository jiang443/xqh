//
//  IMSnapchatAttachment.swift
//  AfterDoctor
//  处方消息 Attachment
//  Created by jiang on 2018/9/9.
//  Copyright © 2018年 jiang. All rights reserved.
//

import UIKit
import NIMSDK
import BSCommon
import SwiftyJSON

class IMDocumentAttachment: NSObject,NIMCustomAttachment,IMCustomAttachmentInfo {

    var title = ""
    
    var link = ""
    
    var isFromMe = false
    
    var bean = DocumentBean()
    
    func cellContent(_ message:NIMMessage?) -> String{
        return "BSChat.IMDocumentContentView"
    }
    
    func contentSize(_ message: NIMMessage?, cellWidth width: CGFloat) -> CGSize {
        if message != nil{
            isFromMe = message!.isOutgoingMsg
        }
        
        var width:CGFloat = width*0.6
        var size = StringUtils.getBoundingRectWithString(self.title, labelWidth: width - 20, textSize: StringUtils.FONT_NORMAL)
        if size.height < 20{
            size = StringUtils.getBoundingRect(self.title, width: 0, height: 20, textSize: StringUtils.FONT_NORMAL)
            width = size.width + 20
            if width < 50{
                width = 50
            }
        }
        return CGSize(width: width, height: size.height + 20)
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
        var dict = [String:Any]()
        var data = [String:Any]()
        dict[EncodeKeys.CMType] = IMCustomMessageType.document.rawValue
        dict[EncodeKeys.CMData] = self.bean.toDict()
        if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []){
            if let jsonStr = String(data: jsonData, encoding: .utf8){
                res = jsonStr
            }
        }
        return res
    }
    

}


class DocumentBean{
    var title = ""
    var link = ""
    
    class func getBean(_ json:JSON) -> DocumentBean{
        let bean = DocumentBean()
        bean.title = json["title"].stringValue
        bean.link = json["link"].stringValue
        return bean
    }
    
    func toDict() -> [String:Any]{
        return ["title":title,
                "link":link]
    }
}
