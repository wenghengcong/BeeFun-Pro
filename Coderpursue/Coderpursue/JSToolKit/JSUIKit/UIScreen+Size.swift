//
//  JSScreen.swift
//  LoveYou
//
//  Created by WengHengcong on 2016/11/11.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit

//设计稿全部以iPhone 6尺寸设计

func designBy4_7Inch(_ x:CGFloat) -> CGFloat {
    let scale = ( (UIScreen.width) / CGFloat(375.0) )
    let result = scale * x
    return result
}

func designBy3_5Inch(_ x:CGFloat) -> CGFloat {
    let scale = ( (UIScreen.width) / CGFloat(320.0) )
    let result = scale * x
    return result
}

func designBy5_5Inch(_ x:CGFloat) -> CGFloat {
    let scale = ( (UIScreen.width) / CGFloat(414.0) )
    let result = scale * x
    return result
}

extension UIScreen {
    
    public enum Size: Int {
        case unknownSize = 0
        case screen3_5Inch
        case screen4_0Inch
        case screen4_7Inch
        case screen5_5Inch
        case screen7_9Inch
        case screen9_7Inch
        case screen12_9Inch
    }
    
    static public func sizeByInch() -> Size {
        
        let w: Double = Double(UIScreen.main.bounds.width)
        let h: Double = Double(UIScreen.main.bounds.height)
        let screenHeight: Double = max(w, h)
        
        switch screenHeight {
        case 480:
            return Size.screen3_5Inch
        case 568:
            return Size.screen4_0Inch
        case 667:
            return UIScreen.main.scale == 3.0 ? Size.screen5_5Inch : Size.screen4_7Inch
        case 736:
            return Size.screen5_5Inch
        case 1024:
            switch UIDevice.modelReadable() {
            case .iPadMini,.iPadMini2,.iPadMini3,.iPadMini4:
                return Size.screen7_9Inch
            default:
                return Size.screen9_7Inch
            }
        case 1366:
            return Size.screen12_9Inch
        default:
            return Size.unknownSize
        }
    }
    
    // MARK: properties
    /// 屏幕scale（避免与scale冲突）
    static let screenScale = UIScreen.scale()
    
    /// 是否是retina屏幕
    static let isRetina = UIScreen.scale() > 1.0
    
    /// 屏幕bound(去掉s，避免与bounds冲突)
    static let bound  = UIScreen.bounds()
    
    /// 屏幕Size
    static let size  = UIScreen.bound.size
    
    /// 屏幕width
    static let width  = UIScreen.size.width
    
    /// 屏幕height
    static let height  = UIScreen.size.height
    
    
    /// 返回屏幕bounds
    ///
    /// - Returns: <#return value description#>
    public static func bounds() -> CGRect {
        return UIScreen.main.bounds
    }
    
    /// 返回屏幕scale
    ///
    /// - Returns: <#return value description#>
    public static func scale() -> CGFloat {
        return UIScreen.main.scale
    }
    
    // MAEK: size compare
    static public func isEqual(_ size: Size) -> Bool {
        return size == UIScreen.sizeByInch() ? true : false;
    }
    
    static public func isLargerThan(_ size: Size) -> Bool {
        return size.rawValue < UIScreen.sizeByInch().rawValue ? true : false;
    }
    
    static public func isSmallerThan(_ size: Size) -> Bool {
        return size.rawValue > UIScreen.sizeByInch().rawValue ? true : false;
    }
    
}
