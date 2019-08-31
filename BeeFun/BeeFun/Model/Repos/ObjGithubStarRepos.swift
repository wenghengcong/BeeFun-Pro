//
//  ObjStarRepos.swift
//  BeeFunMac
//
//  Created by WengHengcong on 2017/12/27.
//  Copyright © 2017年 LuCi. All rights reserved.
//

import Foundation
import ObjectMapper

/// Star repos可以在请求头添加accept字段，获取到star的时间
/// https://developer.github.com/v3/activity/starring/
class ObjGithubStarRepos: NSObject, Mappable {
    var starred_at: String?
    var repo: ObjRepos?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        starred_at <- map["starred_at"]
        repo <- map["repo"]
        repo?.starred_at = starred_at
    }
}
