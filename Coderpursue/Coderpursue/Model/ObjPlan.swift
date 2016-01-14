//
//  ObjPlan.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/14.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper

/*
"private_repos" : 0,
"collaborators" : 0,
"space" : 976562499,
"name" : "free"
*/

class ObjPlan: Mappable {
    
    var private_repos:Int?
    var collaborators:Int?
    var space:Int?
    var name:String?
    
    required init?(_ map: Map) {
//        super.init(map)
    }
    
    func mapping(map: Map) {
//        super.mapping(map)
        private_repos <- map["private_repos"]
        collaborators <- map["collaborators"]
        space <- map["space"]
        name <- map["name"]
    }
    
}
