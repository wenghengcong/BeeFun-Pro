//
//  ObjUser.swift
//  BeeFun
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

class ObjUser: NSObject,NSCoding,Mappable {

    // MARK: repos
    var total_private_repos:Int?
    var public_repos:Int?
    var owned_private_repos:Int?
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
    var gravatar_id:String?;
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
    
    struct UserKey {
        
        static let totalPrivateReposKey = "total_private_repos"
        static let publicReposKey = "public_repos"
        static let ownedPrivateReposKey = "owned_private_repos"
        static let reposUrlKey = "repos_url"
        
        static let followersKey = "followers"
        static let followingKey = "following"
        static let followingUrlKey = "following_url"
        static let followersUrlKey = "followers_url"
        
        static let nameKey = "name"
        static let bioKey = "bio"
        static let organizationsUrlKey = "organizations_url"
        static let locationKey = "location"
        static let blogKey = "blog"
        static let avatarUrlKey = "avatar_url"
        static let emailKey = "email"
        static let companyKey = "company"
        static let hireableKey = "hireable"
        static let loginKey = "login"
        
        static let privateGistsKey = "private_gists"
        static let publicGistsKey = "public_gists"
        static let gistsUrlKey = "gists_url"
        
        static let typeKey = "type"
        static let starredUrlKey = "starred_url"
        static let idKey = "id"
        static let collaboratorsKey = "collaborators"
        static let gravatarIdKey = "gravatar_id"
        static let diskUsageKey = "disk_usage"
        static let urlKey = "url"
        static let updatedAtKey = "updated_at"
        static let createdAtKey = "created_at"
        static let siteAdminKey = "site_admin"
        static let receivedRventsUrlKey = "received_events_url"
        static let subscriptionsUrlKey = "subscriptions_url"
        static let eventsUrlKey = "events_url"
        static let htmlUrlKey = "html_url"
        static let planKey = "plan"

    }

    
    // MARK: init and mapping
    required init?(map: Map) {
//        super.init(map)
        
    }

    override init() {
        
    }
    
