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

class JSFile: NSObject{
    
   public class  func readJsonBySwiftyJSON(_ path:String) -> JSON {
        let path = Bundle.main.path(forResource: path, ofType: "json")
        var result:JSON
        if path != nil {
            if let dataFromList = NSData.init(contentsOfFile: path!){
                result = JSON(dataFromList)
                return result
            }else{
                return JSON.null
            }
        }else{
            return JSON.null
        }
    }
    
    public class  func readJsonByMapper<T:Mappable>(_ path:String,object:T) -> T {
        
        let path = Bundle.main.path(forResource: path, ofType: "json")
        if path != nil {
            if let dataFromList = NSData.init(contentsOfFile: path!){
                let jsonStr:String = (NSString(data: dataFromList as Data, encoding: String.Encoding.utf8.rawValue))! as String // UTF8转String
                if let paraseObj = Mapper<T>().map(JSONString:jsonStr) {
                    return paraseObj
                }else{
                    return JSObject.init() as! T
                }
                
            }else{
                return JSObject.init() as! T
            }
        }else{
            return JSObject.init() as! T
        }
        
    }
}
