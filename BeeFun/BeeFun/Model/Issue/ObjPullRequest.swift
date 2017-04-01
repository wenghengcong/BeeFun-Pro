//
//  ObjPullRequest.swift
//  Coderpursue
//
//  Created by WengHengcong on 2/23/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//
/**
*
"url": "https://api.github.com/repos/octocat/Hello-World/pulls/1347",
"html_url": "https://github.com/octocat/Hello-World/pull/1347",
"diff_url": "https://github.com/octocat/Hello-World/pull/1347.diff",
"patch_url": "https://github.com/octocat/Hello-World/pull/1347.patch"
*/

import UIKit
import ObjectMapper

class ObjPullRequest: NSObject,Mappable {
    
    var url:String?
    var html_url:String?
    var diff_url:String?
    var patch_url:String?
    
    required init?(map: Map) {
        //        super.init(map)
    }
    
    func mapping(map: Map) {
        //        super.mapping(map)

        url <- map["url"]
        html_url <- map["html_url"]
        diff_url <- map["diff_url"]
        patch_url <- map["patch_url"]
        
    }
}
