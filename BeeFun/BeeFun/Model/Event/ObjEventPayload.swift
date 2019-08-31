//
//  ObjEventPayload.swift
//  BeeFun
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

enum EventAction: String {
    
    //GistEvent
    case create
    
    //GistEvent
    case update
    
    //GollumEvent/InstallationEvent/IssueCommentEvent/LabelEvent
    //MilestoneEvent/ProjectCardEvent/ProjectColumnEvent
    //ProjectEvent/PullRequestReviewCommentEvent
    //RepositoryEvent/TeamEvent
    case created
    
    //GollumEvent/IssueCommentEvent/IssuesEvent/LabelEvent
    //MemberEvent/MilestoneEvent/ProjectCardEvent/ProjectColumnEvent
    //ProjectEvent/PullRequestEvent/PullRequestReviewEvent
    //PullRequestReviewCommentEvent/TeamEvent
    case edited
    
    //InstallationEvent/IssueCommentEvent/LabelEvent
    //MemberEvent/MilestoneEvent/ProjectCardEvent/ProjectColumnEvent
    //ProjectEvent/PullRequestReviewCommentEvent
    //RepositoryEvent/TeamEvent
    case deleted
    
    //InstallationRepositoriesEvent/MemberEvent/MembershipEvent
    //MembershipEvent
    case added
    
    //InstallationRepositoriesEvent
    case removed
    
    //IssuesEvent
    case milestoned
     //IssuesEvent
    case demilestoned
    
    //IssuesEvent
    case labeled

    //IssuesEvent
    case unlabeled

    //IssuesEvent/PullRequestEvent
    case assigned
    
    //IssuesEvent/PullRequestEvent
    case unassigned
    
    //IssuesEvent/ProjectEvent/PullRequestEvent
    case reopened

    //IssuesEvent/MilestoneEvent/PullRequestEvent
    case opened

    //IssuesEvent/MilestoneEvent/ProjectEvent/PullRequestEvent
    case closed
    
    //MarketplacePurchaseEvent
    case purchased
    
    //MarketplacePurchaseEvent
    case cancelled
    
    //MarketplacePurchaseEvent
    case changed
    
    //OrganizationEvent
    case member_added
    
    //OrganizationEvent
    case member_removed
    
    //OrganizationEvent
    case member_invited
    
    //OrgBlockEvent
    case blocked
    
    //OrgBlockEvent
    case unblocked
    
    //ProjectCardEvent
    case converted
    
    //ProjectCardEvent/ProjectColumnEvent
    case moved
    
    //PullRequestEvent
    case review_requested
    
    //PullRequestEvent
    case review_request_removed

    //PullRequestReviewEvent
    case submitted
    
    //PullRequestReviewEvent
    case dismissed
    
    //ReleaseEvent
    case published
    
    //RepositoryEvent
    case publicized
    
    //RepositoryEvent
    case privatized
    
    //TeamEvent
    case added_to_repository
    
    //TeamEvent
    case removed_from_repository
    
    //WatchEvent
    case started
}

class ObjEventPayload: NSObject, Mappable {

    var action: EventAction?
    var issue: ObjIssue?
    var comment: ObjComment?
    var ref: String?
    var ref_type: String?
    
    var master_branch: String?
    var cdescription: String?
    var pusher_type: String?
    var sender: ObjUser?
    var push_id: Int?
    
    var size: Int?
    var distinct_size: Int?
    var head: String?
    var before: String?
    var commits: [ObjCommit]?
    
    var member: ObjMember?
    var pull_request: ObjPullRequest?
    var number: Int?
    var cpublic: Bool?  //对应public，添加c为前缀
    var release: ObjRelease?
    var forkee: ObjRepos?
    
    //GollumEvent
    var pages: [ObjPage]?

    required init?(map: Map) {
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
        sender <- map["sender"]
        push_id <- map["push_id"]
        
        size <- map["size"]
        distinct_size <- map["distinct_size"]
        head <- map["head"]
        before <- map["before"]
        commits <- map["commits"]
        
        number <- map["number"]
        cpublic <- map["public"]
        pull_request <- map["pull_request"]
        release <- map["release"]
        member <- map["member"]
        
        forkee <- map["forkee"]
        pages <- map["pages"]
    }

}
