//
//  ObjUser.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/14.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper

/*
"total_private_repos" : 0,
"public_repos" : 20,
"repos_url" : "https:\/\/api.github.com\/users\/wenghengcong\/repos",
"location" : "ShangHai",
"followers" : 7,
"bio" : null,
"organizations_url" : "https:\/\/api.github.com\/users\/wenghengcong\/orgs",
"type" : "User",
"blog" : "http:\/\/www.wenghengcong.com",
"starred_url" : "https:\/\/api.github.com\/users\/wenghengcong\/starred{\/owner}{\/repo}",
"owned_private_repos" : 0,
"id" : 3964406,
"name" : "wenghengcong",
"following" : 21,
"gists_url" : "https:\/\/api.github.com\/users\/wenghengcong\/gists{\/gist_id}",
"following_url" : "https:\/\/api.github.com\/users\/wenghengcong\/following{\/other_user}",
"updated_at" : "2016-01-13T21:28:22Z",
"collaborators" : 0,
"avatar_url" : "https:\/\/avatars.githubusercontent.com\/u\/3964406?v=3",
"gravatar_id" : "",
"url" : "https:\/\/api.github.com\/users\/wenghengcong",
"followers_url" : "https:\/\/api.github.com\/users\/wenghengcong\/followers",
"created_at" : "2013-03-25T13:03:12Z",
"private_gists" : 0,
"disk_usage" : 1022292,
"company" : null,
"hireable" : true,
"login" : "wenghengcong",
"site_admin" : false,
"public_gists" : 2,
"received_events_url" : "https:\/\/api.github.com\/users\/wenghengcong\/received_events",
"email" : "wenghengcong@gmail.com",
"plan" : {
"private_repos" : 0,
"collaborators" : 0,
"space" : 976562499,
"name" : "free"
},
"subscriptions_url" : "https:\/\/api.github.com\/users\/wenghengcong\/subscriptions",
"events_url" : "https:\/\/api.github.com\/users\/wenghengcong\/events{\/privacy}",
"html_url" : "https:\/\/github.com\/wenghengcong"
*/

class ObjUser: Mappable {

    // MARK: repos
    var total_private_repos:Int?;
    var public_repos:Int?;
    var owned_private_repos:Int?;
    var repos_url:String?
    
    // MARK: follower
    var followers:Int?;
    var following:Int?;
    var following_url:String?
    var followers_url:String?

    // MARK: user infomation
    var name:String?
    var bio:String?
    var organizations_url:String?
    var location:String?
    var blog:String?
    var avatar_url:String?
    var email:String?
    var company:String?
    var hireable:Bool?
    var login:String?       //wenghengcong

    // MARK: gist
    var private_gists:Int?;
    var public_gists:Int?;
    var gists_url:String?
    
    // MARK: github information
    var type:String?
    var starred_url:String?
    var id:Int?;
    var collaborators:Int?;
    var gravatar_id:Int?;
    var disk_usage:Int?;
    var url:String?
    var updated_at:String?
    var created_at:String?
    var site_admin:Bool?
    var received_events_url:String?
    var subscriptions_url:String?
    var events_url:String?
    var html_url:String?
    var plan:ObjPlan?
    
    // MARK: init and mapping
    required init?(_ map: Map) {
//        super.init(map)
        
    }
    
    func mapping(map: Map) {
//        super.mapping(map)

        total_private_repos <- map["total_private_repos"]
        public_repos <- map["public_repos"]
        owned_private_repos <- map["owned_private_repos"]
        repos_url <- map["repos_url"]
        
        followers <- map["followers"]
        following <- map["following"]
        following_url <- map["following_url"]
        followers_url <- map["followers_url"]
        
        name <- map["name"]
        bio <- map["bio"]
        organizations_url <- map["organizations_url"]
        location <- map["location"]
        blog <- map["blog"]
        avatar_url <- map["avatar_url"]
        email <- map["email"]
        company <- map["company"]
        hireable <- map["hireable"]
        login <- map["login"]
        
        private_gists <- map["private_gists"]
        public_gists <- map["public_gists"]
        gists_url <- map["gists_url"]
        
        type <- map["type"]
        starred_url <- map["starred_url"]
        id <- map["id"]
        gravatar_id <- map["gravatar_id"]
        disk_usage <- map["disk_usage"]
        url <- map["url"]
        updated_at <- map["updated_at"]
        created_at <- map["created_at"]
        site_admin <- map["site_admin"]
        received_events_url <- map["received_events_url"]
        subscriptions_url <- map["subscriptions_url"]
        events_url <- map["events_url"]
        html_url <- map["html_url"]
        plan <- map["plan"]
        
    }
}
