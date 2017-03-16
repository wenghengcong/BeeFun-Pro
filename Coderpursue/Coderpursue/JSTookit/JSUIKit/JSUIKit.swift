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

/// 当前顶部视图控制器
let jsTopViewController = jsAppDelegate.tabBarController.topViewController()

/// 当前顶部导航栏控制器
let jsTopNavigationViewController = jsAppDelegate.tabBarController.currentNavigationViewController()

/// 当前顶部视图
let jsTopView = jsTopViewController?.view

let uiStatusBarHeight = 20.0

let uiNavigationBarHeight = 44.0

let uiTopBarHeight = 64.0

let uiTabBarHeight = 49.0


let uiKeyboardHeight = 20.0

