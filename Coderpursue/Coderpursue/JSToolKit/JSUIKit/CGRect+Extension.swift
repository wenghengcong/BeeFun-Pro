
//
//  CGRect+Extension.swift
//  Coderpursue
//
//  Created by WengHengcong on 2017/3/29.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

extension CGRect {

    /// CGRect init
    ///
    /// - Parameters:
    ///   - x: x
    ///   - y: y
    ///   - w: w
    ///   - h: h
    public init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
        self.init(x: x, y: y, width: w, height: h)
    }
    
    /// rect.x
    public var x: CGFloat {
        get {
            return self.origin.x
        } set(value) {
            self.origin.x = value
        }
    }
    

    /// rect.y
    public var y: CGFloat {
        get {
            return self.origin.y
        } set(value) {
            self.origin.y = value
        }
    }
    
    /// rect.width
    public var w: CGFloat {
        get {
            return self.size.width
        } set(value) {
            self.size.width = value
        }
    }
    
    /// rect.height
    public var h: CGFloat {
        get {
            return self.size.height
        } set(value) {
            self.size.height = value
        }
    }
    
    /// rect.area
    public var area: CGFloat {
        return self.h * self.w
    }
}
