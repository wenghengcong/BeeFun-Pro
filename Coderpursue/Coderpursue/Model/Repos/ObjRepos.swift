//
//  ObjRepos.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/23.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
/*
"archive_url" = "https://api.github.com/repos/wenghengcong/Alamofire/{archive_format}{/ref}";
"assignees_url" = "https://api.github.com/repos/wenghengcong/Alamofire/assignees{/user}";
"blobs_url" = "https://api.github.com/repos/wenghengcong/Alamofire/git/blobs{/sha}";
"branches_url" = "https://api.github.com/repos/wenghengcong/Alamofire/branches{/branch}";
"clone_url" = "https://github.com/wenghengcong/Alamofire.git";
"collaborators_url" = "https://api.github.com/repos/wenghengcong/Alamofire/collaborators{/collaborator}";
"comments_url" = "https://api.github.com/repos/wenghengcong/Alamofire/comments{/number}";
"commits_url" = "https://api.github.com/repos/wenghengcong/Alamofire/commits{/sha}";
"compare_url" = "https://api.github.com/repos/wenghengcong/Alamofire/compare/{base}...{head}";
"contents_url" = "https://api.github.com/repos/wenghengcong/Alamofire/contents/{+path}";
"contributors_url" = "https://api.github.com/repos/wenghengcong/Alamofire/contributors";
"created_at" = "2015-09-17T15:29:50Z";
"default_branch" = master;
"deployments_url" = "https://api.github.com/repos/wenghengcong/Alamofire/deployments";
description = "Elegant HTTP Networking in Swift";
"downloads_url" = "https://api.github.com/repos/wenghengcong/Alamofire/downloads";
"events_url" = "https://api.github.com/repos/wenghengcong/Alamofire/events";
fork = 1;
forks = 0;
"forks_count" = 0;
"forks_url" = "https://api.github.com/repos/wenghengcong/Alamofire/forks";
"full_name" = "wenghengcong/Alamofire";
"git_commits_url" = "https://api.github.com/repos/wenghengcong/Alamofire/git/commits{/sha}";
"git_refs_url" = "https://api.github.com/repos/wenghengcong/Alamofire/git/refs{/sha}";
"git_tags_url" = "https://api.github.com/repos/wenghengcong/Alamofire/git/tags{/sha}";
"git_url" = "git://github.com/wenghengcong/Alamofire.git";
"has_downloads" = 1;
"has_issues" = 0;
"has_pages" = 0;
"has_wiki" = 0;
homepage = "";
"hooks_url" = "https://api.github.com/repos/wenghengcong/Alamofire/hooks";
"html_url" = "https://github.com/wenghengcong/Alamofire";
id = 42664539;
"issue_comment_url" = "https://api.github.com/repos/wenghengcong/Alamofire/issues/comments{/number}";
"issue_events_url" = "https://api.github.com/repos/wenghengcong/Alamofire/issues/events{/number}";
"issues_url" = "https://api.github.com/repos/wenghengcong/Alamofire/issues{/number}";
"keys_url" = "https://api.github.com/repos/wenghengcong/Alamofire/keys{/key_id}";
"labels_url" = "https://api.github.com/repos/wenghengcong/Alamofire/labels{/name}";
language = Swift;
"languages_url" = "https://api.github.com/repos/wenghengcong/Alamofire/languages";
"merges_url" = "https://api.github.com/repos/wenghengcong/Alamofire/merges";
"milestones_url" = "https://api.github.com/repos/wenghengcong/Alamofire/milestones{/number}";
"mirror_url" = "<null>";
name = Alamofire;
"notifications_url" = "https://api.github.com/repos/wenghengcong/Alamofire/notifications{?since,all,participating}";
"open_issues" = 0;
"open_issues_count" = 0;
owner =     {
"avatar_url" = "https://avatars.githubusercontent.com/u/3964406?v=3";
"events_url" = "https://api.github.com/users/wenghengcong/events{/privacy}";
"followers_url" = "https://api.github.com/users/wenghengcong/followers";
"following_url" = "https://api.github.com/users/wenghengcong/following{/other_user}";
"gists_url" = "https://api.github.com/users/wenghengcong/gists{/gist_id}";
"gravatar_id" = "";
"html_url" = "https://github.com/wenghengcong";
id = 3964406;
login = wenghengcong;
"organizations_url" = "https://api.github.com/users/wenghengcong/orgs";
"received_events_url" = "https://api.github.com/users/wenghengcong/received_events";
"repos_url" = "https://api.github.com/users/wenghengcong/repos";
"site_admin" = 0;
"starred_url" = "https://api.github.com/users/wenghengcong/starred{/owner}{/repo}";
"subscriptions_url" = "https://api.github.com/users/wenghengcong/subscriptions";
type = User;
url = "https://api.github.com/users/wenghengcong";
};
permissions =     {
admin = 1;
pull = 1;
push = 1;
};
private = 0;
"pulls_url" = "https://api.github.com/repos/wenghengcong/Alamofire/pulls{/number}";
"pushed_at" = "2015-09-17T05:49:05Z";
"releases_url" = "https://api.github.com/repos/wenghengcong/Alamofire/releases{/id}";
size = 1397;
"ssh_url" = "git@github.com:wenghengcong/Alamofire.git";
"stargazers_count" = 0;
"stargazers_url" = "https://api.github.com/repos/wenghengcong/Alamofire/stargazers";
"statuses_url" = "https://api.github.com/repos/wenghengcong/Alamofire/statuses/{sha}";
"subscribers_url" = "https://api.github.com/repos/wenghengcong/Alamofire/subscribers";
"subscription_url" = "https://api.github.com/repos/wenghengcong/Alamofire/subscription";
"svn_url" = "https://github.com/wenghengcong/Alamofire";
"tags_url" = "https://api.github.com/repos/wenghengcong/Alamofire/tags";
"teams_url" = "https://api.github.com/repos/wenghengcong/Alamofire/teams";
"trees_url" = "https://api.github.com/repos/wenghengcong/Alamofire/git/trees{/sha}";
"updated_at" = "2015-09-17T15:29:51Z";
url = "https://api.github.com/repos/wenghengcong/Alamofire";
watchers = 0;
"watchers_count" = 0;

*/

