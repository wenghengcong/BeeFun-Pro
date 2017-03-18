//
//  JSUIGloable.swift
//  Coderpursue
//
//  Created by WengHengcong on 2017/3/18.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

class JSUIGlobal: NSObject {
    
}

/// 全局keywindow
let jsKeywindow = jsAppDelegate.window

/// 状态栏高度20
let uiStatusBarHeight = 20.0

/// 导航栏高度44
let uiNavigationBarHeight = 44.0

/// 顶部高度=64
let uiTopBarHeight = 64.0

/// 底部tabbar高度
let uiTabBarHeight = 49.0

/// 键盘高度
let uiKeyboardHeight = 20.0


//http://stackoverflow.com/questions/26667009/get-top-most-uiviewcontroller

/// 获取顶部视图控制器
///
/// - Parameter controller: <#controller description#>
/// - Returns: <#return value description#>
func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    if let navigationController = controller as? UINavigationController {
        return topViewController(controller: navigationController.visibleViewController)
    }
    if let tabController = controller as? UITabBarController {
        if let selected = tabController.selectedViewController {
            return topViewController(controller: selected)
        }
    }
    if let presented = controller?.presentedViewController {
        return topViewController(controller: presented)
    }
    return controller
}


/// 顶部控制器
///
/// - Returns: <#return value description#>
func currentNavigationViewController() -> UINavigationController?{
    let nav = topViewController()?.navigationController
    return nav
}


/// 当前视图控制器，即顶部视图控制器
///
/// - Returns: <#return value description#>
func currentViewController() -> UIViewController? {
    return topViewController()
}


/// 当前顶部视图控制器
let jsTopViewController = topViewController()


/// 当前顶部导航栏控制器
let jsTopNavigationViewController = currentNavigationViewController()


/// 当前顶部视图
let jsTopView = jsTopViewController?.view
