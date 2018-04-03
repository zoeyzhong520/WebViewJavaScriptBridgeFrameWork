//
//  WebViewJavaScriptBridgeFrameWorkSubViewController.swift
//  WebViewJavaScriptBridgeFrameWork
//
//  Created by JOE on 2018/4/3.
//  Copyright © 2018年 Hongyear Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

import UIKit

class WebViewJavaScriptBridgeFrameWorkSubViewController: WebViewJavaScriptBridgeFrameWorkBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension WebViewJavaScriptBridgeFrameWorkSubViewController {
    
    fileprivate func setPage() {
        
        self.title = "Sub"
        
        let rightBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightBtnClickAction))
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    @objc fileprivate func rightBtnClickAction() {
        
        self.navigationController?.pushViewController(WebViewJavaScriptBridgeFrameWorkHomeViewController(), animated: true)
    }
}

















