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
    
//    var linked = "http://local.seedu.me/#/"
    var linked = "http://192.168.2.37:8080/#/"
    
    var baiduLinked = "http://www.baidu.com"
    
    var authorization = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1aWQiOjU0LCJyb2xlVHlwZSI6MSwiaXNzIjoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3N0dWRlbnQvbG9naW4iLCJpYXQiOjE1MjE3OTM1MzksImV4cCI6MTUyNzc5MzUzOSwibmJmIjoxNTIxNzkzNTM5LCJqdGkiOiJDZDRRaWxlUHIwU2lHcmhZIn0.wvAmx9F9r7gtZff6b8uuA4fhcD_81vzD3M3-7-xgiSE"
    
    ///当前时间戳
    var currentTimeStamp:Int = 0
    
    ///录音机
    var recorder:AVAudioRecorder?
    
    ///cafFilePath
    var cafFilePath = ""
    
    ///mp3FilePath
    var mp3FilePath = ""
    
    ///是否正在录音
    var isRecording = false
    
    ///本地录音文件地址
    var musicURL:URL!
    
    ///音频文件时长
    var audioDurationSeconds:Double = 0.0
    
    ///上传录音文件返回的uuid
    var uuid = ""
    
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
    
    //MARK: UI
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
        
        //录音
        self.bridge.registerHandler("record") { (data, responseCallBack) in
            CheckAuthStatusTool.checkVideoAuthStatus(vc: self, authorizedClosure: {
                print("data: \(data)")
                self.getCurrentTimeStamp() //获取当前时间戳
                self.setRecorder(index: self.currentTimeStamp) //设置录音机
                self.record() //开始录音
                responseCallBack!(true) //回调
            }, unAuthorizedClosure: {
                responseCallBack!(false)
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
            //返回文件名 + 返回录音文件时长
            responseCallBack!(["name":"\(self.currentTimeStamp)", "time":"\(self.audioDurationSeconds)"])
        }
        
        //上传录音文件
        self.bridge.registerHandler("uploadFile") { (data, responseCallBack) in
            print("上传录音文件data: \(data)")
            let dataDict = data as? [String : Any]
            let fileName = dataDict?["name"] as? String ?? ""
            self.uploadFile(fileName: fileName) { uuid in
                //返回uuid
                responseCallBack!(["uuid":uuid])
            }
        }
        
        //播放
        self.bridge.registerHandler("play") { (data, responseCallBack) in
            print("data: \(data)")
            let dataDict = data as? [String : Any]
            let fileName = dataDict?["name"] ?? ""
            self.musicURL = URL(fileURLWithPath: TmpPath.appendingPathComponent("\(fileName).pcm"))
            self.play()
            responseCallBack!(true)
        }
        
        //暂停播放
        self.bridge.registerHandler("pausePlay") { (data, responseCallBack) in
            self.pausePlay()
            responseCallBack!(true)
        }
        
        //停止播放
        self.bridge.registerHandler("stopPlay") { (data, responseCallBack) in
            self.stopPlay()
        }
        
        //清除WebView缓存
        self.bridge.registerHandler("removeWebsiteData") { (data, responseCallBack) in
            WebViewJavaScriptBridgeFrameWorkHomeViewModel.removeWebsiteData()
            responseCallBack!("清除缓存完毕")
        }
        
        let url = URL(string: self.linked)
        self.webView.load(URLRequest(url: url!))
//        WebViewJavaScriptBridgeFrameWorkHomeViewModel.loadLocalHTML(webView: self.webView)
        self.view.addSubview(webView)
    }
    
    //MARK: 录音和停止录音
    
    ///设置录音机
    fileprivate func setRecorder(index: Int) {
        self.recorder = Recorder.setupRecorder(index: index)
    }
    
    ///录音
    fileprivate func record() {
        Recorder.startRecorder(recorder: self.recorder)
        
        //设置录音状态
        self.isRecording = true
        
        //禁止自动休眠
        UIApplication.shared.isIdleTimerDisabled = true
        
        self.cafFilePath = TmpPath.appendingPathComponent("\(self.currentTimeStamp).pcm")
        self.mp3FilePath = TmpPath.appendingPathComponent("\(self.currentTimeStamp).mp3")
//        self.musicURL = URL(fileURLWithPath: self.cafFilePath)
        
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
        
        //设置录音状态
        self.isRecording = false
    }
    
    ///停止录音
    fileprivate func stopRecord() {
        Recorder.stopRecorder(recorder: self.recorder)
        self.recorder = nil
        
        //设置录音状态
        self.isRecording = false
        
        //恢复自动休眠
        UIApplication.shared.isIdleTimerDisabled = false
        
        //获取录音文件的时长
        self.audioDurationSeconds = Recorder.audioDuration(index: self.currentTimeStamp)
    }
    
    //MARK: 上传录音文件
    
    ///上传录音文件
    fileprivate func uploadFile(fileName: String, completion: @escaping ((String) -> Void)) {
        
        let fileURL = URL(fileURLWithPath: self.mp3FilePath)
        let headers = [
            "Authorization" : self.authorization
        ]
        
        WebViewJavaScriptBridgeFrameWorkHomeViewModel.uploadFile(URLString: SubmitUrl, headers: headers, fileURL: fileURL, name: "file", fileName: "\(fileName).mp3", vc: self) { (uuid) in
            completion(uuid)
        }
    }
    
    //MARK: 播放和停止播放
    
    ///播放
    fileprivate func play() {
        
        if AudioPlayer.share(model: Music.createModel(withMusicURL: self.musicURL, withVoice_Time: nil, withAudio: nil)) {
            AudioPlayer.play()
            AudioPlayer.shareInstance.finishPlayingClosure = { [weak self] in
                self?.bridge.callHandler("onend", data: "data", responseCallback: { (callBack) in
                    print("callBack: \(callBack)")
                })
            }
        } else {
            print("AudioPlayer初始化失败")
        }
    }
    
    ///暂停播放
    fileprivate func pausePlay() {
    
        AudioPlayer.pause()
    }
    
    ///停止播放
    fileprivate func stopPlay() {
        
        AudioPlayer.stop()
    }
    
    //MARK: 其他方法
    
    ///获取当前时间戳
    fileprivate func getCurrentTimeStamp() {
        
        let timeStamp = WebViewJavaScriptBridgeFrameWorkHomeViewModel.getCurrentTimeStamp()
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
    
    ///copyFile
    fileprivate func copyFile() {
        
        WebViewJavaScriptBridgeFrameWorkHomeViewModel.copyFile()
    }
}

extension WebViewJavaScriptBridgeFrameWorkHomeViewController: WKUIDelegate, WKNavigationDelegate {
    
    //MARK: WKUIDelegate, WKNavigationDelegate
    
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



