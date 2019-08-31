//
//  BFBaseTabBarController.swift
//  BeeFun
//
//  Created by wenghengcong on 15/12/30.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

import UIKit

class BFBaseTabBarController: JSTabBarController {

    // MARK: 初始化方法
    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        titles = ["Explore".localized, "Message".localized, "Stars".localized, "Profile".localized]
        images = ["tab_hot", "tab_mes", "tab_star", "tab_me"]
        selectedImages = ["tab_hot_sel", "tab_mes_sel", "tab_star_sel", "tab_me_sel"]
        controllers = ["BFTrendingController", "BFMessageController", "BFStarController", "BFProfileController"]
        super.addAllChildrenViewController()
        setTabBarApperance()
    }

    override func setTabBarApperance() {
        super.setTabBarApperance()
        JSApperence.setTabbarTextColor( .black, for: .normal)
        JSApperence.setTabbarTextColor( .red, for: .selected)
        self.tabBar.barTintColor = UIColor.iOS11White  //背景色
        self.tabBar.tintColor = UIColor.bfTabBarTitleTextColor//文字颜色
    }

    func getRootController(by index: Int) -> UIViewController? {
        if (self.viewControllers?.isBeyond(index: index))! {
            return nil
        }
        let viewC = self.viewControllers?[index]
        return viewC
    }

    func reload() {
        BFTabbarManager.jsAppDelegate.window?.rootViewController = BFBaseTabBarController()
    }

    //http://stackoverflow.com/questions/26667009/get-top-most-uiviewcontroller
    
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
    func currentNavigationViewController() -> UINavigationController? {
//        let topView = topViewController()
//        if let tabCont = controllers?.containsType(of: topView) {
//            return self.navigationController
//        }
        
        let nav = topViewController()?.navigationController
        return nav
    }
    
    /// 返回当前顶部视图控制器
    ///
    /// - Returns: <#return value description#>
    func currentViewController() -> UIViewController? {
        return topViewController()
    }
    
    func gotoTab(index: Int) {
        self.selectedIndex = index
    }
}
