//
//  YYTextManager.swift
//  BeeFun
//
//  Created by WengHengcong on 16/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import YYText

class YYTextManager: NSObject {

    class func enableDebug() {
        let debugOption = YYTextDebugOption()
        debugOption.baselineColor = UIColor.red
        debugOption.ctFrameFillColor = UIColor.red
        debugOption.ctLineFillColor = UIColor(red: 0.000, green: 0.463, blue: 1.000, alpha: 0.180)
        debugOption.cgGlyphBorderColor = UIColor(red: 1.000, green: 0.524, blue: 0.000, alpha: 0.200)
        YYTextDebugOption.setShared(debugOption)
    }
    
    class func addLineBreakCharacterAttribute(orginal: NSAttributedString?) -> NSMutableAttributedString {
        if orginal == nil {
            return self.newLineCharacterAttribute()
        }
        let mutable = NSMutableAttributedString(attributedString: orginal!)
        mutable.append(self.newLineCharacterAttribute())
        return mutable
    }
    
    /// 换行符属性文本
    class func newLineCharacterAttribute() -> NSMutableAttributedString {
        return NSMutableAttributedString(string: "\n")
    }
    
    class func addBlankSpaceCharacterAttribute(orginal: NSAttributedString?, count: Int) -> NSMutableAttributedString {
        if orginal == nil {
            return self.newLineCharacterAttribute()
        }
        let mutable = NSMutableAttributedString(attributedString: orginal!)
        mutable.append(self.blankSpaceCharacterAttribute(count: count))
        return mutable
    }
    
    /// 空白字符
    ///
    /// - Parameter count: <#count description#>
    /// - Returns: <#return value description#>
    class func blankSpaceCharacterAttribute(count: Int) -> NSMutableAttributedString {
        let blank = String(repeating: " ", count: count)
        return NSMutableAttributedString(string: blank)
    }
    
    class func moreDotCharacterAttribute(count: Int) -> NSMutableAttributedString {
        let blank = String(repeating: ".", count: count)
        return NSMutableAttributedString(string: blank)
    }
}

extension NSMutableAttributedString {
    
    /// 增加换行符
    func addLineBreakCharacterAttribute() {
        append(YYTextManager.newLineCharacterAttribute())
    }
    
    /// 增加空白字符
    ///
    /// - Parameter count: 空白字符的个数
    func addBlankSpaceCharacterAttribute(_ count: Int) {
        append(YYTextManager.blankSpaceCharacterAttribute(count: count))
    }
    
    /// 增加.符号
    ///
    /// - Parameter count: <#count description#>
    func addMoreDotCharacterAttribute(_ count: Int) {
        append(YYTextManager.moreDotCharacterAttribute(count: count))
    }
}
