//
//  ObjEvent.swift
//  BeeFun
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

/// Event
///
/// - commitCommentEvent: Triggered when a commit comment is created
/// - createEvent: Represents a created repository, branch, or tag.
/// - deleteEvent: Represents a deleted branch or tag.
/// - deploymentEvent: <#deploymentEvent description#>
/// - deploymentStatusEvent: <#deploymentStatusEvent description#>
/// - downloadEvent: <#downloadEvent description#>
/// - followEvent: <#followEvent description#>
/// - forkEvent: <#forkEvent description#>
/// - forkApplyEvent: <#forkApplyEvent description#>
/// - gistEvent: <#gistEvent description#>
/// - gollumEvent: <#gollumEvent description#>
/// - installationEvent: <#installationEvent description#>
/// - installationRepositoriesEvent: <#installationRepositoriesEvent description#>
/// - issuesEvent: <#issuesEvent description#>
/// - issueCommentEvent: <#issueCommentEvent description#>
/// - labelEvent: <#labelEvent description#>
/// - marketplacePurchaseEvent: <#marketplacePurchaseEvent description#>
/// - memberEvent: <#memberEvent description#>
/// - membershipEvent: <#membershipEvent description#>
/// - milestoneEvent: <#milestoneEvent description#>
/// - organizationEvent: <#organizationEvent description#>
/// - OrgBlockEvent: <#OrgBlockEvent description#>
/// - pageBuildEvent: <#pageBuildEvent description#>
/// - projectCardEvent: <#projectCardEvent description#>
/// - projectColumnEvent: <#projectColumnEvent description#>
/// - projectEvent: <#projectEvent description#>
/// - publicEvent: <#publicEvent description#>
/// - pullRequestEvent: <#pullRequestEvent description#>
/// - pullRequestReviewEvent: <#pullRequestReviewEvent description#>
/// - pullRequestReviewCommentEvent: <#pullRequestReviewCommentEvent description#>
/// - pushEvent: <#pushEvent description#>
/// - releaseEvent: <#releaseEvent description#>
/// - repositoryEvent: <#repositoryEvent description#>
/// - statusEvent: <#statusEvent description#>
/// - teamEvent: <#teamEvent description#>
/// - teamAddEvent: <#teamAddEvent description#>
/// - watchEvent: <#watchEvent description#>
public enum EventType: String {

    case commitCommentEvent = "CommitCommentEvent"
    case createEvent = "CreateEvent"
    case deleteEvent = "DeleteEvent"
    case deploymentEvent = "DeploymentEvent"
    case deploymentStatusEvent = "DeploymentStatusEvent"
    case downloadEvent = "DownloadEvent"
    case followEvent = "FollowEvent"
    case forkEvent = "ForkEvent"
    case forkApplyEvent = "ForkApplyEvent"
    case gistEvent = "GistEvent"
    case gollumEvent = "GollumEvent"
    case installationEvent = "InstallationEvent"
    case installationRepositoriesEvent = "InstallationRepositoriesEvent"
    case issuesEvent = "IssuesEvent"
    case issueCommentEvent = "IssueCommentEvent"
    case labelEvent = "LabelEvent"
    case marketplacePurchaseEvent = "MarketplacePurchaseEvent"
    case memberEvent = "MemberEvent"
    case membershipEvent = "MembershipEvent"
    case milestoneEvent = "MilestoneEvent"
    case organizationEvent = "OrganizationEvent"
    case OrgBlockEvent = "OrgBlockEvent"
    case pageBuildEvent = "PageBuildEvent"
    case projectCardEvent = "ProjectCardEvent"
    case projectColumnEvent = "ProjectColumnEvent"
    case projectEvent = "ProjectEvent"
    case publicEvent = "PublicEvent"
    case pullRequestEvent = "PullRequestEvent"
    case pullRequestReviewEvent = "PullRequestReviewEvent"
    case pullRequestReviewCommentEvent = "PullRequestReviewCommentEvent"
    case pushEvent = "PushEvent"
    case releaseEvent = "ReleaseEvent"
    case repositoryEvent = "RepositoryEvent"
    case statusEvent = "StatusEvent"
    case teamEvent = "TeamEvent"
    case teamAddEvent = "TeamAddEvent"
    case watchEvent = "WatchEvent"

}

public enum CreateEventType: String {

    case CreateRepositoryEvent = "repository"
    case CreateBranchEvent = "branch"
    case CreateTagEvent = "tag"

}

class ObjEvent: NSObject, Mappable {

    var id: String?
    var type: EventType?
    var actor: ObjUser?
    var repo: ObjRepos?
    var payload: ObjEventPayload?
    var org: ObjUser?
    var cpublic: Bool?           //"public" is keyword,so add "c" prefix
    var created_at: String?

    //TODO: org is organization
    //var org:String?

    override init() {
        super.init()
    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
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
