//
//  FileCacheHelper.swift
//  WebViewJavaScriptBridgeFrameWork
//
//  Created by JOE on 2018/4/13.
//  Copyright © 2018年 Hongyear Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

import UIKit

class FileCacheHelper: NSObject {

    /// 清除path文件夹下缓存大小
    //Error Domain=NSCocoaErrorDomain Code=513 "未能移除“Snapshots”，因为您没有访问它的权限。"
    class func clearCacheWithFilePath(path: String) -> Bool {
        
        var subPathArr = [String]()
        
        do {
            try subPathArr = FileManager.default.contentsOfDirectory(atPath: path)
        } catch let error {
            print("error: \(error.localizedDescription)")
        }
        
        var filePath = ""
        
        for subPath in subPathArr {
            filePath = (path as NSString).appendingPathComponent(subPath)
            
            //删除子文件夹
            do {
                if !filePath.contains("/Caches/Snapshots") {
                    try FileManager.default.removeItem(atPath: filePath)
                }
            } catch let error {
                print("error: \(error.localizedDescription)")
                return false
            }
        }
        
        return true
    }
}








