//
//  RequsetGithubTrendingModel.swift
//  BeeFun
//
//  Created by WengHengcong on 2018/10/4.
//  Copyright © 2018年 LuCi. All rights reserved.
//

import UIKit
import ObjectMapper

public class BFGithubTrendingRequsetModel: NSObject, Mappable {

    
    /// 从1.数据库，2.GitHub解析 获取数据
    var source: Int = 1
    
    /// 假如不传type Repos and User,否则 1.Repos、2.User
    var type: Int?
    
    /// 时间，获取Trending的时间:monthly/daily/monthly
    var time: BFGihubTrendingTimeEnum?
    
    /// 指的是要获取什么语言，可选参数，无须区分也可传all
    var language: String?
    
    /// 当前页面，必选参数，若不分页，传0
    var page: Int?
    
    /// 每页数目，必选参数，若不分页，传0
    var perpage: Int?
    
    /// 排序列：star_num(Repo)、up_star_num(Repo)、name（User/Repo）、pos(针对User，默认使用排名)
    var sort: String?
    
    /// 排序，只能是asc或者desc
    var direction: String?
    
    public override init() {
        
    }
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        source <- map["source"]
        type <- map["type"]
        time <- map["time"]
        language <- map["language"]
        page <- map["page"]
        perpage <- map["perpage"]
        sort <- map["sort"]
        direction <- map["direction"]
    }
}
