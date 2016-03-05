//
//  ObjEmail.swift
//  Coderpursue
//
//  Created by WengHengcong on 16/1/25.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper

class ObjEmail: NSObject ,Mappable{

    var email:String?
    var primary:Bool?
    var verified:Bool?
    
    
    required init?(_ map: Map) {
        //        super.init(map)
    }
    
    func mapping(map: Map) {
        //        super.mapping(map)
        email <- map["email"]
        primary <- map["primary"]
        verified <- map["verified"]
    }
    
}
