//
//  ObjEvent.swift
//  Coderpursue
//
//  Created by WengHengcong on 2/23/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//
/**
{
"id": "3675348721",
"type": "IssueCommentEvent",
"actor":ObjUser,
"repo":ObjRepos,
"payload": ObjEventPayload,
"public": true,
"created_at": "2016-02-22T23:11:00Z"
}
*/

import UIKit
import ObjectMapper

class ObjEvent: NSObject {
    
    var id:Int?
    var type:String?
    var actor:ObjUser?
    var repo:ObjRepos?
    var payload:ObjEventPayload?
    var cpublic:Bool?           //"public" is keyword,so add "c" prefix
    var created_at:String?

    //TODO: org is organization
    //var org:String?
    
    
    required init?(_ map: Map) {
        //        super.init(map)
    }
    
    func mapping(map: Map) {
        //        super.mapping(map)
        id <- map["id"]
        type <- map["type"]
        actor <- map["actor"]
        repo <- map["repo"]
        payload <- map["payload"]
        cpublic <- map["public"]
        created_at <- map["created_at"]
    }
}
