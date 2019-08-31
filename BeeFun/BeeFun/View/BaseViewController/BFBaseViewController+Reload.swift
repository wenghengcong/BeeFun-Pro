//
//  BFBaseViewController+Reload.swift
//  BeeFun
//
//  Created by WengHengcong on 2018/5/31.
//  Copyright © 2018年 JungleSong. All rights reserved.
//

import UIKit

extension BFBaseViewController {
    
    /// 检查当前网络状态，并显示网络异常页面
    func checkCurrentNetworkState() -> Bool {
        if BFNetworkManager.shared.isReachable {
            removeReloadView()
        } else {
            showReloadView()
        }
        return BFNetworkManager.shared.isReachable
    }
    
    /// 检查是否登录，会显示未登录视图
    func checkCurrentLoginState() -> Bool {
        if UserManager.shared.isLogin {
            removeLoginView()
        } else {
            showLoginView()
        }
        return UserManager.shared.isLogin
    }
    
    func refreshReloadView() {
        removeReloadView()
        showReloadView()
    }
    
    func showReloadView() {
        if !needShowReloadView {
            return
        }
        //最高等级占位图，可移除登录、无数据视图及隐藏表格
        DispatchQueue.main.async {
            if let reloadClosure = self.reloadViewClosure {
                //不能触达网络
                reloadClosure(false)
            }
        }
        tableView.isHidden = true
        removeLoginView()
        removeEmptyView()
        tableView.isHidden = true
        if !hasReloadView() {
            placeReloadView = BFPlaceHolderView(frame: view.frame, tip: reloadTip, image: reloadImage, actionTitle: reloadActionTitle)
            placeReloadView?.layer.zPosition = .greatestFiniteMagnitude
            placeReloadView?.placeHolderActionDelegate = self
            view.insertSubview(placeReloadView!, at: 0)
        }
        if let reloadView = placeReloadView {
            view.bringSubview(toFront: reloadView)
        }
    }
    
    func removeReloadView() {
        if !needShowReloadView {
            return
        }
        DispatchQueue.main.async {
            if let reloadClosure = self.reloadViewClosure {
                //触达网络
                reloadClosure(true)
            }
        }
        placeReloadView?.removeFromSuperview()
        tableView.isHidden = false
    }
    
    func hasReloadView() -> Bool {
        if placeReloadView == nil {
            return false
        }
        return true
    }
    
    @objc func reconnect() {
        if !hasEmptyView() && needLogin {
           _ = UserManager.shared.needLoginAlert()
        }
    }
}
