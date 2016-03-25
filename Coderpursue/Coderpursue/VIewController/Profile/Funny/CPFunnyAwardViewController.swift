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

        // Do any additional setup after loading the view.
        self.navigationController!.navigationBar.topItem?.title = ""
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Award"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if navigationType == .Other {
            let userDefault = NSUserDefaults.standardUserDefaults()
            userDefault.setBool(true, forKey: "\(username)needauth")
        }
        
        return true
    }
    
    override func webViewDidStartLoad(webView: UIWebView) {
        
        super.webViewDidStartLoad(webView)
        
    }
    
    
    override func webViewDidFinishLoad(webView: UIWebView) {
        super.webViewDidFinishLoad(webView)
        
        
    }
}