class ObjRepos: NSObject,Mappable {
    
    var archive_url:String?
    var assignees_url:String?
    var blobs_url:String?
    var branches_url:String?
    
    var clone_url:String?
    var collaborators_url:String?
    var comments_url:String?
    var commits_url:String?
    
    var compare_url:String?
    var contents_url:String?
    var contributors_url:String?
    var created_at:String?
    var default_branch:String?
    var deployments_url:String?
    var cdescription:String?            //description同关键字冲突，加c前缀
    var downloads_url:String?
    var events_url:String?
    var fork:Int?
    
    var forks:Int?
    var forks_count:Int?
    var forks_url:String?
    
    var full_name:String?
    var git_commits_url:String?
    var git_refs_url:String?
    var git_tags_url:String?
    var git_url:String?
    var has_downloads:Int?
    var has_issues:Int?
    var has_pages:Int?
    var has_wiki:Int?
    var homepage:String?
    var hooks_url:String?
    var html_url:String?
    var id :Int?
    var issue_comment_url:String?
    var issue_events_url:String?
    
    var issues_url:String?
    var keys_url:String?
    var labels_url:String?
    var language:String?
    var languages_url:String?
    var merges_url:String?
    var milestones_url:String?
    var mirror_url:String?
    var name:String?
    var notifications_url:String?
    var open_issues:Int?
    var open_issues_count:Int?
    var owner:ObjUser?
    var permissions:ObjPermissions?
    var cprivate:Bool?              //private同关键字冲突，加c前缀
    
    var pulls_url:String?
    var pushed_at:String?
    var releases_url:String?
    var size:Int?
    var ssh_url:String?
    var stargazers_count:Int?
    var stargazers_url:String?
    var statuses_url:String?
    var subscribers_url:String?
    var subscription_url:String?
    var svn_url:String?
    var tags_url:String?
    var teams_url:String?
    var trees_url:String?
    var updated_at:String?
    
