//
//  AppDelegate.swift
//  Rent
//
//  Created by jiang 2019/2/22.
//  Copyright © 2019年 jiang. All rights reserved.
//

import UIKit
import SwiftEventBus
import BSCommon
import BSChat
import BSPush
import Bugly
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var tabBarViewController: BSTabBarController?
    fileprivate let showGuide = false  //是否显示引导页（视频在内部配置）
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        
        // 设置第三方库
        setupLibs()
        initSDK(application, launchOptions: launchOptions)
//        configUShareSDK()
        
        MainManager.getInstance().register()

        // 引导页
        launch()
        
        window?.makeKeyAndVisible()
        
        // 状态栏设置为白色字体
        //UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
        window?.rootViewController?.navigationController?.navigationBar.barStyle = .black
        
        self.processWillLaunch()
        
        ///如果是点击推送通知进入APP的，检查是否需要跳转页面
        if let userInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable : Any]{
            ThreadUtils.delay(1) {
                self.notiRedirect(userInfo: userInfo, byLaunch: true)
            }
        }
        
        return true
    }
    
    func launch() {
        let launchTime = SettingUserDefault.getFistLaunchTime()
        YYLog("firstLaunchTime = \(launchTime)")
        YYLog("currentVersion = \(IOSUtils.getAppVersion())")
        let guideShowed = SettingUserDefault.getGuideShowed()
        if showGuide && !guideShowed{
            let guideVc = GuidePageViewController()
            self.window?.rootViewController = guideVc
        } else {
            login()
        }
    }
    
    // 登录
    func login() {
        self.window?.rootViewController?.view.removeFromSuperview()
        self.window?.rootViewController?.removeFromParent()
        let tabBarVc = BSTabBarController()
        self.window?.rootViewController = tabBarVc
        self.window?.makeKeyAndVisible()

        UserViewModel().loginInfo(callBack: {
            YYLog("获取用户信息")
        })
    }
    
    // 退出
    func logout() {
        let guideShowed = SettingUserDefault.getGuideShowed()
        if showGuide && !guideShowed{
            // 还没显示新版本引导页的时候，token过时的不需要退到登录页
            return
        }

//        GroupDefaults["has-new-share"] = false
//        GroupDefaults.synchronize()

        // 清空用户消息
        UserInfoManager.shareManager().userInfo = UserInfoModel()
        UserInfoManager.shareManager().logout()
        UserInfoManager.shareManager().saveUserInfo(UserInfoManager.shareManager().userInfo)
        PushManager.getInstance().removeAliasTags()
        PushManager.removeAllNotifications()
        MainManager.getInstance().imLogout()
        MobClick.profileSignOff()

        self.window?.rootViewController?.view.removeFromSuperview()
        self.window?.rootViewController?.removeFromParent()
        let loginVc = LoginViewController()
        self.window?.rootViewController = loginVc
        self.window?.makeKeyAndVisible()
    }
    
    func setupLibs() {
        MainManager.getInstance().loadLibs()
        YYHUD.initHUDStyle()
        IQKeyboardManager.shared.enable = true
    }
    
    // 配置友盟SDK
    func configUShareSDK() {
        
        UMConfigure.initWithAppkey(kUmengAppKey, channel: kUmengChannelId)
        
        UMSocialManager.default()?.setPlaform(UMSocialPlatformType.wechatTimeLine, appKey: kWechatAppKey, appSecret: kWechatAppSecret, redirectURL: "http://www.baidu.com/")
        
    }
    
    fileprivate func initSDK(_ application: UIApplication, launchOptions: [AnyHashable: Any]?){
        MainManager.getInstance().setupIM()
        PushManager.setupPush(key:kJPushKey, launchOptions: launchOptions)
        UMConfigure.setLogEnabled(true)
        UMConfigure.initWithAppkey(kUmengAppKey, channel: kUmengChannelId)
        
        let config = BuglyConfig()
        config.reportLogLevel = .debug
        Bugly.start(withAppId: kBuglyAppId, config: config)
        Bugly.updateAppVersion(IOSUtils.getAppVersion())
        configBugly()
        MTA.start(withAppkey: kMTA)
    }
    
    private func configBugly() {
        let buglyConfig = BuglyConfig()
        buglyConfig.debugMode = true
        buglyConfig.reportLogLevel = .info
        Bugly.start(withAppId: kBuglyAppId,config:buglyConfig)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        let result = UMSocialManager.default()?.handleOpen(url, sourceApplication: sourceApplication, annotation: annotation)
        
        if result == true {
            YYHUD.showToast("分享成功")
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let result = UMSocialManager.default()?.handleOpen(url, options: options)
        
        if result == true {
            YYHUD.showToast("分享成功")
        }
        
        return true
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        let result = UMSocialManager.default()?.handleOpen(url)
        
        if result == true {
            YYHUD.showToast("分享成功")
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenStr = NSString.localizedStringWithFormat("%@", deviceToken as CVarArg) as String
        SettingUserDefault.setDeviceToken(StringUtils.getDeviceTokenString(tokenStr))
        PushManager.registerDeviceToken(deviceToken)
        print("APNS Token:---------------\n  \(SettingUserDefault.getDeviceToken())")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]){
        //ChatManager.getInstance().receiveNotification(userInfo: userInfo)
        PushManager.handleRemoteNotification(userInfo)
        self.notiRedirect(userInfo: userInfo, byLaunch: false)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        self.application(application, didReceiveRemoteNotification: userInfo)
        ThreadUtils.delay(1) {
            completionHandler(UIBackgroundFetchResult.newData)  //调用成功，操作完毕
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
         SwiftEventBus.post(Event.System.appWillResignActive.rawValue)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        self.processWillLaunch()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
//        let launchTime = SettingUserDefault.getFistLaunchTime()
//        if launchTime.isEmpty { // 首次打开APP
//            return
//        }
        
        /// 检查版本
        if !UserInfoManager.shareManager().haveCheckVersion {
            checkVersion(isShowTips: false)
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    /// 检查更新
    func checkVersion(isShowTips: Bool) {
        if let config = MTAConfig.getInstance(){ // 使用腾讯移动分析的在线参数获取更新参数
            let version = config.getCustomProperty("version", default: "")
            let url = config.getCustomProperty("url", default: "")
            let forceUpdate = config.getCustomProperty("forceUpdate", default: "0")
            let content = config.getCustomProperty("content", default: "")
            YYLog("version = \(String(describing: version)) , url = \(String(describing: url)) , forceUpdate = \(String(describing: forceUpdate)) , version = \(String(describing: content)) , ")
            ///逻辑处理
            self.showVersionAlertView(isShowTips: isShowTips, clientVersion: version ?? "1.0.0", isForce: forceUpdate?.intValue() ?? 0, updateContent: content ?? "", downloadUrl: url ?? APPDOWNLOADURL)
        }
    }
    
    /// 显示更新弹框
    func showVersionAlertView(isShowTips: Bool, clientVersion: String, isForce: Int, updateContent: String, downloadUrl: String) {
        let currentVersion = IOSUtils.getAppVersion()
        YYLog("当前版本 = \(currentVersion) , 更新版本 = \(clientVersion)")
        if currentVersion >= clientVersion { // 不需要更新
            if isShowTips {
                YYHUD.showToast("当前已是最新版本")
            } else {
                YYLog("当前已是最新版本")
            }
            UserInfoManager.shareManager().haveCheckVersion = true
            return
        } else {
            YYLog("需要更新")
        }
        
        UserInfoManager.shareManager().haveCheckVersion = true
        
        let newVersionView = FindNewVersionView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        newVersionView.isForce = isForce
        newVersionView.clientVersion = clientVersion
        newVersionView.updateContent = updateContent
        newVersionView.updateVersionCallback = { // 立即更新
            YYLog("立即更新")
            let urlString = downloadUrl
            if let url = URL(string: urlString) {
                //根据iOS系统版本，分别处理
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:],
                                              completionHandler: {
                                                (success) in
                    })
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        newVersionView.show()
    }

    ///应用加载前的操作
    func processWillLaunch(){
        SwiftEventBus.post(Event.System.appWillLaunch.rawValue)
        let manager = UserInfoManager.shareManager()
        if manager.isLogin(){
            PushManager.getInstance().setAliasTags()
            MainManager.getInstance().imAutoLogin()
            //MainManager.getInstance().storePatients()
            Bugly.setUserIdentifier(manager.getUserInfo().phone)
        }
    }
    
    func notiRedirect(userInfo:[AnyHashable : Any], byLaunch:Bool){
        if !UserInfoManager.shareManager().isLogin() || UIApplication.shared.applicationState == .active{
            return
        }
        if userInfo.intValue(key: "contentType") == 1{  //1=系统消息
            
        } else if userInfo.intValue(key: "contentType") == 2 { // IM消息
            
        }
    }
    
}


