//
//  ObjLinks.swift
//  BeeFun
//
//  Created by WengHengcong on 15/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper
/*
{
    "self": {
        "href": "https://api.github.com/repos/octocat/Hello-World/pulls/1347"
    },
    "html": {
        "href": "https://github.com/octocat/Hello-World/pull/1347"
    },
    "issue": {
        "href": "https://api.github.com/repos/octocat/Hello-World/issues/1347"
    },
    "comments": {
        "href": "https://api.github.com/repos/octocat/Hello-World/issues/1347/comments"
    },
    "review_comments": {
        "href": "https://api.github.com/repos/octocat/Hello-World/pulls/1347/comments"
    },
    "review_comment": {
        "href": "https://api.github.com/repos/octocat/Hello-World/pulls/comments{/number}"
    },
    "commits": {
        "href": "https://api.github.com/repos/octocat/Hello-World/pulls/1347/commits"
    },
    "statuses": {
        "href": "https://api.github.com/repos/octocat/Hello-World/statuses/6dcb09b5b57875f334f61aebed695e2e4193db5e"
    }
}
*/

class ObjLinks: NSObject, Mappable {
    
    var cself: ObjHref?
    var html: ObjHref?
    var issue: ObjHref?
    var comments: ObjHref?
    var review_comments: ObjHref?
    var review_comment: ObjHref?
    var commits: ObjHref?
    var statuses: ObjHref?

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        cself <- map["self"]
        html <- map["html"]
        issue <- map["issue"]
        comments <- map["comments"]
        review_comments <- map["sha"]
        review_comment <- map["sha"]
        commits <- map["sha"]
        statuses <- map["sha"]
    }
}
