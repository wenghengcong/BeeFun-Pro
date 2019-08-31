//
//  ObjRelease.swift
//  BeeFun
//
//  Created by WengHengcong on 26/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper
/*
{
    "assets": [],
    "assets_url": "https://api.github.com/repos/ckrey/MQTT-Client-Framework/releases/7834095/assets",
    "author": {
    },
    "body": "\r\n    [FIX] added connectTo:",
    "created_at": "2017-09-21T04:42:48Z",
    "draft": false,
    "html_url": "https://github.com/ckrey/MQTT-Client-Framework/releases/tag/0.9.9",
    "id": 7834095,
    "name": "Session Manager and CoreDataPersistence",
    "prerelease": false,
    "published_at": "2017-09-21T04:44:14Z",
    "tag_name": "0.9.9",
    "tarball_url": "https://api.github.com/repos/ckrey/MQTT-Client-Framework/tarball/0.9.9",
    "target_commitish": "master",
    "upload_url": "https://uploads.github.com/repos/ckrey/MQTT-Client-Framework/releases/7834095/assets{?name,label}",
    "url": "https://api.github.com/repos/ckrey/MQTT-Client-Framework/releases/7834095",
    "zipball_url": "https://api.github.com/repos/ckrey/MQTT-Client-Framework/zipball/0.9.9"
}
 */
class ObjRelease: Mappable {
    
    var assets: [ObjAsset]?
    var assets_url: String?
    var author: ObjUser?
    
    var body: String?
    var created_at: String?
    var draft: Bool?
    var html_url: String?
    var id: Int?
    var name: String?
    var prerelease: Bool?
    var published_at: String?
    var tag_name: String?
    var tarball_url: String?
    var target_commitish: String?
    var upload_url: String?
    var url: String?
    var zipball_url: String?

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        assets <- map["assets"]
        assets_url <- map["assets_url"]
        author <- map["author"]
        body <- map["body"]
        created_at <- map["created_at"]
        draft <- map["draft"]
        html_url <- map["html_url"]
        id <- map["id"]
        name <- map["name"]
        prerelease <- map["prerelease"]
        published_at <- map["published_at"]
        tag_name <- map["tag_name"]
        tarball_url <- map["tarball_url"]
        target_commitish <- map["target_commitish"]
        upload_url <- map["upload_url"]
        url <- map["url"]
        zipball_url <- map["zipball_url"]
    }
}
