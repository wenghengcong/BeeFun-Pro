//
//  GithubTrengingRepositoryModel.swift
//  BeeFun
//
//  Created by WengHengcong on 2018/10/3.
//  Copyright © 2018年 LuCi. All rights reserved.
//

import Foundation
import ObjectMapper

/*
 {
     "today": "2018-10-04",
     "time_period": "daily",
     "language": "objective-c",
     "full_name": "SatanWoo / JSDebugger",
     "type": 1,
     "pos": 1,
     "user_url": null,
     "login": null,
     "user_id": null,
     "repo_name": "JSDebugger",
     "repo_url": "https://github.com/SatanWoo/JSDebugger",
     "repo_language_color": "#438eff",
     "repo_language": "Objective-C",
     "star_num": 28,
     "star_url": "https://github.com/SatanWoo/JSDebugger/stargazers",
     "fork_num": 4,
     "fork_url": "https://github.com/SatanWoo/JSDebugger/network",
     "star_text_time_period": "19 stars today",
     "up_star_num": 19,
     "user_avatar": null,
     "created_at": null,
     "updated_at": null,
     "repo_desc": "JavaScript-Based Debugger For Inspecting Running State Of Your Application",
     "built_by_users": "[{\"url\":\"https://github.com/SatanWoo\",\"avatar\":\"https://avatars3.githubusercontent.com/u/1303079?s\\u003d40\\u0026v\\u003d4\",\"login\":\"SatanWoo\"},{\"url\":\"https://github.com/ValiantCat\",\"avatar\":\"https://avatars0.githubusercontent.com/u/6142855?s\\u003d40\\u0026v\\u003d4\",\"login\":\"ValiantCat\"}]"
 }
 */
class BFGithubTrengingModel: NSObject, Mappable {

    var today: String?
    var time_period: String?
    var language: String?
    var full_name: String?
    var type: Int?
    var pos: Int?
    var user_url: String?
    var login: String?
    var user_id: Int?
    var repo_name: String?
    var repo_url: String?
    
    var repo_language_color: String?
    var repo_language: String?
    var star_num: Int?
    var star_url: String?
    var fork_num: Int?
    var fork_url: String?
    var star_text_time_period: String?
    var up_star_num: Int?
    var user_avatar: String?
    var created_at: String?
    var updated_at: String?
    var repo_desc: String?
    var repo_owner: String?
    
    //以下字段为解析后的字段
    
    /// repo的维护者
    var built_by_users: [BFGithubTrendingUserModel]?
    
    /// repo是否被用户star
    var starred: Bool?
    
    /// user是否被用户follow
    var followed: Bool?
    
    private var built_by_users_string: String?

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        today <- map["today"]
        time_period <- map["time_period"]
        language <- map["language"]
        full_name <- map["full_name"]
        pos <- map["pos"]
        user_url <- map["user_url"]
        login <- map["login"]
        user_id <- map["user_id"]
        repo_name <- map["repo_name"]
        repo_owner <- map["repo_owner"]
        repo_url <- map["repo_url"]
        type <- map["type"]
        
        repo_language_color <- map["repo_language_color"]
        repo_language <- map["repo_language"]
        star_num <- map["star_num"]
        star_url <- map["star_url"]
        fork_num <- map["fork_num"]
        fork_url <- map["fork_url"]
        star_text_time_period <- map["star_text_time_period"]
        up_star_num <- map["up_star_num"]
        user_avatar <- map["user_avatar"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        repo_desc <- map["repo_desc"]
        built_by_users_string <- map["built_by_users"]
        
        if let userJson = built_by_users_string, let users = Mapper<BFGithubTrendingUserModel>().mapArray(JSONString: userJson) {
            built_by_users = users
        }
    }
}
