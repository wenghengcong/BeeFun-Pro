//
//  ObjIssue.swift
//  Coderpursue
//
//  Created by WengHengcong on 2/23/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//
/**
{
"url": "https://api.github.com/repos/wenghengcong/TestForCoder/issues/2",
"repository_url": "https://api.github.com/repos/wenghengcong/TestForCoder",
"labels_url": "https://api.github.com/repos/wenghengcong/TestForCoder/issues/2/labels{/name}",
"comments_url": "https://api.github.com/repos/wenghengcong/TestForCoder/issues/2/comments",
"events_url": "https://api.github.com/repos/wenghengcong/TestForCoder/issues/2/events",
"html_url": "https://github.com/wenghengcong/TestForCoder/issues/2",
"id": 135574763,
"number": 2,
"title": "Issue 2",

"user": ObjUser,

"labels": [],
"state": "open",
"locked": false,
"assignee": null,
"milestone": null,
"comments": 1,
"created_at": "2016-02-22T23:11:00Z",
"updated_at": "2016-02-22T23:11:15Z",
"closed_at": null,
"repository": ObjRepos
"closed_by":ObjUser
"pull_request":ObjPullRequest
"body": "@wenghengcong\r\nnoti user"
}
*/
import UIKit
import ObjectMapper

class ObjIssue: NSObject,Mappable {

    var url:String?
    var repository_url:String?
    var labels_url:String?
    var comments_url:String?
    var events_url:String?
    var html_url:String?
    var id:Int?
    var number:Int?
    var title:String?
    var user:ObjUser?
    var labels:[ObjLabel]?
    var state:String?
    var locked:Bool?
    var assignee:ObjUser?
    var milestone:ObjMilestone?
    var comments:Int?
    var created_at:String?
    var updated_at:String?
    var closed_at:String?
    var repository:ObjRepos?
    var closed_by:ObjUser?
    var pull_request:ObjPullRequest?
    var body:String?
    
    required init?(map: Map) {
        //        super.init(map)
    }
    
    func mapping(map: Map) {
        //        super.mapping(map)
        
        url <- map["url"]
        repository_url <- map["repository_url"]
        labels_url <- map["labels_url"]
        comments_url <- map["comments_url"]
        events_url <- map["events_url"]
        html_url <- map["html_url"]
        id <- map["id"]
        number <- map["number"]
        title <- map["title"]
        user <- map["user"]
        labels <- map["labels"]
        state <- map["state"]
        locked <- map["locked"]
        assignee <- map["assignee"]
        milestone <- map["milestone"]
        comments <- map["comments"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        closed_at <- map["closed_at"]
        repository <- map["repository"]
        closed_by <- map["closed_by"]
        pull_request <- map["pull_request"]
        body <- map["body"]

        
    }
}
