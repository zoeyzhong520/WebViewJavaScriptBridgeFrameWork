//
//  WebViewJavaScriptBridgeFrameWorkWebViewDetailViewController.swift
//  WebViewJavaScriptBridgeFrameWork
//
//  Created by JOE on 2018/4/13.
//  Copyright © 2018年 Hongyear Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

import UIKit

class WebViewJavaScriptBridgeFrameWorkWebViewDetailViewController: WebViewJavaScriptBridgeFrameWorkBaseViewController {

    lazy var webView:WKWebView = {
        let webView = WKWebView(frame: self.view.bounds)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        return webView
    }()
    
    lazy var progressView:UIProgressView = {
        let frame = CGRect(x: 0, y: NavigationBarHeight + StatusBarHeight, width: screenWidth, height: 2)
        let progressView = UIProgressView(frame: frame)
        progressView.trackTintColor = UIColor.white
        progressView.progressTintColor = UIColor.cyan
        return progressView
    }()
    
    ///URLString
    var URLString:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        progressView.reloadInputViews()
    }
}

extension WebViewJavaScriptBridgeFrameWorkWebViewDetailViewController {
    
    //MARK: UI
    
    fileprivate func setPage() {
        
        guard let urlStr = self.URLString else {
            print("URLString is nil")
            WebViewJavaScriptBridgeFrameWorkHomeViewModel.showHUDWithDuration(vc: self, message: "URLString is nil", duration: 2.0)
            WebViewJavaScriptBridgeFrameWorkHomeViewModel.asyncAfterOnMainQueue(deadline: 2.0, completion: {
                //GCD延时执行
                self.navigationController?.popViewController(animated: true)
            })
            return
        }
        
        let url = URL(string: urlStr)
        self.webView.load(URLRequest(url: url!))
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil) //添加观察者
        self.view.addSubview(webView)
        
        self.addProgressView()
    }
    
    ///addProgressView
    fileprivate func addProgressView() {
        
        self.view.addSubview(progressView)
    }
}

extension WebViewJavaScriptBridgeFrameWorkWebViewDetailViewController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress" {
            progressView.isHidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
}

extension WebViewJavaScriptBridgeFrameWorkWebViewDetailViewController: WKUIDelegate, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(#function)
        progressView.setProgress(0.0, animated: true)
    }
}










