//
//  String+Extension.swift
//  LoveYou
//
//  Created by WengHengcong on 2017/3/12.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

// MARK: - Localized
extension String {
    
    //http://stackoverflow.com/questions/25081757/whats-nslocalizedstring-equivalent-in-swift
    //https://github.com/nixzhu/dev-blog/blob/master/2014-04-24-internationalization-tutorial-for-ios-2014.md
    
    
    /// 获取APP语言字符串
    var localized: String {
        let lang = JSLanguage.appLanguage
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)!
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
    
    /// 获取英文国际化字符串
    var enLocalized: String {
        let path = Bundle.main.path(forResource: kEnglishLanguage, ofType: "lproj")
        let bundle = Bundle(path: path!)!
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
    
    /// 获取中文国际化字符串
    var cnLocalized: String {
        let path = Bundle.main.path(forResource: kChineseLanguage, ofType: "lproj")
        let bundle = Bundle(path: path!)!
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
    
    /// 获取APP语言字符串
    func localized(withComment:String) -> String {
        let path = Bundle.main.path(forResource: kChineseLanguage, ofType: "lproj")
        let bundle = Bundle(path: path!)!
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: withComment)
    }
    
    /// 获取英文国际化字符串
    func enLocalized(withComment:String) -> String {
        let path = Bundle.main.path(forResource: kEnglishLanguage, ofType: "lproj")
        let bundle = Bundle(path: path!)!
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: withComment)
    }
    
    /// 获取中文国际化字符串
    func cnLocalized(withComment:String) -> String {
        let path = Bundle.main.path(forResource: kChineseLanguage, ofType: "lproj")
        let bundle = Bundle(path: path!)!
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: withComment)
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
