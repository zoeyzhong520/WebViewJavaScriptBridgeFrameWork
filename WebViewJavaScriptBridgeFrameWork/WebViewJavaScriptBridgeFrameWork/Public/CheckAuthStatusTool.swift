//
//  CheckAuthStatusTool.swift
//  WebViewJavaScriptBridgeFrameWork
//
//  Created by JOE on 2018/4/9.
//  Copyright © 2018年 Hongyear Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

import UIKit
import AVFoundation

class CheckAuthStatusTool: NSObject {

    ///检测用户是否已进行麦克风使用授权
    class func checkVideoAuthStatus(vc: UIViewController, authorizedClosure: (() -> Void), unAuthorizedClosure: (() -> Void)) {
        
        let videoAuthStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        if videoAuthStatus == AVAuthorizationStatus.restricted || videoAuthStatus == AVAuthorizationStatus.denied {
            //未授权
            CheckAuthStatusTool.showSetAlertView(vc: vc)
            unAuthorizedClosure()
        } else {
            //已授权
            authorizedClosure()
        }
    }
    
    ///提示用户进行麦克风使用授权
    class func showSetAlertView(vc: UIViewController) {
        let alertVC = UIAlertController(title: "麦克风权限未开启", message: "麦克风权限未开启，请进入系统【设置】>【隐私】>【麦克风】中打开开关,开启麦克风功能", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        let setAction = UIAlertAction(title: "去设置", style: .default) { (action) in
            //跳入当前App设置界面
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(setAction)
        vc.present(alertVC, animated: true, completion: nil)
    }
}


