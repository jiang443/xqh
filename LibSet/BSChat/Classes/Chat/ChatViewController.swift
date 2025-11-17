//
//  ChatViewController.swift
//  AfterDoctor
//
//  Created by jiang on 2018/8/29.
//  Copyright © 2018年 jiang. All rights reserved.
//

import UIKit
import SwiftyJSON
import KSPhotoBrowser
import AVFoundation
import BSCommon
import SwiftEventBus

public class ChatViewController: HistroyChatViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var stateModel = ConvStateModel()
    weak fileprivate var timer:Timer?
    
    lazy var viewModel: BSChatViewModel = {
        return BSChatViewModel()
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.getUserCard()
        if self.userType == 2 && UserInfoManager.shareManager().getType() == .doctor{
            if self.stateModel.im.accId.isEmpty || self.stateModel.needLoadPatient{
                ThreadUtils.delay(0.5, closure: {
                    self.checkValid()
                })
            }
            else{
                self.checkTips()
            }
            
            TimeUtils.getInternetDate(isLocal: false, complete: { date in
                if abs(Date().interval() - date.interval()) > 40{
                    DialogUtils.showMessage("您的手机时间不准确，可能造成会话结束时间异常，请校准系统时间！")
                }
            })
        }
        
        
    }
    
    override func initData(){
        
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getUserCard()
        if !self.isFirstLoad && self.userType == 2{
            ThreadUtils.delay(0.5, closure: {
                self.checkValid()
            })
        }
    }
    
    func startUpdate(){
        if self.timer == nil{
            let timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(fireTimer(_:)), userInfo: nil, repeats: true)
            self.fireTimer(timer)
        }
        else{
            self.timer?.fireDate = Date()
        }
    }
    
    func stopUpdate(){
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc func fireTimer(_ sender:Timer){
        if !UserInfoManager.shareManager().isLogin(){
            self.stopUpdate()
            return
        }
        if sender != self.timer{
            self.timer?.invalidate()
        }
        self.timer = sender
        
        //以下单位都是秒
        let endTime = TimeUtils.getTimeInterval(dataStr:self.stateModel.conv.endTime, format:"yyyy-MM-dd HH:mm:ss")
        let timeLeft  = endTime - TimeUtils.getCurrentTimeInterval()
        print("会话剩余时间 == \(timeLeft) 秒")
        if timeLeft <= 0{
            self.stopUpdate()
            self.checkValid()
        }
        else if timeLeft <= 10{
            self.timer?.fireDate = Date().addingTimeInterval(1)
        }
        else if timeLeft <= 60{
            self.timer?.fireDate = Date().addingTimeInterval(10)
        }
    }
    
    override public func onTapAvatar(_ message: NIMMessage!) -> Bool {
        var openId = ""
        if let fromId = message.from{
            print("Client Id = \(fromId)")
            if fromId.count > 16{
                openId = fromId
            }
        }
        if !openId.isEmpty{
            SwiftEventBus.post(Event.Patient.detail.rawValue, userInfo: ["patientId" : self.userId])
        }
        return true
    }

    @objc func onTapMediaItemCamera(){
        self.onCamera()
    }
    
    func onTapMediaItemPrescription(){
        
    }
    
    override public func send(_ message: NIMMessage!) {
        if self.appUserType == .doctor && self.userType == 2 {
            if self.stateModel.conv.isInBlacklist == 1{
                let msg = "当前用户在您的黑名单中，您暂不能发起与TA会话，是否前往解除黑名单页面？"
                let alert = UIAlertController(title: "提示", message: msg, preferredStyle: .alert)
                alert.addAction(title: "取消", color: UIColor.darkGray, action: { action in
                    ///
                })
                alert.addAction(title: "前往", color: UIUtils.getTextBlueColor(), action: { (action) in
                    SwiftEventBus.post(Event.Patient.settings.rawValue, userInfo: ["patientId" : self.userId, "isInBlacklist" : 1])
                })
                self.present(alert, animated: true, completion: nil)
                return
            }
            else if self.stateModel.conv.isEnd == 1 {
                let msg = "会话有效期已过，如继续则当次会话用户无需支付积分。请确认是否继续？"
                let alert = UIAlertController(title: "提示", message: msg, preferredStyle: .alert)
                alert.addAction(title: "取消", color: UIColor.darkGray, action: { action in
                    ///
                })
                alert.addAction(title: "继续", color: UIUtils.getTextBlueColor(), action: { (action) in
                    self.viewModel.createConv(patientId: self.userId, callBack: { model in
                        self.stateModel.conv.isEnd = model.conv.isEnd
                        self.stateModel.conv.endTime = model.conv.endTime
                        super.send(message)
                        self.checkTips()
                    }, failureCallBack: { msg, code in
                        YYHUD.showToast(msg)
                    })
                })
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
        super.send(message)
    }
    
    ///NIMChatManagerDelegate:发送消息完成后的回调；
    ///重载，添加发送成功后的Server处理接口
    override public func send(_ message: NIMMessage, didCompleteWithError error: Error?) {
        super.send(message, didCompleteWithError: error)
        let types:[NIMMessageType] = [.audio, .text, .image, .custom]//支持的消息类型
        if !types.contains(message.messageType){
            return
        }
//        if message.messageObject == nil
//            || message.messageObject!.isKind(of: NIMTipObject.self)
//            || message.messageObject!.isKind(of: NIMNotificationObject.self)
//            || message.messageObject!.isKind(of: NIMRobotObject.self){
//            return
//        }
        if error == nil{
            IMNotificationManager.getInstance().checkMessage(at: [message])
            if userId.isEmpty{
                return
            }
            if self.userType == 1{  //发给员工的
                self.viewModel.replyStaff(staffId: userId, callBack: { (model) in
                }) { (msg, code) in
                    YYHUD.showToast(msg)
                }
            }
            else if self.userType == 2 { //发给用户的
                if UserInfoManager.shareManager().getType() == .doctor{
                    let taskId = self.stateModel.onTask ? self.stateModel.taskId : ""
                    self.viewModel.replyPatient(patientId: userId, taskId: taskId, callBack: { (model) in
                        if self.stateModel.onTask && model.taskResult.points > 0{
                            self.view.endEditing(true)
                            SwiftEventBus.post(Event.Chat.taskReward.rawValue, userInfo: ["coins":model.taskResult.points])
                        }
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FinishTaskNotificationName"), object: nil)
                        self.stateModel.onTask = false
                        self.stateModel.conv.isEnd = model.conv.isEnd
                        self.stateModel.conv.endTime = model.conv.endTime
                        self.checkTips()
                    }) { (msg, code) in
                        if code == 6005{
                            self.stateModel.onTask = false
                        }
                        YYHUD.showToast(msg)
                    }
                    if self.stateModel.conv.isEnd == 1{
                        self.checkValid()
                    }
                }
                else{   //非员工类型员工回复用户
                    self.viewModel.replyPatient(patientId: userId, taskId: "", callBack: { (model) in
                    }) { (msg, code) in
                        YYHUD.showToast(msg)
                    }
                }
            }
        }
        else{
            YYHUD.showToast("发送消息失败")
        }
    }
    
    
    func checkValid(){
        if self.userType != 2 && UserInfoManager.shareManager().getType() != .doctor{
            return
        }
        //let accId = self.session.sessionId
        self.viewModel.getConvState(patientId: userId, callBack: { (model) in
            var tmpModel = model    //转存信息
            tmpModel.onTask = self.stateModel.onTask
            tmpModel.needLoadPatient = self.stateModel.needLoadPatient
            tmpModel.taskId = self.stateModel.taskId
            self.stateModel = tmpModel
            self.checkTips()
        }) { (msg, code) in
            YYHUD.showToast(msg)
        }
    }
    
    func checkTips(){
        if UserInfoManager.shareManager().getType() == .doctor{
            self.isFirstLoad = false
            if self.stateModel.conv.isEnd == 1{
                self.topTipLable.isHidden = false
            }
            else{
                self.topTipLable.isHidden = true
                self.startUpdate()
            }
            
            if self.stateModel.conv.isInBlacklist == 1 {
                let msg = "当前用户在您的黑名单中，您暂不能发起与TA会话，是否前往解除黑名单页面？"
                let alert = UIAlertController(title: "提示", message: msg, preferredStyle: .alert)
                alert.addAction(title: "取消", color: UIColor.darkGray, action: { action in
                    ///
                })
                alert.addAction(title: "前往", color: UIUtils.getTextBlueColor(), action: { (action) in
                    SwiftEventBus.post(Event.Patient.settings.rawValue, userInfo: ["patientId" : self.userId, "isInBlacklist" : 1])
                })
                self.present(alert, animated: true, completion: nil)
            }
            
            return
        }
    }
    
    override public func onTapCell(_ event: NIMKitEvent!) -> Bool {
        if event.eventName == NIMKitEventNameTapLabelLink{
            if let link = event.data as? String{
                if !link.isEmpty{
                    SwiftEventBus.post(Event.System.openUrl.rawValue, userInfo: ["title":"网页详情", "url": StringUtils.getFilePath(link)])
//                    let webView = WebViewController()
//                    webView.url = StringUtils.getFilePath(link)
//                    webView.title = "网页详情"
//                    self.navigationController?.pushViewController(webView, animated: true)
                }
            }
        }
        else if let message = event.messageModel.message{
            if message.messageType == .image{
                self.getFileList()
                var itemArr = [KSPhotoItem]()
                if let imageView = self.touchedView as? UIImageView{
                    for item in self.fileList{
                        if item.url == self.touchedImageUrl{
                            let item = KSPhotoItem(sourceView: imageView, imageUrl: URL(string: item.url))
                            itemArr.append(item)
                        }
                        else{
                            let thumbImage = UIImage.imageFrom(url: item.thumbUrl)
                            let item = KSPhotoItem(sourceView: self.touchedView, thumbImage: thumbImage, imageUrl: URL(string: item.url))
                            itemArr.append(item)
                        }
                    }
                }
                else{
                    for item in self.fileList{
                        let thumbImage = UIImage.imageFrom(url: item.thumbUrl)
                        let item = KSPhotoItem(sourceView: self.touchedView, thumbImage: thumbImage, imageUrl: URL(string: item.url))
                        itemArr.append(item)
                    }
                }
                if itemArr.count > 0{
                    var index = 0   //资源的序号
                    if let findIdx = self.fileList.index(where: { $0.url == self.touchedImageUrl }){
                        index = findIdx
                    }
                    let browser = KSPhotoBrowser(photoItems: itemArr, selectedIndex: UInt(index))
                    //browser.delegate = self
                    browser.dismissalStyle = .scale
                    browser.backgroundStyle = .black
                    browser.loadingStyle = .indeterminate
                    browser.pageindicatorStyle = .dot
                    browser.pageindicatorStyle = .dot
                    browser.bounces = false
                    browser.show(from: self)
                }
            }
        }
        return super.onTapCell(event)
    }
    
    //MARK: ------------  IMAGE PICKER DELEGATE  -----------------
    
    func selectPhoto(){
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as! UIImage  //原始照片
        if picker.sourceType == UIImagePickerController.SourceType.camera{
//            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        else{
            image = info[UIImagePickerController.InfoKey.editedImage.rawValue] as! UIImage    //编辑后的照片
        }
        picker.dismiss(animated: true, completion: nil)
        self.send(IMSessionMsgConverter.getImageMessage(with: image))
    }
    
    @objc public func image(_ image:UIImage,didFinishSavingWithError:NSError?,contextInfo:AnyObject){
        if didFinishSavingWithError != nil {
            return
        }
    }
    
    @objc public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
    }
    
    @objc public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func onCamera(){
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            YYHUD.showToast("相机功能不可用")
            return
        }
        let pickerController = UIImagePickerController()
        pickerController.sourceType = UIImagePickerController.SourceType.camera
        pickerController.allowsEditing = false
        pickerController.showsCameraControls = true
        pickerController.cameraDevice = UIImagePickerController.CameraDevice.rear
        pickerController.cameraFlashMode = UIImagePickerController.CameraFlashMode.auto
        pickerController.delegate = self
        pickerController.mediaTypes = ["public.image"]  //只显示照片项目
        self.present(pickerController, animated: true, completion: nil)
    }
    
    override public func handleBack() {
        super.handleBack()
        self.stopUpdate()
    }
    
}


