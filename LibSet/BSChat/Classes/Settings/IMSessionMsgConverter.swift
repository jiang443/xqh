//
//  IMSessionMsgConverter.swift
//  AfterDoctor
//
//  Created by jiang on 2018/9/11.
//  Copyright © 2018年 tmpName. All rights reserved.
//

import UIKit

class IMSessionMsgConverter: NSObject {
    
    class func getTipMessgae(tip: String) -> NIMMessage {
        let message = NIMMessage()
        let tipObject = NIMTipObject()
        message.messageObject = tipObject
        message.text = tip
        let setting = NIMMessageSetting()
        setting.apnsEnabled = false
        setting.shouldBeCounted = false
        message.setting = setting
        return message
    }
    
    class func getTextMessgae(text: String) -> NIMMessage {
        let message = NIMMessage()
        message.text = text
        return message
    }
    
    class func getImageMessage(with image: UIImage?) -> NIMMessage? {
        var imageObject: NIMImageObject? = nil
        if let image = image {
            imageObject = NIMImageObject(image: image)
        }
        return IMSessionMsgConverter.generateImageMessage(imageObject)
    }

    class func getImageMessage(withPath path: String) -> NIMMessage? {
        let imageObject = NIMImageObject(filepath: path)
        return IMSessionMsgConverter.generateImageMessage(imageObject)
    }

    
    class func generateImageMessage(_ imageObject: NIMImageObject?) -> NIMMessage? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = dateFormatter.string(from: Date())
        imageObject?.displayName = "图片发送于\(dateString)"
        let option = NIMImageOption()
        option.compressQuality = 0.8
        imageObject?.option = option
        let message = NIMMessage()
        message.messageObject = imageObject
        message.apnsContent = "发来了一张图片"
        let setting = NIMMessageSetting()
        setting.scene = NIMNOSSceneTypeMessage
        message.setting = setting
        return message
    }

    
    class func getPrescriptionMessage(attach: IMDocumentAttachment) -> NIMMessage {
        let message = NIMMessage()
        let customObject = NIMCustomObject()
        customObject.attachment = attach
        message.messageObject = customObject
        message.apnsContent = "发来了文件资料消息"
        return message
    }
    
    class func getNutritionMessage(attach: IMNutritionAttachment) -> NIMMessage {
        let message = NIMMessage()
        let customObject = NIMCustomObject()
        customObject.attachment = attach
        message.messageObject = customObject
        message.apnsContent = "发来了员工建议消息"
        return message
    }
    
    class func getProductMessage(attach: IMProductAttachment) -> NIMMessage {
        let message = NIMMessage()
        let customObject = NIMCustomObject()
        customObject.attachment = attach
        message.messageObject = customObject
        message.apnsContent = "发来了产品推荐"
        return message
    }


}
