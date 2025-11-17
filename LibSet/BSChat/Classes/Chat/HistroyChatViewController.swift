//
//  HistroyChatViewController.swift
//  Alamofire
//
//  Created by jiang on 2019/5/10.
//

import UIKit
import BSCommon

protocol RemoteSessionDelegate {
    func fetchRemoteData(error:Error?)
}

public class HistroyChatViewController: BaseChatViewController,RemoteSessionDelegate {
    
    var config:RemoteSessionConfig!
    
    override public init!(session: NIMSession!) {
        super.init(session: session)
        self.config = RemoteSessionConfig(session: session)
        self.config.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    @objc override public func sessionConfig() -> NIMSessionConfig! {
        return self.config
    }
    
    
    // MARK: - RemoteSessionDelegate
    func fetchRemoteData(error: Error?) {
        if error != nil {
            YYLog(StringUtils.ERROR + error!.localizedDescription ?? "")
            //YYHUD.showToast("获取远程消息失败")
        }
    }

    // MARK: - NIMSessionConfiguratorDelegate
    @objc override public func didFetchMessageData() {
        super.didFetchMessageData()
        YYHUD.dismiss()
    }

}


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
class RemoteSessionConfig:IMSessionConfig{
    var provider:NIMRemoteMessageDataProvider!
    var delegate:RemoteSessionDelegate?{
        didSet{
            self.provider.delegate = delegate
        }
    }
    
    init(session:NIMSession){
        super.init()
        self.session = session
        self.provider = NIMRemoteMessageDataProvider.init(session: session, limit: 20)
    }
    
    @objc public func messageDataProvider() -> NIMKitMessageProvider! {
        return self.provider
    }
    
    ///是否禁用输入控件
    @objc public func disableInputView() -> Bool {
        return false    //正常显示
    }
    
    ///是否禁用音频轮播
    @objc public func disableAutoPlayAudio() -> Bool {
        return true     //禁用
    }
    
    ///是否显示已读
    @objc override public func shouldHandleReceipt() -> Bool {
        return false
    }
    
    ///是否禁止显示新到的消息,默认不禁止
    @objc public func disableReceiveNewMessages() -> Bool {
        return false
    }
}


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
public class NIMRemoteMessageDataProvider: NSObject, NIMKitMessageProvider {
    var session = NIMSession()
    var limit = 0
    var delegate:RemoteSessionDelegate?
    var msgArray = [NIMMessage]()
    var lastTime = TimeInterval(exactly: 0)
    
    init(session:NIMSession, limit:Int){
        super.init()
        self.session = session
        self.limit = limit
    }
    
    @objc public func pullDown(_ firstMessage: NIMMessage!, handler: NIMKitDataProvideHandler!) {
        self.remoteFetch(firstMessage,handler: handler)
    }
    
    func remoteFetch(_ message: NIMMessage?, handler: NIMKitDataProvideHandler?) {
        YYHUD.showStatus("请稍候")
        let searchOpt = NIMHistoryMessageSearchOption()
        searchOpt.startTime = 0
        searchOpt.endTime = message?.timestamp ?? 0
        searchOpt.currentMessage = message
        searchOpt.limit = UInt(limit)
        searchOpt.sync = true   //获取远程消息的时候同步到本地
        NIMSDK.shared().conversationManager.fetchMessageHistory(session, option: searchOpt, result: { error, messages in
            YYHUD.dismiss()
            var sortedArr = [NIMMessage]()
            if let arr = messages as? [NIMMessage]{
                for item in arr{
                    sortedArr.insert(item, at: 0)
                }
            }
            handler?(error, sortedArr)
            self.delegate?.fetchRemoteData(error: error)
        })
    }
}
