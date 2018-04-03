//
//  WebViewJavaScriptBridgeFrameWorkHomeViewController.swift
//  WebViewJavaScriptBridgeFrameWork
//
//  Created by JOE on 2018/4/3.
//  Copyright © 2018年 Hongyear Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

import UIKit
import WebKit

class WebViewJavaScriptBridgeFrameWorkHomeViewController: WebViewJavaScriptBridgeFrameWorkBaseViewController {

    lazy var webView:WKWebView = {
        let webView = WKWebView(frame: self.view.bounds)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        return webView
    }()
    
    var bridge:WebViewJavascriptBridge!
    
    var linked = "http://phone.seedu.me/external/migu/#/"
    
    var baiduLinked = "http://www.baidu.com"
    
    var authorization = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1aWQiOjU0LCJyb2xlVHlwZSI6MiwiaXNzIjoiaHR0cDovL3Bob25lLnNlZWR1Lm1lL3RlYWNoZXIvbG9naW4iLCJpYXQiOjE1MjIxMzAyMDUsImV4cCI6MTUyODEzMDIwNSwibmJmIjoxNTIyMTMwMjA1LCJqdGkiOiJHam9mbzRtQTN5eDFSazZDIn0.5u65fCABLVc4MXYluL0U-v1j-K1V7y-I8KGFWRQ0fgo"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension WebViewJavaScriptBridgeFrameWorkHomeViewController {
    
    fileprivate func setPage() {
        self.title = "Home"
        self.addLeftBarItem()
        self.addWebView()
    }
    
    ///设置导航按钮
    fileprivate func addLeftBarItem() {
        
        let leftBtn = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(leftBarClickAction))
        self.navigationItem.rightBarButtonItem = leftBtn
    }
    
    @objc fileprivate func leftBarClickAction() {
        
        self.bridge.callHandler("back", data: "data") { (callBack) in
            print("callBack: \(callBack)")
        }
    }
    
    ///创建WebView
    fileprivate func addWebView() {
        
        WebViewJavascriptBridge.enableLogging() //设置调试模式
        
        self.bridge = WebViewJavascriptBridge.init(self.webView)
        self.bridge.setWebViewDelegate(self)
        
        //注册监听js的方法
        self.bridge.registerHandler("getAuthorization") { (data, responseCallBack) in
            responseCallBack!(self.authorization)
            print("getAuthorization called: \(data)")
        }
        
        self.bridge.registerHandler("close") { (data, responseCallBack) in
            print("close called: \(data)")
        }
        
        let url = URL(string: self.linked)
        self.webView.load(URLRequest(url: url!))
        self.view.addSubview(webView)
    }
}

extension WebViewJavaScriptBridgeFrameWorkHomeViewController: WKUIDelegate, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(#function)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("\(error)")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("\(error)")
    }
}


















