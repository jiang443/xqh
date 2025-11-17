//
//  IMMsgDatasourceExtension.swift
//  Alamofire
//
//  Created by jiang on 2019/5/27.
//

import Foundation
import BSCommon
import SwiftEventBus

class IMMsgDatasourceExtension: NSObject {

}

extension NIMSessionMsgDatasource{
    static func yy_swizzle() {
        guard let m1 = class_getInstanceMethod(self, #selector(resetMessages(_:))) else {
            return
        }
        guard let m2 = class_getInstanceMethod(self, #selector(swizzle_resetMessages(_:))) else {
            return
        }
        
        if (class_addMethod(self, #selector(swizzle_resetMessages(_:)), method_getImplementation(m2), method_getTypeEncoding(m2))) {
            class_replaceMethod(self, #selector(swizzle_resetMessages(_:)), method_getImplementation(m1), method_getTypeEncoding(m1))
        } else {
            method_exchangeImplementations(m1, m2)
        }
    }
    
    @objc func swizzle_resetMessages(_ handler: @escaping (_ error:Error?)->Void) {
        print("swizzle_resetMessages")
        self.items = NSMutableArray()   //[NIMMessageModel]
        self.setMessageIdDict(NSMutableDictionary())
        
        if let provider = self.getMessageProvider() as? NIMKitMessageProvider{
            // 1.加载本地DB中的消息
            let limit = NIMKit.shared().config.messageLimit
            let messages = NIMSDK.shared().conversationManager.messages(in: getCurrentSession(), message: nil, limit: limit)
            self.insertMessageModels(self.models(withMessages: messages))   //根据Model时间戳查找插入位置
            if handler != nil {
                handler(nil)
            }
            
            // 2.拉取远程消息
            if provider.responds(to: #selector(NIMKitMessageProvider.pullDown(_:handler:))){
                provider.pullDown!(nil, handler: { error, messages in
                    ThreadUtils.threadOnMain {
                        //根据Model时间戳查找插入位置
                        self.insertMessageModels(self.models(withMessages: messages))
                        if handler != nil {
                            handler(error)
                        }
                    }
                })
            }
        } //数据获取两步走
    }

//    ///根据Model时间戳查找插入位置
//    func appendMessageModels(_ models:[NIMMessageModel]?) -> [NIMMessageModel]{
//        var appendArr = [NIMMessageModel]()
//        if models == nil || models!.count == 0 {
//            return appendArr
//        }
//        let msgIdDict = self.getMessageIdDict()
//        for model in models ?? [] {
//            guard let model = model as? NIMMessageModel else {
//                continue
//            }
//            if msgIdDict[model.message.messageId] != nil {  //找到消息ID
//                continue
//            }
//            let result = self.insertMessageModels([model])    //根据Model时间戳查找插入位置
//            if let result = result as? [NIMMessageModel] {
//                appendArr.append(contentsOf: result)
//            }
//        }
//        return appendArr
//    }
    
    ///Message->Model,完全转译
    func models(withMessages messages: [NIMMessage]?) -> [NIMMessageModel]? {
        var array: [AnyHashable] = []
        for message in messages ?? [] {
            let model = NIMMessageModel(message: message)
            array.append(model)
        }
        return array as? [NIMMessageModel]
    }
    
    ///设置MessageIdDict，KVC
    func setMessageIdDict(_ dict:NSMutableDictionary){
        self.setValue(dict, forKey: "msgIdDict")
    }
    
    ///获取MessageIdDict，KVC
    func getMessageIdDict() -> [String:NIMMessageModel] {
        if let dict = self.value(forKey: "msgIdDict") as? [String:NIMMessageModel]{
            return dict
        }
        return [String:NIMMessageModel]()
    }
    
    ///获取currentSession，KVC
    func getCurrentSession() -> NIMSession {
        if let session = self.value(forKey: "currentSession") as? NIMSession{
            return session
        }
        return NIMSession()
    }
    
    ///获取dataProvider，KVC
    func getMessageProvider() -> NIMKitMessageProvider? {
        if let provider = self.value(forKey: "dataProvider") as? NIMKitMessageProvider{
            return provider
        }
        return nil
    }
}
