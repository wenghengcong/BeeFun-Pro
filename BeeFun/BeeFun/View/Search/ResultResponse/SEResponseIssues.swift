//
//  SEResponseIssues.swift
//  BeeFun
//
//  Created by WengHengcong on 10/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper

class SEResponseIssues: NSObject, Mappable {
    
    var totalCount: Int?
    var incompleteResults: Bool?
    var items: [ObjIssue]?
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        //        super.mapping(map)
        totalCount <- map["total_count"]
        incompleteResults <- map["incomplete_results"]
        items <- map["items"]
    }
    
}
