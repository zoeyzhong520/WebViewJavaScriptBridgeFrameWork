//
//  NetWorkTool.swift
//  WebViewJavaScriptBridgeFrameWork
//
//  Created by JOE on 2018/4/12.
//  Copyright © 2018年 Hongyear Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

import UIKit
import Alamofire

class NetWorkTool: NSObject {

    /// Upload file to server.
    class func uploadFile(URLString: String, parameters: [String : Any], headers: HTTPHeaders?, fileURL: URL?, name: String?, fileName: String?, finishedCallback : @escaping (_ result : Any) -> (), failedCallback : @escaping (_ error : NSError) -> ()) {
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            guard let fileUrl = fileURL else { return }
            guard let filename = fileName else { return }
            guard let name1 = name else { return }
            
            multipartFormData.append(fileUrl, withName: name1, fileName: filename, mimeType: "application/octet-stream")
            
            for (key, value) in parameters {
                if let data = (value as? String)?.data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                }
            }
        }, to: URLString, method: .post, headers: headers) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseData(completionHandler: { (response) in
                    guard let data = response.data else { return }
                    
                    /// 将结果回调出去
                    finishedCallback(data)
                })
                
                upload.responseJSON(completionHandler: { (response) in
                    print("response: \(response)")
                })
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
            case .failure(let encodingError):
                print("encodingError: \(encodingError.localizedDescription)")
                failedCallback(encodingError as NSError)
            }
        }
    }
}










