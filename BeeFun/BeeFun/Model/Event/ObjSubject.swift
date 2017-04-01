//
//  ObjSubject.swift
//  BeeFun
//
//  Created by WengHengcong on 2/23/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//
/**
"title": "marked designated initializers (issue #1142)",
"url": "https://api.github.com/repos/jessesquires/JSQMessagesViewController/pulls/1460",
"latest_comment_url": "https://api.github.com/repos/jessesquires/JSQMessagesViewController/pulls/1460",
"type": "PullRequest"
*/

import UIKit
import ObjectMapper

public enum SubjectType:String {
    
    case Issue = "Issue"
    case PullRequest = "PullRequest"
    case Release = "Release"
    case Commit = "Commit"
    
}

class ObjSubject: NSObject,Mappable {
    
    var title:String?
    var url:String?
    var latest_comment_url:String?
    var type:String?

    required init?(map: Map) {
        //        super.init(map)
    }
    
    func mapping(map: Map) {
        //        super.mapping(map)
        
        title <- map["title"]
        url <- map["url"]
        latest_comment_url <- map["latest_comment_url"]
        type <- map["type"]

    }
}
