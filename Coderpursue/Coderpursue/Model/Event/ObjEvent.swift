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

public enum EventType:String {
    
    case CommitCommentEvent = "CommitCommentEvent"
    case CreateEvent = "CreateEvent"
    case DeleteEvent = "DeleteEvent"
    case DeploymentEvent = "DeploymentEvent"
    case DeploymentStatusEvent = "DeploymentStatusEvent"
    case DownloadEvent = "DownloadEvent"
    case FollowEvent = "FollowEvent"
    case ForkEvent = "ForkEvent"
    case ForkApplyEvent = "ForkApplyEvent"
    case GistEvent = "GistEvent"
    case GollumEvent = "GollumEvent"
    case IssuesEvent = "IssuesEvent"
    case IssueCommentEvent = "IssueCommentEvent"
    case MemberEvent = "MemberEvent"
    case MembershipEvent = "MembershipEvent"
    case PageBuildEvent = "PageBuildEvent"
    case PublicEvent = "PublicEvent"
    case PullRequestEvent = "PullRequestEvent"
    case PullRequestReviewCommentEvent = "PullRequestReviewCommentEvent"
    case PushEvent = "PushEvent"
    case ReleaseEvent = "ReleaseEvent"
    case RepositoryEvent = "RepositoryEvent"
    case StatusEvent = "StatusEvent"
    case TeamAddEvent = "TeamAddEvent"
    case WatchEvent = "WatchEvent"

}


public enum CreateEventType:String {
    
    case CreateRepositoryEvent = "repository"
    case CreateBranchEvent = "branch"
    case CreateTagEvent = "tag"
    
}


class ObjEvent: NSObject,Mappable {
    
    var id:String?
    var type:String?
    var actor:ObjUser?
    var repo:ObjRepos?
    var payload:ObjEventPayload?
    var org:ObjUser?
    var cpublic:Bool?           //"public" is keyword,so add "c" prefix
    var created_at:String?
    
    //TODO: org is organization
    //var org:String?
    
    
    required init?(_ map: Map) {
        //        super.init(map)
    }
    
    func mapping(_ map: Map) {
        //        super.mapping(map)
        id <- map["id"]
        type <- map["type"]
        actor <- map["actor"]
        org <- map["org"]
        repo <- map["repo"]
        payload <- map["payload"]
        cpublic <- map["public"]
        created_at <- map["created_at"]
    }
}