    var url:String?
    var watchers:Int?
    var watchers_count:Int?
    var subscribers_count:Int?
    
    struct ReposKey {
        
        static let archiveUrlKey = "archive_url"
        static let assigneesUrlKey = "assignees_url"
        static let blobsUrlKey = "blobs_url"
        static let branchesUrlKey = "branches_url"
        
        static let cloneUrlKey = "clone_url"
        static let collaboratorsUrlKey = "collaborators_url"
        static let commentsUrlKey = "comments_url"
        static let commitsUrlKey = "commits_url"
        
        static let compareUrlKey = "compare_url"
        static let contentsUrlKey = "contents_url"
        static let contributorsUrlKey = "contributors_url"
        static let createdAtKey = "created_at"
        static let defaultBranchKey = "default_branch"
        static let deploymentsUrlKey = "deployments_url"
        static let descriptionKey = "description"
        static let downloadsUrlKey = "downloads_url"
        static let eventsUrlKey = "events_url"
        static let forkKey = "fork"
        
        static let forksKey = "forks"
        static let forksCountKey = "forks_count"
        static let forksUrlKey = "forks_url"
        
        static let fullNameKey = "full_name"
        static let gitCommitsUrlKey = "git_commits_url"
        static let gitRefsUrlKey = "git_refs_url"
        static let gitTagsUrlKey = "git_tags_url"
        static let gitUrlKey = "git_url"
        static let hasDownloadsKey = "has_downloads"
        static let hasIssuesKey = "has_issues"
        static let hasPagesKey = "has_pages"
        static let hasWikiKey = "has_wiki"
        static let homepageKey = "homepage"
        static let hooksUrlKey = "hooks_url"
        static let htmlUrlKey = "html_url"
        static let idKey = "id"
        static let issueCommentUrlKey = "issue_comment_url:"
        static let issueEventsUrlKey = "issue_events_url"
        
        static let issuesUrlKey = "issues_url"
        static let keysUrlKey = "keys_url"
        static let labelsUrlKey = "labels_url"
        static let languageKey = "language"
        static let languagesUrlKey = "languages_url"
        static let mergesUrlKey = "merges_url"
        static let milestonesUrlKey = "milestones_url"
        static let mirrorUrlKey = "mirror_url"
        static let nameKey = "name"
        static let notificationsUrlKey = "notifications_url"
        static let openIssuesKey = "open_issues"
        static let openIssuesCountKey = "open_issues_count"
        static let ownerKey = "owner"
        static let permissionsKey = "permissions"
        static let privateKey = "private"
        
        
        static let pullsUrlKey = "pulls_url"
        static let pushedAtKey = "pushed_at"
        static let releasesUrlKey = "releases_url"
        static let sizeKey = "size"
        static let sshUrley = "ssh_url"
        static let stargazersCountKey = "stargazers_count"
        static let stargazersUrlKey = "stargazers_url"
        static let statusesUrlKey = "statuses_url"
        static let subscribersUrlKey = "subscribers_url"
        static let subscriptionUrlKey = "subscription_url"
        static let svnUrlKey = "svn_url"
        static let tagsUrlKey = "tags_url"
        static let teamsUrlKey = "teams_url"
        static let treesUrlKey = "trees_url:"
        static let updatedAtKey = "updated_at"
        
        static let urlKey = "url"
        static let watchersKey = "watchers"
        static let watchersCountKey = "watchers_count"
        static let subscribersCount = "subscribers_count"
        

    }
    
    // MARK: init and mapping
    required init?(_ map: Map) {
        //        super.init(map)
        
    }
    
    override init() {
        
    }
    
