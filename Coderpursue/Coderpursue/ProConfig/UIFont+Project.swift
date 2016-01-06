//
//  UIFont+Project.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/3.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit

extension UIFont {
    
    enum CPEFontSize : CGFloat{
        case TinyFontSize = 10
        case SmallFontSize = 12
        case MiddleFontSize = 14
        case LargeFontSize = 15
        case HugeFontSize = 17
    }
    //MARK: system font
    
    class func tinySizeSystemFont() -> UIFont {
        return UIFont.systemFontOfSize(CPEFontSize.TinyFontSize.rawValue)
    }
    
    class func smallSizeSystemFont() -> UIFont {
        return UIFont.systemFontOfSize(CPEFontSize.SmallFontSize.rawValue)
    }
    
    class func middleSizeSystemFont() -> UIFont {
        return UIFont.systemFontOfSize(CPEFontSize.MiddleFontSize.rawValue)
    }
    
    class func largeSizeSystemFont() -> UIFont {
        return UIFont.systemFontOfSize(CPEFontSize.LargeFontSize.rawValue)
    }
    
    class func hugeSizeSystemFont() -> UIFont {
        return UIFont.systemFontOfSize(CPEFontSize.HugeFontSize.rawValue)
    }
    
    //MARK: system bold font
    
    class func tinySizeBoldSystemFont() -> UIFont {
        return UIFont.boldSystemFontOfSize(CPEFontSize.SmallFontSize.rawValue)
    }
    
    class func smallSizeBoldSystemFont() -> UIFont {
        return UIFont.boldSystemFontOfSize(CPEFontSize.SmallFontSize.rawValue)
    }
    
    class func middleSizeBoldSystemFont() -> UIFont {
        return UIFont.boldSystemFontOfSize(CPEFontSize.SmallFontSize.rawValue)
    }
    
    class func largeSizeBoldSystemFont() -> UIFont {
        return UIFont.boldSystemFontOfSize(CPEFontSize.SmallFontSize.rawValue)
    }
    
    class func hugeSizeBoldSystemFont() -> UIFont {
        return UIFont.boldSystemFontOfSize(CPEFontSize.SmallFontSize.rawValue)
    }
}