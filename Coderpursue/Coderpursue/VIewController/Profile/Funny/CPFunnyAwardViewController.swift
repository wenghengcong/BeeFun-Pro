//
//  CPFunnyAwardViewController.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/25/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

class CPFunnyAwardViewController: CPWebViewController {

    var username:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Award"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func leftItemAction(_ sender: UIButton?) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWithRequest request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if navigationType == .other {
            let userDefault = UserDefaults.standard
            userDefault.set(true, forKey: "\(username)needauth")
        }
        
        return true
    }
    
    override func webViewDidStartLoad(_ webView: UIWebView) {
        
        super.webViewDidStartLoad(webView)
        
    }
    
    
    override func webViewDidFinishLoad(_ webView: UIWebView) {
        super.webViewDidFinishLoad(webView)
        
        
    }
}
