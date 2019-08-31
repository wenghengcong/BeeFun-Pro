//
//  SESearchUserModel.swift
//  BeeFun
//
//  Created by WengHengcong on 09/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit

public enum SearchUserQueryPrefix: String {
    
    case Typee = "type"
    case In = "in"
    case Repos = "repos"
    case Location = "location"
    case Language = "language"
    case Followers = "followers"
    case Created = "created"
    
}

public enum UserType: String {
    
    case Default = ""
    case User = "user"
    case Org = "org"
    
}

public enum UserInField: String {
    
    case Default = ""
    case Email = "email"
    case UserName = "login"
    case FullName = "fullname"
    
}

open class SESearchUserModel: SESearchBaseModel {
    
    //ccombine all parameters to q
    //now support only one to one,but github api support one to many
    //such as,type:org type:user,but now support only type:user or type:org
    
    override var languagePara: String? {
        didSet {
            q = combineQuery()
        }
    }
    
    override var keyword: String? {
        didSet {
            q = combineQuery()
        }
    }
    
    var typePara: UserType? {
        didSet {
            q = combineQuery()
        }
    }

    var inPara: UserInField? {
        didSet {
            q = combineQuery()
        }
    }

    var reposPara: String? {
        didSet {
            q = combineQuery()
        }
    }

    var locationPara: String? {
        didSet {
            q = combineQuery()
        }
    }

    var createdPara: String? {
        didSet {
            q = combineQuery()
        }
    }

    var followersPara: String? {
        didSet {
            q = combineQuery()
        }
    }
    
    override func combineQuery() -> String {
        
        var query = ""
        
        if keyword != nil {
            query += "\(keyword!)"
        }
        
        //type:org
        if typePara != nil {
            let typeStr = typePara!.rawValue
            query += " type:\(typeStr)"
        }
        
        //in:email
        if inPara != nil {
            let inStr = inPara!.rawValue
            query += " in:\(inStr)"
        }
        
        //repos:>9000
        if reposPara != nil {
            query += " repos:\(reposPara!)"
        }
        
        //location:iceland
        if locationPara != nil {
            query += " location:\(locationPara!)"
        }
        
        //language:javascript
        if languagePara != nil {
            query += " language:\(languagePara!)"
        }
        
        //created:<2011-01-01
        if createdPara != nil {
            query += " created:\(createdPara!)"
        }
        
        //followers:>=1000
        if followersPara != nil {
            query += " followers:\(followersPara!)"
        }
        
        if query.isEmpty || (query == "") {
            query = "type:user"
        }
        
        return query
        
    }

}
