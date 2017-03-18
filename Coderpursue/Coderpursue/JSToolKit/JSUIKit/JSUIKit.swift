//
//  JSUIKit.swift
//  LoveYou
//
//  Created by WengHengcong on 2017/3/13.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

/// 应用的代理
let jsAppDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate

let jsKeywindow = jsAppDelegate.window

let uiStatusBarHeight = 20.0

let uiNavigationBarHeight = 44.0

let uiTopBarHeight = 64.0

let uiTabBarHeight = 49.0


let uiKeyboardHeight = 20.0

//http://stackoverflow.com/questions/26667009/get-top-most-uiviewcontroller
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


func currentNavigationViewController() -> UINavigationController?{
    let nav = topViewController()?.navigationController
    return nav
}

func currentViewController() -> UIViewController? {
    return topViewController()
}

