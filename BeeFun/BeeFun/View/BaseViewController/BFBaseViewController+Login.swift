//
//  BFBaseViewController+Login.swift
//  BeeFun
//
//  Created by WengHengcong on 2018/6/2.
//  Copyright © 2018年 JungleSong. All rights reserved.
//

import UIKit

extension BFBaseViewController {
        
    /// 在未登录时，展示了网络出错视图，但是此时需要提醒用户未登录
    func noEmptyViewNeedLoginAlert() {
        if !hasEmptyView() {
            if !UserManager.shared.needLoginAlert() {
                return
            }
        }
    }
    
    /// 更改属性，重新刷新视图
    func refreshLoginView() {
        removeLoginView()
        showLoginView()
    }
    
    func showLoginView() {
        
        if !needShowLoginView {
            return
        }
        
        //次于网络出错视图，若有网络出错视图，则不添加，直接移除未登录视图
        if hasReloadView() {
            removeLoginView()
            removeEmptyView()
            return
        }
        DispatchQueue.main.async {
            if let loginClosure = self.loginViewClosure {
                //未登录
                loginClosure(false)
            }
        }
        //无网络出错视图
        removeEmptyView()
        tableView.isHidden = true

        if !hasLoginView() {
            placeLoginView = BFPlaceHolderView(frame: view.frame, tip: loginTip, image: loginImage, actionTitle: loginActionTitle)
            // .greatestFiniteMagnitude 可以使view始终在最上层
            placeLoginView?.layer.zPosition = .greatestFiniteMagnitude
            placeLoginView?.placeHolderActionDelegate = self
            view.insertSubview(placeLoginView!, at: 0)
        }
        if let reloadView = placeLoginView {
            view.bringSubview(toFront: reloadView)
        }
    }
    
    func removeLoginView() {
        if !needShowLoginView {
            return
        }
        DispatchQueue.main.async {
            if let loginClosure = self.loginViewClosure {
                //已登录
                loginClosure(true)
            }
        }
        placeLoginView?.removeFromSuperview()
        tableView.isHidden = false
    }
    
    func hasLoginView() -> Bool {
        if placeLoginView == nil {
            return false
        }
        return true
    }
    
    @objc func login() {
        UserManager.shared.userSignIn()
    }
}
