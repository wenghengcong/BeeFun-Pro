//
//  PlistHelper.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/17.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit
import Foundation

enum PHError: Error {
    case `nil`(String)
    case nsData(String)
    case json(String)
}

public extension Dictionary {
    
    /**
     Load a Plist file from the app bundle into a new dictionary
     
     :param: File name
     :throws: EHError : Nil
     :return: Dictionary<String, AnyObject>?
     */
    static func readPlist(_ filename: String) throws -> Dictionary<String, AnyObject> {
        
        guard let path = Bundle.appBundle.path(forResource: filename, ofType: "plist")  else {
            throw PHError.nil("[PlistHelper][readPlist] (pathForResource) The file could not be located\nFile : '\(filename).plist'")
        }
        guard let plistDict = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject> else {
            throw PHError.nil("[PlistHelper][readPlist] (NSDictionary) There is a file error or if the contents of the file are an invalid representation of a dictionary. File : '\(filename)'.plist")
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
    static func readPlist(_ filename: String) throws -> [String : AnyObject] {
        
        guard let path = Bundle.appBundle.path(forResource: filename, ofType: "plist")  else {
            throw PHError.nil("[EasyHelper][readPList] (pathForResource) The file could not be located\nFile : '\(filename).plist'")
        }
        guard let plistDict = NSDictionary(contentsOfFile: path) as? [String : AnyObject] else {
            throw PHError.nil("[EasyHelper][readPList] (NSDictionary) There is a file error or if the contents of the file are an invalid representation of a dictionary. File : '\(filename)'.plist")
        }
        
        return plistDict
    }
}


class PlistHelper: NSObject {

}

