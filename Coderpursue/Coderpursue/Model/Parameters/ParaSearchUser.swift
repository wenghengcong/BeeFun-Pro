//
//  ParaSearch.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/8/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

class ParaSearchUser : NSObject{

    var q:String
    var sort:String
    var order:String
    
    init(query:String ,sort:String ,order:String) {
        
        self.q = query
        self.sort = sort
        self.order = order
        
    }
    
    convenience override init() {
        self.init(query:"" ,sort:"indexed" ,order:"desc")
    }
    
}

public enum SearchUserQueryPrefix:String {
    
    case Type = "type"
    case In = "in"
    case Repos = "repos"
    case Location = "location"
    case Language = "language"
    case Followers = "followers"
    case Created = "created"
    
}

public enum UserType:String {
    
    case Default = ""
    case User = "user"
    case Org = "org"
    
}

public enum InField:String {
    
    case Default = ""
    case Email = "email"
    case UserName = "login"
    case FullName = "fullname"
    
}


