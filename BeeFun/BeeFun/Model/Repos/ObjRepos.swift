//
//  ObjRepos.swift
//  BeeFun
//
//  Created by wenghengcong on 16/1/23.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import Foundation
import ObjectMapper
/*
 {
 "id": 3739481,
 "name": "ZXingObjC",
 "full_name": "TheLevelUp/ZXingObjC",
 "owner": {
     "login": "TheLevelUp",
     "id": 1521628,
     "avatar_url": "https://avatars3.githubusercontent.com/u/1521628?v=4",
     "gravatar_id": "",
     "url": "https://api.github.com/users/TheLevelUp",
     "html_url": "https://github.com/TheLevelUp",
     "followers_url": "https://api.github.com/users/TheLevelUp/followers",
     "following_url": "https://api.github.com/users/TheLevelUp/following{/other_user}",
     "gists_url": "https://api.github.com/users/TheLevelUp/gists{/gist_id}",
     "starred_url": "https://api.github.com/users/TheLevelUp/starred{/owner}{/repo}",
     "subscriptions_url": "https://api.github.com/users/TheLevelUp/subscriptions",
     "organizations_url": "https://api.github.com/users/TheLevelUp/orgs",
     "repos_url": "https://api.github.com/users/TheLevelUp/repos",
     "events_url": "https://api.github.com/users/TheLevelUp/events{/privacy}",
     "received_events_url": "https://api.github.com/users/TheLevelUp/received_events",
     "type": "Organization",
     "site_admin": false
 },
 "private": false,
 "html_url": "https://github.com/TheLevelUp/ZXingObjC",
 "description": "An Objective-C Port of ZXing",
 "fork": false,
 "url": "https://api.github.com/repos/TheLevelUp/ZXingObjC",
 "forks_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/forks",
 "keys_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/keys{/key_id}",
 "collaborators_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/collaborators{/collaborator}",
 "teams_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/teams",
 "hooks_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/hooks",
 "issue_events_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/issues/events{/number}",
 "events_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/events",
 "assignees_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/assignees{/user}",
 "branches_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/branches{/branch}",
 "tags_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/tags",
 "blobs_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/git/blobs{/sha}",
 "git_tags_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/git/tags{/sha}",
 "git_refs_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/git/refs{/sha}",
 "trees_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/git/trees{/sha}",
 "statuses_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/statuses/{sha}",
 "languages_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/languages",
 "stargazers_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/stargazers",
 "contributors_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/contributors",
 "subscribers_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/subscribers",
 "subscription_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/subscription",
 "commits_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/commits{/sha}",
 "git_commits_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/git/commits{/sha}",
 "comments_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/comments{/number}",
 "issue_comment_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/issues/comments{/number}",
 "contents_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/contents/{+path}",
 "compare_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/compare/{base}...{head}",
 "merges_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/merges",
 "archive_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/{archive_format}{/ref}",
 "downloads_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/downloads",
 "issues_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/issues{/number}",
 "pulls_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/pulls{/number}",
 "milestones_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/milestones{/number}",
 "notifications_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/notifications{?since,all,participating}",
 "labels_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/labels{/name}",
 "releases_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/releases{/id}",
 "deployments_url": "https://api.github.com/repos/TheLevelUp/ZXingObjC/deployments",
 "created_at": "2012-03-16T14:09:18Z",
 "updated_at": "2018-05-02T02:14:07Z",
 "pushed_at": "2018-04-18T07:42:30Z",
 "git_url": "git://github.com/TheLevelUp/ZXingObjC.git",
 "ssh_url": "git@github.com:TheLevelUp/ZXingObjC.git",
 "clone_url": "https://github.com/TheLevelUp/ZXingObjC.git",
 "svn_url": "https://github.com/TheLevelUp/ZXingObjC",
 "homepage": "",
 "size": 187508,
 "stargazers_count": 2644,
 "watchers_count": 2644,
 "language": "Objective-C",
 "has_issues": true,
 "has_projects": false,
 "has_downloads": true,
 "has_wiki": true,
 "has_pages": false,
 "forks_count": 666,
 "mirror_url": null,
 "archived": false,
 "open_issues_count": 21,
 "license": {
     "key": "apache-2.0",
     "name": "Apache License 2.0",
     "spdx_id": "Apache-2.0",
     "url": "https://api.github.com/licenses/apache-2.0"
 },
 "forks": 666,
 "open_issues": 21,
 "watchers": 2644,
 "default_branch": "master",
 "permissions": {
     "admin": false,
     "push": false,
     "pull": true
 }
 }
*/

