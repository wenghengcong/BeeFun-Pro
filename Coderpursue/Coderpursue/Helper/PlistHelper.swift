//
//  PlistHelper.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/17.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit
import Foundation

enum PHError: ErrorType {
    case Nil(String)
    case NSData(String)
    case JSON(String)
}

public extension Dictionary {
    
    /**
     Load a Plist file from the app bundle into a new dictionary
     
     :param: File name
     :throws: EHError : Nil
     :return: Dictionary<String, AnyObject>?
     */
    static func readPlist(filename: String) throws -> Dictionary<String, AnyObject> {
        
        guard let path = NSBundle.mainBundle().pathForResource(filename, ofType: "plist")  else {
            throw PHError.Nil("[PlistHelper][readPlist] (pathForResource) The file could not be located\nFile : '\(filename).plist'")
        }
        guard let plistDict = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject> else {
            throw PHError.Nil("[PlistHelper][readPlist] (NSDictionary) There is a file error or if the contents of the file are an invalid representation of a dictionary. File : '\(filename)'.plist")
        }
        
        return plistDict
    }
    
}

public extension Array {
    
    /**
     Load a Plist file from the app bundle into a new array
     
     :param: File name
     :throws: EHError : Nil
     :return: Dictionary<String, AnyObject>?
     */
    static func readPlist(filename: String) throws -> [String : AnyObject] {
        
        guard let path = NSBundle.mainBundle().pathForResource(filename, ofType: "plist")  else {
            throw PHError.Nil("[EasyHelper][readPList] (pathForResource) The file could not be located\nFile : '\(filename).plist'")
        }
        guard let plistDict = NSDictionary(contentsOfFile: path) as? [String : AnyObject] else {
            throw PHError.Nil("[EasyHelper][readPList] (NSDictionary) There is a file error or if the contents of the file are an invalid representation of a dictionary. File : '\(filename)'.plist")
        }
        
        return plistDict
    }
}


class PlistHelper: NSObject {

}

