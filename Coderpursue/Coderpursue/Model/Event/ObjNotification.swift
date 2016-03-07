//
//  ObjNotification.swift
//  Coderpursue
//
//  Created by WengHengcong on 2/23/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

/**
{
"id": "125784581",
"unread": true,
"reason": "subscribed",
"updated_at": "2016-02-22T18:22:41Z",
"last_read_at": null,
"subject":ObjSubject
"repository": ObjRepos,
"url": "https://api.github.com/notifications/threads/125784581",
"subscription_url": "https://api.github.com/notifications/threads/125784581/subscription"
}

*/

import UIKit
import ObjectMapper


public enum NotificationReason:String {
    
    case Subscribed = "subscribed"
    case Manual = "manual"
    case Author = "author"
    case Comment = "comment"
    case Mention = "mention"
    case TeamMention = "team_mention"
    case StateChange = "state_change"
    case Assign = "assign"

}

class ObjNotification: NSObject,Mappable {

    var id:Int?
    var unread:Bool?
    var reason:String?
    var updated_at:String?
    var last_read_at:String?
    var subject:ObjSubject?
    var repository:ObjRepos?
    var url:String?
    var subscription_url:String?
    
    required init?(_ map: Map) {
        //        super.init(map)
    }
    
    func mapping(map: Map) {
        //        super.mapping(map)
        id <- map["id"]
        unread <- map["unread"]
        reason <- map["reason"]
        updated_at <- map["updated_at"]
        last_read_at <- map["last_read_at"]
        subject <- map["subject"]
        repository <- map["repository"]
        url <- map["url"]
        subscription_url <- map["subscription_url"]
        
    }
    
}
