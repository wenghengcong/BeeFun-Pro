//
//  ObjAsset.swift
//  BeeFun
//
//  Created by WengHengcong on 26/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper
/*
 {
     "url": "https://api.github.com/repos/octocat/Hello-World/releases/assets/1",
     "browser_download_url": "https://github.com/octocat/Hello-World/releases/download/v1.0.0/example.zip",
     "id": 1,
     "name": "example.zip",
     "label": "short description",
     "state": "uploaded",
     "content_type": "application/zip",
     "size": 1024,
     "download_count": 42,
     "created_at": "2013-02-27T19:35:32Z",
     "updated_at": "2013-02-27T19:35:32Z",
     "uploader": {
         "login": "octocat",
         "id": 1,
         "avatar_url": "https://github.com/images/error/octocat_happy.gif",
         "gravatar_id": "",
         "url": "https://api.github.com/users/octocat",
         "html_url": "https://github.com/octocat",
         "followers_url": "https://api.github.com/users/octocat/followers",
         "following_url": "https://api.github.com/users/octocat/following{/other_user}",
         "gists_url": "https://api.github.com/users/octocat/gists{/gist_id}",
         "starred_url": "https://api.github.com/users/octocat/starred{/owner}{/repo}",
         "subscriptions_url": "https://api.github.com/users/octocat/subscriptions",
         "organizations_url": "https://api.github.com/users/octocat/orgs",
         "repos_url": "https://api.github.com/users/octocat/repos",
         "events_url": "https://api.github.com/users/octocat/events{/privacy}",
         "received_events_url": "https://api.github.com/users/octocat/received_events",
         "type": "User",
         "site_admin": false
    }
 }
 */
class ObjAsset: Mappable {

    var url: String?
    var browser_download_url: String?
    var id: ObjUser?
    
    var name: String?
    var label: String?
    var state: Bool?
    var content_type: String?
    var size: Int?
    var download_count: Int?
    var created_at: Bool?
    var updated_at: String?
    var uploader: ObjUser?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        url <- map["url"]
        browser_download_url <- map["browser_download_url"]
        id <- map["id"]
        name <- map["name"]
        label <- map["label"]
        state <- map["state"]
        content_type <- map["content_type"]
        size <- map["size"]
        download_count <- map["download_count"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        uploader <- map["uploader"]

    }
    
}
