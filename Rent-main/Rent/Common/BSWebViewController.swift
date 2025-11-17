//
//  BSWebViewController.swift
//  Rent
//
//  Created by jiang 2019/3/8.
//  Copyright © 2019年 jiang. All rights reserved.
//

import UIKit
import WebKit

class BSWebViewController: BSBaseViewController {

    var url = ""
    
    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: self.view.bounds, configuration: getConfig())
        webView.backgroundColor = UIColor.white
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.contentOffset = CGPoint(x: 0, y: webView.scrollView.contentOffset.y)
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        YYHUD.dismiss()
    }
    
    /// UI
    func setupUI() {
        self.view.addSubview(self.webView)
        self.webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    /// Data
    func loadData() {
        if let nsUrl = URL(string: url) {
            let request = URLRequest(url: nsUrl)
            self.webView.load(request)
        }
    }
    
    //不显示文字选中菜单
    func getConfig() -> WKWebViewConfiguration{
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

}

extension BSWebViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        YYHUD.showStatus("加载中")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        YYHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        YYHUD.dismiss()
        YYHUD.showToast("加载失败，请重试")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    
    
}
