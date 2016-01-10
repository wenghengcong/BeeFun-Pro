//
//  GitV3API.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/10.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit
import Foundation
import Moya
import Alamofire

// MARK: - Provider setup
let GitHubProvider = MoyaProvider<GitHubAPI>()


public enum GitHubAPI {
    
    case Authorize(client_id:String ,redirect_uri:String ,scope:String,state:String)
    case AccessToken
    
}

extension GitHubAPI: TargetType {

    public var baseURL: NSURL { return NSURL(string: "https://api.github.com")! }
    public var path: String {
        switch self {
            
        case .Authorize:
            return "https://github.com/login/oauth/authorize"
        case .AccessToken:
            return "https://github.com/login/oauth/access_token"

        }
    }

    public var method: Moya.Method {
        
        switch self {
            
        case .Authorize:
            return .GET
        case .AccessToken:
            return .POST
        default:
            return .GET
        }
    }
    
    public var parameters: [String: AnyObject]? {
        
        switch self {
            
        case .Authorize(let client_id, let redirect_uri, let scope, let state):
            return [
                "client_id":client_id,
                "redirect_uri":redirect_uri,
                "scope":scope,
                "state":state,
            ]
        case .AccessToken:
            return [
                "":""
            ]
        default:
            return nil
            
            
        }
        
        
    }
    
    
    public var sampleData: NSData {
        switch self {
        case .Authorize:
            return "Half measures are as bad as nothing at all.".dataUsingEncoding(NSUTF8StringEncoding)!
        case .AccessToken:
            return "Half measures are as bad as nothing at all.".dataUsingEncoding(NSUTF8StringEncoding)!
        }
    }
    
}

// MARK: - Provider support

private extension String {
    var URLEscapedString: String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
    }
}

public func url(route: TargetType) -> String {
    return route.baseURL.URLByAppendingPathComponent(route.path).absoluteString
}

