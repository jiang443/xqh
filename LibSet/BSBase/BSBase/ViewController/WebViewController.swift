//
//  WebViewController.swift
//  Rent
//
//  Created by jiang on 19/3/18.
//  Copyright © 2019年 tmpName. All rights reserved.
//
//需要监控网络请求与响应数据，可用NSURLConnectionDataDelegate
//在shouldStartLoadWithRequest中开启Connection

import UIKit
import WebViewJavascriptBridge
import SwiftEventBus
import BSCommon
import SwiftyJSON

open class WebViewController: BaseViewController,UIWebViewDelegate{
    open var webView = UIWebView()
    open var interfaces = [String]()
    fileprivate var commonApi = [String]()
    fileprivate var lockCache = [String:Int]()
    open var bridge = WebViewJavascriptBridge()
    open var callback: WVJBResponseCallback?
    open var url = ""
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        YYHUD.dismiss()
    }
    
    open override func initUI() {
        
        YYLog("url = \(url)")

        self.setNavTheme()
        
        self.commonApi = ["getToken","goBack","systemError"]
        self.refreshData()
        
        if let nsUrl = URL(string: url){
            let request = URLRequest(url: nsUrl)
            webView.loadRequest(request)
        }
    }
    
    fileprivate func setWebView(){
        self.view.addSubview(webView)
        self.view.backgroundColor = UIColor.white
        self.webView.backgroundColor = UIColor.white
        webView.delegate = self
        webView.scalesPageToFit = true
        webView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(self.view)
        }
        //webView.frame = CGRect(x: 0, y: 0, width: UIUtils.getScreenWidth(), height: UIUtils.getScreenHeight() - 64)
        //WebViewJavascriptBridge.enableLogging()
        self.bridge = WebViewJavascriptBridge(webView)
        self.bridge.setWebViewDelegate(self)
        for name in self.commonApi{
            self.bridge.registerHandler(name) { (data, respCallback) in
                print(StringUtils.LOG + "Public H5 Call (\(name)):\n")
                self.callback = respCallback
                self.checkCommonApi(name: name, params: data, callback: respCallback)
            }
        }
        for name in self.interfaces{
            self.bridge.registerHandler(name) { (data, respCallback) in
                print(StringUtils.LOG + "PageAPI H5 Call (\(name)):\n")
                self.callback = respCallback
                self.didReceiveCall(name: name, params: data, callback: respCallback)
            }
        }
    }
    
    open override func refreshData() {
        self.webView.removeFromSuperview()
        self.webView = UIWebView()
        self.setWebView()
        
        if let nsUrl = URL(string: url){
            let request = URLRequest(url: nsUrl)
            webView.loadRequest(request)
            self.view.addSubview(webView)
        }
    }
    
    open  override var shouldAutorotate : Bool{
        return false
    }
    
    open  override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    open func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool{
        
        if let urlString = request.url?.absoluteString{
            if urlString.isEmpty{
                print("urlString = \(urlString)")
            }
            else{
                print("UrlString is nil ")
            }
        }
        
        //        var urlComps:[String]! = (urlString?.componentsSeparatedByString("://"))
        //        if(urlComps?.count > 0 && urlComps[0] == "ios"){
        //            var params:[String]
        //
        //            if urlComps[1].containsString("#!%23"){
        //                params = urlComps[1].componentsSeparatedByString("#!%23")
        //            }else{
        //                params = urlComps[1].componentsSeparatedByString("#!#")
        //            }
        //            let funcName = params[0]
        //        }
        return true
    }
    
    
    open func webViewDidFinishLoad(_ webView: UIWebView){
        UserDefaults.standard.set(0, forKey: "WebKitCacheModelPreferenceKey")   //减少内存泄漏
        YYHUD.dismiss()
        self.didFinish()
        
        
        if let resp: CachedURLResponse = URLCache.shared.cachedResponse(for: webView.request!){
            
            print("\((resp.response as? HTTPURLResponse)?.allHeaderFields)")
        }
        
        
        //        self.webView.stringByEvaluatingJavaScriptFromString("alert('success!!!')")
        //        [self.editorView stringByEvaluatingJavaScriptFromString:@"var script = document.createElement('script');"\
        //        "script.type = 'text/javascript';"
        //        "script.text = \"function myFunction() { "
        //        "document.getElementById('rich_media_title').style.display = 'none';"
        //        "document.getElementById('rich_media_meta_list').style.display = 'none';"
        //        "document.getElementById('rich_media_thumb_wrp').style.display = 'none';"
        //        "alert('success')}\";"
        //        "document.getElementsByTagName('head')[0].appendChild(script);"];
        //
        //        [self.editorView stringByEvaluatingJavaScriptFromString:@"myFunction();"];
    }
    
    open func webViewDidStartLoad(_ webView: UIWebView){
        YYHUD.showStatus("加载中...")
    }
    
    open func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        if self.isOnShow{
            YYHUD.dismiss()
            YYHUD.showToast("请重试")
        }
    }
    
    open func didFinish(){
        YYHUD.dismiss()
    }
    
    private func checkCommonApi(name:String, params:Any?, callback:WVJBResponseCallback?){
        if name == "getToken"{
            if callback != nil{
                let user = getUserInfo()
                callback!(["Token" : user.token])
            }
        }
        else if name == "goBack"{
            self.handleBack()
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
    
    open func didReceiveCall(name:String, params:Any?, callback:WVJBResponseCallback?){
        print("didReceiveCall = \(name)")
        //        if let dict = params as? [String:Any]{
        //            print("data dict = \(dict)")
        //        }
        //        else if let str = params as? String{
        //            print("data string = \(str)")
        //        }
        
        if callback != nil{
            callback!("")
        }
    }
    
    ///获取当前页面URL（ByJS）
    open func getPageUrl() -> String{
        var res = ""
        let script = "document.location.href"
        if let value = webView.stringByEvaluatingJavaScript(from: script){
            res = value
        }
        return res
    }
    
    ///获取当前页面标题（ByJS）
    open func getPageTitle() -> String{
        var res = ""
        let script = "document.title"
        if let value = webView.stringByEvaluatingJavaScript(from: script){
            res = value
        }
        return res
    }
    
    ///跳转到新的页面（ByJS）
    open func goto(url:String){
        let script = "location.href='\(url)'"   //也可用"window.open('\(url)')"
        if let value = webView.stringByEvaluatingJavaScript(from: script){
            print(value)
        }
    }
    
    open override func handleBack() {
        self.normalBack()
    }
    
    open func normalBack(){
        if self.webView.canGoBack{
            self.webView.goBack()
        }
        else{
            super.handleBack()
        }
    }
    
    ///生成回调Json字符串
    open func getResult(success:Bool,message:String,data:[String:Any]) -> String{
        let dict = ["Error": success,
                    "ErrorMsg":message,
                    "Result":data] as [String : Any]
        return dict.toJson()
    }
    
    
    fileprivate struct User {
        var token = ""
        var type = ""
    }
    
    ///接口调用间隔时间
    public func freeTimeFor(_ api:String) -> Int{
        let lastTime = lockCache[api] ?? 0
        let currentTime = TimeUtils.getCurrentTimeInterval()
        lockCache[api] = currentTime
        return currentTime - lastTime
    }
    
}


