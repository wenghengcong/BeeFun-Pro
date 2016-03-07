//
//  ObjCommit.swift
//  Coderpursue
//
//  Created by WengHengcong on 2/23/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper

/*

"sha": "134f57a577b4dc45a29818d11d2484c549a86ac0",
"author":ObjUser,
"message": "starred repos done",
"distinct": true,
"url": "https://api.github.com/repos/wenghengcong/Coderpursue/commits/134f57a577b4dc45a29818d11d2484c549a86ac0"

*/

class ObjCommit: NSObject,Mappable {
    
    var sha:String?
    var author:ObjUser?
    var message:String?
    var distinct:Bool?
    var url:String?

    required init?(_ map: Map) {
        //        super.init(map)
    }
    
    func mapping(map: Map) {
        //        super.mapping(map)
        sha <- map["sha"]
        author <- map["author"]
        message <- map["message"]
        distinct <- map["distinct"]
        url <- map["url"]
        
    }
}
