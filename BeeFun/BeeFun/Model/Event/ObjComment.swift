//
//  ObjComment.swift
//  BeeFun
//
//  Created by WengHengcong on 2/23/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//
/**
*
{
     "html_url": "https://github.com/octocat/Hello-World/commit/6dcb09b5b57875f334f61aebed695e2e4193db5e#commitcomment-1",
     "url": "https://api.github.com/repos/octocat/Hello-World/comments/1",
     "id": 1,
     "body": "Great stuff",
     "path": "file1.txt",
     "position": 4,
     "line": 14,
     "commit_id": "6dcb09b5b57875f334f61aebed695e2e4193db5e",
     "user": {},
     "created_at": "2011-04-14T16:00:49Z",
     "updated_at": "2011-04-14T16:00:49Z"
}
 */

import UIKit
import ObjectMapper

class ObjComment: NSObject, Mappable {

    var url: String?
    var html_url: String?
    var issue_url: String?
    var id: Int?
    var user: ObjUser?
    var created_at: String?
    var updated_at: String?
    var body: String?
    var position: Int?
    var line: String?
    var path: String?
    var commit_id: String?

    required init?(map: Map) {
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
