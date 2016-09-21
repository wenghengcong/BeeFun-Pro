//
//  ObjPermissions.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/23.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper

class ObjPermissions: NSObject,Mappable {
    
    var admin:Int?
    var pull:Int?
    var push:Int?
    
    required init?(map: Map) {
        //        super.init(map)
    }
    
    func mapping(map: Map) {
        //        super.mapping(map)
        admin <- map["admin"]
        pull <- map["pull"]
        push <- map["push"]
    }
    
}
