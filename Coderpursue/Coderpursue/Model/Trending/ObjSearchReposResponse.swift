//
//  ObjSearchReposResponse.swift
//  Coderpursue
//
//  Created by WengHengcong on 4/9/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper

class ObjSearchReposResponse: NSObject,Mappable{
    
    var totalCount:Int?
    var incompleteResults:Bool?
    var items:[ObjRepos]?
    
    required init?(_ map: Map) {
        //        super.init(map)
    }
    
    func mapping(map: Map) {
        //        super.mapping(map)
        totalCount <- map["total_count"]
        incompleteResults <- map["incomplete_results"]
        items <- map["items"]
    }
    
}
