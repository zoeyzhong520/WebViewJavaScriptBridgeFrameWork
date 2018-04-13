//
//  common.swift
//  WebViewJavaScriptBridgeFrameWork
//
//  Created by ZHONG ZHAOJUN on 2018/4/8.
//  Copyright © 2018年 Hongyear Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

import UIKit

///屏幕宽度
let screenWidth = UIScreen.main.bounds.size.width

///屏幕高度
let screenHeight = UIScreen.main.bounds.size.height

//MARK: - 文件路径

/// tmp目录路径
let TmpPath = NSTemporaryDirectory() as NSString

/// bundle 目录路径
let BundlePath = Bundle.main.bundlePath as NSString

/// Documents目录路径
let DocumentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString

///pc.seedu.me
let PCAppURL = "https://pc.seedu.me"

///Host
let Host = "phone.seedu.me"

/// 任务-主观题单题提交 POST
let SubjectiveSubmitUrl = "http://\(Host)/subject"

/// 共读语音文件提交 POST
let SubmitUrl = "http://\(Host)/hybrid/file"

///状态栏高度
let StatusBarHeight = UIApplication.shared.statusBarFrame.size.height

//导航栏高度
let NavigationBarHeight:CGFloat = 44.0














