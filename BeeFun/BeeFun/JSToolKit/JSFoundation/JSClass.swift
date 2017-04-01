//
//  JSClass.swift
//  LoveYou
//
//  Created by WengHengcong on 2017/2/27.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

class JSClass: NSObject {

    /// get class name as string
    var className: String {
        return NSStringFromClass(self as! AnyClass).components(separatedBy: ".").last ?? ""
    }
    
    /// crate class from class name of string
    ///
    /// - Parameter className: string type
    /// - Returns: the class
    class func fromClassName(className : String) -> NSObject {
        let className = Bundle.main.infoDictionary!["CFBundleName"] as! String + "." + className
        let aClass = NSClassFromString(className) as! UIViewController.Type
        return aClass.init()
    }
    
    
    /// get class name of string
    public class var className: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }
    
    /*
     var className: String {
     return String(describing: type(of: self))
     }
     
     class var className: String {
     return String(describing: self)
     }
     */
    
}
