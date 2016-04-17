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
    required init?(_ map: Map) {
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
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(total_private_repos, forKey:UserKey.totalPrivateReposKey)
        aCoder.encodeObject(public_repos, forKey:UserKey.publicReposKey)
        aCoder.encodeObject(owned_private_repos, forKey:UserKey.ownedPrivateReposKey)
        aCoder.encodeObject(repos_url, forKey:UserKey.reposUrlKey)
        
        aCoder.encodeObject(followers, forKey:UserKey.followersKey)
        aCoder.encodeObject(following, forKey:UserKey.followingKey)
        aCoder.encodeObject(following_url, forKey:UserKey.followingUrlKey)
        aCoder.encodeObject(followers_url, forKey:UserKey.followersUrlKey)

        aCoder.encodeObject(name, forKey:UserKey.nameKey)
        aCoder.encodeObject(bio, forKey:UserKey.bioKey)
        aCoder.encodeObject(organizations_url, forKey:UserKey.organizationsUrlKey)
        aCoder.encodeObject(location, forKey:UserKey.locationKey)
        aCoder.encodeObject(blog, forKey:UserKey.blogKey)
        aCoder.encodeObject(avatar_url, forKey:UserKey.avatarUrlKey)
        aCoder.encodeObject(email, forKey:UserKey.emailKey)
        aCoder.encodeObject(company, forKey:UserKey.companyKey)
        aCoder.encodeObject(hireable, forKey:UserKey.hireableKey)
        aCoder.encodeObject(login, forKey:UserKey.loginKey)
        
        aCoder.encodeObject(private_gists, forKey:UserKey.privateGistsKey)
        aCoder.encodeObject(public_gists, forKey:UserKey.publicGistsKey)
        aCoder.encodeObject(gists_url, forKey:UserKey.gistsUrlKey)
        
        aCoder.encodeObject(type, forKey:UserKey.typeKey)
        aCoder.encodeObject(starred_url, forKey:UserKey.starredUrlKey)
        aCoder.encodeObject(id, forKey:UserKey.idKey)
        aCoder.encodeObject(collaborators, forKey: UserKey.collaboratorsKey)
        aCoder.encodeObject(gravatar_id, forKey:UserKey.gravatarIdKey)
        aCoder.encodeObject(disk_usage, forKey:UserKey.diskUsageKey)
        aCoder.encodeObject(url, forKey:UserKey.urlKey)
        aCoder.encodeObject(updated_at, forKey:UserKey.updatedAtKey)
        aCoder.encodeObject(created_at, forKey:UserKey.createdAtKey)
        aCoder.encodeObject(site_admin, forKey:UserKey.siteAdminKey)
        aCoder.encodeObject(received_events_url, forKey:UserKey.receivedRventsUrlKey)
        aCoder.encodeObject(subscriptions_url, forKey:UserKey.subscriptionsUrlKey)
        aCoder.encodeObject(events_url, forKey:UserKey.eventsUrlKey)
        aCoder.encodeObject(html_url, forKey:UserKey.htmlUrlKey)
        aCoder.encodeObject(plan, forKey:UserKey.planKey)

    }
    
    //The required keyword means this initializer must be implemented on every subclass of the class that defines this initializer.
    
    //The convenience keyword denotes this initializer as a convenience initializer. Convenience initializers are secondary, supporting initializers that need to call one of their class’s designated initializers. Designated initializers are the primary initializers for a class. They fully initialize all properties introduced by that class and call a superclass initializer to continue the initialization process up the superclass chain. Here, you’re declaring this initializer as a convenience initializer because it only applies when there’s saved data to be loaded.
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        total_private_repos = aDecoder.decodeObjectForKey(UserKey.totalPrivateReposKey) as? Int
        public_repos = aDecoder.decodeObjectForKey(UserKey.publicReposKey) as? Int
        owned_private_repos = aDecoder.decodeObjectForKey(UserKey.ownedPrivateReposKey) as? Int
        repos_url = aDecoder.decodeObjectForKey(UserKey.reposUrlKey) as? String
        
        followers = aDecoder.decodeObjectForKey(UserKey.followersKey) as? Int
        following = aDecoder.decodeObjectForKey(UserKey.followingKey) as? Int
        following_url = aDecoder.decodeObjectForKey(UserKey.followingUrlKey) as? String
        followers_url = aDecoder.decodeObjectForKey(UserKey.followersUrlKey) as? String
        
        name = aDecoder.decodeObjectForKey(UserKey.nameKey) as? String
        bio = aDecoder.decodeObjectForKey(UserKey.bioKey) as? String
        organizations_url = aDecoder.decodeObjectForKey(UserKey.organizationsUrlKey) as? String
        location = aDecoder.decodeObjectForKey(UserKey.locationKey) as? String
        blog = aDecoder.decodeObjectForKey(UserKey.blogKey) as? String
        avatar_url = aDecoder.decodeObjectForKey(UserKey.avatarUrlKey) as? String
        email = aDecoder.decodeObjectForKey(UserKey.emailKey) as? String
        company = aDecoder.decodeObjectForKey(UserKey.companyKey) as? String
        hireable = aDecoder.decodeObjectForKey(UserKey.hireableKey) as? Bool
        login = aDecoder.decodeObjectForKey(UserKey.loginKey) as? String
        
        private_gists = aDecoder.decodeObjectForKey(UserKey.privateGistsKey) as? Int
        public_gists = aDecoder.decodeObjectForKey(UserKey.publicGistsKey) as? Int
        gists_url = aDecoder.decodeObjectForKey(UserKey.gistsUrlKey) as? String
        
        type = aDecoder.decodeObjectForKey(UserKey.typeKey) as? String
        starred_url = aDecoder.decodeObjectForKey(UserKey.starredUrlKey) as? String
        id = aDecoder.decodeObjectForKey(UserKey.idKey) as? Int
        collaborators = aDecoder.decodeObjectForKey(UserKey.collaboratorsKey) as? Int
        gravatar_id = aDecoder.decodeObjectForKey(UserKey.gravatarIdKey) as? String
        disk_usage = aDecoder.decodeObjectForKey(UserKey.diskUsageKey) as? Int
        url = aDecoder.decodeObjectForKey(UserKey.urlKey) as? String
        updated_at = aDecoder.decodeObjectForKey(UserKey.updatedAtKey) as? String
        created_at = aDecoder.decodeObjectForKey(UserKey.createdAtKey) as? String
        site_admin = aDecoder.decodeObjectForKey(UserKey.siteAdminKey) as? Bool
        received_events_url = aDecoder.decodeObjectForKey(UserKey.receivedRventsUrlKey) as? String
        subscriptions_url = aDecoder.decodeObjectForKey(UserKey.subscriptionsUrlKey) as? String
        events_url = aDecoder.decodeObjectForKey(UserKey.eventsUrlKey) as? String
        html_url = aDecoder.decodeObjectForKey(UserKey.htmlUrlKey) as? String
        plan = aDecoder.decodeObjectForKey(UserKey.planKey) as? ObjPlan
        
    }
    
    
    //MARK: Archive path
    static let documentDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory,inDomains: .UserDomainMask).first!
    static let archiveURL = documentDirectory.URLByAppendingPathComponent("userinfo")
    
    
    // MARK: save and load user info with disk
    class func saveUserInfo(user:ObjUser?) {
        
        if user == nil {
            print("user is nil...")
        }else {
            let isScuessfulSave = NSKeyedArchiver.archiveRootObject(user!, toFile: ObjUser.archiveURL.path!)
            if !isScuessfulSave {
                print("Failed to save user ...")
            }
        }

    }
    
    class func loadUserInfo() -> ObjUser? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(ObjUser.archiveURL.path!) as? ObjUser

    }
    
    class func deleteUserInfo() {
        
        let fileM = NSFileManager.defaultManager()
        if( fileM.fileExistsAtPath(archiveURL.path!) ){
            do {
                try fileM.removeItemAtURL(archiveURL)
            }catch{
                
            }
        }
        
    }
    
}
