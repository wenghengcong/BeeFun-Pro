//
//  SearchAPI.swift
//  BeeFun
//
//  Created by WengHengcong on 09/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import Foundation
import Moya
import Alamofire
import ObjectMapper

class InsideSearchProvider<Target>: MoyaProvider<Target> where Target: TargetType {
    
    override init(endpointClosure: @escaping (Target) -> Endpoint, requestClosure: @escaping (Endpoint, @escaping MoyaProvider<SearchAPI>.RequestResultClosure) -> Void, stubClosure: @escaping (Target) -> StubBehavior, callbackQueue: DispatchQueue?, manager: Manager, plugins: [PluginType], trackInflights: Bool) {
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, callbackQueue: callbackQueue, manager: manager, plugins: plugins, trackInflights: trackInflights)
    }
}

struct SearchProvider {
    
    fileprivate static var endpointsClosure = { (target: SearchAPI) -> Endpoint in
        
        var endpoint: Endpoint = Endpoint(url: url(target), sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: target.headers)
        return endpoint
    }
    static func stubBehaviour(_: SearchAPI) -> Moya.StubBehavior {
        return .never
    }
    
    static func DefaultProvider() -> InsideSearchProvider<SearchAPI> {
        
        return InsideSearchProvider(endpointClosure: endpointsClosure, requestClosure: MoyaProvider<SearchAPI>.defaultRequestMapping, stubClosure: MoyaProvider.neverStub, callbackQueue: DispatchQueue.main, manager: Alamofire.SessionManager.default, plugins: [], trackInflights: false)
    }
    
    fileprivate struct SharedProvider {
        static var instance = SearchProvider.DefaultProvider()
    }
    static var sharedProvider: InsideSearchProvider<SearchAPI> {
        get {
            return SharedProvider.instance
        }
        
        set (newSharedProvider) {
            SharedProvider.instance = newSharedProvider
        }
        
    }
}

public enum SearchAPI {
    
    //search
    case search(para: SESearchBaseModel)
    case searchCommit(para: SESearchBaseModel)
}

extension SearchAPI: TargetType {
    
    public var headers: [String: String]? {

        var header = ["User-Agent": "BeeFunMac", "Authorization": AppToken.shared.access_token ?? "", "timeoutInterval": "15.0", "Accept": "application/vnd.github.v3.star+json"]
        switch self {
            
        case .searchCommit:
            //https://developer.github.com/v3/search/#search-commits
            header = ["User-Agent": "BeeFunMac", "Authorization": AppToken.shared.access_token ?? "", "timeoutInterval": "15.0", "Accept": "application/vnd.github.cloak-preview"]
        default:
            header = ["User-Agent": "BeeFunMac", "Authorization": AppToken.shared.access_token ?? "", "timeoutInterval": "15.0"]
            return header
        }
        return header
    }
    
    public var parameterEncoding: ParameterEncoding {
        return Alamofire.ParameterEncoding.self as! ParameterEncoding
    }
    public var baseURL: URL {
        switch self {
        default:
            return URL(string: "https://api.github.com/search")!
        }
    }
    
    public var path: String {
        switch self {
        //search
        case .search(let para):
            return "/\(para.requestUrl)"
        case .searchCommit(let para):
            return "/\(para.requestUrl)"
        }
        
    }
    
    public var method: Moya.Method {
        
        switch self {
        default:
            return .get
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .search(let para):
            return [
                "q": para.q as AnyObject,
                "sort": para.sort as AnyObject,
                "order": para.order as AnyObject,
                "page": para.page as AnyObject,
                "per_page": para.perPage as AnyObject
            ]
        case .searchCommit(let para):
            return [
                "q": para.q as AnyObject,
                "sort": para.sort as AnyObject,
                "order": para.order as AnyObject,
                "page": para.page as AnyObject,
                "per_page": para.perPage as AnyObject
            ]
        }
    }
    
    public var task: Task {
        let encoding: ParameterEncoding
        switch self.method {
        case .post:
            encoding = JSONEncoding.default
        default:
            encoding = URLEncoding.default
        }
        if let requestParameters = parameters {
            return .requestParameters(parameters: requestParameters, encoding: encoding)
        }
        return .requestPlain
    }
    
    //Any target you want to hit must provide some non-nil NSData that represents a sample response. This can be used later for tests or for providing offline support for developers. This should depend on self.
    public var sampleData: Data {
        switch self {
            
        default :
            return "default".data(using: String.Encoding.utf8)!
        }
        
    }
}
