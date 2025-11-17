//
//  IMSessionConfig.swift
//  AfterDoctor
//  会话相关配置：自定义消息，输入方式类型，语音格式等
//  Created by jiang on 2018/9/11.
//  Copyright © 2018年 tmpName. All rights reserved.
//

import UIKit
import BSCommon

class IMSessionConfig: NSObject,NIMSessionConfig {
    
    var session = NIMSession()
    
    func mediaItems() -> [NIMMediaItem]! {
        let defaultItems = NIMKit.shared().config.defaultMediaItems() as! [NIMMediaItem]
        
        let cameraImage = ImageCenter.bundleImage("chat_camera", with: self.classForCoder)
        let cameraItem = NIMMediaItem("onTapMediaItemCamera",
                                            normalImage: cameraImage,
                                            selectedImage: cameraImage,
                                            title: "拍摄")
        
//        let isMe = session.sessionType == NIMSessionType.P2P && (session.sessionId == NIMSDK.shared().loginManager.currentAccount())  //发给自己的消息
        var items = [NIMMediaItem]()
        for item in defaultItems{
            if item.title == "相册" || item.title == "照片" {
                item.title = "照片"
                let photoImage = ImageCenter.bundleImage("chat_photo", with: self.classForCoder)
                item.normalImage = photoImage
                item.selectedImage = photoImage
                items.append(item)
            }
        }
        items.insert(cameraItem!, at: 0)
        return items
    }
    
    /// 是否处理回执
    func shouldHandleReceipt() -> Bool {
        return true
    }
    
    /// 输入栏类型：文字，语音，表情，更多
    func inputBarItemTypes() -> [NSNumber]! {
        return [NSNumber(value:NIMInputBarItemType.voice.rawValue),
                NSNumber(value:NIMInputBarItemType.textAndRecord.rawValue),
                NSNumber(value:NIMInputBarItemType.emoticon.rawValue),
                NSNumber(value:NIMInputBarItemType.more.rawValue)]
    }
    
    func shouldHandleReceipt(for message: NIMMessage!) -> Bool {
        //文字，语音，图片，视频，文件，地址位置和自定义消息都支持已读回执，其他的不支持
        let type = message.messageType
//        if message.messageType == NIMMessageType.custom{
//            if let object = message.messageObject as? NIMCustomObject{
//                let attacthment = object.attachment
//                if attacthment?.isKind(of: "OtherAttachment"){
//                    return false
//                }     }     }
        return type == .text
        || type == .audio
        || type == .image
        || type == .custom
        || type == .video
        || type == .file
        || type == .location
    }
    
    func disableProximityMonitor() -> Bool {
        return false
    }
    
    func recordType() -> NIMAudioType {
        return NIMAudioType.AAC
    }
    
    //在进入会话的时候是否禁止自动去拿历史消息,默认打开
//    func autoFetchWhenOpenSession() -> Bool {
//        return false
//    }
    
    
    
    
    
    
}
