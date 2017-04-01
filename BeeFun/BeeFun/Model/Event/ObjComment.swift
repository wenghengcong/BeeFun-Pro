//
//  ObjComment.swift
//  Coderpursue
//
//  Created by WengHengcong on 2/23/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//
/**
*
{
"url": "https://api.github.com/repos/wenghengcong/TestForCoder/issues/comments/187431233",
"html_url": "https://github.com/wenghengcong/TestForCoder/issues/2#issuecomment-187431233",
"issue_url": "https://api.github.com/repos/wenghengcong/TestForCoder/issues/2",
"id": 187431233,
"user": ObjUser,
"created_at": "2016-02-22T23:11:15Z",
"updated_at": "2016-02-22T23:11:15Z",
"body": "comment again"
}
*/

import UIKit
import ObjectMapper

class ObjComment: NSObject,Mappable {
    
    var url:String?
    var html_url:String?
    var issue_url:String?
    var id:Int?
    var user:ObjUser?
    var created_at:String?
    var updated_at:String?
    var body:String?
    var position:String?
    var line:String?
    var path:String?
    var commit_id:String?


    required init?(map: Map) {
        //        super.init(map)
    }
    
    func mapping(map: Map) {
        //        super.mapping(map)
        url <- map["url"]
        html_url <- map["html_url"]
        issue_url <- map["issue_url"]
        id <- map["id"]
        user <- map["user"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        body <- map["body"]
        position <- map["position"]
        line <- map["line"]
        path <- map["path"]
        commit_id <- map["commit_id"]

        
    }
}
