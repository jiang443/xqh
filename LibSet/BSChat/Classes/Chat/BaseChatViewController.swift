//
//  DoctorChatListViewController.swift
//  AfterDoctor
//
//  Created by jiang on 2019/1/15.
//  Copyright © 2019 tmpName. All rights reserved.
//

import UIKit
import SwiftyJSON
import KSPhotoBrowser
import AVFoundation
import BSCommon

public class BaseChatViewController: NIMSessionViewController,UIGestureRecognizerDelegate {
    
    fileprivate var config:IMSessionConfig? = nil
    var isFirstLoad = true
    var adapter:NIMSessionTableAdapter?
    var touchedView = UIView()
    var fileList = [FileData]()
    var touchedImageUrl = ""
    var topTipLable = UILabel()
    var userId = ""
    var userType = 0
    var appUserType = UserInfoManager.shareManager().getType()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItems?.removeAll()
        self.navigationItem.leftItemsSupplementBackButton = false
        self.setNavTheme()
        self.tabBarController?.tabBar.isHidden = true
        if let titleView = self.navigationItem.titleView as? NIMKitTitleView{
            titleView.titleLabel.textColor = UIColor.white
            titleView.titleLabel.font = UIFont.systemFont(ofSize: StringUtils.FONT_LARGE)
        }
        
        //tipLabel.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 30)
        topTipLable.backgroundColor = UIColor.init(white: 0.8, alpha: 0.6)
        topTipLable.textColor = UIColor.red
        topTipLable.textAlignment = .center
        topTipLable.font = UIFont.systemFont(ofSize: 15)
        topTipLable.text = "当前会话有效期已过"
        self.topTipLable.isHidden = true
        self.view.addSubview(topTipLable)
        self.topTipLable.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.height.equalTo(30)
        }

        self.tableView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self.view)
        }
        
        self.initData()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTouch))
        gesture.numberOfTapsRequired = 1
        gesture.delegate = self
        //gesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gesture)
    }
    
    func getUserCard(){
        let dict = IMMainManager.getInstance().getUserCard(accId: self.session.sessionId)
        if dict.count > 0{
            userId = dict.stringValue(key: "userId")
            userType = dict.intValue(key: "userType")
        }
    }
    
    @objc public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        //var point = CGPoint.zero
        //point = touch.location(in: self.view)
        self.touchedImageUrl = ""
        self.touchedView = self.view
        let view = touch.view!
        self.touchedView = view
        // 通用：备用
        //        for subView in view.subviews{
        //            if subView.frame.origin.y > 0 && subView.isKind(of: UIImageView.self){
        //                self.touchedView = subView
        //            }
        //        }
        if let contentView = view as? NIMSessionImageContentView{
            if let object = contentView.model.message.messageObject as? NIMImageObject{
                self.touchedImageUrl = object.url ?? ""
            }
            self.touchedView = contentView.imageView
        }
        return false
    }
    
    @objc func onTouch(){
        self.view.endEditing(true)
    }
    
    func initData(){
        
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.appUserType = UserInfoManager.shareManager().getType()
        if let adapter = self.tableView.delegate as? NIMSessionTableAdapter{
            self.adapter = adapter
            self.getFileList()
        }
        
//        if let interactor = self.adapter?.interactor as? NIMSessionInteractorImpl{
//            interactor.dataSource.loadHistoryMessages { (index, messages, error) in
//                print("")
//            }
//        }
    }
    
    func getUser() -> UserInfoModel{
        return UserInfoManager.shareManager().getUserInfo()
    }
    
//    override public func refreshSessionTitle(_ title: String!) {
//        super.refreshSessionTitle(title + "(data)")
//    }
    
    override public func menusItems(_ message: NIMMessage!) -> [Any]! {
        var items = [UIMenuItem]()
        if let defaultItems = super.menusItems(message) as? [UIMenuItem]{
            items.append(contentsOf: defaultItems)
//            for idx in 0..<items.count{
//                if items[idx].title == "删除"{
//                    items.remove(at:idx)
//                }
//            }
            if IMUtil.canMessageBeRevoked(message){
                items.append(UIMenuItem(title: "撤回", action: #selector(revokeMessage)))
            }
        }
        return items
    }
    
    @objc func revokeMessage(){
        let message = self.messageForMenu
        if message == nil{
            YYHUD.showToast("无法获取消息数据")
            return
        }
        NIMSDK.shared().chatManager.revokeMessage(message!) { (error) in
            if let err = error as NSError?{
                if err.code == NIMRemoteErrorCode.codeDomainExpireOld.rawValue{
                    YYHUD.showToast("发送时间超过5分钟的消息，不能被撤回")
                }
                else{
                    YYHUD.showToast("消息撤回失败，请重试")
                }
            }
            else{
                if let model = self.uiDelete(message!){
                    let tip = IMSessionMsgConverter.getTipMessgae(tip: IMUtil.tip(onMessageRevoked: nil))
                    tip.timestamp = model.messageTime
                    // saveMessage 方法执行成功后会触发 onRecvMessages: 回调，但是这个回调上来的 NIMMessage 时间为服务器时间，和界面上的时间有一定出入，所以要提前先在界面上插入一个和被删消息的界面时间相符的 Tip, 当触发 onRecvMessages: 回调时，组件判断这条消息已经被插入过了，就会忽略掉。
                    if let session = message?.session{
                        NIMSDK.shared().conversationManager.save(tip, for: session, completion: nil)
                    }
                }
            }//end of else
        }
    }
    
    //MARK: ---- InputView Settings ----
    override public func sessionConfig() -> NIMSessionConfig! {
        if self.config == nil{
            self.config = IMSessionConfig()
            self.config!.session = self.session
        }
        return self.config
    }
   
    override public func send(_ message: NIMMessage!) {
        //        if message!.messageType == .audio{
        //            let object = message!.messageObject! as? NIMAudioObject
        //        }
        do{
            try NIMSDK.shared().chatManager.send(message, to: self.session!)
        } catch let error as NSError{
            print(error.localizedDescription)
            YYHUD.showToast("发送消息失败")
        }
    }
    
    
    //MARK:录音事件
    override public func showRecordFileNotSendReason(){
        YYHUD.showToast("录音时间太短")
    }
    
    override public func onRecordFailed(_ error: Error!) {
        YYHUD.showToast("录音失败")
    }
    
    override public func recordFileCanBeSend(_ filepath: String!) -> Bool {
        let url = URL.init(fileURLWithPath: filepath)
        let urlAsset = AVURLAsset(url: url, options: nil)
        let time: CMTime = urlAsset.duration
        let mediaLength = CGFloat(CMTimeGetSeconds(time))
        return mediaLength > 1.5
    }
    
    @objc override public func handleBack() {
        NIMSDK.shared().chatManager.remove(self)
        NIMSDK.shared().conversationManager.remove(self)
        NIMSDK.shared().mediaManager.remove(self as! NIMMediaManagerDelegate)
        
        super.handleBack()
    }
    
    ///获取会话中文件
    func getFileList(){
        self.fileList.removeAll()
        if let messages = self.adapter?.interactor.items(){
            for item in messages{
                if let model = item as? NIMMessageModel{
                    if model.message.messageType == .image{
                        if let object = model.message.messageObject as? NIMImageObject{
                            let file = FileData()
                            file.type = 1
                            file.url = object.url ?? ""
                            file.thumbUrl = object.thumbUrl ?? ""
                            self.fileList.append(file)
                        }
                    }
                }
            }//end of for
        }
    }
    
    class FileData{
        ///1:Image  2:Video
        var type = 0
        var url = ""
        var thumbUrl = ""
    }
}



