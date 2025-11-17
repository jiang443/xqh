//
//  IMCellLayoutConfig.swift
//  AfterDoctor
//
//  Created by jiang on 2018/9/9.
//  Copyright © 2018年 jiang. All rights reserved.
//

import UIKit
import BSCommon

class IMCellLayoutConfig: NIMCellLayoutConfig {
    
    let types = ["IMDocumentAttachment","IMTaskPreparedAttachment"]
    let sessionCustomconfig = IMSessionCustomContentConfig()
    
    override func contentSize(_ model: NIMMessageModel!, cellWidth width: CGFloat) -> CGSize {
        let message = model.message!
        //自定义消息类型
        if isSupportedCustomMessage(message: message){
            return self.sessionCustomconfig.contentSize(width, message: message)
        }
        
        //如果没有特殊需求，就走默认处理流程
        return super.contentSize(model, cellWidth: width)
    }
    
    func isSupportedCustomMessage(message:NIMMessage) -> Bool{
        var res = false
        if let object = message.messageObject as? NIMCustomObject{
            if let attachObj = object.attachment as? NSObject{
                res = types.contains(attachObj.nameOfClass())
            }
        }
        return res
    }
    
    override func cellContent(_ model: NIMMessageModel!) -> String! {
        let message = model.message!
        //自定义消息类型
        if isSupportedCustomMessage(message: message){
            return self.sessionCustomconfig.cellContent(message)
        }
        //如果没有特殊需求，就走默认处理流程
        return super.cellContent(model!)
    }
    
    override func cellInsets(_ model: NIMMessageModel!) -> UIEdgeInsets {
        let message = model.message!
        //自定义消息类型
        if message.session?.sessionType == NIMSessionType.chatroom{
            return UIEdgeInsets.zero
        }
        //如果没有特殊需求，就走默认处理流程
        return super.cellInsets(model!)
    }
    
    override func contentViewInsets(_ model: NIMMessageModel!) -> UIEdgeInsets {
        let message = model.message!
        //自定义消息类型
        if isSupportedCustomMessage(message: message){
            return self.sessionCustomconfig.contentViewInsets(message)
        }
        //如果没有特殊需求，就走默认处理流程
        return super.contentViewInsets(model!)
    }
    
    override func shouldShowAvatar(_ model: NIMMessageModel!) -> Bool {
        if model.message.messageType == .custom{
            if let attachInfo = (model.message.messageObject as? NIMCustomObject)?.attachment as? IMCustomAttachmentInfo{
                if attachInfo.responds(to: #selector(IMCustomAttachmentInfo.shouldShowAvatar)){
                    return attachInfo.shouldShowAvatar!()
                }
            }
        }
        return super.shouldShowAvatar(model!)
    }
    
    override func shouldShowNickName(_ model: NIMMessageModel!) -> Bool {
        return super.shouldShowNickName(model!)
    }
    
    override func customViews(_ model: NIMMessageModel!) -> [Any]! {
        return super.customViews(model!)
    }

}
