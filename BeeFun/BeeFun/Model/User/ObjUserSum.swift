//
//  ObjUserSum.swift
//  BeeFun
//
//  Created by WengHengcong on 16/1/25.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper

/*
"login": "Mike19800206",
"id": 13727538,
"avatar_url": "https://avatars.githubusercontent.com/u/13727538?v=3",
"gravatar_id": "",
"url": "https://api.github.com/users/Mike19800206",
"html_url": "https://github.com/Mike19800206",
"followers_url": "https://api.github.com/users/Mike19800206/followers",
"following_url": "https://api.github.com/users/Mike19800206/following{/other_user}",
"gists_url": "https://api.github.com/users/Mike19800206/gists{/gist_id}",
"starred_url": "https://api.github.com/users/Mike19800206/starred{/owner}{/repo}",
"subscriptions_url": "https://api.github.com/users/Mike19800206/subscriptions",
"organizations_url": "https://api.github.com/users/Mike19800206/orgs",
"repos_url": "https://api.github.com/users/Mike19800206/repos",
"events_url": "https://api.github.com/users/Mike19800206/events{/privacy}",
"received_events_url": "https://api.github.com/users/Mike19800206/received_events",
"type": "User",
"site_admin": false
*/

class ObjUserSum: NSObject,Mappable {

    var login:String?       //wenghengcong
    var id:Int?;
    var avatar_url:String?
    var url:String?
    var html_url:String?
    var following_url:String?
    var followers_url:String?
    var gists_url:String?
    var starred_url:String?
    var subscriptions_url:String?
    var organizations_url:String?
    var repos_url:String?
    var events_url:String?
    var received_events_url:String?
    var type:String?
    var site_admin:Bool?

    struct UserSumKey {
        
        static let reposUrlKey = "repos_url"
        static let followingUrlKey = "following_url"
        static let followersUrlKey = "followers_url"
        static let organizationsUrlKey = "organizations_url"
        static let avatarUrlKey = "avatar_url"
        static let emailKey = "email"
        static let loginKey = "login"
        static let gistsUrlKey = "gists_url"
        
        static let typeKey = "type"
        static let starredUrlKey = "starred_url"
        static let idKey = "id"
        static let urlKey = "url"
        static let siteAdminKey = "site_admin"
        static let receivedRventsUrlKey = "received_events_url"
        static let subscriptionsUrlKey = "subscriptions_url"
        static let eventsUrlKey = "events_url"
        static let htmlUrlKey = "html_url:"
        
    }
    // MARK: init and mapping
    required init?(map: Map) {
        //        super.init(map)
        
    }
    
    
    func mapping(map: Map) {
        //        super.mapping(map)

        repos_url <- map[UserSumKey.reposUrlKey]
        following_url <- map[UserSumKey.followingUrlKey]
        followers_url <- map[UserSumKey.followersUrlKey]
        organizations_url <- map[UserSumKey.organizationsUrlKey]
        avatar_url <- map[UserSumKey.avatarUrlKey]
        login <- map[UserSumKey.loginKey]
        gists_url <- map[UserSumKey.gistsUrlKey]
        
        type <- map[UserSumKey.typeKey]
        starred_url <- map[UserSumKey.starredUrlKey]
        id <- map[UserSumKey.idKey]
        url <- map[UserSumKey.urlKey]
        site_admin <- map[UserSumKey.siteAdminKey]
        received_events_url <- map[UserSumKey.receivedRventsUrlKey]
        subscriptions_url <- map[UserSumKey.subscriptionsUrlKey]
        events_url <- map[UserSumKey.eventsUrlKey]
        html_url <- map[UserSumKey.htmlUrlKey]
        
    }

}