    func mapping(map: Map) {
//        super.mapping(map)

        total_private_repos <- map[UserKey.totalPrivateReposKey]
        public_repos <- map[UserKey.publicReposKey]
        owned_private_repos <- map[UserKey.ownedPrivateReposKey]
        repos_url <- map[UserKey.reposUrlKey]
        
        followers <- map[UserKey.followersKey]
        following <- map[UserKey.followingKey]
        following_url <- map[UserKey.followingUrlKey]
        followers_url <- map[UserKey.followersUrlKey]
        
        name <- map[UserKey.nameKey]
        bio <- map[UserKey.bioKey]
        organizations_url <- map[UserKey.organizationsUrlKey]
        location <- map[UserKey.locationKey]
        blog <- map[UserKey.blogKey]
        avatar_url <- map[UserKey.avatarUrlKey]
        email <- map[UserKey.emailKey]
        company <- map[UserKey.companyKey]
        hireable <- map[UserKey.hireableKey]
        login <- map[UserKey.loginKey]
        
        private_gists <- map[UserKey.privateGistsKey]
        public_gists <- map[UserKey.publicGistsKey]
        gists_url <- map[UserKey.gistsUrlKey]
        
        type <- map[UserKey.typeKey]
        starred_url <- map[UserKey.starredUrlKey]
        id <- map[UserKey.idKey]
        collaborators <- map[UserKey.collaboratorsKey]
        gravatar_id <- map[UserKey.gravatarIdKey]
        disk_usage <- map[UserKey.diskUsageKey]
        url <- map[UserKey.urlKey]
        updated_at <- map[UserKey.updatedAtKey]
        created_at <- map[UserKey.createdAtKey]
        site_admin <- map[UserKey.siteAdminKey]
        received_events_url <- map[UserKey.receivedRventsUrlKey]
        subscriptions_url <- map[UserKey.subscriptionsUrlKey]
        events_url <- map[UserKey.eventsUrlKey]
        html_url <- map[UserKey.htmlUrlKey]
        plan <- map[UserKey.planKey]
        
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(total_private_repos, forKey:UserKey.totalPrivateReposKey)
        aCoder.encode(public_repos, forKey:UserKey.publicReposKey)
        aCoder.encode(owned_private_repos, forKey:UserKey.ownedPrivateReposKey)
        aCoder.encode(repos_url, forKey:UserKey.reposUrlKey)
        
        aCoder.encode(followers, forKey:UserKey.followersKey)
        aCoder.encode(following, forKey:UserKey.followingKey)
        aCoder.encode(following_url, forKey:UserKey.followingUrlKey)
        aCoder.encode(followers_url, forKey:UserKey.followersUrlKey)

        aCoder.encode(name, forKey:UserKey.nameKey)
        aCoder.encode(bio, forKey:UserKey.bioKey)
        aCoder.encode(organizations_url, forKey:UserKey.organizationsUrlKey)
        aCoder.encode(location, forKey:UserKey.locationKey)
        aCoder.encode(blog, forKey:UserKey.blogKey)
        aCoder.encode(avatar_url, forKey:UserKey.avatarUrlKey)
        aCoder.encode(email, forKey:UserKey.emailKey)
        aCoder.encode(company, forKey:UserKey.companyKey)
        aCoder.encode(hireable, forKey:UserKey.hireableKey)
        aCoder.encode(login, forKey:UserKey.loginKey)
        
        aCoder.encode(private_gists, forKey:UserKey.privateGistsKey)
        aCoder.encode(public_gists, forKey:UserKey.publicGistsKey)
        aCoder.encode(gists_url, forKey:UserKey.gistsUrlKey)
        
        aCoder.encode(type, forKey:UserKey.typeKey)
        aCoder.encode(starred_url, forKey:UserKey.starredUrlKey)
        aCoder.encode(id, forKey:UserKey.idKey)
        aCoder.encode(collaborators, forKey: UserKey.collaboratorsKey)
        aCoder.encode(gravatar_id, forKey:UserKey.gravatarIdKey)
        aCoder.encode(disk_usage, forKey:UserKey.diskUsageKey)
        aCoder.encode(url, forKey:UserKey.urlKey)
        aCoder.encode(updated_at, forKey:UserKey.updatedAtKey)
        aCoder.encode(created_at, forKey:UserKey.createdAtKey)
        aCoder.encode(site_admin, forKey:UserKey.siteAdminKey)
        aCoder.encode(received_events_url, forKey:UserKey.receivedRventsUrlKey)
        aCoder.encode(subscriptions_url, forKey:UserKey.subscriptionsUrlKey)
        aCoder.encode(events_url, forKey:UserKey.eventsUrlKey)
        aCoder.encode(html_url, forKey:UserKey.htmlUrlKey)
        aCoder.encode(plan, forKey:UserKey.planKey)

    }
    
    //The required keyword means this initializer must be implemented on every subclass of the class that defines this initializer.
    
    //The convenience keyword denotes this initializer as a convenience initializer. Convenience initializers are secondary, supporting initializers that need to call one of their class’s designated initializers. Designated initializers are the primary initializers for a class. They fully initialize all properties introduced by that class and call a superclass initializer to continue the initialization process up the superclass chain. Here, you’re declaring this initializer as a convenience initializer because it only applies when there’s saved data to be loaded.
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        total_private_repos = aDecoder.decodeObject(forKey: UserKey.totalPrivateReposKey) as? Int
        public_repos = aDecoder.decodeObject(forKey: UserKey.publicReposKey) as? Int
        owned_private_repos = aDecoder.decodeObject(forKey: UserKey.ownedPrivateReposKey) as? Int
        repos_url = aDecoder.decodeObject(forKey: UserKey.reposUrlKey) as? String
        
