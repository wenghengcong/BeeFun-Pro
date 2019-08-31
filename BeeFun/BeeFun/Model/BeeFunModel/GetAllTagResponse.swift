//
//  GetAllTagResponse.swift
//  BeeFun
//
//  Created by WengHengcong on 2018/5/3.
//  Copyright © 2018年 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper

class GetAllTagResponse: BeeFunResponseModel {

    var data: [ObjTag]?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
    }
}
