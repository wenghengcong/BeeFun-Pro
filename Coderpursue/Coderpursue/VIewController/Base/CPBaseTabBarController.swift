//
//  CPBaseTabBarController.swift
//  Coderpursue
//
//  Created by wenghengcong on 15/12/30.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

import UIKit

class CPBaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customView()
    }
    
    func customView() {
        self.tabBar.barTintColor = UIColor.tabBarBackgroundColor  //背景色
        self.tabBar.tintColor = UIColor.tabBarTitleTextColor//文字颜色
    }

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

}