public class ObjRepos: NSObject, Mappable {

    //1
    var archive_url: String?
    var assignees_url: String?
    var blobs_url: String?
    var branches_url: String?
    var clone_url: String?
    var collaborators_url: String?
    var comments_url: String?
    var commits_url: String?
    var compare_url: String?
    var contents_url: String?

    //11
    var contributors_url: String?
    var created_at: String?
    var default_branch: String?
    var deployments_url: String?
    var cdescription: String?            //description同关键字冲突，加c前缀
    var downloads_url: String?
    var events_url: String?
    var fork: Bool?
    var forks: Int?
    var forks_count: Int?

    //21
    var forks_url: String?
    var full_name: String?
    var git_commits_url: String?
    var git_refs_url: String?
    var git_tags_url: String?
    var git_url: String?
    var has_downloads: Bool?
    var has_projects: Bool?
    var has_issues: Bool?
    var has_pages: Bool?
    var has_wiki: Bool?

    //31
    var homepage: String?
    var hooks_url: String?
    var html_url: String?
    var id: Int?
    var issue_comment_url: String?
    var issue_events_url: String?
    var issues_url: String?
    var keys_url: String?
    var labels_url: String?
    var language: String?

    //41
    var languages_url: String?
    var merges_url: String?
    var milestones_url: String?
    var mirror_url: String?
    var name: String?
    var notifications_url: String?
    var open_issues: Int?
    var open_issues_count: Int?
    var owner: ObjUser?
    var star_owner: String?
    var permissions: ObjPermissions?

    //51
    var cprivate: Bool?              //private同关键字冲突，加c前缀
    var pulls_url: String?
    var pushed_at: String?
    var releases_url: String?
    var size: Int?
    var ssh_url: String?
    var stargazers_count: Int?
    var stargazers_url: String?
    var statuses_url: String?
    var subscribers_url: String?

    //61
    var subscription_url: String?
    var svn_url: String?
    var tags_url: String?
    var teams_url: String?
    var trees_url: String?
    var updated_at: String?
    var url: String?
    var watchers: Int?
    var watchers_count: Int?
    var subscribers_count: Int?

    //以下字段为单独增加
    var star_tags: [String]?
    var star_lists: [String]?
    /// 是否订阅该项目
    var watched: Bool? = false
    /// 是否关注该项目
    var starred: Bool? = false
    /// 关注该repo的时间，从网络请求中截取
    var starred_at: String?
    
    /// Trending中
    var trending_star_text: String?                       /// star
    var trending_fork_text: String?                       /// star
    var trending_star_interval_text: String?                     /// 200 stars this week
    var trending_showcase_update_text: String?              ///Updated Jul 5, 2017
    var score: Double?  //搜索得分
    
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
        static let hasProjects = "has_projects"
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
        static let starOwnerKey = "star_owner"
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
        static let subscribersCountKey = "subscribers_count"

        static let starTagsKey = "star_tags"
        static let starListKey = "star_lists"
        static let watchedKey = "watched"
        static let scoreKey = "score"
        
        static let starred_atKey = "starred_at"
        
        static let trending_star_textKey = "trending_star_text"
        static let trending_fork_textKey = "trending_fork_text"
        static let trending_star_interval_textKey = "trending_star_interval_text"
        static let trending_showcase_update_textKey = "trending_showcase_update_text"
    }

    // MARK: init and mapping
    required public init?(map: Map) {
    }

    override init() {
        super.init()
    }

    public func mapping(map: Map) {
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
        has_projects <- map[ReposKey.hasProjects]
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
        star_owner <- map[ReposKey.starOwnerKey]
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
        subscribers_count <- map[ReposKey.subscribersCountKey]
        score <- map[ReposKey.scoreKey]
        starred_at <- map[ReposKey.starred_atKey]
        
        star_tags <- map[ReposKey.starTagsKey]
        star_lists <- map[ReposKey.starListKey]
        trending_fork_text <- map[ReposKey.trending_fork_textKey]
        trending_star_text <- map[ReposKey.trending_star_textKey]
        trending_star_interval_text <- map[ReposKey.trending_star_interval_textKey]
        trending_showcase_update_text <- map[ReposKey.trending_showcase_update_textKey]
    }

}
