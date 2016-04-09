//
//  ParaSearchRepos.swift
//  Coderpursue
//
//  Created by WengHengcong on 4/9/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

public enum SearchReposQueryPrefix:String {
    
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


public enum ReposInField:String {
    
    //Without the qualifier, only the name and description are searched.
    //jquery in:name,description
    case Default = ""
    case Name = "name"
    case Description = "description"
    case Readme = "readme"
    
}

public class ParaSearchRepos: NSObject {
    
    var q:String
    var sort:String
    var order:String
    
    //ccombine all parameters to q
    //now support only one to one,but github api support one to many
    //such as,type:org type:user,but now support only type:user or type:org
    var keyword:String?
    var inPara:ReposInField?
    var sizePara:String?
    var forksPara:String?
    var forkPara:Bool?
    var userPara:String?
    var languagePara:String?
    var starsPara:String?
    var createdPara:String?
    var pushedPara:String?

    //page
    var page:Int = 1
    var perPage:Int = 10
    
    init(query:String ,sort:String ,order:String) {
        
        self.q = query
        self.sort = sort
        self.order = order
        
    }
    
    convenience override init() {
        self.init(query:"" ,sort:"" ,order:"desc")
    }
    
    func combineQuery()->String {
        
        var query = ""
        
        if(keyword != nil){
            query += "\(keyword!)"
        }
        
        //in:email
        if(inPara != nil){
            let inStr = inPara!.rawValue
            query += " in:\(inStr)"
        }
        
        //size:50..120
        if(sizePara != nil){
            query += " size:\(sizePara!)"
        }
        
        //forks:>=205
        if(forksPara != nil){
            query += " forks:\(forksPara!)"
        }
        
        //forks:>=205
        if(forkPara != nil){
            query += " fork:\(forksPara!)"
        }
        
        //user:github
        if(userPara != nil){
            query += " user:\(userPara!)"
        }
        
        //language:javascript
        if(languagePara != nil){
            query += " language:\(languagePara!)"
        }
        
        //created:<2011-01-01
        if(createdPara != nil){
            query += " created:\(createdPara!)"
        }
        
        //pushed:<2011-01-01
        if(pushedPara != nil){
            query += " pushed:\(pushedPara!)"
        }
        
        //stars:10..20
        if(starsPara != nil){
            query += " stars:\(starsPara!)"
        }
        
        if(query.isEmpty || (query == "") ){
            query = "in:name,description"
        }
        
        return query
        
    }

}
