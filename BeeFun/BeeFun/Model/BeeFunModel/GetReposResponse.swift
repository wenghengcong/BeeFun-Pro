//
//  GetReposResponse.swift
//  BeeFun
//
//  Created by WengHengcong on 2018/5/12.
//  Copyright © 2018年 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper

class GetReposResponse: BeeFunResponseModel {
    var data: [ObjRepos]?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
    }
}
