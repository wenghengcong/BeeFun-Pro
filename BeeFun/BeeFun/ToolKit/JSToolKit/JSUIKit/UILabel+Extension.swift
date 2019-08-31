//
//  UILabel+Extension.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/4/14.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

extension UILabel {

    /// 初始化方法
    ///
    /// - Parameters:
    ///   - fontSize: 字体大小
    ///   - align: 对齐方式
    ///   - mutiple: 是否显示多行
    convenience init(size fontSize: CGFloat, align: NSTextAlignment, mutiple: Bool) {
        self.init()
        font = UIFont.systemFont(ofSize: fontSize)
        textAlignment = align
        if mutiple {
            numberOfLines = 0
        }
    }

    /// 初始化方法
    ///
    /// - Parameters:
    ///   - fontSize: 字体大小
    ///   - mutiple: 是否显示多行
    convenience init(size fontSize: CGFloat, mutiple: Bool) {
        self.init(size: fontSize, align: .left, mutiple: mutiple)
    }
    /// 设置文本中subString中的颜色
    ///
    /// - Parameters:
    ///   - subText: 指定文本
    ///   - color: 该文本需要设置的颜色
    func setSubTextColor(_ subText: String, color: UIColor) {

        let attributedString: NSMutableAttributedString = self.attributedText != nil ? NSMutableAttributedString(attributedString: self.attributedText!) : NSMutableAttributedString(string: self.text!)

        let range = attributedString.mutableString.range(of: subText, options:NSString.CompareOptions.caseInsensitive)
        if range.location != NSNotFound {
            attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
        }
        self.attributedText = attributedString
    }
    
    /// 设置字体大小自适应
    ///
    /// - Parameter factor: 最小的缩小倍数
    func adjustFontSizeToFitWidth(minScale factor: CGFloat) {
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = factor
    }
    
    /// 设置字体大小自适应
    ///
    /// - Parameter fontsize: 最小的字体大小
    func adjustFontSizeToFitWidth(minFont fontsize: CGFloat) {
        let scale = fontsize/self.font.pointSize
        adjustFontSizeToFitWidth(minScale: scale)
    }
    
}
