//
//  JSFile.swift
//  LoveYou
//
//  Created by WengHengcong on 2017/2/20.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper

class JSFileManager: NSObject {

    static let shared = JSFileManager()
    
    // MARK: - Directory
    class var homeDirectory: String {
        return NSHomeDirectory()
    }
    
    class var libraryDirectory: String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
        return documentsPath
    }
    
    class var tmpDirectory: String {
        return NSTemporaryDirectory()
    }
    
    class var documentDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    }
    
    class var preferenceDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.preferencePanesDirectory, .userDomainMask, true).first!
    }
    
    class var cachestDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
    }
    
    // MARK: - Directory URL
    class var documentsUrl: URL {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsUrl
    }
    
    class var cachestUrl: URL {
        let cachesUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return cachesUrl
    }
    
    // MARK: - JSON
    public class  func readJsonBySwiftyJSON(_ path: String) -> JSON {
        let path = Bundle.appBundle.path(forResource: path, ofType: "json")
        var result: JSON
        if path != nil {
            if let dataFromList = NSData(contentsOfFile: path!) {
                result = JSON(dataFromList)
                return result
            } else {
                return JSON.null
            }
        } else {
            return JSON.null
        }
    }

    public class  func readJsonByMapper<T: Mappable>(_ path: String, object: T) -> T {

        let path = Bundle.appBundle.path(forResource: path, ofType: "json")
        if path != nil {
            if let dataFromList = NSData(contentsOfFile: path!) {
                let jsonStr: String = (NSString(data: dataFromList as Data, encoding: String.Encoding.utf8.rawValue))! as String // UTF8转String
                if let paraseObj = Mapper<T>().map(JSONString:jsonStr) {
                    return paraseObj
                } else {
                    return JSObject() as! T
                }

            } else {
                return JSObject() as! T
            }
        } else {
            return JSObject() as! T
        }

    }
}
