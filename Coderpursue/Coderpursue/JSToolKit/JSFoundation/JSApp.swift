//
//  JSAppVersion.swift
//  LoveYou
//
//  Created by WengHengcong on 2016/10/28.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit

//appid
public let AppleAppID = "1094338006"

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
    
    
    /// info dictionary
    class var infoDictionary:Dictionary<String,Any> {
        return getInfoDictionary()
    }
    
    /// display name
    class var displayName:String {
        return getAppDisplayName()
    }
    
    /// name
    class var name:String {
        return getAppName()
    }
    
    /// bundle identifier
    class var bundleIdentifier:String {
        return getAppBudleIndetifier()
    }
    
    /// 获取infoplist中的设置
    ///
    /// - Returns: infoDictionary
    class func getInfoDictionary()->Dictionary<String, Any> {
        var info = Bundle.appBundle.infoDictionary
        if (info == nil || (info?.isEmpty)!){
            info = Bundle.main.infoDictionary!
        }
        
        if (info == nil || (info?.isEmpty)!){
            info = Bundle.main.localizedInfoDictionary!
        }

        return info!
    }
    
    /// 应用版本
    /// 标识应用程序的发布版本号。该版本的版本号是三个时期分隔的整数组成的字符串。第一个整数代表重大修改的版本，如实现新的功能或重大变化的修订。第二个整数表示的修订，实现较突出的特点。第三个整数代表维护版本。
    /// - returns: CFBundleShortVersionString
    public class func getAppVersion()->String {
        let release = JSApp.infoDictionary["CFBundleShortVersionString"] as? String
        if let ver = release {
            return ver
        }
        return "1.0"
    }
    
    /// 编译版本
    /// 标识（发布或未发布）的内部版本号。这是一个单调增加的字符串，包括一个或多个时期分隔的整数
    /// - returns: CFBundleVersion
    public class func getBuildVersion()->String {
        let build = JSApp.infoDictionary["CFBundleVersion"] as? String
        if let ver = build {
            return ver
        }
        return "1"
    }
    
    /// 获取APP显示名
    ///
    /// - Returns: CFBundleDisplayName
    public class func getAppDisplayName() -> String {
        let displayName = JSApp.infoDictionary["CFBundleDisplayName"] as! String
        return displayName
    }
    
    /// 获取APP Name
    ///
    /// - Returns: CFBundleName
    public class func getAppName() -> String {
        let appName = JSApp.infoDictionary["CFBundleName"] as! String
        return appName
    }
    
    /// 获取APP Bundle Identifier
    ///
    /// - Returns: CFBundleIdentifier
    public class func getAppBudleIndetifier() -> String {
        let appName = JSApp.infoDictionary["CFBundleIdentifier"] as! String
        return appName
    }
    
    /// 评价APP
    public class func rateUs()->Void {
        if appId == UnKnown  {
            appId = AppleAppID
        }
        let appstroreUrl = ("itms-apps://itunes.apple.com/app/id\(appId)")
        UIApplication.shared.openURL(  URL(string: appstroreUrl)! );
    }
    
}
