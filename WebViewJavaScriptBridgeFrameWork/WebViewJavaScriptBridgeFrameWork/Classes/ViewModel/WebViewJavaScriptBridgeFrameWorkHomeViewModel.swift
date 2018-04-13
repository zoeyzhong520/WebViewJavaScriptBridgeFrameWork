//
//  WebViewJavaScriptBridgeFrameWorkHomeViewModel.swift
//  WebViewJavaScriptBridgeFrameWork
//
//  Created by JOE on 2018/4/11.
//  Copyright © 2018年 Hongyear Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class WebViewJavaScriptBridgeFrameWorkHomeViewModel: NSObject {
    
    //MARK: - Local HTML
    
    ///Load Local HTML
    class func loadLocalHTML(webView: WKWebView) {
        
        let htmlPath = self.bundleFrameworkPath(resource: "index", ofType: "html")
        let baseURL = URL(fileURLWithPath: htmlPath)
        print("baseURL: \(baseURL)\r")
        
        if let htmlData = try? Data(contentsOf: baseURL) {
            print("htmlData: \(htmlData)\r")
        }
        
        print("documentPath: \(DocumentPath)\r")
        var html = (try? String(contentsOfFile: htmlPath, encoding: String.Encoding.utf8)) ?? ""
        if html == "" {
            print("html is empty")
            return
        }
        html = html.replacingOccurrences(of: "/static/css/", with: "")
        html = html.replacingOccurrences(of: "/static/js/", with: "")
        print("html: \(html)")
        
        let htmlCssJsPaths = self.htmlCssJsFilePaths(dirPath: DocumentPath as String)
        print("htmlCssJsPaths: \(htmlCssJsPaths)\r")
        
        self.loadHTMLString(htmlContent: html, baseURL: baseURL, webView: webView)
    }
    
    ///loadHTMLString
    class func loadHTMLString(htmlContent: String, baseURL: URL, webView: WKWebView) {
        
        // Load the html into the webview
        webView.loadHTMLString(htmlContent, baseURL: baseURL)
    }
    
    //MARK: - 清除WebView缓存
    
    ///清除WebView缓存
    class func removeWebsiteData() {
        
        let websiteDataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        
        ///Data from
        let dateFrom = Date(timeIntervalSince1970: 0)
        
        ///Execute
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: dateFrom) {
            //Done
            print("清除缓存完毕")
        }
    }
    
    //MARK: - 获取当前时间戳
    
    ///获取当前时间戳
    class func getCurrentTimeStamp() -> Int {
        
        //获取当前时间
        let now = Date()
        
        //创建一个日期格式器
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        print("当前日期时间：\(dateFormatter.string(from: now))")
        
        //当前时间的时间戳
        let timeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        print("当前时间戳：\(timeStamp)")
        
        return timeStamp
    }
    
    //MARK: - 文件操作
    
    ///拷贝文件到沙盒
    class func copyMissionFile(sourcePath: String, toPath: String) -> Bool {
        
        var retVal = true // If the file already exists, we'll return success…
        let finalLocation = (toPath as NSString).appendingPathComponent((sourcePath as NSString).lastPathComponent)
        if !FileManager.default.fileExists(atPath: finalLocation) {
            do {
                try FileManager.default.copyItem(atPath: sourcePath, toPath: finalLocation)
            } catch let error {
                print("error: \(error.localizedDescription)")
                retVal = false
            }
        }
        return retVal
    }
    
    ///拷贝文件
    class func copyFile() {
        
        let htmlFilePath = self.bundleFrameworkPath(resource: "index", ofType: "html")
        let jsAppPath = self.bundleFrameworkPath(resource: "app.b7a44742ac2aafd7a837", ofType: "js")
        let jsManifestPath = self.bundleFrameworkPath(resource: "manifest.2ae2e69a05c33dfc65f8", ofType: "js")
        let jsVendorPath = self.bundleFrameworkPath(resource: "vendor.3793cece39c7ec53285e", ofType: "js")
        let cssFilePath = self.bundleFrameworkPath(resource: "app.16099212544d1bb4422c4995bb23c599", ofType: "css")
        
        self.copyMissionFile(sourcePath: htmlFilePath, toPath: DocumentPath as String) == true ? print("OK") : print("NO")
        self.copyMissionFile(sourcePath: jsAppPath, toPath: DocumentPath as String) == true ? print("OK") : print("NO")
        self.copyMissionFile(sourcePath: jsManifestPath, toPath: DocumentPath as String) == true ? print("OK") : print("NO")
        self.copyMissionFile(sourcePath: jsVendorPath, toPath: DocumentPath as String) == true ? print("OK") : print("NO")
        self.copyMissionFile(sourcePath: cssFilePath, toPath: DocumentPath as String) == true ? print("OK") : print("NO")
    }
    
    /// 获取沙盒目录下的所有html、css、js文件
    class func htmlCssJsFilePaths(dirPath: String) -> [String] {
        
        var filePath = [String]()
        
        if let array = FileManager.default.subpaths(atPath: dirPath) {
            for file in array {
                if (file as NSString).pathExtension == "html" || (file as NSString).pathExtension == "css" || (file as NSString).pathExtension == "js" {
                    filePath.append(file)
                }
            }
        }
        return filePath
    }
    
    //MARK: - Bundle获取文件路径
    
    ///bundleFrameworkPath
    class func bundleFrameworkPath(resource: String, ofType: String) -> String {
        
        return Bundle.main.path(forResource: resource, ofType: ofType) ?? ""
    }
    
    //MARK: - 文件上传
    
    ///上传录音文件
    class fileprivate func uploadFile(URLString: String, parameters: [String : Any]?, headers: HTTPHeaders?, fileURL: URL?, name: String?, fileName: String?, success: @escaping ((String) -> Void), failure: @escaping ((NSError) -> Void)) {
        
        NetWorkTool.uploadFile(URLString: URLString, parameters: parameters ?? [String : Any](), headers: headers, fileURL: fileURL, name: name, fileName: fileName, finishedCallback: { (data) in
            
            do {
                let json = try JSON(data: data as! Data)
                let uuid = json["data"]["uuid"].string ?? ""
                success(uuid)
            } catch let error {
                print("error: \(error.localizedDescription)")
            }
            
        }) { (error) in
            failure(error)
        }
    }
    
    ///上传录音文件
    class func uploadFile(URLString: String, parameters: [String : Any]? = nil, headers: HTTPHeaders? = nil, fileURL: URL?, name: String?, fileName: String?, vc: UIViewController, success: @escaping ((String) -> Void)) {
        
        let alert = self.showHUD(vc: vc, message: "上传中···")
        
        self.uploadFile(URLString: URLString, parameters: parameters, headers: headers, fileURL: fileURL, name: name, fileName: fileName, success: { (uuid) in
            print("uuid: \(uuid)")
            self.hideHUD(alert: alert)
            success(uuid)
            self.showHUDWithDuration(vc: vc, message: "上传完成")
        }) { (error) in
            self.hideHUD(alert: alert)
        }
    }
    
    //MARK: - HUD活动指示器
    
    ///showHUD
    class func showHUD(vc: UIViewController, message: String?) -> UIAlertController {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        vc.present(alert, animated: true, completion: nil)
        return alert
    }
    
    class func showHUDWithDuration(vc: UIViewController, message: String?, duration: TimeInterval = 1.0) {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        vc.present(alert, animated: true, completion: nil)
        
        //延迟执行
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    ///hideHUD
    class func hideHUD(alert: UIAlertController) {
        
        alert.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - 自定义弹框
    
    ///showAlertWithMessage
    class func showAlertWithMessage(vc: UIViewController, message: String?, completion: @escaping (() -> Void)) {
        
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "否", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "是", style: .default, handler: { (action) in
            completion()
        }))
        vc.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - GCD
    
    ///主线程GCD延时执行
    class func asyncAfterOnMainQueue(deadline: TimeInterval, completion: @escaping (() -> Void)) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + deadline) {
            completion()
        }
    }
}












