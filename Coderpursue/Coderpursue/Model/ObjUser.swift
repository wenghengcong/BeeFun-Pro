//
//  ObjUser.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/12.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper

class ObjUser: Mappable {
    
    var access_token:String?
    var token_type:String?
    var scope:String?


    required init?(_ map: Map) {
    }
    
    func mapping(map:Map) {
        
        access_token        <- map["access_token"]
        token_type          <- map["token_type"]
        scope               <- map["scope"]
    }
}
