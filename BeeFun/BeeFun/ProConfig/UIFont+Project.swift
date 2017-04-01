//
//  UIFont+Project.swift
//  BeeFun
//
//  Created by wenghengcong on 16/1/3.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit

extension UIFont {
    
    enum CPEFontSize : CGFloat{
        case tinyFontSize = 10
        case smallFontSize = 12
        case middleFontSize = 14
        case largeFontSize = 15
        case hugeFontSize = 17
    }
    //MARK: system font
    
    class func tinySizeSystemFont() -> UIFont {
        return UIFont.systemFont(ofSize: CPEFontSize.tinyFontSize.rawValue)
    }
    
    class func smallSizeSystemFont() -> UIFont {
        return UIFont.systemFont(ofSize: CPEFontSize.smallFontSize.rawValue)
    }
    
    class func middleSizeSystemFont() -> UIFont {
        return UIFont.systemFont(ofSize: CPEFontSize.middleFontSize.rawValue)
    }
    
    class func largeSizeSystemFont() -> UIFont {
        return UIFont.systemFont(ofSize: CPEFontSize.largeFontSize.rawValue)
    }
    
    class func hugeSizeSystemFont() -> UIFont {
        return UIFont.systemFont(ofSize: CPEFontSize.hugeFontSize.rawValue)
    }
    
    //MARK: system bold font
    
    class func tinySizeBoldSystemFont() -> UIFont {
        return UIFont.boldSystemFont(ofSize: CPEFontSize.smallFontSize.rawValue)
    }
    
    class func smallSizeBoldSystemFont() -> UIFont {
        return UIFont.boldSystemFont(ofSize: CPEFontSize.smallFontSize.rawValue)
    }
    
    class func middleSizeBoldSystemFont() -> UIFont {
        return UIFont.boldSystemFont(ofSize: CPEFontSize.smallFontSize.rawValue)
    }
    
    class func largeSizeBoldSystemFont() -> UIFont {
        return UIFont.boldSystemFont(ofSize: CPEFontSize.smallFontSize.rawValue)
    }
    
    class func hugeSizeBoldSystemFont() -> UIFont {
        return UIFont.boldSystemFont(ofSize: CPEFontSize.smallFontSize.rawValue)
    }
}
