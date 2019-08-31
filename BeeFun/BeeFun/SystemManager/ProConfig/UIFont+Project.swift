//
//  UIFont+Project.swift
//  BeeFun
//
//  Created by wenghengcong on 16/1/3.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit

extension UIFont {

    //PingFang Light、Medium、Regular、Thin、Ultralight、Semibold
    enum CPEFontSize: CGFloat {
        case tinyFontSize = 10
        case smallFontSize = 12
        case middleFontSize = 14
        case largeFontSize = 15
        case hugeFontSize = 17
    }
    
    class func bfSystemFont(ofSize: CGFloat) -> UIFont {
        if iOSVersion.iOS9Later {
            return UIFont(name: "PingFang-SC-Regular", size: ofSize)!
        }
        return UIFont.systemFont(ofSize: ofSize)
    }
    
    class func bfBoldSystemFont(ofSize: CGFloat) -> UIFont {
        if iOSVersion.iOS9Later {
            return UIFont(name: "PingFang-SC-Medium", size: ofSize)!
        }
        return UIFont.systemFont(ofSize: ofSize)
    }
    
    // MARK: system font

    class func tinySizeSystemFont() -> UIFont {
        if iOSVersion.iOS9Later {
            return UIFont(name: "PingFang-SC-Regular", size: CPEFontSize.tinyFontSize.rawValue)!
        }
        return UIFont.systemFont(ofSize: CPEFontSize.tinyFontSize.rawValue)
    }

    class func smallSizeSystemFont() -> UIFont {
        if iOSVersion.iOS9Later {
            return UIFont(name: "PingFang-SC-Regular", size: CPEFontSize.smallFontSize.rawValue)!
        }
        return UIFont.systemFont(ofSize: CPEFontSize.smallFontSize.rawValue)
    }

    class func middleSizeSystemFont() -> UIFont {
        if iOSVersion.iOS9Later {
            return UIFont(name: "PingFang-SC-Regular", size: CPEFontSize.middleFontSize.rawValue)!
        }
        return UIFont.systemFont(ofSize: CPEFontSize.middleFontSize.rawValue)
    }

    class func largeSizeSystemFont() -> UIFont {
        if iOSVersion.iOS9Later {
            return UIFont(name: "PingFang-SC-Regular", size: CPEFontSize.largeFontSize.rawValue)!
        }
        return UIFont.systemFont(ofSize: CPEFontSize.largeFontSize.rawValue)
    }

    class func hugeSizeSystemFont() -> UIFont {
        if iOSVersion.iOS9Later {
            return UIFont(name: "PingFang-SC-Regular", size: CPEFontSize.hugeFontSize.rawValue)!
        }
        return UIFont.systemFont(ofSize: CPEFontSize.hugeFontSize.rawValue)
    }

    // MARK: system bold font

    class func tinySizeBoldSystemFont() -> UIFont {
        if iOSVersion.iOS9Later {
            return UIFont(name: "PingFang-SC-Medium", size: CPEFontSize.tinyFontSize.rawValue)!
        }
        return UIFont.boldSystemFont(ofSize: CPEFontSize.tinyFontSize.rawValue)
    }

    class func smallSizeBoldSystemFont() -> UIFont {
        if iOSVersion.iOS9Later {
            return UIFont(name: "PingFang-SC-Medium", size: CPEFontSize.smallFontSize.rawValue)!
        }
        return UIFont.boldSystemFont(ofSize: CPEFontSize.smallFontSize.rawValue)
    }

    class func middleSizeBoldSystemFont() -> UIFont {
        if iOSVersion.iOS9Later {
            return UIFont(name: "PingFang-SC-Medium", size: CPEFontSize.middleFontSize.rawValue)!
        }
        return UIFont.boldSystemFont(ofSize: CPEFontSize.middleFontSize.rawValue)
    }

    class func largeSizeBoldSystemFont() -> UIFont {
        if iOSVersion.iOS9Later {
            return UIFont(name: "PingFang-SC-Medium", size: CPEFontSize.largeFontSize.rawValue)!
        }
        return UIFont.boldSystemFont(ofSize: CPEFontSize.largeFontSize.rawValue)
    }

    class func hugeSizeBoldSystemFont() -> UIFont {
        if iOSVersion.iOS9Later {
            return UIFont(name: "PingFang-SC-Medium", size: CPEFontSize.hugeFontSize.rawValue)!
        }
        return UIFont.boldSystemFont(ofSize: CPEFontSize.hugeFontSize.rawValue)
    }
}
