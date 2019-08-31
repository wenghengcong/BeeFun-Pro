//
//  JumpManager.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/3/30.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit
import TOWebViewController
import SafariServices

class JumpManager: NSObject {

    static let shared = JumpManager()
    
    /// 跳转到Repos detail页面
    ///
    /// - Parameter repos: 项目model
    func jumpReposDetailView(repos: ObjRepos?, from: ReposDetailFrom) {
        if repos != nil && (repos?.name != nil || repos?.url != nil) {
            //获取该repo的user以及name
            if let repoName = repos?.name {
                //1. reponame不为空
                //repo name格式为：ueer/reponame
                let componets = repoName.split("/")
                if componets.count >= 2 {
                    let owner = ObjUser()
                    owner.login = componets.first
                    repos?.owner = owner
                    repos?.name = componets.last
                } else if let repoUrl = repos?.url {
                    //repo name格式为：reponame
                    //就去看repo 的url不是空的，分拆
                    let componets = repoUrl.split("/")
                    if componets.count > 2 {
                        let owner = ObjUser()
                        owner.login = componets[componets.count-2]
                        repos?.owner = owner
                        repos?.name = componets.last
                    }
                }
            } else if let repoUrl = repos?.url {
                //2.reponame为空，repo 的url不为空，分拆
                let componets = repoUrl.split("/")
                if componets.count > 2 {
                    let owner = ObjUser()
                    owner.login = componets[componets.count-2]
                    repos?.owner = owner
                }
            }
            
            let vc = BFRepoDetailController()
            vc.hidesBottomBarWhenPushed = true
            vc.repoModel = repos
            vc.from = from
            DispatchQueue.main.async {
                BFTabbarManager.shared.jsTopNavigationViewController()?.pushViewController(vc, animated: true)
            }
        }
    }
    
    /// 跳转到用户详情页
    ///
    /// - Parameter user: 用户model
    func jumpUserDetailView(user: ObjUser?) {
        if user != nil {
            let vc = BFUserDetailController()
            vc.hidesBottomBarWhenPushed = true
            vc.developer = user
            
            DispatchQueue.main.async {
                BFTabbarManager.shared.jsTopNavigationViewController()?.pushViewController(vc, animated: true)
            }
        }
    }
    
    /// 跳转到M页
    ///
    /// - Parameter url: M页地址
    func jumpWebView(url: String?) {
        if url != nil {
            if let JUMPURL = URL(string: url!) {
                let web = SFSafariViewController(url: JUMPURL)
                web.hidesBottomBarWhenPushed = true
                if #available(iOS 11.0, *) {
                    web.dismissButtonStyle = .close
                } else {
                    // Fallback on earlier versions
                }
                DispatchQueue.main.async {
                    BFTabbarManager.shared.jsTopNavigationViewController()?.present(web, animated: true, completion: {
                        
                    })
                }
            }
//            let webController = BFWebViewController(urlString: url)
//            webController?.loadingBarTintColor = UIColor.bfRedColor
//            if let webview = webController?.webView {
//                for scrollView in webview.subviews where scrollView.isKind(of: UIScrollView.self) {
//                    let src = scrollView as? UIScrollView
//                    src?.showsHorizontalScrollIndicator = false
//                    src?.bounces = false
//                }
//                webview.scalesPageToFit = true
//                webview.backgroundColor = .clear
//                webview.isOpaque = false
//            }
//
//            webController?.hidesBottomBarWhenPushed = true
//            DispatchQueue.main.async {
//                BFTabbarManager.shared.jsTopNavigationViewController()?.pushViewController(webController!, animated: true)
//            }
        }
    }
    
    /// 跳转到Issue详情页
    ///
    /// - Parameter issue: Issue model
    func jumpIssueDetailView(issue: ObjIssue?) {
        if let url = issue?.html_url {
            jumpWebView(url: url)
        }
    }
}
