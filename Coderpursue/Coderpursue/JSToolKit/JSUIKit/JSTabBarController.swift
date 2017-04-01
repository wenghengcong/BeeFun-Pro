//
//  JSTabBarController.swift
//  LoveYou
//
//  Created by WengHengcong on 2016/10/30.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit

class JSTabBarController: UITabBarController {

    var titles:[String]?
    var images:[String]?
    var selectedImages:[String]?
    var controllers:[String]?
    
    // MARK: 初始化方法
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(viewControllers controllers:[String] ,titles:[String] , images:[String] , selectedImages:[String]) {
        
        self.init()
        self.controllers = controllers
        self.titles = titles
        self.images = images
        self.selectedImages = selectedImages
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        
        super.viewDidLoad()
        addChildrenViewController()
        customTabBarApperance()
    }
    
    private func addChildrenViewController() -> Void {
        
        //获取命名空间
        let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"]
        guard let ns = nameSpace as? String else{
            return
        }
        
        guard titles != nil else {
//            JSLog.error("error:titles must't empty")
            return
        }
        
        guard selectedImages != nil else {
//            JSLog.error("error:select images must't empty")
            return
        }
        
        guard images != nil else {
//            JSLog.error("error:default images must't empty")
            return
        }
        
        guard controllers != nil else {
//            JSLog.error("error:controllers must't empty")
            return
        }
        
        for (index,className) in controllers!.enumerated() {
            // 将类名转化为类
            let cls: AnyClass? = NSClassFromString(ns + "." + className)
            
            //Swift中如果想通过一个Class来创建一个对象, 必须告诉系统这个Class的确切类型
            guard let vcCls = cls as? UIViewController.Type else
            {
                JSLog.error("error:cls不能当做UIViewController")
                return
            }
            
            let vc = vcCls.init()
            vc.title = titles![index]
            vc.tabBarItem.image = UIImage.init(named: images![index]);
            vc.tabBarItem.selectedImage = UIImage.init(named: selectedImages![index])
            let nav = JSNavigationController(rootViewController:vc)
            self.addChildViewController(nav)
        }
        
    }
    
    func customTabBarApperance() {
        //self.tabBar.barTintColor = UIColor.white  //背景色
        //self.tabBar.tintColor = UIColor.blue      //文字颜色
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
