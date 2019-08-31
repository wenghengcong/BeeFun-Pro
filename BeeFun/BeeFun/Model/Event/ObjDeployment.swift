//
//  ObjDeployment.swift
//  BeeFun
//
//  Created by WengHengcong on 26/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper
/*
{
    "url": "https://api.github.com/repos/baxterthehacker/public-repo/deployments/710692",
    "id": 710692,
    "sha": "9049f1265b7d61be4a8904a9a27120d2064dab3b",
    "ref": "master",
    "task": "deploy",
    "payload": {
    },
    "environment": "production",
    "description": null,
    "creator": {
    },
    "created_at": "2015-05-05T23:40:38Z",
    "updated_at": "2015-05-05T23:40:38Z",
    "statuses_url": "https://api.github.com/repos/baxterthehacker/public-repo/deployments/710692/statuses",
    "repository_url": "https://api.github.com/repos/baxterthehacker/public-repo"
}
*/
class ObjDeployment: Mappable {

    var url: String?
    var sha: String?
    var id: Int?
    var ref: String?
    var task: String?
    
    var payload: ObjDeploymentPayload?
    var environment: String?
    var description: String?
    var creator: ObjUser?
    var created_at: String?
    
    var updated_at: String?
    var statuses_url: String?
    var repository_url: String?

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        url <- map["url"]
        sha <- map["sha"]
        id <- map["id"]
        ref <- map["ref"]
        task <- map["task"]
        payload <- map["payload"]
        environment <- map["environment"]
        description <- map["description"]
        creator <- map["creator"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        statuses_url <- map["statuses_url"]
        repository_url <- map["repository_url"]
    }
}
