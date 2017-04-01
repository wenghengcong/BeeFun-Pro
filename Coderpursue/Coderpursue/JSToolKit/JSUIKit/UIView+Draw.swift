//
//  UIView+Draw.swift
//  LoveYou
//
//  Created by WengHengcong on 2017/3/8.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

// MARK: - Position

extension UIView {
    
    var width:CGFloat {
        
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
        
    }
    
    var height:CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
        
    }
    
    var size:CGSize  {
        get {
            return self.frame.size
        }
        set {
            self.frame.size = newValue
        }
    }
    
    var origin:CGPoint {
        get {
            return self.frame.origin
        }
        set {
            self.frame.origin = newValue
        }
    }
    
    var x:CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin = CGPoint(x: newValue, y: self.frame.origin.y)
            
        }
    }
    
    var y:CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin = CGPoint(x: self.frame.origin.x, y: newValue)
            
        }
    }
    
    var centerX:CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center = CGPoint(x: newValue, y: self.center.y)
            
        }
    }
    
    var centerY:CGFloat {
        get {
            return self.center.y
        }
        set {
            self.center = CGPoint(x: self.center.x, y: newValue)
            
        }
    }
    
    var left:CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue
            
        }
    }
    
    var right:CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set {
            self.frame.origin.x = newValue - self.frame.size.width
            
        }
    }
    
    var top:CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
        }
    }
    
    var bottom:CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set {
            self.frame.origin.y = newValue - self.frame.size.height
            
        }
    }
    
}

// MARK: - Draw Layout

extension UIView {
    
    var radius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
    }
    
    enum ViewBorder:String {
        case left = "borderLeft"
        case right = "borderRight"
        case top = "borderTop"
        case bottom = "borderBottom"
    }
    
    var defaultBorderColor:UIColor {
        get {
            if self.responds(to: #selector(getter: UIView.tintColor)) {
                return self.tintColor
            }else {
                return UIColor.blue
            }
        }
        set {
            self.defaultBorderColor = newValue
        }
    }
    
    /**
     添加四周边框
     */
    func addOnePixelAroundBorder() {
        self.addOnePixelAroundBorder(self.defaultBorderColor, radius: 0)
    }
    
    func addOnePixelAroundBorder(_ color:UIColor) {
        self.addOnePixelAroundBorder(color, radius: 0)
    }
    
    func addOnePixelAroundBorder(_ color:UIColor ,radius:CGFloat) {
        let retinaPixelSize = 1.0 / (UIScreen.main.scale)
        self.addAroundBorder(color, radius: radius, width: retinaPixelSize)
    }
    
    func addAroundBorder(_ color:UIColor ,radius:CGFloat ,width:CGFloat) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    /**
     *  添加单边边框
     */
    func addSingleBorder(_ color:UIColor ,at:ViewBorder) {
        let retinaPixelSize = 1.0 / (UIScreen.main.scale)
        addSingleBorder(color, linewidth: retinaPixelSize, at: at)
    }
    
    func addSingleBorder(_ color:UIColor ,linewidth:CGFloat ,at:ViewBorder) {
        let retinaPixelSize = 1.0 / (UIScreen.main.scale)
        let maxLinewidth = max(retinaPixelSize, linewidth)
        
        let border = CALayer()
        border.borderColor = color.cgColor
        border.borderWidth = maxLinewidth
        border.name = at.rawValue
        
        switch (at) {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: self.width, height: linewidth)
            break
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: linewidth, height: self.height)
            break
        case .right:
            border.frame = CGRect(x: self.width-linewidth, y: 0, width: linewidth, height: self.height)
            break
        case .bottom:
            border.frame = CGRect(x: 0, y: self.height-linewidth, width: self.width, height: linewidth)
            break
        }
        removeBorder(at)
        self.layer.addSublayer(border)
    }
    
    func removeBorder(_ at:ViewBorder) {
        var layerForRemove: CALayer?
        for layer in self.layer.sublayers! {
            if layer.name == at.rawValue {
                layerForRemove = layer
            }
        }
        if let layer = layerForRemove {
            layer.removeFromSuperlayer()
        }
    }
    
    func removeAllBorders() {
        removeBorder(.top)
        removeBorder(.left)
        removeBorder(.bottom)
        removeBorder(.right)
    }
    
}
