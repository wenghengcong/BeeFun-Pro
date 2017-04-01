//
//  UIStoryboard+Extension.swift
//  Coderpursue
//
//  Created by WengHengcong on 2017/3/19.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    
    class func reloadInstantiateInitialViewController(storyboard:String) -> UIViewController?{
        let storyboardName = "Main"
        let storyboard = UIStoryboard.init(name: storyboardName, bundle: nil)
        return  storyboard.instantiateInitialViewController()
    }
    
    class func reloadView(storyboard:String, view:String) -> UIViewController{
        let storyboard = UIStoryboard.init(name:storyboard, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier:view)
    }
    
    class func reloadViewInMainStoryboard(view:String) -> UIViewController{
        let storyboard = UIStoryboard.init(name:"Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier:view)
    }
    
    class func storybard(name:String) -> UIStoryboard{
        return UIStoryboard.init(name: name, bundle: nil)
    }
    
}
