//
//  WKWebViewController.swift
//  AfterDoctorExtension
//
//  Created by jiang on 2018/7/20.
//  Copyright © 2018年 jiang. All rights reserved.
//

import UIKit
import WebKit
import SnapKit
import WebViewJavascriptBridge
import BSCommon
import SwiftEventBus
import BSBase


open class WKWebViewController: BaseViewController,WKUIDelegate,WKNavigationDelegate {
    
    //WKScriptMessageHandler //WKWebView的代理，暂不用此方式
    open var webView = WKWebView()
    open var interfaces = [String]()
    fileprivate var commonApi = [String]()
    open var bridge = WebViewJavascriptBridge()
    public var callback: WVJBResponseCallback?
    open var url = ""{
        didSet{
            if !url.isEmpty{
                let user = getUserInfo()
                if url.contains("?"){
                    url = "\(url)&token=\(user.token)&appSign=\(user.type)"
                }
                else{
                    url = "\(url)?token=\(user.token)&appSign=\(user.type)"
                }
            }
        }
    }
    
    open override func initSettings() {
        self.commonApi = ["appSign","systemError"]
    }
    
    open override func initUI() {
        self.setNavTheme()
        self.refreshData()
    }
    
    fileprivate func setWebView(){
        self.webView.backgroundColor = UIColor.white
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        //禁止左右滑动左右
        self.webView.scrollView.contentOffset = CGPoint(x: 0, y: webView.scrollView.contentOffset.y)
        self.view.addSubview(webView)
        self.bridge = WebViewJavascriptBridge(webView)
        for name in self.commonApi{
            self.bridge.registerHandler(name) { (data, respCallback) in
                print("data from html page:\n")
                self.callback = respCallback
                self.checkCommonApi(name: name, params: data, callback: respCallback)
            }
        }
        for name in self.interfaces{
            self.bridge.registerHandler(name) { (data, respCallback) in
                print("data from html page:\n")
                self.callback = respCallback
                self.didReceiveCall(name: name, params: data, callback: respCallback)
            }
        }
        webView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(self.view)
        }
    }
    
    open override func refreshData() {
        self.webView.removeFromSuperview()
        self.webView = WKWebView(frame: self.view.frame, configuration: getConfig())
        setWebView()
        
        if let nsUrl = URL(string: url){
            let request = URLRequest(url: nsUrl)
            webView.load(request)
        }
    }
    
    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        YYHUD.showStatus("加载中")
    }
    
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        YYHUD.dismiss()
    }
    
    open func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        if self.isOnShow{
            YYHUD.dismiss()
            YYHUD.showToast("请重试")
        }
    }
    
    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        //print("url = \(String(describing: navigationAction.request.url?.absoluteString))")
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    
    //不显示文字选中菜单
    public func getConfig() -> WKWebViewConfiguration{
        // 禁止选择CSS
        let css = "body{-webkit-user-select:none;-webkit-user-drag:none;}"
        // CSS选中样式取消
        var javascript = ""
        javascript += "var style = document.createElement('style');"
        javascript += "style.type = 'text/css';"
        javascript += "var cssContent = document.createTextNode('\(css)');"
        javascript += "style.appendChild(cssContent);"
        javascript += "document.body.appendChild(style);"
        // javascript注入
        let noneSelectScript = WKUserScript(source: javascript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let userContent = WKUserContentController()
        userContent.addUserScript(noneSelectScript)
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContent
        
        configuration.preferences.minimumFontSize = 10
        configuration.preferences.javaScriptEnabled = true
        // 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        //        // 添加一个名称，在JS通过这个名称发送消息
        //        for item in self.interfaces{
        //            configuration.userContentController.add(self, name: item)
        //        }
        return configuration
    }
    
    //    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    //        //print("didReceive Message : name = \(message.name)")
    //        var body = ""
    //        if let value = message.body as? String{
    //            body = value
    //        }
    //        //didReceiveMessage(name: message.name, )
    //    }
    
    private func checkCommonApi(name:String, params:Any?, callback:WVJBResponseCallback?){
        if name == "appSign"{
            if callback != nil{
                let user = getUserInfo()
                callback!("{\"type\":\"\(user.type)\",\"token\":\"\(user.token)\"}")
            }
        }
        else if name == "systemError"{
            if let dict = params as? [String:Any]{
                print(StringUtils.ERROR + "WebView sysError dict = \(dict)")
                if dict.intValue(key: "code") == -1{    //Token过期，退出登录
                    SwiftEventBus.post(Event.System.logout.rawValue)
                }
            }
            else if let str = params as? String{
                print(StringUtils.ERROR + "WebView sysError string = \(str)")
            }
        }
    }
    
    open func didReceiveCall(name:String, params:Any?, callback:WVJBResponseCallback?){
        print("didReceiveCall = \(name)")
        //        if let dict = params as? [String:Any]{
        //            print("data dict = \(dict)")
        //        }
        //        else if let str = params as? String{
        //            print("data string = \(str)")
        //        }
        if callback != nil{
            callback!("data received by iOS.")
        }
    }
    
    open override func handleBack() {
        if self.webView.backForwardList.backList.count > 0{
            self.webView.goBack()
        }
        else{
            super.handleBack()
        }
    }
    
    ///获取当前页面URL（ByJS）
    open func getPageUrl(completion:((String) -> Void)?){
        let script = "document.location.href"
        webView.evaluateJavaScript(script) { (response, error) in
            if let val = response as? String{
                completion?(val)
            }
        }
    }
    
    ///获取当前页面标题（ByJS）
    open func getPageTitle(completion:((String) -> Void)?){
        let script = "document.title"
        webView.evaluateJavaScript(script) { (response, error) in
            if let val = response as? String{
                completion?(val)
            }
        }
    }
    
    ///生成回调Json字符串
    func getResult(success:Bool,message:String,data:[String:Any]) -> String{
        let dict = ["Error": success,
                    "ErrorMsg":message,
                    "Result":data] as [String : Any]
        return dict.toJson()
    }
    
    ///获取用户信息
    fileprivate func getUserInfo() -> User{
        var type = ""
        let manager = UserInfoManager.shareManager()
        switch manager.getType(){
        case .doctor:
            type = "doctor"
        case .nurse:
            type = "nurse"
        case .director:
            type = "director"
        case .pi:
            type = "PI"
        case .comNurse:
            type = "community_nurse"
        case .comDirector:
            type = "community_director"
        default:
            break
        }
        var user = User()
        user.type = type
        user.token = manager.token
        return user
    }
    
    fileprivate struct User {
        var token = ""
        var type = ""
    }
}



