//
//  JSUIGloable.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/3/18.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

class JSUIGlobal: NSObject {
    
}

/// 状态栏高度20
let uiStatusBarHeight:CGFloat = 20.0

/// 导航栏高度44
let uiNavigationBarHeight:CGFloat = 44.0

/// 顶部高度=64
let uiTopBarHeight:CGFloat = 64.0

/// 底部tabbar高度
let uiTabBarHeight:CGFloat = 49.0

/// 键盘高度
let uiKeyboardHeight:CGFloat = 20.0


/// 距离顶部的point
let uiTopPoint = CGPoint.init(x: 0, y: uiTopBarHeight)

/// 全局keywindow
let jsKeywindow  = UIApplication.shared.windows.first

/// 当前顶部视图控制器
let jsTopViewController = jsAppDelegate.tabBarController?.topViewController()


/// 当前顶部导航栏控制器
let jsTopNavigationViewController = jsAppDelegate.tabBarController?.currentNavigationViewController()


/// 当前顶部视图
let jsTopView = jsTopViewController?.view
