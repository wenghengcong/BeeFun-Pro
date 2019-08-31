//
//  ObjShowcase.swift
//  BeeFun
//
//  Created by WengHengcong on 3/8/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper

/*

"name": "Policies",
"slug": "policies",
"description": "From federal governments to corporations to student clubs, groups of all sizes are using GitHub to share, discuss, and improve laws.  Ask...",
"image_url": "http://trending.codehub-app.com/policies.png",
"repositories": [ObjRespo]

*/
class ObjShowcase: NSObject, Mappable {

    var name: String?
    var slug: String?
    var cdescription: String?
    var image_url: String?
    var repositories: [ObjRepos]?
    
    //自定义字段，从网页解析
    /// 项目数目
    var trend_repo_text: String?
    /// 语言数目
    var trend_lan_text: String?
    /// 解析后的图片svg数据，base64未解码数据
    var svgXml: String?

    override init() {
        super.init()
    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        //        super.mapping(map)
        name <- map["name"]
        slug <- map["slug"]
        cdescription <- map["description"]
        image_url <- map["image_url"]
        repositories <- map["repositories"]
        //自定义字段
        //repos_count\launguage_count
    }
}
