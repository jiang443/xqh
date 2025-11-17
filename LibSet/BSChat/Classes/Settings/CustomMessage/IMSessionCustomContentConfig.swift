//
//  IMSessionCustomContentConfig.swift
//  AfterDoctor
//
//  Created by jiang on 2018/9/10.
//  Copyright © 2018年 jiang. All rights reserved.
//

import UIKit

class IMSessionCustomContentConfig: NSObject,NIMSessionContentConfig {
    
    func contentSize(_ cellWidth: CGFloat, message: NIMMessage!) -> CGSize {
        let object = message.messageObject! as! NIMCustomObject
        if !object.isKind(of: NIMCustomObject.self){
            print("Message must be custom")
        }
        if let info = object.attachment as? IMCustomAttachmentInfo {
            return info.contentSize(message, cellWidth: cellWidth)
        }
        return CGSize.zero
    }
    
    func cellContent(_ message: NIMMessage!) -> String! {
        let object = message.messageObject! as! NIMCustomObject
//        if !object.isKind(of: NIMCustomObject.self){
//            print("Message must be custom")
//        }
        if let info = object.attachment as? IMCustomAttachmentInfo {
            return info.cellContent(message)
        }
        return ""
    }
    
    func contentViewInsets(_ message: NIMMessage!) -> UIEdgeInsets {
        let object = message.messageObject! as! NIMCustomObject
        if !object.isKind(of: NIMCustomObject.self){
            print("Message must be custom")
        }
        if let info = object.attachment as? IMCustomAttachmentInfo {
            return info.contentViewInsets(message)
        }
        return UIEdgeInsets.zero
    }
    

}
