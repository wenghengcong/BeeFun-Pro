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
    
    /**
     return UIColor by hex str
     
     - parameter hexStr: hex num
     - parameter alpha:  alpha num
     
     - returns: UIColor
     */
    class func hexStr(var hexStr : NSString,alpha : CGFloat) -> UIColor {
        
        hexStr = hexStr.stringByReplacingOccurrencesOfString("#", withString: "");
        let scanner = NSScanner(string: hexStr as String);
        var color : UInt32 = 0
        if scanner.scanHexInt(&color) {
            let r = CGFloat( (color & 0xFF0000) >> 16 ) / 255.0
            let g = CGFloat( (color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat( (color & 0x0000FF) ) / 255.0
            return UIColor(red: r, green: g, blue: b, alpha: alpha)
        }else{
            print("invalid hex string",terminator:"")
            return UIColor.whiteColor()
        }
    }
    //MARK: navigation bar
    class func navigationBarTitleTextColor() -> UIColor {
        //white
        return UIColor.hexStr("ffffff", alpha: 1.0)
    }
    
    class func navigationBarBackgroundColor() -> UIColor {
        //red
        return UIColor.hexStr("e31100", alpha: 1.0)
    }
    
    //MARK: tab bar
    class func tabBarTitleTextColor() -> UIColor {
        //red
        return UIColor.hexStr("e31100", alpha: 1.0)
    }
    
    class func tabBarBackgroundColor() -> UIColor {
        //light gray
        return UIColor.whiteColor()
    }
    
    //MARK: label
    class func labelSubtitleTextColor() -> UIColor {
        //black
        return UIColor.hexStr("9b9b9b", alpha: 1.0)
    }
    
    class func labelTitleTextColor() -> UIColor {
        //gray
        return UIColor.hexStr("000000", alpha: 1.0)
    }
    
    //MARK: text field
    class func textFieldTextColor() -> UIColor {
        //black
        return UIColor.hexStr("000000", alpha: 1.0)
    }
    
    class func textFieldPlaceholderTextColor() -> UIColor {
        //light gray
        return UIColor.hexStr("c7c6cd", alpha: 1.0)
    }
    
    //MARK: text view
    class func textViewTextColor() -> UIColor {
        return UIColor.hexStr("000000", alpha: 1.0)
    }
    
    class func textViewPlaceholderTextColor() -> UIColor {
        return UIColor.hexStr("c7c6cd", alpha: 1.0)
    }
    
    //MARK: button
    class func buttonWihteTitleTextColor() -> UIColor {
        return UIColor.hexStr("ffffff", alpha: 1.0)
    }
    
    class func buttonBlackTitleTextColor() -> UIColor {
        return UIColor.hexStr("000000", alpha: 1.0)
    }
    
    class func buttonRedTitleTextColor() -> UIColor {
        return UIColor.hexStr("e31100", alpha: 1.0)
    }
    
    class func buttonRedBackgroundColor() -> UIColor {
        return UIColor.hexStr("e31100", alpha: 1.0)
    }
    
    //below 3 color group
    class func buttonWhiteBackgroundColor() -> UIColor {
        return UIColor.hexStr("ffffff", alpha: 1.0)
    }
    
    class func buttonHighlightBackgroundColor() -> UIColor {
        return UIColor.hexStr("e31100", alpha: 1.0)
    }
    
    class func buttonSelectedBackgroundColor() -> UIColor {
        return UIColor.hexStr("e31100", alpha: 1.0)
    }
    
    //MARK: view
    class func viewBackgroundColor() -> UIColor {
        return UIColor.hexStr("f8f8f8", alpha: 1.0)
    }
    
    //badege
    class func badgeBackgroundColor() -> UIColor {
        return UIColor.hexStr("e31100", alpha: 1.0);
    }
    
    //line
    class func lineBackgroundColor() -> UIColor {
        return UIColor.hexStr("d9d9d9", alpha: 1.0);
    }
    
    
    //MARK: color name
    class func cpBlackColor() -> UIColor {
        //black
        return UIColor.hexStr("000000", alpha: 1.0)
    }
    
    class func cpRedColor() -> UIColor {
        //red
        return UIColor.hexStr("e31100", alpha: 1.0)
    }
    
    class func cpBlueColor() -> UIColor {
        //red
        return UIColor.hexStr("5677fc", alpha: 1.0)
    }
}