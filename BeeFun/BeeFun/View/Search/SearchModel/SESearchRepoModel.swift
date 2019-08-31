//
//  SESearchRepoModel.swift
//  BeeFun
//
//  Created by WengHengcong on 09/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit

public enum SearchReposQueryPrefix: String {
    
    case In = "in"
    case Size = "size"
    case Forks = "forks"
    //The second way is to specify whether forked repositories should be included in results at all. By default, forked repositories are not shown. You can choose to include forked repositories by adding fork:true to your search. Or, if you only want forked repositories, add fork:only to your search.
    case Fork = "fork"
    
    case User = "user"
    case Language = "language"
    case Stars = "stars"
    case Created = "created"
    case Pushed = "pushed"
    
}

public enum ReposInField: String {
    
    //Without the qualifier, only the name and description are searched.
    //jquery in:name,description
    case Default = ""
    case Name = "name"
    case Description = "description"
    case Readme = "readme"
    
}

open class SESearchRepoModel: SESearchBaseModel {

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
    
    var inPara: ReposInField? {
        didSet {
            q = combineQuery()
        }
    }

    var sizePara: String? {
        didSet {
            q = combineQuery()
        }
    }

    var forksPara: String? {
        didSet {
            q = combineQuery()
        }
    }

    var forkPara: Bool? {
        didSet {
            q = combineQuery()
        }
    }

    var userPara: String? {
        didSet {
            q = combineQuery()
        }
    }

    var starsPara: String? {
        didSet {
            q = combineQuery()
        }
    }

    var createdPara: String? {
        didSet {
            q = combineQuery()
        }
    }

    var pushedPara: String? {
        didSet {
            q = combineQuery()
        }
    }
    
    override func combineQuery() -> String {
        var query = ""
        
        if keyword != nil {
            query += "\(keyword!)"
        }
        
        //in:email
        if inPara != nil {
            let inStr = inPara!.rawValue
            query += " in:\(inStr)"
        }
        
        //size:50..120
        if sizePara != nil {
            query += " size:\(sizePara!)"
        }
        
        //forks:>=205
        if forksPara != nil {
            query += " forks:\(forksPara!)"
        }
        
        //forks:>=205
        if forkPara != nil {
            query += " fork:\(forksPara!)"
        }
        
        //user:github
        if userPara != nil {
            query += " user:\(userPara!)"
        }
        
        //language:javascript
        if languagePara != nil {
            query += " language:\(languagePara!)"
        }
        
        //created:<2011-01-01
        if createdPara != nil {
            query += " created:\(createdPara!)"
        }
        
        //pushed:<2011-01-01
        if pushedPara != nil {
            query += " pushed:\(pushedPara!)"
        }
        
        //stars:10..20
        if starsPara != nil {
            query += " stars:\(starsPara!)"
        }
        
        if query.isEmpty || (query == "") {
            query = "in:name,description"
        }
        
        return query
        
    }

}
