//
//  String+Size.swift
//  LoveYou
//
//  Created by WengHengcong on 2017/3/10.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit
import Foundation

extension NSString {
    
    // FIXME: 为什么无效？？？
    /// 返回文本高度
    ///
    /// - Parameters:
    ///   - width: 文本占宽
    ///   - font: 文本字体
    /// - Returns: 文本高度
    func height(with width:CGFloat, font:UIFont) -> CGFloat {
        let constraintRect = CGSize(width:width,height:.greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.height
    }
    
    
    
    /// 返回文本宽度
    ///
    /// - Parameters:
    ///   - height: 文本占高
    ///   - font: 文本字体
    /// - Returns: 文本宽度
    func width(with height: CGFloat ,font:UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let attributes = [NSFontAttributeName: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        
        let boundingBox = boundingRect(with: constraintRect, options: option, attributes: attributes, context: nil)
        return boundingBox.width
    }
}

extension String {
    /// 返回文本高度
    ///
    /// - Parameters:
    ///   - width: 文本占宽
    ///   - font: 文本字体
    /// - Returns: 文本高度
    func height(with width:CGFloat, font:UIFont) -> CGFloat {
        let calString = self as NSString
        return calString.height(with: width, font: font)
    }
    /// 返回文本宽度
    ///
    /// - Parameters:
    ///   - height: 文本占高
    ///   - font: 文本字体
    /// - Returns: 文本宽度
    func width(with height: CGFloat ,font:UIFont) -> CGFloat {
        let calString = self as NSString
        return calString.width(with: height, font: font)
    }
}
