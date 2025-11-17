//
//  IMCustomAttachmentDecoder.swift
//  AfterDoctor
//  Attachment 公共解释器
//  Created by jiang on 2018/9/9.
//  Copyright © 2018年 jiang. All rights reserved.
//

import SwiftyJSON

class IMCustomAttachmentDecoder: NSObject,NIMCustomAttachmentCoding {
    
    func decodeAttachment(_ content: String?) -> NIMCustomAttachment? {
        if content == nil || content!.isEmpty{
            return nil
        }
        let json = JSON(parseJSON: content!)
        let type = json[EncodeKeys.CMType].intValue
        let data = json[EncodeKeys.CMData]
        
        switch type {
        case IMCustomMessageType.document.rawValue:
            let attachment = IMDocumentAttachment()
            let bean = DocumentBean.getBean(data)
            attachment.title = bean.title
            attachment.link = bean.link
            attachment.bean = bean
            return attachment

//        case IMCustomMessageType.nutrition.rawValue:
//            let attachment = IMNutritionAttachment()
//            if let contentDict = data[EncodeKeys.kContent]{ // json字符串
//                let model = RecipeModel.toBean(contentDict.stringValue)
//                attachment.imageUrl = model.recipePic
//                var text = ""
//                for idx in 0..<model.list.count{
//                    let item = model.list[idx]
//                    if idx < 2{
//                        text = text + "\(item.productName) * \(item.quantity)\n"
//                    }
//                    else if idx == 2{
//                        text = text + "..."
//                    }
//                    else{
//                        break
//                    }
//                }
//                attachment.text = text
//                attachment.model = model
//            }
//            return attachment
//
//        case IMCustomMessageType.product.rawValue:
//            let attachment = IMProductAttachment()
//            if let contentDict = data[EncodeKeys.kContent]{ // json字符串
//                let model = RecipeModel.toBean(contentDict.stringValue)
//                if model.list.count > 0{
//                    attachment.imageUrl = model.list.first!.thumbnailImg
//                    attachment.title = model.list.first!.productName
//                    attachment.text = model.list.first!.productDesc
//                    attachment.model = model
//                }
//            }
//            return attachment

        default:
            break
        }
        
        return nil
    }
    

}
