//
//  CPBaseTabBarController.swift
//  BeeFun
//
//  Created by wenghengcong on 15/12/30.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

import UIKit

class CPBaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        customView()
    }
    
    func customView() {
        self.tabBar.barTintColor = UIColor.tabBarBackgroundColor  //背景色
        self.tabBar.tintColor = UIColor.tabBarTitleTextColor//文字颜色
    }
    
    func getRootController(by index:Int) -> UIViewController? {
        if (self.viewControllers?.isBeyond(index: index))! {
            return nil
        }
        let viewC = self.viewControllers?[index]
        return viewC
    }
    
    func reloadAllChildController() {
        for item in self.tabBar.items! {
            let newTitle = item.title?.localized
            item.title = newTitle
        }
    }
    
    /// 返回当前顶部视图控制器
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
    
    
    /// 返回当前导航栏控制器
    ///
    /// - Returns: <#return value description#>
    func currentNavigationViewController() -> UINavigationController?{
        let nav = topViewController()?.navigationController
        return nav
    }
    
    /// 返回当前顶部视图控制器
    ///
    /// - Returns: <#return value description#>
    func currentViewController() -> UIViewController? {
        return topViewController()
    }

}
