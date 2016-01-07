//
//  File.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/7.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit

protocol NavigationControllerBackButtonDelegate {
    func navigationShouldPopOnBackButton() -> Bool
}

extension UINavigationController {
    
    func navigationBar(navigationBar: UINavigationBar, shouldPopItem item: UINavigationItem) -> Bool {
        
        // Prevents from a synchronization issue of popping too many navigation items
        // and not enough view controllers or viceversa from unusual tapping
        if self.viewControllers.count < navigationBar.items?.count {
            return true
        }
        
        // Check if we have a view controller that wants to respond to being popped
        var shouldPop = true
        if let viewController = self.topViewController as? NavigationControllerBackButtonDelegate {
            shouldPop = viewController.navigationShouldPopOnBackButton()
        }
        
        if (shouldPop) {
            dispatch_async(dispatch_get_main_queue()) {
                self.popViewControllerAnimated(true)
            }
        }
        else {
            // Prevent the back button from staying in an disabled state
            for view in navigationBar.subviews {
                if view.alpha < 1.0 {
                    [UIView.animateWithDuration(0.25, animations: { () -> Void in
                        view.alpha = 1.0
                    })]
                }
            }
            
        }
        
        return false
    }
}


