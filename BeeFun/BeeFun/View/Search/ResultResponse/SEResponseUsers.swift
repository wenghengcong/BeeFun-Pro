//
//  ObjSearchUserResponse.swift
//  BeeFun
//
//  Created by WengHengcong on 3/9/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper

/*
{
"total_count": 9680799,
"incomplete_results": true,
"items": [
{
"login": "torvalds",
"id": 1024025,
"avatar_url": "https://avatars.githubusercontent.com/u/1024025?v=3",
"gravatar_id": "",
"url": "https://api.github.com/users/torvalds",
"html_url": "https://github.com/torvalds",
"followers_url": "https://api.github.com/users/torvalds/followers",
"following_url": "https://api.github.com/users/torvalds/following{/other_user}",
"gists_url": "https://api.github.com/users/torvalds/gists{/gist_id}",
"starred_url": "https://api.github.com/users/torvalds/starred{/owner}{/repo}",
"subscriptions_url": "https://api.github.com/users/torvalds/subscriptions",
"organizations_url": "https://api.github.com/users/torvalds/orgs",
"repos_url": "https://api.github.com/users/torvalds/repos",
"events_url": "https://api.github.com/users/torvalds/events{/privacy}",
"received_events_url": "https://api.github.com/users/torvalds/received_events",
"type": "User",
"site_admin": false,
"score": 1
},
{
"login": "tj",
"id": 25254,
"avatar_url": "https://avatars.githubusercontent.com/u/25254?v=3",
"gravatar_id": "",
"url": "https://api.github.com/users/tj",
"html_url": "https://github.com/tj",
"followers_url": "https://api.github.com/users/tj/followers",
"following_url": "https://api.github.com/users/tj/following{/other_user}",
"gists_url": "https://api.github.com/users/tj/gists{/gist_id}",
"starred_url": "https://api.github.com/users/tj/starred{/owner}{/repo}",
"subscriptions_url": "https://api.github.com/users/tj/subscriptions",
"organizations_url": "https://api.github.com/users/tj/orgs",
"repos_url": "https://api.github.com/users/tj/repos",
"events_url": "https://api.github.com/users/tj/events{/privacy}",
"received_events_url": "https://api.github.com/users/tj/received_events",
"type": "User",
"site_admin": false,
"score": 1
}
]
}
*/

class SEResponseUsers: NSObject, Mappable {

    var totalCount: Int?
    var incompleteResults: Bool?
    var items: [ObjUser]?

    override init() {
        super.init()
    }
    
    required init?(map: Map) {
    }

    func mapping(map: Map) {
        //        super.mapping(map)
        totalCount <- map["total_count"]
        incompleteResults <- map["incomplete_results"]
        items <- map["items"]
    }

}
