//
//  ObjMilestone.swift
//  Coderpursue
//
//  Created by WengHengcong on 2/23/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

/**
*  
"url": "https://api.github.com/repos/octocat/Hello-World/milestones/1",
"html_url": "https://github.com/octocat/Hello-World/milestones/v1.0",
"labels_url": "https://api.github.com/repos/octocat/Hello-World/milestones/1/labels",
"id": 1002604,
"number": 1,
"state": "open",
"title": "v1.0",
"description": "Tracking milestone for version 1.0",

"creator": ObjUser

"open_issues": 4,
"closed_issues": 8,
"created_at": "2011-04-10T20:09:31Z",
"updated_at": "2014-03-03T18:58:10Z",
"closed_at": "2013-02-12T13:22:01Z",
"due_on": "2012-10-09T23:39:01Z"

*/

import UIKit
import ObjectMapper

class ObjMilestone: NSObject,Mappable {
    var url:String?
    var html_url:String?
    var labels_url:String?
    var id:Int?
    var number:Int?
    var state:String?
    var title:String?
    var cdescription:String?    //与description关键字冲突

    var creator:ObjUser?
    
    var open_issues:Int?
    var closed_issues:Int?
    var created_at:String?
    var updated_at:String?
    var closed_at:String?
    var due_on:String?
    
    required init?(_ map: Map) {
        //        super.init(map)
    }
    
    func mapping(_ map: Map) {
        //        super.mapping(map)
        url <- map["url"]
        html_url <- map["html_url"]
        labels_url <- map["labels_url"]
        id <- map["id"]
        number <- map["number"]
        state <- map["state"]
        title <- map["title"]
        cdescription <- map["description"]
        creator <- map["creator"]
        open_issues <- map["open_issues"]
        closed_issues <- map["closed_issues"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        closed_at <- map["closed_at"]
        due_on <- map["due_on"]
        
    }
}
