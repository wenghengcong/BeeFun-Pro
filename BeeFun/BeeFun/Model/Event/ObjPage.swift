//
//  ObjPage.swift
//  BeeFun
//
//  Created by WengHengcong on 14/10/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper
/*
 {
     "action": "edited",
     "html_url": "https://github.com/AFNetworking/AFNetworking/wiki/AFNetworking-3.0-Migration-Guide",
     "page_name": "AFNetworking-3.0-Migration-Guide",
     "sha": "2d4cab76bc2bb73c890ebada2d53b614f0945635",
     "summary": null,
     "title": "AFNetworking 3.0 Migration Guide"
 }
 */
class ObjPage: Mappable {
    
    var action: String?
    var html_url: String?
    var page_name: String?
    var sha: String?
    var summary: String?
    var title: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        action <- map["action"]
        html_url <- map["html_url"]
        page_name <- map["page_name"]
        sha <- map["sha"]
        summary <- map["summary"]
        title <- map["title"]
    }
}
