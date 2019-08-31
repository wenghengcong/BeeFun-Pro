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

    var width: CGFloat {

        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }

    }

    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }

    }

    var size: CGSize {
        get {
            return self.frame.size
        }
        set {
            self.frame.size = newValue
        }
    }

    var origin: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            self.frame.origin = newValue
        }
    }

    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin = CGPoint(x: newValue, y: self.frame.origin.y)

        }
    }

    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin = CGPoint(x: self.frame.origin.x, y: newValue)

        }
    }

    var centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center = CGPoint(x: newValue, y: self.center.y)

        }
    }

    var centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            self.center = CGPoint(x: self.center.x, y: newValue)

        }
    }

    var left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue

        }
    }

    var right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set {
            self.frame.origin.x = newValue - self.frame.size.width

        }
    }

    var top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
        }
    }

    var bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set {
            self.frame.origin.y = newValue - self.frame.size.height

        }
    }

}
// MARK: - Calculator poisiton

extension UIView {

    /// 计算控件相对于屏幕的左边距
    ///
    /// - Parameter width: 控件宽度
    /// - Returns: 控件距离屏幕左边距
    class func xSpace(width: CGFloat) -> CGFloat {
        return self.xSpace(width: width, relative: ScreenSize.width)
    }

    /// 计算控件相对于父视图的左边距
    ///
    /// - Parameters:
    ///   - width: 控件宽度
    ///   - full: 父视图的整体宽度
    /// - Returns: 控件相对于父视图的左边距
    class func xSpace(width: CGFloat, relative full: CGFloat) -> CGFloat {
        let leftX = (full-width)/2.0
        return leftX
    }

    /// 计算控件相对于屏幕的上边距
    ///
    /// - Parameter height: 控件高度
    /// - Returns: 控件距离屏幕上边距
    class func ySpace(height: CGFloat) -> CGFloat {
        return self.ySpace(height: height, relative: ScreenSize.height)
    }

    /// 计算控件相对于父视图的上边距
    ///
    /// - Parameters:
    ///   - height: 控件高度
    ///   - full: 控件父视图的整体高度
    /// - Returns: 控件相对于父视图的上边距
    class func ySpace(height: CGFloat, relative full: CGFloat) -> CGFloat {
        let topY = (full-height)/2.0
        return topY
    }

}

// MARK: - Draw Layout

extension UIView {

