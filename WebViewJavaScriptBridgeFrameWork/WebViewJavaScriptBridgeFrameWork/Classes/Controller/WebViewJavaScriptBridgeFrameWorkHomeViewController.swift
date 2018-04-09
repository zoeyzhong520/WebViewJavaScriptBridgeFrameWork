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
    
    var linked = "http://phone.seedu.me/external/migu/#/"
    
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
            })
        }
        
        //暂停录音
        self.bridge.registerHandler("pauseRecord") { (data, responseCallBack) in
            self.pauseRecord()
        }
        
        //停止录音
        self.bridge.registerHandler("stopRecord") { (data, responseCallBack) in
            self.stopRecord()
            responseCallBack!(self.mp3FilePath)
        }
        
        let url = URL(string: self.linked)
        self.webView.load(URLRequest(url: url!))
        self.view.addSubview(webView)
    }
    
    //MARK: 录音和停止录音
    
    ///设置录音机
    fileprivate func setRecorder() {
        self.getCurrentTimeStamp()
        self.recorder = Recorder.setupRecorder(index: self.currentTimeStamp)
    }
    
    ///录音
    fileprivate func record() {
        Recorder.startRecorder(recorder: self.recorder)
        
        //禁止自动休眠
        UIApplication.shared.isIdleTimerDisabled = true
        
        self.cafFilePath = TmpPath.appendingPathComponent("\(self.currentTimeStamp).pcm")
        self.mp3FilePath = TmpPath.appendingPathComponent("\(self.currentTimeStamp).mp3")
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
        print("当前时间戳：\(timeStamp)")
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



