//
//  JSClass.swift
//  LoveYou
//
//  Created by WengHengcong on 2017/2/27.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

class JSClass {

    /// crate class from class name of string
    ///
    /// - Parameter className: string type
    /// - Returns: the class
    class func from(_ name: String) -> AnyClass! {
        let className = JSApp.getAppName() + "." + name
        return NSClassFromString(className)
    }

}