    func mapping(map: Map) {
        //        super.mapping(map)
        
        archive_url <- map[ReposKey.archiveUrlKey]
        assignees_url <- map[ReposKey.assigneesUrlKey]
        blobs_url <- map[ReposKey.blobsUrlKey]
        branches_url <- map[ReposKey.branchesUrlKey]
        
        clone_url <- map[ReposKey.cloneUrlKey]
        collaborators_url <- map[ReposKey.collaboratorsUrlKey]
        comments_url <- map[ReposKey.commentsUrlKey]
        commits_url <- map[ReposKey.commitsUrlKey]
        
        compare_url <- map[ReposKey.compareUrlKey]
        contents_url <- map[ReposKey.contentsUrlKey]
        contributors_url <- map[ReposKey.contributorsUrlKey]
        created_at <- map[ReposKey.createdAtKey]
        default_branch <- map[ReposKey.defaultBranchKey]
        deployments_url <- map[ReposKey.deploymentsUrlKey]
        cdescription <- map[ReposKey.descriptionKey]
        downloads_url <- map[ReposKey.downloadsUrlKey]
        events_url <- map[ReposKey.eventsUrlKey]
        fork <- map[ReposKey.forkKey]
        
        forks <- map[ReposKey.forksKey]
        forks_count <- map[ReposKey.forksCountKey]
        forks_url <- map[ReposKey.forksUrlKey]
        
        full_name <- map[ReposKey.fullNameKey]
        git_commits_url <- map[ReposKey.gitCommitsUrlKey]
        git_refs_url <- map[ReposKey.gitRefsUrlKey]
        git_tags_url <- map[ReposKey.gitTagsUrlKey]
        git_url <- map[ReposKey.gitUrlKey]
        has_downloads <- map[ReposKey.hasDownloadsKey]
        has_issues <- map[ReposKey.hasIssuesKey]
        has_pages <- map[ReposKey.hasPagesKey]
        has_wiki <- map[ReposKey.hasWikiKey]
        homepage <- map[ReposKey.homepageKey]
        hooks_url <- map[ReposKey.hooksUrlKey]
        html_url <- map[ReposKey.htmlUrlKey]
        id <- map[ReposKey.idKey]
        issue_comment_url <- map[ReposKey.issueCommentUrlKey]
        issue_events_url <- map[ReposKey.issueEventsUrlKey]
        
        issues_url <- map[ReposKey.issuesUrlKey]
        keys_url <- map[ReposKey.keysUrlKey]
        labels_url <- map[ReposKey.labelsUrlKey]
        language <- map[ReposKey.languageKey]
        languages_url <- map[ReposKey.languagesUrlKey]
        merges_url <- map[ReposKey.mergesUrlKey]
        milestones_url <- map[ReposKey.milestonesUrlKey]
        mirror_url <- map[ReposKey.mirrorUrlKey]
        name <- map[ReposKey.nameKey]
        notifications_url <- map[ReposKey.notificationsUrlKey]
        open_issues <- map[ReposKey.openIssuesKey]
        open_issues_count <- map[ReposKey.openIssuesCountKey]
        owner <- map[ReposKey.ownerKey]
        permissions <- map[ReposKey.permissionsKey]
        cprivate <- map[ReposKey.privateKey]
        
        pulls_url <- map[ReposKey.pullsUrlKey]
        pushed_at <- map[ReposKey.pushedAtKey]
        releases_url <- map[ReposKey.releasesUrlKey]
        size <- map[ReposKey.sizeKey]
        ssh_url <- map[ReposKey.sshUrley]
        stargazers_count <- map[ReposKey.stargazersCountKey]
        stargazers_url <- map[ReposKey.stargazersUrlKey]
        statuses_url <- map[ReposKey.statusesUrlKey]
        subscribers_url <- map[ReposKey.subscribersUrlKey]
        subscription_url <- map[ReposKey.subscriptionUrlKey]
        svn_url <- map[ReposKey.svnUrlKey]
        tags_url <- map[ReposKey.gitTagsUrlKey]
        teams_url <- map[ReposKey.teamsUrlKey]
        trees_url <- map[ReposKey.treesUrlKey]
        updated_at <- map[ReposKey.updatedAtKey]
        
        url <- map[ReposKey.urlKey]
        watchers <- map[ReposKey.watchersKey]
        watchers_count <- map[ReposKey.watchersCountKey]
        subscribers_count <- map[ReposKey.subscribersCount]

    }

    
}
