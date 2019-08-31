//
//  GithubTrendingUserModel.swift
//  BeeFun
//
//  Created by WengHengcong on 2018/10/4.
//  Copyright © 2018年 LuCi. All rights reserved.
//

import UIKit
import ObjectMapper
/*
 {
     "url":"https://github.com/SatanWoo",
     "avatar":"https://avatars3.githubusercontent.com/u/1303079?s/....",
     "login":"SatanWoo"
 }
 */
class BFGithubTrendingUserModel: NSObject, Mappable {
    
    /// 主页
    var url: String?
    
    /// 头像
    var avatar: String?
    
    /// login 名
    var login: String?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        url <- map["url"]
        avatar <- map["avatar"]
        login <- map["login"]
    }
}
