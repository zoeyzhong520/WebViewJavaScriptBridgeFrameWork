//
//  WebViewJavaScriptBridgeFrameWorkSubViewController.swift
//  WebViewJavaScriptBridgeFrameWork
//
//  Created by JOE on 2018/4/3.
//  Copyright © 2018年 Hongyear Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

import UIKit

class WebViewJavaScriptBridgeFrameWorkSubViewController: WebViewJavaScriptBridgeFrameWorkBaseViewController {
    
    ///URLString
    var URLString = "https://movie.douban.com/subject/4920389/"
    
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
        
        let rightBtn = UIBarButtonItem(title: "共读", style: .plain, target: self, action: #selector(rightBtnClickAction))
        self.navigationItem.rightBarButtonItem = rightBtn
        
        self.addImageView()
    }
    
    @objc fileprivate func rightBtnClickAction() {
        
        self.navigationController?.pushViewController(WebViewJavaScriptBridgeFrameWorkHomeViewController(), animated: true)
    }
    
    ///addImageView
    fileprivate func addImageView() {
        
        let image = UIImage(named: "touhaowanjia.jpg")
        let imgView = UIImageView(image: image)
        imgView.contentMode = .scaleAspectFit
        imgView.frame = CGRect(x: 100, y: 100, width: screenWidth, height: (image?.size.height)!)
        imgView.center = self.view.center
        self.view.addSubview(imgView)
        
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imgViewTapAction)))
    }
    
    @objc fileprivate func imgViewTapAction() {
        
        let vc = WebViewJavaScriptBridgeFrameWorkWebViewDetailViewController()
        vc.URLString = self.URLString
        self.navigationController?.pushViewController(vc, animated: true)
    }
}






