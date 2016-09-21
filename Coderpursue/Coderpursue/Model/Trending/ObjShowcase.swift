//
//  ObjShowcase.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/8/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper

/*

"name": "Policies",
"slug": "policies",
"description": "From federal governments to corporations to student clubs, groups of all sizes are using GitHub to share, discuss, and improve laws.  Ask...",
"image_url": "http://trending.codehub-app.com/policies.png",
"repositories": [ObjRespo]

*/
class ObjShowcase: NSObject,Mappable {

    var name:String?
    var slug:String?
    var cdescription:String?
    var image_url:String?
    var repositories:[ObjRepos]?
    
    override init() {
        super.init()
    }
    
    required init?(_ map: Map) {
        //        super.init(map)
    }
    
    func mapping(_ map: Map) {
        //        super.mapping(map)
        name <- map["name"]
        slug <- map["slug"]
        cdescription <- map["description"]
        image_url <- map["image_url"]
        repositories <- map["repositories"]
        
    }
}
