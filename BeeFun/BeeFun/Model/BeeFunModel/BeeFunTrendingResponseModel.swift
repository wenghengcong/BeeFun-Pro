//
//  BeeFunTrendingResponseModel.swift
//  BeeFun
//
//  Created by Hunt on 2019/6/25.
//  Copyright © 2019 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper


class BeeFunTrendingResponseModel: NSObject, Mappable {
    var code: Int?
    var codeEnum: BFStatusCode?
    var msg: String?
    var data: [BFGithubTrengingModel]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        //                super.mapping(map)
        code <- map["code"]
        if code != nil {
            codeEnum = BFStatusCode(rawValue: code!)
        }
        msg <- map["msg"]
        data <- map["data"]
    }
}
