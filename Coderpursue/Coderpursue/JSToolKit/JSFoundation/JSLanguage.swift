//
//  JSLanguage.swift
//  Coderpursue
//
//  Created by WengHengcong on 2017/3/17.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

/// 这个key不能修改
let kAppleLanguageKey = "AppleLanguages"

/// 用户选择的语言
let kAppChooseLanguageKey = "kAppChooseLanguageKey"

let kChineseLanguage = "zh-Hans"

let kEnglishLanguage = "en"


class JSLanguage: NSObject {
    
    
    /// 获取系统的两位语言代码
    class var languageCode:String {
        return  Locale.current.languageCode!
    }
    
    /// 获取系统的语言
    class var systemLanguage:String {
        get {
            //NSLocale.preferredLanguages.first获取到的仍然是app内设置的语言选择
//            let system = NSLocale.preferredLanguages.first!
            var system = languageCode
            if (system == "zh") {
                system = kChineseLanguage
            }else if(system == "zh"){
                system = kEnglishLanguage
            }else{
                system = kEnglishLanguage
            }
            JSLog.debug("system language is \(system) ")
            return system
        }
    }
    
    /// 用户选择的语言，默认是系统的语言
    class var userLanguage:String {
        
        set {
            let def = UserDefaults.standard
            def.set(newValue, forKey: kAppChooseLanguageKey)
            def.synchronize()
            JSLog.debug("user choose new language \(newValue) ")
        }
        
        get {
            let def = UserDefaults.standard
            var choose = def.object(forKey: kAppChooseLanguageKey)
            if choose == nil{
                choose = systemLanguage
            }
            JSLog.debug("user choose language is \(choose!) ")
            return choose as! String
        }
    }
    
    /// 当前设置的语言
    class var currentLanguage:String {
        set {
            let def = UserDefaults.standard
            def.set([newValue], forKey: kAppleLanguageKey)
            def.synchronize()
            JSLog.debug("set current language is \(newValue) ")
        }
        
        get {
            let def = UserDefaults.standard
            let langArray = def.object(forKey: kAppleLanguageKey) as! NSArray
            let current = langArray.firstObject as! String
            JSLog.debug("current language is \(current) ")
            return current
        }
    }
    
    /// 设置APP内语言为选中的语言
    class func setUserLanguage() {
        currentLanguage = userLanguage
    }
    
    /// 设置语言
    ///
    /// - Parameter lang: <#lang description#>
    class func switchLanguage(to lang: String) {
        currentLanguage = lang
    }
    
    /// 设置为本地默认化语言
    class func setSystemLanguage() {
        switchLanguage(to: systemLanguage)
    }
    
    /// 设置为英文语言
    class func setEnglish() {
        switchLanguage(to: kEnglishLanguage)
    }
    
    /// 设置为中文语言
    class func setChinese() {
        switchLanguage(to: kChineseLanguage)
    }
    
}
