//
//  ObjTagModel.swift
//  BeeFun
//
//  Created by WengHengcong on 2018/5/3.
//  Copyright © 2018年 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper

public class ObjTag: NSObject, Mappable, NSCopying {
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let newCopy = ObjTag()
        newCopy.name = name
        newCopy.owner = owner
        newCopy.count = count
        newCopy.sort = sort
        newCopy.repos = repos
        newCopy.created_at = created_at
        newCopy.updated_at = updated_at
        return newCopy
    }
    
    var name: String?
    var owner: String?
    var count: Int?
    var sort: Int?
    var repos: String?
    var created_at: Int64?
    var updated_at: Int64?
    
    required public init?(map: Map) {
    }
    
    override init() {
        super.init()
    }
    
    public func mapping(map: Map) {
        name <- map["name"]
        owner <- map["owner"]
        count <- map["count"]
        sort <- map["sort"]
        repos <- map["repos"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
    }
    
}
