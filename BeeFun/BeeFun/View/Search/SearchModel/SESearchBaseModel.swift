//
//  SESearchBaseModel.swift
//  BeeFun
//
//  Created by WengHengcong on 10/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit

enum SESearchType: Int {
    case repo, user, issue, code, commit, wiki
}

open class SESearchBaseModel: NSObject {
    
    var type: SESearchType = .repo
    var requestUrl: String
    
    var keyword: String? {
        didSet {
            q = combineQuery()
        }
    }
    
    var q: String {
        didSet {
            q = combineQuery()
        }
    }

    var sort: String {
        didSet {
            q = combineQuery()
        }
    }

    var order: String {
        didSet {
            q = combineQuery()
        }
    }

    var languagePara: String? {
        didSet {
            q = combineQuery()
        }
    }
    
    //page
    var page: Int = 1
    var perPage: Int = 10
    
    init(requestURL: String, query: String, sort: String, order: String) {
        self.requestUrl = requestURL
        self.q = query
        self.sort = sort
        self.order = order
    }
    
    convenience override init() {
        self.init(requestURL:"", query:"", sort:"", order:"desc")
    }
    
    func combineQuery() -> String {
        var query = ""
        if keyword != nil {
            query += "\(keyword!)"
        }
        
        //language:javascript
        if languagePara != nil {
            query += " language:\(languagePara!)"
        }
        
        return query
    }

}
