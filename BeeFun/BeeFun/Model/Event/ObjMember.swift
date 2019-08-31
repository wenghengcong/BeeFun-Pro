//
//  ObjMember.swift
//  BeeFun
//
//  Created by WengHengcong on 26/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper
/*
{
    "avatar_url": "https://avatars1.githubusercontent.com/u/170270?v=4",
    "events_url": "https://api.github.com/users/sindresorhus/events{/privacy}",
    "followers_url": "https://api.github.com/users/sindresorhus/followers",
    "following_url": "https://api.github.com/users/sindresorhus/following{/other_user}",
    "gists_url": "https://api.github.com/users/sindresorhus/gists{/gist_id}",
    "gravatar_id": "",
    "html_url": "https://github.com/sindresorhus",
    "id": 170270,
    "login": "sindresorhus",
    "organizations_url": "https://api.github.com/users/sindresorhus/orgs",
    "received_events_url": "https://api.github.com/users/sindresorhus/received_events",
    "repos_url": "https://api.github.com/users/sindresorhus/repos",
    "site_admin": false,
    "starred_url": "https://api.github.com/users/sindresorhus/starred{/owner}{/repo}",
    "subscriptions_url": "https://api.github.com/users/sindresorhus/subscriptions",
    "type": "User",
    "url": "https://api.github.com/users/sindresorhus"
}
 */
class ObjMember: Mappable {
    
    var avatar_url: String?
    var events_url: String?
    var followers_url: Int?
    var following_url: String?
    var gists_url: String?
    
    var gravatar_id: String?
    var html_url: String?
    var id: Int?
    var login: String?
    var organizations_url: String?
    
    var received_events_url: String?
    var repos_url: String?
    var site_admin: Bool?
    var starred_url: String?
    var subscriptions_url: String?
    
    var type: String?
    var url: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        avatar_url <- map["avatar_url"]
        events_url <- map["events_url"]
        followers_url <- map["followers_url"]
        following_url <- map["following_url"]
        gists_url <- map["gists_url"]
        gravatar_id <- map["gravatar_id"]
        html_url <- map["html_url"]
        id <- map["id"]
        organizations_url <- map["organizations_url"]
        received_events_url <- map["received_events_url"]
        repos_url <- map["repos_url"]
        site_admin <- map["site_admin"]
        starred_url <- map["starred_url"]
        subscriptions_url <- map["subscriptions_url"]
        type <- map["type"]
        url <- map["url"]
    }
    
}
