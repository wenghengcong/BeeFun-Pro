//
//  InstanceManager.swift
//  Coderpursue
//
//  Created by WengHengcong on 2017/3/12.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

/// 应用的代理
let cpAppDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate

let cpKeywindow = cpAppDelegate.window


/// 当前顶部视图控制器
let cpTopViewController = cpAppDelegate.tabBarController?.topViewController()


/// 当前顶部导航栏控制器
let cpTopNavigationViewController = cpAppDelegate.tabBarController?.currentNavigationViewController()


/// 当前顶部视图
let cpTopView = cpTopViewController?.view
