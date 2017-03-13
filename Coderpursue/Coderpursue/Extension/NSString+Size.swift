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

import UIKit

// MARK: - Localized
extension String {
    
    //http://stackoverflow.com/questions/25081757/whats-nslocalizedstring-equivalent-in-swift
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func localized(withComment:String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: withComment)
    }
    
}

// MARK: - count
extension String {
    /// 字符串长度
    var length: Int {
        return self.characters.count
    }
    
    /// 按UTF16标准的字符串长度
    var utf16Length:Int {
        return self.utf16.count
    }
    
    // MARK: - index
    
    /// 返回Index类型
    ///
    /// - Parameter from: <#from description#>
    /// - Returns: <#return value description#>
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
}

// MARK: - substring
extension String {
    //http://stackoverflow.com/questions/39677330/how-does-string-substring-work-in-swift-3
    
    /// 裁剪字符串from
    ///
    /// - Parameter from: <#from description#>
    /// - Returns: <#return value description#>
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    /// 裁剪字符串to
    ///
    /// - Parameter to: <#to description#>
    /// - Returns: <#return value description#>
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    /// 裁剪字符串range
    ///
    /// - Parameter r: <#r description#>
    /// - Returns: <#return value description#>
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}

extension String {
    
}

extension String{
    
    
}

