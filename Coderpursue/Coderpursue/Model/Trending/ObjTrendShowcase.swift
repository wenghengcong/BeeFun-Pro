//
//  ObjTrendShowcase.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/8/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

/*

"name": "Policies",
"slug": "policies",
"description": "From federal governments to corporations to student clubs, groups of all sizes are using GitHub to share, discuss, and improve laws.  Ask...",
"image_url": "http://trending.codehub-app.com/policies.png"

*/

import UIKit
import ObjectMapper

class ObjTrendShowcase: NSObject,Mappable {

    var name:String?
    var slug:String?
    var cdescription:String?
    var imageUrl:String?
    
    required init?(_ map: Map) {
        //        super.init(map)
    }
    
    func mapping(map: Map) {
        //        super.mapping(map)
        name <- map["name"]
        slug <- map["slug"]
        cdescription <- map["description"]
        imageUrl <- map["image_url"]

    }
    
}
