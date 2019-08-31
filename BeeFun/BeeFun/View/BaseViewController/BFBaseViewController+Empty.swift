//
//  BFBaseViewController+Empty.swift
//  BeeFun
//
//  Created by WengHengcong on 2018/6/2.
//  Copyright © 2018年 JungleSong. All rights reserved.
//

import UIKit

extension BFBaseViewController: BFPlaceHolderViewDelegate {
    
    func refreshEmptyView() {
        removeEmptyView()
        showEmptyView()
    }
    
    func showEmptyView() {
        if !needShowEmptyView {
            return
        }
        //次于未登录及网络错误视图，故需要先判断是否有
        if hasReloadView() || hasLoginView() {
            return
        }
        //无未登录及网络错误视图

        tableView.isHidden = true        
        if !hasEmptyView() {
            placeEmptyView = BFPlaceHolderView(frame: self.view.frame, tip: emptyTip, image: emptyImage, actionTitle: emptyActionTitle)
            placeEmptyView?.placeHolderActionDelegate = self
            placeEmptyView?.layer.zPosition = .greatestFiniteMagnitude
            view.insertSubview(placeEmptyView!, at: 0)
        }
        
        if let reloadView = placeEmptyView {
            view.bringSubview(toFront: reloadView)
        }
    }
    
    func removeEmptyView() {
        if !needShowEmptyView {
            return
        }
        placeEmptyView?.removeFromSuperview()
        tableView.isHidden = false
    }
    
    func hasEmptyView() -> Bool {
        if placeEmptyView == nil {
            return false
        }
        return true
    }
    
    @objc func request() {
        
    }
    
    /// 占位图代理
    @objc func didAction(place: BFPlaceHolderView) {
        if place == placeEmptyView {
            request()
        } else if place == placeLoginView {
            login()
        } else if place == placeReloadView {
            self.request()
        }
    }
}
