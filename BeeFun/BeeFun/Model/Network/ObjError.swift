//
//  ObjErrorMessage.swift
//  BeeFun
//
//  Created by WengHengcong on 3/8/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper

/*
{

"resource": "Search",
"field": "q",
"code": "missing"
}

*/

class ObjError: NSObject, Mappable {

    var resource: String?
    var field: String?
    var code: String?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        //        super.mapping(map)
        resource <- map["resource"]
        field <- map["field"]
        code <- map["code"]

    }
}
