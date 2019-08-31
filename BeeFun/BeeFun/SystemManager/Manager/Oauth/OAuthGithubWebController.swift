//
//  OAuthWebViewController.swift
//  BeeFun
//
//  Created by WengHengcong on 2018/1/24.
//  Copyright © 2018年 LuCi. All rights reserved.
//

import OAuthSwift
import WebKit
import MBProgressHUD

typealias WebView = WKWebView

class OAuthGithubWebController: OAuthWebViewController {
    
    var targetURL: URL?
    let webView: WebView = WebView()
    var progressHud: MBProgressHUD = MBProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sign in to GitHub"
        configWebView()
        configHudView()
    }
    
    func configWebView() {
        
        self.webView.frame = UIScreen.main.bounds
        self.webView.navigationDelegate = self
        self.hidesBottomBarWhenPushed = true
        self.view.addSubview(self.webView)
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    func configHudView() {
        progressHud = MBProgressHUD.init(view: self.view)
        progressHud.mode = .determinate
        progressHud.delegate = self
        progressHud.removeFromSuperViewOnHide = true
        progressHud.label.text = "On the way..."
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress") {
            progressHud.progress = Float(webView.estimatedProgress)
            if webView.estimatedProgress >= 0.7 {
                let _ : Void = {
                    hideHud()
                }()
            }
        }
    }
    
    override func handle(_ url: URL) {
        targetURL = url
        super.handle(url)
        self.loadAddressURL()
    }
    
    func loadAddressURL() {
        guard let url = targetURL else {
            return
        }
        let req = URLRequest(url: url)
        showHud()
        self.webView.load(req)
    }
    
    func showHud() {
        progressHud.show(animated: true)
        self.view.addSubview(progressHud)
    }
    
    func hideHud() {
        progressHud.hide(animated: true)
    }

}

extension OAuthGithubWebController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // here we handle internally the callback url and call method that call handleOpenURL (not app scheme used)
        if let url = navigationAction.request.url, url.scheme == "beefunios" {
            AppDelegate.sharedInstance.applicationHandle(url: url)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("\(error)")
        self.dismissWebViewController()
        // maybe cancel request...
    }
}

extension OAuthGithubWebController: MBProgressHUDDelegate {
    func hudWasHidden(_ hud: MBProgressHUD) {
        progressHud.removeFromSuperview()
    }
}
