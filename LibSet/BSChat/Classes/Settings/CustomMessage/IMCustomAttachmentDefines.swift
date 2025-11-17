//
//  IMCustomAttachmentDefines.swift
//  AfterDoctor
//  自定义消息相关 - 公共类型定义类
//  Created by jiang on 2018/9/9.
//  Copyright © 2018年 jiang. All rights reserved.
//

import UIKit

enum IMCustomMessageType:Int {
    case other = 0  //未知类型
    case donation = 1
    case taskPared = 2
    case consultMark = 3
    case document = 4
}

class EncodeKeys{
    static let CMType  = "scene"
    static let CMData  = "content"
//    static let CMValue = "value"
//    static let CMFlag  = "flag"
//    static let CMURL   = "url"
//    static let CMMD5   = "md5"
    static let kContent   = "content"
    static let kTitle   = "title"
}

@objc public protocol IMCustomAttachmentInfo:NSObjectProtocol {
    func cellContent(_ message: NIMMessage?) -> String
    func contentSize(_ message: NIMMessage?, cellWidth width: CGFloat) -> CGSize
    func contentViewInsets(_ message: NIMMessage?) -> UIEdgeInsets
    @objc optional func formatedMessage() -> String
    @objc optional func showCoverImage() -> UIImage
    @objc optional func shouldShowAvatar() -> Bool
    @objc optional func setShowCover(_ image: UIImage?)
    @objc optional func canBeRevoked() -> Bool      //可否转发
    @objc optional func canBeForwarded() -> Bool    //可否撤回
}

