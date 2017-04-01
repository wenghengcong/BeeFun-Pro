//
//  Bundle+Extension.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/3/19.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

extension Bundle {

    
    /// 中文Bundle
    class var cnBundle:Bundle {
        return langBundle(kChineseLanguage)
    }
    
    /// 英文Bundle
    class var enBundle:Bundle {
        return langBundle(kEnglishLanguage)
    }
    
    /// APP语言Bundle
    class var appBundle:Bundle {
        let appLang = JSLanguage.appLanguage
        return langBundle(appLang)
    }
    
    /// 根据语言返回Bundle
    ///
    /// - Parameter language: <#language description#>
    /// - Returns: <#return value description#>
    class func langBundle(_ language:String) -> Bundle {
        
        if language.isEmpty {
            return Bundle.main
        }else{
            if let pathR = Bundle.main.path(forResource: language, ofType: "lproj") {
                let bundle = Bundle(path: pathR)!
                return bundle
            }else{
                return Bundle.main
            }
        }
    }
    
    
    
}
