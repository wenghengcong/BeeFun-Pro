//
//  CPStyleGuide.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/6.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import Foundation
import UIKit

class CPStyleGuide {
    
    class func textFieldPlaceholderAttributes() -> [String:AnyObject] {
        
        let font = UIFont.middleSizeSystemFont()
        let color = UIColor.textFieldPlaceholderTextColor()
        
        return [
            NSFontAttributeName:font,
            NSForegroundColorAttributeName:color
        ]
    }
    
    class func textFieldTextAttributes() -> [String:AnyObject] {
        
        let font = UIFont.largeSizeSystemFont()
        let color = UIColor.textViewTextColor()
        
        return [
            NSFontAttributeName:font,
            NSForegroundColorAttributeName:color
        ]
    }
    
    class func navTitleTextAttributes() -> [String:AnyObject] {
        
        let font = UIFont.hugeSizeSystemFont()
        let color = UIColor.navigationBarTitleTextColor()
        return [
            NSFontAttributeName:font,
            NSForegroundColorAttributeName:color
        ]
    }
    
    
}