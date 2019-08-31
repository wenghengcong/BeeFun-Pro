//
//  ObjDeploymentPayload.swift
//  BeeFun
//
//  Created by WengHengcong on 26/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper

class ObjDeploymentPayload: Mappable {

    var task: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        task <- map["url"]
    }
}
