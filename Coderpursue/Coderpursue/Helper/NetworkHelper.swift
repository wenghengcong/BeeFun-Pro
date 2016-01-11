//
//  NetworkHelper.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/10.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit

public class NetworkHelper: NSObject {

    public static func clearCookies() {
        
        let storage : NSHTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in storage.cookies! {
            storage.deleteCookie(cookie)
        }
        NSUserDefaults.standardUserDefaults()
        
    }
    
}
