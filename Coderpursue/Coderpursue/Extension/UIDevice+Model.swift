//
//  UIDevice+Model.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/17.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import Foundation
import UIKit


 
// MARK: screen info
struct ScreenSize {
    static let ScreenWidth          = UIScreen.main.bounds.size.width
    static let ScreenHeith          = UIScreen.main.bounds.size.height
    static let ScreenScale          = UIScreen.main.scale
    static let ScreenMaxLength      = max(ScreenSize.ScreenWidth, ScreenSize.ScreenHeith)
    static let ScreenMinLength      = min(ScreenSize.ScreenWidth, ScreenSize.ScreenHeith)
}

// MARK: device type
struct DeviceType {
    
    static let isIPad                           = UIDevice.current.userInterfaceIdiom == .pad
    static let isIPhone4                        = UIScreen.main.bounds.size.height < 568
    static let isIPhone5                        = UIScreen.main.bounds.size.height == 568
    static let isIPhone6                        = UIScreen.main.bounds.size.height == 667
    static let isIPhone6Plus                    = UIScreen.main.bounds.size.height == 736
    static let isDevicePortrait                 = UIDevice.current.orientation.isPortrait
    static let isDeviceLandscape                = UIDevice.current.orientation.isLandscape

}

// MARK:  sysetem version
struct iOSVersion {
    
    static let IOS7Beolow   = UIDevice.SYSTEM_VERSION_LESS_THAN("7.0")
    static let IOS7_8         = UIDevice.SYSTEM_VERSION_LESS_THAN("8.0") && UIDevice.SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO("7.0")
    static let IOS8_9         = UIDevice.SYSTEM_VERSION_LESS_THAN("9.0") && UIDevice.SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO("8.0")
    static let IOS9_10         = UIDevice.SYSTEM_VERSION_LESS_THAN("10.0") && UIDevice.SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO("9.0")
    
    static let IOS7Above         = UIDevice.SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO("7.0")
    static let IOS8Above         = UIDevice.SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO("8.0")
    static let IOS9Above         = UIDevice.SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO("9.0")

}

/** Model Extends UIDevice */
extension UIDevice {
    
    //systeme version compare methods
    
    class func SYSTEM_VERSION_EQUAL_TO(_ version: NSString) -> Bool {
        return self.current.systemVersion.compare(version as String,
            options: NSString.CompareOptions.numeric) == ComparisonResult.orderedSame
    }
    
    class func SYSTEM_VERSION_GREATER_THAN(_ version: NSString) -> Bool {
        return self.current.systemVersion.compare(version as String,
            options: NSString.CompareOptions.numeric) == ComparisonResult.orderedDescending
    }
    
    class func SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(_ version: NSString) -> Bool {
        return self.current.systemVersion.compare(version as String,
            options: NSString.CompareOptions.numeric) != ComparisonResult.orderedAscending
    }
    
    class func SYSTEM_VERSION_LESS_THAN(_ version: NSString) -> Bool {
        return UIDevice.current.systemVersion.compare(version as String,
            options: NSString.CompareOptions.numeric) == ComparisonResult.orderedAscending
    }
    
    class func SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(_ version: NSString) -> Bool {
        return self.current.systemVersion.compare(version as String,
            options: NSString.CompareOptions.numeric) != ComparisonResult.orderedDescending
    }
    
}
