//
//  NetworkHelper.swift
//  BeeFun
//
//  Created by wenghengcong on 16/1/10.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit

open class NetworkHelper: NSObject {

    open static func clearCookies() {
        
        let storage : HTTPCookieStorage = HTTPCookieStorage.shared
        for cookie in storage.cookies! {
            storage.deleteCookie(cookie)
        }        
    }
    
}
