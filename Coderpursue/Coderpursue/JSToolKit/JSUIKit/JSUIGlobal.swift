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


/// 全局keywindow
let jsKeywindow = jsAppDelegate.window

/// 当前顶部视图控制器
let jsTopViewController = jsAppDelegate.tabBarController?.topViewController()


/// 当前顶部导航栏控制器
let jsTopNavigationViewController = jsAppDelegate.tabBarController?.currentNavigationViewController()


/// 当前顶部视图
let jsTopView = jsTopViewController?.view
