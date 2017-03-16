//
//  JSObject.swift
//  LoveYou
//
//  Created by WengHengcong on 2017/2/27.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper

class JSObject:NSObject,Mappable {
    
    var version:Int?
    
    override init() {
        super.init()
        version = 1
    }
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        version    <- map["version"]
    }

}

