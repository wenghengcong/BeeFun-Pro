//
//  JSAppVersion.swift
//  LoveYou
//
//  Created by WengHengcong on 2016/10/28.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit

class JSApp: NSObject {

    
    /// 应用APPID
    static var UnKnown:String = "Unknown"
    static var appId:String = UnKnown
    static var appStoreLink:String = UnKnown

    /// 应用版本
    class var appVersion:String {
        return getAppVersion()
    }
    
    /// 编译版本
    class var buildVersion:String {
        return getBuildVersion()
    }
    
    /// 应用版本
    /// 标识应用程序的发布版本号。该版本的版本号是三个时期分隔的整数组成的字符串。第一个整数代表重大修改的版本，如实现新的功能或重大变化的修订。第二个整数表示的修订，实现较突出的特点。第三个整数代表维护版本。
    /// - returns: CFBundleShortVersionString
    public class func getAppVersion()->String {
        let release = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        if let ver = release {
            return ver
        }
        return "1.0"
    }
    
    /// 编译版本
    /// 标识（发布或未发布）的内部版本号。这是一个单调增加的字符串，包括一个或多个时期分隔的整数
    /// - returns: CFBundleVersion
    public class func getBuildVersion()->String {
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        if let ver = build {
            return ver
        }
        return "1"
    }
    
    public class func rateUs()->Void {

        if appId == UnKnown  {
            
        }
        let appstroreUrl = ("itms-apps://itunes.apple.com/app/id\(appId)")
        UIApplication.shared.openURL(  URL(string: appstroreUrl)! );
    }
    
}
