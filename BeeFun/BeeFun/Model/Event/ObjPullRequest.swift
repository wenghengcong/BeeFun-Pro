//
//  ObjPullRequest.swift
//  BeeFun
//
//  Created by WengHengcong on 15/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper
/*
{
    "id": 1,
    "url": "https://api.github.com/repos/octocat/Hello-World/pulls/1347",
    "html_url": "https://github.com/octocat/Hello-World/pull/1347",
    "diff_url": "https://github.com/octocat/Hello-World/pull/1347.diff",
    "patch_url": "https://github.com/octocat/Hello-World/pull/1347.patch",
    "issue_url": "https://api.github.com/repos/octocat/Hello-World/issues/1347",
    "commits_url": "https://api.github.com/repos/octocat/Hello-World/pulls/1347/commits",
    "review_comments_url": "https://api.github.com/repos/octocat/Hello-World/pulls/1347/comments",
    "review_comment_url": "https://api.github.com/repos/octocat/Hello-World/pulls/comments{/number}",
    "comments_url": "https://api.github.com/repos/octocat/Hello-World/issues/1347/comments",
    "statuses_url": "https://api.github.com/repos/octocat/Hello-World/statuses/6dcb09b5b57875f334f61aebed695e2e4193db5e",
    "number": 1347,
    "state": "open",
    "title": "new-feature",
    "body": "Please pull these awesome changes",
    "assignee": {
    },
    "milestone": {
        
    },
    "locked": false,
    "created_at": "2011-01-26T19:01:12Z",
    "updated_at": "2011-01-26T19:01:12Z",
    "closed_at": "2011-01-26T19:01:12Z",
    "merged_at": "2011-01-26T19:01:12Z",
    "head": {
        
    },
    "base": {
        
    },
    "_links": {
    },
    "user": {
    }
}
 */
class ObjPullRequest: NSObject, Mappable {
    
    var id: Int?
    var _links: ObjLinks?
    var url: String?
    var html_url: String?
    var diff_url: String?
    var patch_url: String?
    var issue_url: String?
    var commits_url: String?
    var review_comments_url: String?
    var review_comment_url: String?
    var comments_url: String?
    var statuses_url: String?
    var body: String?
    var number: Int?
    var state: String?
    var locked: Int?
    var title: String?
    var additions: Int?
    var milestone: ObjMilestone?
    
    var created_at: String?
    var updated_at: String?
    var closed_at: String?
    var merged_at: String?
    var merge_commit_sha: String?
    //值可为：OWNER、NONE、 CONTRIBUTOR、COLLABORATOR
    var author_association: String?
    var assignee: ObjUser?
    var assignees: [ObjUser]?

    var base: ObjBranch?
    var head: ObjBranch?
    
    var changed_files: Int?
    var comments: Int?
    var commits: Int?
    var deletions: Int?
    var maintainer_can_modify: Bool?
    
    var mergeable_state: String?
    var merged: Bool?
    var merged_by: ObjUser?
    
    var rebaseable: Bool?
    var review_comments: Int?
    
    var mergeable: Bool?
    //不确定以下值类型
    var requested_reviewers: [ObjUser]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        //        super.mapping(map)
        id <- map["id"]
        _links <- map["_links"]
        url <- map["url"]
        html_url <- map["html_url"]
        diff_url <- map["diff_url"]
        patch_url <- map["patch_url"]
        issue_url <- map["issue_url"]
        commits_url <- map["commits_url"]
        review_comments_url <- map["review_comments_url"]
        review_comment_url <- map["review_comment_url"]
        comments_url <- map["comments_url"]
        statuses_url <- map["statuses_url"]
        body <- map["body"]
        number <- map["number"]
        
        state <- map["state"]
        locked <- map["locked"]
        title <- map["title"]
        milestone <- map["milestone"]
        additions <- map["additions"]
        
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        closed_at <- map["closed_at"]
        merged_at <- map["merged_at"]
        merge_commit_sha <- map["merge_commit_sha"]
        
        author_association <- map["author_association"]
        assignee <- map["assignee"]
        assignees <- map["assignees"]
        base <- map["base"]
        head <- map["head"]
        
        changed_files <- map["changed_files"]
        comments <- map["comments"]
        
        commits <- map["commits"]
        deletions <- map["deletions"]
        maintainer_can_modify <- map["maintainer_can_modify"]
        mergeable_state <- map["mergeable_state"]
        merged <- map["merged"]
        merged_by <- map["merged_by"]
        rebaseable <- map["rebaseable"]
        review_comments <- map["review_comments"]
        mergeable <- map["mergeable"]
        requested_reviewers <- map["requested_reviewers"]
    }
}
