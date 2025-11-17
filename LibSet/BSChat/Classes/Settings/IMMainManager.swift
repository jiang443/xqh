//
//  NIMMainController.swift
//  AfterDoctor
//
//  Created by jiang on 2018/8/22.
//  Copyright © 2018年 jiang. All rights reserved.
//

import UIKit
import BSCommon

class IMMainManager: NSObject {
    var kNIMAppKey = ""
    var kNIMAppSecret = ""
    var cerName = "pushEP"
    var configDelegate:NIMSDKConfigDelegate?    //暂存作用
    
    fileprivate static let thisInstance = IMMainManager()
    
    static func getInstance() -> IMMainManager{
        return thisInstance
    }
    
    func setupNIMSDK(){
        let user = UserInfoManager.shareManager().getUserInfo()
        self.configDelegate = ChatConfigDelegate()
        NIMSDKConfig.shared().delegate = self.configDelegate
        NIMSDKConfig.shared().shouldSyncUnreadCount = true
        NIMSDKConfig.shared().maxAutoLoginRetryTimes = 10
        NIMSDKConfig.shared().maximumLogDays = 7
        NIMSDKConfig.shared().shouldCountTeamNotification = false
        NIMSDKConfig.shared().animatedImageThumbnailEnabled = false
        NIMKit.shared().config.avatarType = .rounded
        //[NIMKit sharedKit].config.avatarType
        
        let option = NIMSDKOption(appKey: kNIMAppKey)
        option.apnsCername = ""
        NIMSDK.shared().register(with: option)
        NIMCustomObject.registerCustomDecoder(IMCustomAttachmentDecoder())    //自定义消息解释器
        NIMKit.shared().registerLayoutConfig(IMCellLayoutConfig()) //自定义消息排版配置
        //NIMSDK.shared().enableConsoleLog()  //开启控制台调试
        //NIMSDK.shared().register(withAppID: key, cerName: "")   //Push Cer
        NIMKit.shared().provider = IMDataProviderImpl() //管理用户信息
        
        if !UserInfoManager.shareManager().isLogin(){
            print(StringUtils.ERROR + "应用账号未登录，无法登录IM")
            return
        }
        let imToken:String = user.token
        if imToken.isEmpty{
            YYHUD.showToast("聊天功能暂不可用(imToken=null)")
            return
        }
        NIMSDK.shared().loginManager.login(user.accId.lowercased(), token: imToken) { (error) in
            if error != nil{
                print(StringUtils.ERROR + " IM Login Failed!\n" + error!.localizedDescription)
                NIMSDK.shared().loginManager.autoLogin(user.account.lowercased(), token: imToken)
            }
            else{
                print("用户-\(user.account):: IM Login Success.")
            }
        }
    }
    
    
    ///从服务器请求用户信息，并刷新缓存数据
    func fetchUserInfo(userIds:[String], complete:(()->Void)?){
        NIMSDK.shared().userManager.fetchUserInfos(userIds) { users, error in
            if error == nil && users?.count > 0 {
                NIMKit.shared().notfiyUserInfoChanged(userIds)
                complete?()
            }
        }
    }
    
    ///刷新最近会话中的用户数据
    func refreshRecentUserInfo(){
        var ids = [String]()
        if let sessions = NIMSDK.shared().conversationManager.allRecentSessions(){
            let me = NIMSDK.shared().loginManager.currentAccount()
            for recent: NIMRecentSession in sessions {
                if recent.session!.sessionType == NIMSessionType.P2P && !(recent.session!.sessionId == me) {
                    ids.append(recent.session!.sessionId)
                }
            }
            self.fetchUserInfo(userIds: ids, complete: nil)
        }
    }
    
    func autoLogin(){
        let user = UserInfoManager.shareManager().getUserInfo()
        let loginData = NIMAutoLoginData()
        loginData.account = user.accId.lowercased()
        loginData.token = user.token
        NIMSDK.shared().loginManager.autoLogin(loginData)
    }
    
    func imLogout(){
        NIMSDK.shared().loginManager.logout({ (error) in
            if error != nil{
                print(StringUtils.ERROR + "IM账号退出失败\n "
                    + String(describing: error?.localizedDescription))
            }
        })
    }
    
    ///获取用户名片信息
    func getUserCard(accId:String) -> [String:Any]{
        var resDict = [String:Any]()
        if let user = NIMSDK.shared().userManager.userInfo(accId){
            var remark = ""
            var name = ""
            var nickName = ""
            var showName = ""
            //userType:  1:员工  2:用户
            if var infoExtDict = StringUtils.getDictFromJson(user.userInfo?.ext){
                name = infoExtDict.stringValue(key: "name")
                nickName = infoExtDict.stringValue(key: "nickname")
                if let remarkDict =  StringUtils.getDictFromJson(user.ext){
                    remark = remarkDict.stringValue(key: "alias")
                    for item in remarkDict{
                        infoExtDict[item.key] = item.value
                    }
                }
                if let staffDict = infoExtDict["staffInfo"] as? [String:Any]{
                    infoExtDict["businessRoleId"] = staffDict["businessRoleId"] as AnyObject?
                    infoExtDict["orgSystemType"] = staffDict["orgSystemType"] as AnyObject?
                }
                resDict = infoExtDict
            }
            if remark.isEmpty{
                if name.isEmpty{
                    showName = nickName
                }
                else if nickName.isEmpty{
                    showName = name
                }
                else{
                    showName = "\(name)(\(nickName))"
                }
            }
            else if nickName.isEmpty{
                showName = remark
            }
            else{
                showName = "\(remark)(\(nickName))"
            }
            //本地增加字段
            resDict["accId"] = accId
            resDict["showName"] = showName
        }
        return resDict
    }

}
