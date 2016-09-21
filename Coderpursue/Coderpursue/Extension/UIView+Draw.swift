//
//  UIView+Draw.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/17.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit
import Foundation

/** Draw Extends UIView

*/
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
        case Left = "borderLeft"
        case Right = "borderRight"
        case Top = "borderTop"
        case Bottom = "borderBottom"
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
        case .Top:
            border.frame = CGRect(x: 0, y: 0, width: self.width, height: linewidth)
            break
        case .Left:
            border.frame = CGRect(x: 0, y: 0, width: linewidth, height: self.height)
            break
        case .Right:
            border.frame = CGRect(x: self.width-linewidth, y: 0, width: linewidth, height: self.height)
            break
        case .Bottom:
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
        removeBorder(.Top)
        removeBorder(.Left)
        removeBorder(.Bottom)
        removeBorder(.Right)
    }
    
}
