//
//  EventAPI.swift
//  BeeFun
//
//  Created by WengHengcong on 10/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import Foundation
import Moya
import Alamofire
import ObjectMapper

class InsideEventProvider<Target>: MoyaProvider<Target> where Target: TargetType {
    override init(endpointClosure: @escaping (Target) -> Endpoint, requestClosure: @escaping (Endpoint, @escaping MoyaProvider<EventAPI>.RequestResultClosure) -> Void, stubClosure: @escaping (Target) -> StubBehavior, callbackQueue: DispatchQueue?, manager: Manager, plugins: [PluginType], trackInflights: Bool) {
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, callbackQueue: callbackQueue, manager: manager, plugins: plugins, trackInflights: trackInflights)
    }
    
}

struct EventProvider {
    
    fileprivate static var endpointsClosure = { (target: EventAPI) -> Endpoint in
        // Sign all non-XApp token requests
        var endpoint: Endpoint = Endpoint(url: url(target), sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: target.headers)
        return endpoint
    }
    
    static func stubBehaviour(_: EventAPI) -> Moya.StubBehavior {
        return .never
    }
    
    static func DefaultProvider() -> InsideEventProvider<EventAPI> {
        return InsideEventProvider(endpointClosure: endpointsClosure, requestClosure: MoyaProvider<EventAPI>.defaultRequestMapping, stubClosure: MoyaProvider.neverStub, callbackQueue: DispatchQueue.main, manager: Alamofire.SessionManager.default, plugins: [], trackInflights: false)
    }
    
    fileprivate struct SharedProvider {
        static var instance = EventProvider.DefaultProvider()
    }
    static var sharedProvider: InsideEventProvider<EventAPI> {
        get {
            return SharedProvider.instance
        }
        
        set (newSharedProvider) {
            SharedProvider.instance = newSharedProvider
        }
        
    }
}

/// Event API
///
/// - publicEvents: List public events
/// - repoEvents: List repository events
/// - repoIssueEvents: List issue events for a repository,Repository issue events have a different format than other events, as documented in the Issue Events API(https://developer.github.com/v3/issues/events/).
/// - repoPublicNetworkEvents: List public events for a network of repositories
/// - orgPublicEvent: List public events for an organization
/// - userReceivedEvents: List events that a user has received,These are events that you've received by watching repos and following users. If you are authenticated as the given user, you will see private events. Otherwise, you'll only see public events.
/// - userReceivedPublicEvents: List public events that a user has received
/// - userEvents: List events performed by a user. If you are authenticated as the given user, you will see your private events. Otherwise, you'll only see public events.
/// - userPublicEvents: List public events performed by a user
/// - orgEvents: List events for an organization

public enum EventAPI {
    case publicEvents(page:Int, perpage:Int)
    case repoEvents(owner:String, repo:String, page:Int, perpage:Int)
    case repoIssueEvents(owner:String, repo:String, page:Int, perpage:Int)
    case repoPublicNetworkEvents(owner:String, repo:String, page:Int, perpage:Int)
    case orgPublicEvent(organization:String, page:Int, perpage:Int)
    case userReceivedEvents(username:String, page:Int, perpage:Int)
    case userReceivedPublicEvents(username:String, page:Int, perpage:Int)
    case userEvents(username:String, page:Int, perpage:Int)
    case userPublicEvents(username:String, page:Int, perpage:Int)
    case orgEvents(username:String, organization:String, page:Int, perpage:Int)
}

extension EventAPI: TargetType {
    
    public var headers: [String : String]? {
        var header = ["User-Agent": "BeeFunMac","Authorization": AppToken.shared.access_token ?? "", "timeoutInterval": "15.0", "Accept": "application/vnd.github.v3.star+json"]
        switch self {
        default:
            header = ["User-Agent": "BeeFunMac","Authorization": AppToken.shared.access_token ?? "", "timeoutInterval": "15.0"]
            return header
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        return (Alamofire.ParameterEncoding.self as? ParameterEncoding)!
    }
    public var baseURL: URL {
        switch self {
        default:
            return URL(string: "https://api.github.com")!
        }
    }
    
    public var path: String {
        switch self {
        //Event
        case .publicEvents:
            return "/events"
        case .repoEvents(let owner, let repo, _, _):
            return "/repos/\(owner)/\(repo)/events"
            
        case .repoIssueEvents(let owner, let repo, _, _):
            return "/repos/\(owner)/\(repo)/issues/events"
            
        case .repoPublicNetworkEvents(let owner, let repo, _, _):
            return "/networks/\(owner)/\(repo)/events"
            
        case .orgPublicEvent(let organization, _, _):
            return "/orgs/\(organization)/events"
            
        case .userReceivedEvents(let username, _, _):
            return "/users/\(username)/received_events"
            
        case .userReceivedPublicEvents(let username, _, _):
            return "/users/\(username)/received_events/public"
        case .userEvents(let username, _, _):
            return "/users/\(username)/events"
        case .userPublicEvents(let username, _, _):
            return "/users/\(username)/events/public"
        case .orgEvents(let username, let organization, _, _):
            return "/users/\(username)/events/orgs/\(organization)"
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
        //Event
        case .publicEvents(let page, let perpage):
            return [
                "page": page as AnyObject,
                "per_page": perpage as AnyObject
            ]
        case .repoEvents(_, _, let page, let perpage):
            return [
                "page": page as AnyObject,
                "per_page": perpage as AnyObject
            ]
        case .repoIssueEvents(_, _, let page, let perpage):
            return [
                "page": page as AnyObject,
                "per_page": perpage as AnyObject
            ]
        case .repoPublicNetworkEvents(_, _, let page, let perpage):
            return [
                "page": page as AnyObject,
                "per_page": perpage as AnyObject
            ]
        case .orgPublicEvent(_, let page, let perpage):
            return [
                "page": page as AnyObject,
                "per_page": perpage as AnyObject
            ]
        case .userReceivedEvents(_, let page, let perpage):
            return [
                "page": page as AnyObject,
                "per_page": perpage as AnyObject
            ]
        case .userReceivedPublicEvents(_, let page, let perpage):
            return [
                "page": page as AnyObject,
                "per_page": perpage as AnyObject
            ]
        case .userEvents(_, let page, let perpage):
            return [
                "page": page as AnyObject,
                "per_page": perpage as AnyObject
            ]
        case .userPublicEvents(_, let page, let perpage):
            return [
                "page": page as AnyObject,
                "per_page": perpage as AnyObject
            ]
        case .orgEvents(_, _, let page, let perpage):
            return [
                "page": page as AnyObject,
                "per_page": perpage as AnyObject
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
