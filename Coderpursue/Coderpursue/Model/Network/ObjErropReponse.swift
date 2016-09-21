//
//  ObjErropReponse.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/8/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper

/*
{
"message": "Validation Failed",
"errors": [
{
"resource": "Search",
"field": "q",
"code": "missing"
}
],
"documentation_url": "https://developer.github.com/v3/search"
}

*/

class ObjErropReponse: NSObject,Mappable {
    
    var message:String?
    var errors:[ObjError]?
    var documentationUrl:String?
    
    required init?(_ map: Map) {
        //        super.init(map)
    }
    
    func mapping(_ map: Map) {
        //        super.mapping(map)
        message <- map["message"]
        errors <- map["errors"]
        documentationUrl <- map["documentation_url"]
        
    }
    
}
