//
//  ObjHref.swift
//  BeeFun
//
//  Created by WengHengcong on 15/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper
/*
{
    "href": "https://api.github.com/repos/octocat/Hello-World/pulls/1347"
}
*/
class ObjHref: NSObject, Mappable {
    var href: String?

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        href <- map["href"]
    }
}
