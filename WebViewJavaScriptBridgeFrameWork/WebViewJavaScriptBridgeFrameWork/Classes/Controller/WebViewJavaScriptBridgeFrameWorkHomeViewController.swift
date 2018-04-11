//
//  WebViewJavaScriptBridgeFrameWorkHomeViewController.swift
//  WebViewJavaScriptBridgeFrameWork
//
//  Created by JOE on 2018/4/3.
//  Copyright © 2018年 Hongyear Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

import UIKit
import AVFoundation

class WebViewJavaScriptBridgeFrameWorkHomeViewController: WebViewJavaScriptBridgeFrameWorkBaseViewController {

    lazy var webView:WKWebView = {
        let webView = WKWebView(frame: self.view.bounds)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        return webView
    }()
    
    var bridge:WebViewJavascriptBridge!
    
    //var linked = "http://local.seedu.me/#/"
    var linked = "http://192.168.2.37:8080/#/"
    //http://192.168.2.37:8080/#/
    
    var baiduLinked = "http://www.baidu.com"
    
    var authorization = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1aWQiOjU0LCJyb2xlVHlwZSI6MiwiaXNzIjoiaHR0cDovL3Bob25lLnNlZWR1Lm1lL3RlYWNoZXIvbG9naW4iLCJpYXQiOjE1MjIxMzAyMDUsImV4cCI6MTUyODEzMDIwNSwibmJmIjoxNTIyMTMwMjA1LCJqdGkiOiJHam9mbzRtQTN5eDFSazZDIn0.5u65fCABLVc4MXYluL0U-v1j-K1V7y-I8KGFWRQ0fgo"
    
    ///当前时间戳
    var currentTimeStamp:Int = 0
    
    ///录音机
    var recorder:AVAudioRecorder?
    
    ///cafFilePath
    var cafFilePath = ""
    
    ///mp3FilePath
    var mp3FilePath = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopRecord() //停止录音
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
        self.getCurrentTimeStamp()
        self.addWebView()
        self.setRecorder()
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
        
        //录音
        self.bridge.registerHandler("record") { (data, responseCallBack) in
            CheckAuthStatusTool.checkVideoAuthStatus(vc: self, authorizedClosure: {
                self.record()
                responseCallBack!(true)
            })
        }
        
        //暂停录音
        self.bridge.registerHandler("pauseRecord") { (data, responseCallBack) in
            self.pauseRecord()
            responseCallBack!(true)
        }
        
        //停止录音
        self.bridge.registerHandler("stopRecord") { (data, responseCallBack) in
            self.stopRecord()
            let urlPath = URL(fileURLWithPath: self.mp3FilePath)
            print("urlPath: \(urlPath)")
            responseCallBack!("\(urlPath)")
        }
        
        //清除WebView缓存
        self.bridge.registerHandler("removeWebsiteData") { (data, responseCallBack) in
            self.removeWebsiteData()
            responseCallBack!("清除缓存完毕")
        }
        
//        let url = URL(string: self.linked)
//        self.webView.load(URLRequest(url: url!))
        self.loadLocalHTML()
        self.view.addSubview(webView)
    }
    
    ///Load Local HTML
    fileprivate func loadLocalHTML() {
        
        let htmlPath = Bundle.main.path(forResource: "index", ofType: "html")!
        let html = (try? String(contentsOfFile: htmlPath, encoding: String.Encoding.utf8)) ?? ""
        if html == "" {
            print("html is empty")
            return
        }
        
        let baseURL = URL(fileURLWithPath: htmlPath)
        print("html: \(html)")
        self.loadHTMLString(htmlContent: html, baseURL: baseURL)
    }
    
    ///loadHTMLString
    fileprivate func loadHTMLString(htmlContent: String, baseURL: URL) {
        
        // Load the html into the webview
        self.webView.loadHTMLString(htmlContent, baseURL: baseURL)
    }
    
    //MARK: 录音和停止录音
    
    ///设置录音机
    fileprivate func setRecorder() {
        self.recorder = Recorder.setupRecorder(index: 1)
    }
    
    ///录音
    fileprivate func record() {
        Recorder.startRecorder(recorder: self.recorder)
        
        //禁止自动休眠
        UIApplication.shared.isIdleTimerDisabled = true
        
        self.cafFilePath = TmpPath.appendingPathComponent("1.pcm")
        self.mp3FilePath = TmpPath.appendingPathComponent("1.mp3")
        //转码
        AudioWrapper.default().conventToMp3(withCafFilePath: self.cafFilePath, mp3FilePath: self.mp3FilePath) { (result) in
            if result == true {
                print("mp3 file compression sucesss")
            }
        }
    }
    
    ///暂停录音
    fileprivate func pauseRecord() {
        Recorder.pauseRecorder(recorder: self.recorder)
    }
    
    ///停止录音
    fileprivate func stopRecord() {
        Recorder.stopRecorder(recorder: self.recorder)
        
        //恢复自动休眠
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    ///获取当前时间戳
    fileprivate func getCurrentTimeStamp() {
        
        //获取当前时间
        let now = Date()
        
        //创建一个日期格式器
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        print("当前日期时间：\(dateFormatter.string(from: now))")
        
        //当前时间的时间戳
        let timeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        self.currentTimeStamp = timeStamp //赋值操作
        self.linked = self.linked + "?\(self.currentTimeStamp)"
        print("当前时间戳：\(timeStamp)")
        print("linked: \(self.linked)")
    }
    
    ///Alert
    fileprivate func alert(message: String?) {
        
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "否", style: .default, handler: { (action) in
            
        }))
        alert.addAction(UIAlertAction(title: "是", style: .default, handler: { (action) in
            self.stopRecord()
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    ///清除WebView缓存
    fileprivate func removeWebsiteData() {
        
        let websiteDataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        
        ///Data from
        let dateFrom = Date(timeIntervalSince1970: 0)
        
        ///Execute
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: dateFrom) {
            //Done
            print("清除缓存完毕")
        }
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