        followers = aDecoder.decodeObject(forKey: UserKey.followersKey) as? Int
        following = aDecoder.decodeObject(forKey: UserKey.followingKey) as? Int
        following_url = aDecoder.decodeObject(forKey: UserKey.followingUrlKey) as? String
        followers_url = aDecoder.decodeObject(forKey: UserKey.followersUrlKey) as? String
        
        name = aDecoder.decodeObject(forKey: UserKey.nameKey) as? String
        bio = aDecoder.decodeObject(forKey: UserKey.bioKey) as? String
        organizations_url = aDecoder.decodeObject(forKey: UserKey.organizationsUrlKey) as? String
        location = aDecoder.decodeObject(forKey: UserKey.locationKey) as? String
        blog = aDecoder.decodeObject(forKey: UserKey.blogKey) as? String
        avatar_url = aDecoder.decodeObject(forKey: UserKey.avatarUrlKey) as? String
        email = aDecoder.decodeObject(forKey: UserKey.emailKey) as? String
        company = aDecoder.decodeObject(forKey: UserKey.companyKey) as? String
        hireable = aDecoder.decodeObject(forKey: UserKey.hireableKey) as? Bool
        login = aDecoder.decodeObject(forKey: UserKey.loginKey) as? String
        
        private_gists = aDecoder.decodeObject(forKey: UserKey.privateGistsKey) as? Int
        public_gists = aDecoder.decodeObject(forKey: UserKey.publicGistsKey) as? Int
        gists_url = aDecoder.decodeObject(forKey: UserKey.gistsUrlKey) as? String
        
        type = aDecoder.decodeObject(forKey: UserKey.typeKey) as? String
        starred_url = aDecoder.decodeObject(forKey: UserKey.starredUrlKey) as? String
        id = aDecoder.decodeObject(forKey: UserKey.idKey) as? Int
        collaborators = aDecoder.decodeObject(forKey: UserKey.collaboratorsKey) as? Int
        gravatar_id = aDecoder.decodeObject(forKey: UserKey.gravatarIdKey) as? String
        disk_usage = aDecoder.decodeObject(forKey: UserKey.diskUsageKey) as? Int
        url = aDecoder.decodeObject(forKey: UserKey.urlKey) as? String
        updated_at = aDecoder.decodeObject(forKey: UserKey.updatedAtKey) as? String
        created_at = aDecoder.decodeObject(forKey: UserKey.createdAtKey) as? String
        site_admin = aDecoder.decodeObject(forKey: UserKey.siteAdminKey) as? Bool
        received_events_url = aDecoder.decodeObject(forKey: UserKey.receivedRventsUrlKey) as? String
        subscriptions_url = aDecoder.decodeObject(forKey: UserKey.subscriptionsUrlKey) as? String
        events_url = aDecoder.decodeObject(forKey: UserKey.eventsUrlKey) as? String
        html_url = aDecoder.decodeObject(forKey: UserKey.htmlUrlKey) as? String
        plan = aDecoder.decodeObject(forKey: UserKey.planKey) as? ObjPlan
        
    }
    
    
    //MARK: Archive path
    static let documentDirectory = FileManager().urls(for: .documentDirectory,in: .userDomainMask).first!
    static let archiveURL = documentDirectory.appendingPathComponent("userinfo")
    
    
    // MARK: save and load user info with disk
    class func saveUserInfo(_ user:ObjUser?) {
        
        if user == nil {
            print("user is nil...")
        }else {
            let isScuessfulSave = NSKeyedArchiver.archiveRootObject(user!, toFile: ObjUser.archiveURL.path)
            if !isScuessfulSave {
                print("Failed to save user ...")
            }
        }

    }
    
    class func loadUserInfo() -> ObjUser? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: ObjUser.archiveURL.path) as? ObjUser

    }
    
    class func deleteUserInfo() {
        
        let fileM = FileManager.default
        if( fileM.fileExists(atPath: archiveURL.path) ){
            do {
                try fileM.removeItem(at: archiveURL)
            }catch{
                
            }
        }
        
    }
    
}
