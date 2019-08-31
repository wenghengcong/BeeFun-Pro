//
//  NetFilter.swift
//  BeeFun
//
//  Created by Hunt on 2019/6/25.
//  Copyright © 2019 JungleSong. All rights reserved.
//

import UIKit

class NetFilter: Codable {
    
    /// Filter名称
    var name: String?
    /// 排序字段
    var sidx: String?
    /// 升降序，desc/asc
    var sord: String?
    /// 页码
    var page: UInt?
    /// 每页大小
    var pageSize: UInt?
}

class TagFilter: NetFilter {
    var owner: String? = UserManager.shared.login
    var tag: String?
    
    enum TagFilterCodingKeys: String, CodingKey {
        case owner
        case tag
    }
    
    required override init() {
        super.init()
    }
    
    //编码方法
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: TagFilterCodingKeys.self)
        try container.encode(owner, forKey: TagFilterCodingKeys.owner)
        try container.encode(tag, forKey: TagFilterCodingKeys.tag)
        try super.encode(to: encoder)
    }
    
    //解码方法
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TagFilterCodingKeys.self)
        self.owner = try container.decode(String.self, forKey: .owner)
        self.tag = try container.decode(String.self, forKey: .tag)
        
        try super.init(from: decoder)
    }
}
