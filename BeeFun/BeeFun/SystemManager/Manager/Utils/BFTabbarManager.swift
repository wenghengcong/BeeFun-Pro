//
//  BFTabbarManager.swift
//  BeeFun
//
//  Created by WengHengcong on 27/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit

class BFTabbarManager: NSObject {
    
    static let shared = BFTabbarManager()
    
    /// 应用的代理
    static let jsAppDelegate: AppDelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()
    
    /************************************常用UI 视图**********************************/
    
    /// 全局keywindow
    static let jsKeywindow: UIWindow? = {
        var window = UIApplication.shared.keyWindow
        if window == nil {
            window = UIApplication.shared.windows.first
        }
        return window
    }()
    
    static let jsTabbarController = {
        return BFTabbarManager.jsAppDelegate.tabBarController
    }()
    
    /// 当前顶部视图控制器
    func jsTopViewController() -> UIViewController? {
        let topView = BFTabbarManager.jsTabbarController?.topViewController()
        return topView
    }
    
    /// 当前顶部导航栏控制器
    func jsTopNavigationViewController() -> UINavigationController? {
        let nav = BFTabbarManager.jsTabbarController?.currentNavigationViewController()
        return nav
    }
    
    /// 当前顶部视图
    func jsTopView() -> UIView? {
        let topView = jsTopViewController()
        return topView?.view
    }
    
    /// 选中tab
    ///
    /// - Parameter index: 位置
    func goto(index: Int) {
        BFTabbarManager.jsTabbarController?.gotoTab(index: index)
    }
}
