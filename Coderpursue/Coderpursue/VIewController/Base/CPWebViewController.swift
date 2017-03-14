//
//  CPWebViewController.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/9.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit
import WebKit
import MBProgressHUD


/// 展示的hud是否占全屏
///
/// - full: 全屏
/// - topOffset: 顶部有64的高度
enum HudMode:String {
    case full = "full"
    case topOffset = "top"
}

class CPWebViewController: CPBaseViewController,WKNavigationDelegate,UIWebViewDelegate {

    // MARK: - property
    
    var webView : UIWebView?
    var hudMode:HudMode = .topOffset
    var hud:MBProgressHUD = MBProgressHUD.init()

    var url : String? {
        didSet {
            let urlTmp = URL(string: url!)
            let urlRequest = URLRequest(url: urlTmp!)
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

    // MARK: - view
    func wvc_customInit() {
        wbc_configUIWebView()
    }
    
    func wbc_configUIWebView() {
        
        self.webView = UIWebView(frame: self.view.bounds)
        self.view.addSubview(self.webView!)
        
        if url != nil {
            
            let urlTmp = URL(string: url!)
            let urlRequest = URLRequest(url: urlTmp!)
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
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        let isFull = (hudMode == .full)
        
        hud.frame = ScreenSize.bounds
        hud.show(animated: true)
        
        if isFull {
            if hud.isDescendant(of: cpKeywindow!){
                hud.hide(animated: false)
            }
            cpKeywindow!.addSubview(hud)
        }else{
            if hud.isDescendant(of: self.view){
                hud.hide(animated: false)
            }
            self.view.addSubview(hud)
        }
        hud.show(animated: true)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //hud hide后会自动移除
        hud.hide(animated: true)
        self.webView!.scrollView.contentInset = UIEdgeInsetsMake(self.topOffset, 0, 0, 0)
        self.webView!.scrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 0.1), animated: true)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        hud.hide(animated: true)
    }
    
    
    // MARK: - Navigation
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    // MARK: back and forward
    func goBack() {
        if (webView!.canGoBack) {
            webView!.goBack()
        }else {
            leftItemAction(nil)
        }
    }
    
    func goForward() {
        if webView!.canGoForward {
            webView!.goForward()
        }else {
            
        }
    }
    

}
