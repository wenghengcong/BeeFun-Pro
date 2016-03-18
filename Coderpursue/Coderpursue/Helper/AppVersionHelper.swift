//
//  AppVersionHelper.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/16/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

class AppVersionHelper: NSObject {
    
    static let sharedInstance = AppVersionHelper()

    let appstoreUrl = "https://itunes.apple.com/cn/app/da-niu-jia/id1053003221?mt=8"
    
    func bundleReleaseVersion()->String{
        let release = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as? String
        return release!
    }
    
    func bundleBuildVersion()->String{
        let build = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as? String
        return build!
    }
    
    //rate us
    func rateUs() {
        let appstroreUrl = ("itms-apps://itunes.apple.com/app/id\(AppleAppID)")
//        let appstroreUrl = ("itms-apps://itunes.apple.com/app/id1023050194")
        UIApplication.sharedApplication().openURL(  NSURL(string: appstroreUrl)! );
    }
    
}
