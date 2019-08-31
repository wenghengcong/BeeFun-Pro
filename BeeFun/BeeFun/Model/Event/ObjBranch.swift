//
//  ObjHead.swift
//  BeeFun
//
//  Created by WengHengcong on 15/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper
/*
{
    "label": "new-topic",
    "ref": "new-topic",
    "sha": "6dcb09b5b57875f334f61aebed695e2e4193db5e",
    "user": {
    }
    "repo": {
        
    }
}
*/

class ObjBranch: NSObject, Mappable {
    
    var label: String?
    var ref: String?
    var sha: String?
    
    var user: ObjUser?
    var repo: ObjRepos?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        label <- map["label"]
        ref <- map["ref"]
        user <- map["user"]
        repo <- map["repo"]
        sha <- map["sha"]
    }
}
