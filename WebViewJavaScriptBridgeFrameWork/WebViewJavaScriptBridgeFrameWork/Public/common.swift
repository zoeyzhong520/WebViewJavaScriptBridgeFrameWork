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

