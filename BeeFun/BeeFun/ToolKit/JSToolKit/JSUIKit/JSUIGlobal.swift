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
/************************************常用UI高度**********************************/
/// 状态栏高度20
let uiStatusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height

/// 导航栏高度44
let uiNavigationBarHeight: CGFloat = 44.0

/// 顶部高度=64
let uiTopBarHeight: CGFloat =  uiStatusBarHeight + uiNavigationBarHeight

/// 底部tabbar高度
//let uiTabBarHeight: CGFloat = 49.0        //作废，采用下面iPhone X/iOS 11中的新值

/// 键盘高度
let uiKeyboardHeight: CGFloat = 20.0

/// 距离顶部的point
let uiTopPoint = CGPoint(x: 0, y: uiTopBarHeight)

/// 除去导航栏和tab栏可见的屏幕高度
let uiScreenHightWithoutTopAndTab = ScreenSize.height - uiTopBarHeight - uiTabBarHeight

/// Label Cell左边距 15
let uiCellLabelLeftMargin: CGFloat = 15.0

/// Label Cell右边距 15
let uiCellLabelRightMargin: CGFloat = 15.0

/// Image Cell左边距 60
let uiCellImageLeftMargin: CGFloat = 60.0

/************************************iPhone X/iOS 11**********************************/
/// 底部home indicator 高度34
let uiSafeAreaBottom: CGFloat = ScreenSize.screen5_8Inch ? 34.0 : 0

/// 纯粹的底部tabbar的高度
let uiPureTabBarHeight: CGFloat = 49.0

/// 底部tabbar高度
let uiTabBarHeight: CGFloat = uiPureTabBarHeight + uiSafeAreaBottom
