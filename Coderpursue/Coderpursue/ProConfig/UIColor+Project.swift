//
//  UIColor+Project.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/3.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {

    //MARK: navigation bar
    class var navigationBarTitleTextColor:UIColor {
        //white
        return UIColor.hex("ffffff", alpha: 1.0)
    }
    
    class var navigationBarBackgroundColor:UIColor {
        //red
        return UIColor.hex("e31100", alpha: 1.0)
    }
    
    //MARK: tab bar
    class var tabBarTitleTextColor:UIColor {
        //red
        return UIColor.hex("e31100", alpha: 1.0)
    }
    
    class var tabBarBackgroundColor:UIColor {
        //light gray
        return UIColor.white
    }
    
    //MARK: label
    class var labelSubtitleTextColor:UIColor {
        //black
        return UIColor.hex("9b9b9b", alpha: 1.0)
    }
    
    class var labelTitleTextColor:UIColor {
        //gray
        return UIColor.hex("000000", alpha: 1.0)
    }
    
    //MARK: text field
    class var textFieldTextColor:UIColor {
        //black
        return UIColor.hex("000000", alpha: 1.0)
    }
    
    class var textFieldPlaceholderTextColor:UIColor {
        //light gray
        return UIColor.hex("c7c6cd", alpha: 1.0)
    }
    
    //MARK: text view
    class var textViewTextColor:UIColor {
        return UIColor.hex("000000", alpha: 1.0)
    }
    
    class var textViewPlaceholderTextColor:UIColor {
        return UIColor.hex("c7c6cd", alpha: 1.0)
    }
    
    //MARK: button
    class var buttonWihteTitleTextColor:UIColor {
        return UIColor.hex("ffffff", alpha: 1.0)
    }
    
    class var buttonBlackTitleTextColor:UIColor {
        return UIColor.hex("000000", alpha: 1.0)
    }
    
    class var buttonRedTitleTextColor:UIColor {
        return UIColor.hex("e31100", alpha: 1.0)
    }
    
    class var buttonRedBackgroundColor:UIColor {
        return UIColor.hex("e31100", alpha: 1.0)
    }
    
    //below 3 color group
    class var buttonWhiteBackgroundColor:UIColor {
        return UIColor.hex("ffffff", alpha: 1.0)
    }
    
    class var buttonHighlightBackgroundColor:UIColor {
        return UIColor.hex("e31100", alpha: 1.0)
    }
    
    class var buttonSelectedBackgroundColor:UIColor {
        return UIColor.hex("e31100", alpha: 1.0)
    }
    
    //MARK: view
    class var viewBackgroundColor:UIColor {
        return UIColor.hex("f8f8f8", alpha: 1.0)
    }
    
    //badege
    class var badgeBackgroundColor:UIColor {
        return UIColor.hex("e31100", alpha: 1.0);
    }
    
    //line
    class var lineBackgroundColor:UIColor {
        return UIColor.hex("d9d9d9", alpha: 1.0);
    }
    
    
    //MARK: color name
    class var cpBlackColor:UIColor {
        //black
        return UIColor.hex("000000", alpha: 1.0)
    }
    
    class var cpRedColor:UIColor {
        //red
        return UIColor.hex("e31100", alpha: 1.0)
    }
    
    class var cpBlueColor:UIColor {
        //red
        return UIColor.hex("5677fc", alpha: 1.0)
    }

    
}

private extension CGFloat {
    /// SwiftRandom extension
    static func random(_ lower: CGFloat = 0, _ upper: CGFloat = 1) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (upper - lower) + lower
    }
}
