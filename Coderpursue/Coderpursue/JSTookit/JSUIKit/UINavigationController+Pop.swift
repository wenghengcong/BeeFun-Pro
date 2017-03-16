//
//  UINavigationController+Pop.swift
//  LoveYou
//
//  Created by WengHengcong on 2017/3/8.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}


protocol NavigationControllerBackButtonDelegate {
    func navigationShouldPopOnBackButton() -> Bool
}

extension UINavigationController {
    
    func navigationBar(_ navigationBar: UINavigationBar, shouldPopItem item: UINavigationItem) -> Bool {
        
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
            DispatchQueue.main.async {
                self.popViewController(animated: true)
            }
        }
        else {
            // Prevent the back button from staying in an disabled state
            for view in navigationBar.subviews {
                if view.alpha < 1.0 {
                    [UIView.animate(withDuration: 0.25, animations: { () -> Void in
                        view.alpha = 1.0
                    })]
                }
            }
            
        }
        
        return false
    }
}
