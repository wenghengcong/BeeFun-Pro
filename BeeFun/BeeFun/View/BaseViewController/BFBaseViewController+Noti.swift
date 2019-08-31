//
//  BFBaseViewController+Noti.swift
//  BeeFun
//
//  Created by WengHengcong on 2018/6/2.
//  Copyright © 2018年 JungleSong. All rights reserved.
//

import UIKit

extension BFBaseViewController {
    
    func registerNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccessful), name: NSNotification.Name.BeeFun.DidLogin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(logoutSuccessful), name: NSNotification.Name.BeeFun.DidLogout, object: nil)
        //Network reachablity
        NotificationCenter.default.addObserver(self, selector: #selector(networkCantReachable), name: NSNotification.Name.BeeFun.UnReachableAfterReachable, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(networkReachable), name: NSNotification.Name.BeeFun.ReachableAfterUnreachable, object: nil)
    }
    
    @objc func loginSuccessful() {
        removeLoginView()
    }
    
    @objc func logoutSuccessful() {
        
    }
    
    @objc func networkCantReachable() {
        //显示reloadview
        showReloadView()
    }
    
    @objc func networkReachable() {
        removeReloadView()
        //进行重连
        reconnect()
    }
}
