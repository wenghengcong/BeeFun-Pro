//
//  JSDevice.swift
//  LoveYou
//
//  Created by WengHengcong on 2016/11/10.
//  Copyright © 2016年 JungleSong. All rights reserved.
//


import UIKit


// MARK: - screen info
struct ScreenSize {
    static let bounds           = UIScreen.bound
    static let width            = UIScreen.width
    static let height           = UIScreen.height
    static let scale            = UIScreen.scale()
    static let maxLength        = max(ScreenSize.width, ScreenSize.height)
    static let minLength        = min(ScreenSize.width, ScreenSize.height)
    
    static let screen3_5Inch    = UIScreen.isEqual(UIScreen.Size.screen3_5Inch)
    static let screen4_0Inch    = UIScreen.isEqual(UIScreen.Size.screen4_0Inch)
    static let screen4_7Inch    = UIScreen.isEqual(UIScreen.Size.screen4_7Inch)
    static let screen5_5Inch    = UIScreen.isEqual(UIScreen.Size.screen5_5Inch)
    static let screen7_9Inch    = UIScreen.isEqual(UIScreen.Size.screen7_9Inch)
    static let screen9_7Inch    = UIScreen.isEqual(UIScreen.Size.screen9_7Inch)
    static let screen12_9Inch   = UIScreen.isEqual(UIScreen.Size.screen12_9Inch)

    
}

// MARK: - device type
struct DeviceType {
    
    static let isPad                            = UIDevice.isPad()
    static let isIPhone4                        = UIDevice.iPhone4Series.contains(UIDevice.modelReadable())
    static let isIPhone5                        = UIDevice.iPhone5Series.contains(UIDevice.modelReadable())
    static let isIPhone6                        = UIDevice.iPhone6Series.contains(UIDevice.modelReadable())
    static let isIPhone6Plus                    = UIDevice.iPhone6PlusSeries.contains(UIDevice.modelReadable())
    static let isIPhone7                        = UIDevice.iPhone7Series.contains(UIDevice.modelReadable())
    static let isIPhone7Plus                    = UIDevice.iPhone7PlusSeries.contains(UIDevice.modelReadable())
    
    static let isPortrait                       = UIDevice.isPortrait()
    static let isLandscape                      = UIDevice.isLandscape()
    
}

// MARK: - sysetem version
struct iOSVersion {
    
    static let iOS7Earlier  = UIDevice.iOS.equalOrEarlier(UIDevice.iOS.Version.seven)
    static let iOS7         = UIDevice.iOS.equal(UIDevice.iOS.Version.seven)
    static let iOS7Later    = UIDevice.iOS.equalOrLater(UIDevice.iOS.Version.seven)
    
    static let iOS8Earlier  = UIDevice.iOS.equalOrEarlier(UIDevice.iOS.Version.eight)
    static let iOS8         = UIDevice.iOS.equal(UIDevice.iOS.Version.eight)
    static let iOS8Later    = UIDevice.iOS.equalOrLater(UIDevice.iOS.Version.eight)
    
    static let iOS9Earlier  = UIDevice.iOS.equalOrEarlier(UIDevice.iOS.Version.nine)
    static let iOS9         = UIDevice.iOS.equal(UIDevice.iOS.Version.nine)
    static let iOS9Later    = UIDevice.iOS.equalOrLater(UIDevice.iOS.Version.nine)
    
    static let iOS10Earlier  = UIDevice.iOS.equalOrEarlier(UIDevice.iOS.Version.ten)
    static let iOS10         = UIDevice.iOS.equal(UIDevice.iOS.Version.ten)
    static let iOS10Later    = UIDevice.iOS.equalOrLater(UIDevice.iOS.Version.ten)
    
}





