//
//  NSMutableAttributedString.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/4/14.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    /// 设置文本subString的颜色
    ///
    /// - Parameters:
    ///   - sub: 文本中需要设置颜色的子文本
    ///   - color: 颜色
    func setSubstringColor(_ sub: String, color: UIColor) {
        let range = self.mutableString.range(of: sub, options:NSString.CompareOptions.caseInsensitive)
        if range.location != NSNotFound {
            self.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
        }
    }
}
