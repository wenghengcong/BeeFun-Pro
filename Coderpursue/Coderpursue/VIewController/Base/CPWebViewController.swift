//
//  CPWebViewController.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/9.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit
import WebKit

class CPWebViewController: CPBaseViewController,WKNavigationDelegate,UIWebViewDelegate {

    // MARK: - property
    
    var webView : UIWebView?
    
    var url : String? {
        didSet {
            let urlTmp = NSURL(string: url!)
            let urlRequest = NSURLRequest(URL: urlTmp!)
            if webView != nil {
                self.webView!.loadRequest(urlRequest)
            }
        }
    }
    var html : String? {
        
        didSet {
            
            if webView != nil {
                self.webView!.loadHTMLString(html!, baseURL: nil)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        wvc_customInit()
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - view
    func wvc_customInit() {
        
        wbc_configUIWebView()
 
    }
    
    func wbc_configUIWebView() {
        
        self.webView = UIWebView(frame: self.view.bounds)
        self.view.addSubview(self.webView!)
        
        if url != nil {
            
            let urlTmp = NSURL(string: url!)
            let urlRequest = NSURLRequest(URL: urlTmp!)
            self.webView!.loadRequest(urlRequest)
        }
        if html != nil {
            self.webView!.loadHTMLString(html!, baseURL: nil)
        }
        
        self.webView!.delegate = self

    }
    
    func wbc_configWKWebView() {
        
        /**
        /* Create our preferences on how the web page should be loaded */
        //        let preferences = WKPreferences()
        //        preferences.javaScriptEnabled = false
        
        
        // Javascript that disables pinch-to-zoom by inserting the HTML viewport meta tag into <head>
        let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" +
        "head.appendChild(meta);";
        let script: WKUserScript = WKUserScript(source: source, injectionTime: .AtDocumentEnd, forMainFrameOnly: true)
        
        // Create the user content controller and add the script to it
        let userContentController: WKUserContentController = WKUserContentController()
        userContentController.addUserScript(script)
        
        // Create the configuration with the user content controller
        let configuration: WKWebViewConfiguration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        
        
        
        /* Now instantiate the web view */
        webView = WKWebView(frame: view.bounds, configuration: configuration)
        webView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView!)
        
        let viewsDic: NSDictionary = ["webView" : webView!]
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[webView]|", options: .AlignAllLeft, metrics: nil, views: viewsDic as! [String : AnyObject]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[webView]|", options: .AlignAllLeft, metrics: nil, views: viewsDic as! [String : AnyObject]))
        
        if let theWebView = webView{
            /* Load a web page into our web view */
            
            if url != nil {
                
                let urlTmp = NSURL(string: url!)
                let urlRequest = NSURLRequest(URL: urlTmp!)
                theWebView.loadRequest(urlRequest)
            }
            if html != nil {
                theWebView.loadHTMLString(html!, baseURL: nil)
            }
            
            theWebView.navigationDelegate = self
            
        }
        **/
    }

    // MARK: - uiwebviewdelegate 
//    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
////        self.webView.scalesPageToFit = true
//        return true
//    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)

    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        self.webView!.scrollView.contentInset = UIEdgeInsetsMake(self.topOffset, 0, 0, 0)
        self.webView!.scrollView.scrollRectToVisible(CGRectMake(0, 0, self.view.frame.size.width, 0.1), animated: true)
        
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)

    }
    
    
    // MARK: - Navigation
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    // MARK: back and forward
    func goBack() {
        
        
        if (webView!.canGoBack) {
            webView!.goBack()
        }else {
            navBack()
        }
    }
    
    func goForward() {
        if webView!.canGoForward {
            webView!.goForward()
        }else {
            
        }
    }
    

}
