//
//  ObjEventPayload.swift
//  Coderpursue
//
//  Created by WengHengcong on 2/23/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

/**
{
"action": "created",
"issue":ObjIssue,
"comment": ObjComment,
}
*/

import UIKit
import ObjectMapper




class ObjEventPayload: NSObject,Mappable {
    
    //IssueCommentEvent,IssuesEvent,WatchEvent,MemberEvent
    var action:String?
    
    //IssueCommentEvent,IssuesEvent,
    var issue:ObjIssue?
    
    //IssueCommentEvent
    var comment:ObjComment?

    //CreateEvent
    /**
    "ref": "master",
    "ref_type": "branch",
    "master_branch": "master",
    "description": "test",
    "pusher_type": "user"
    */
    var ref:String?
    var ref_type:String?
    var master_branch:String?
    var cdescription:String?
    var pusher_type:String?

    
    //PushEvent
    /**
    "push_id": 982473441,
    "size": 2,
    "distinct_size": 2,
    "ref": "refs/heads/master",
    "head": "4c845c219cb70976ddca7937e4ad1c03dca1bb97",
    "before": "53111de7f5dbcd886c719dc734ab1badc02d0dc3"
    */
    var push_id:Int?
    var size:Int?
    var distinct_size:Int?
//    var ref:String?
    var head:String?
    var before:String?
    var commits:[ObjCommit]?

    //MemberEvent
    var member:ObjUser?

    //TODO:add event type
    //ForkEvent
    //forkee
    
    //TODO:add event type
    //PullRequestReviewCommentEvent
    //pull_request
    
    //TODO:add event type
    //PullRequestEvent
    //var number:Int?
    //pull_request
    
    required init?(_ map: Map) {
        //        super.init(map)
    }
    
    func mapping(map: Map) {
        //        super.mapping(map)
        action <- map["action"]
        issue <- map["issue"]
        comment <- map["comment"]
        ref <- map["ref"]
        ref_type <- map["ref_type"]
        master_branch <- map["master_branch"]
        cdescription <- map["description"]
        pusher_type <- map["pusher_type"]
        
        push_id <- map["push_id"]
        size <- map["size"]
        distinct_size <- map["distinct_size"]
        head <- map["head"]
        before <- map["before"]
        commits <- map["commits"]
        
    }

}