    /// 设置圆角
    var radius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
    }

    /// 设置边框颜色
    var borderColor: UIColor {
        get {
            if let color = self.layer.borderColor {
                return UIColor(cgColor: color)
            }
            return UIColor.white
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    /// 设置边框颜色
    var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }

    /// 边框类型
    ///
    /// - none: 不添加
    /// - one: 添加单边
    /// - all: 添加四边
    enum BorderType {
        case none
        case one
        case all
    }
    
    /// 视图Border类型
    ///
    /// - left: 左边框
    /// - right: 右边框
    /// - top: 上边框
    /// - bottom: 下边框
    enum ViewBorder: String {
        case left = "borderLeft"
        case right = "borderRight"
        case top = "borderTop"
        case bottom = "borderBottom"
    }

    /// 默认边框颜色
    var defaultBorderColor: UIColor {
        get {
            return UIColor.bfLineBackgroundColor
        }
        set {
            self.defaultBorderColor = newValue
        }
    }
    
    /// 添加边框（颜色：默认，圆角：0，宽度：1px）
    ///
    /// - Parameters:
    ///   - type: 边框类型
    ///   - at: 指定哪条边添加边框
    func addBorder(type: BorderType, at: ViewBorder) {
        let width = 1.0 / (UIScreen.main.scale)
        addBorder(type: type, color: defaultBorderColor, radius: 0, width: width, at: at)
    }
    
    /// 添加边框（颜色：默认，宽度：1px）
    func addBorder(type: BorderType, radius: CGFloat, at: ViewBorder) {
        let width = 1.0 / (UIScreen.main.scale)
        addBorder(type: type, color: defaultBorderColor, radius: radius, width: width, at: at)
    }
    
    /// 添加边框（宽度：1px）
    func addBorder(type: BorderType, color: UIColor, radius: CGFloat, at: ViewBorder) {
        let width = 1.0 / (UIScreen.main.scale)
        addBorder(type: type, color: color, radius: radius, width: width, at: at)
    }

    /// 添加边框
    ///
    /// - Parameters:
    ///   - type: 边框类型
    ///   - color: 颜色
    ///   - radius: 圆角
    ///   - width: 宽度
    ///   - at: 指点哪条边
    func addBorder(type: BorderType, color: UIColor, radius: CGFloat, width: CGFloat, at: ViewBorder) {
        switch type {
        case .none:
            break
        case .one:
            addBorderSingle(color, width: width, at: at)
        case .all:
            addBorderAround(color, radius: radius, width: width)
        }
    }

    /**
     添加四周边框
     */
    func addBorderAroundInOnePixel() {
        self.addBorderAroundInOnePixel(defaultBorderColor, radius: 0)
    }

    /// 添加1像素四周边框
    ///
    /// - Parameter color: 边框颜色
    func addBorderAroundInOnePixel(_ color: UIColor) {
        self.addBorderAroundInOnePixel(color, radius: 0)
    }

    /// 添加1像素的四周边框
    ///
    /// - Parameters:
    ///   - color: 边框颜色
    ///   - radius: 边框圆角
    func addBorderAroundInOnePixel(_ color: UIColor, radius: CGFloat) {
        let retinaPixelSize = 1.0 / (UIScreen.main.scale)
        self.addBorderAround(color, radius: radius, width: retinaPixelSize)
    }

    /// 添加四周边框
    ///
    /// - Parameters:
    ///   - color: 边框颜色
    ///   - radius: 边框圆角
    ///   - width: 边框宽度
    func addBorderAround(_ color: UIColor, radius: CGFloat, width: CGFloat) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
     /// 添加单边边框（颜色：默认，宽度：1px）
    func addBorderSingle(at: ViewBorder) {
        let retinaPixelSize = 1.0 / (UIScreen.main.scale)
        addBorderSingle(defaultBorderColor, width: retinaPixelSize, at: at)
    }
    
    /// 添加单边边框（宽度：1px）
    func addBorderSingle(_ color: UIColor, at: ViewBorder) {
        let retinaPixelSize = 1.0 / (UIScreen.main.scale)
        addBorderSingle(color, width: retinaPixelSize, at: at)
    }

    /// 添加单边边框
    ///
    /// - Parameters:
    ///   - color: 牙呢
    ///   - width: 宽度
    ///   - at: 指定哪条边
    func addBorderSingle(_ color: UIColor, width: CGFloat, at: ViewBorder) {
        let retinaPixelSize = 1.0 / (UIScreen.main.scale)
        let maxLinewidth = max(retinaPixelSize, width)

        let border = CALayer()
        border.borderColor = color.cgColor
        border.borderWidth = maxLinewidth
        border.name = at.rawValue

        switch at {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: self.width, height: width)
            break
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: width, height: self.height)
            break
        case .right:
            border.frame = CGRect(x: self.width-width, y: 0, width: width, height: self.height)
            break
        case .bottom:
            border.frame = CGRect(x: 0, y: self.height-width, width: self.width, height: width)
            break
        }
        removeBorder(at)
        self.layer.addSublayer(border)
    }

    func removeBorder(_ at: ViewBorder) {
        var layerForRemove: CALayer?
        if let sublayers = self.layer.sublayers {
            for layer in sublayers where layer.name == at.rawValue {
                layerForRemove = layer
            }
            if let layer = layerForRemove {
                layer.removeFromSuperlayer()
            }
        }
    }

    func removeAllBorders() {
        removeBorder(.top)
        removeBorder(.left)
        removeBorder(.bottom)
        removeBorder(.right)
    }

}
