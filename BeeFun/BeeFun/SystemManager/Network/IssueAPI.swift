//
//  IssueAPI.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/4/14.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit
import Foundation
import Moya
import Alamofire
import ObjectMapper

class InsideIssueProvider<Target>: MoyaProvider<Target> where Target: TargetType {
    
    override init(endpointClosure: @escaping (Target) -> Endpoint, requestClosure: @escaping (Endpoint, @escaping MoyaProvider<IssueAPI>.RequestResultClosure) -> Void, stubClosure: @escaping (Target) -> StubBehavior, callbackQueue: DispatchQueue?, manager: Manager, plugins: [PluginType], trackInflights: Bool) {
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, callbackQueue: callbackQueue, manager: manager, plugins: plugins, trackInflights: trackInflights)
    }
    
}

struct IssueProvider {

    fileprivate static var endpointsClosure = { (target: IssueAPI) -> Endpoint in
        var endpoint: Endpoint = Endpoint(url: url(target), sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: target.headers)
        return endpoint
    }
    
    static func stubBehaviour(_: IssueAPI) -> Moya.StubBehavior {
        return .never
    }
    
    static func DefaultProvider() -> InsideIssueProvider<IssueAPI> {
        return InsideIssueProvider(endpointClosure: endpointsClosure, requestClosure: MoyaProvider<IssueAPI>.defaultRequestMapping, stubClosure: MoyaProvider.neverStub, callbackQueue: DispatchQueue.main, manager: Alamofire.SessionManager.default, plugins: [], trackInflights: false)
    }
    
    fileprivate struct SharedProvider {
        static var instance = IssueProvider.DefaultProvider()
    }
    static var sharedProvider: InsideIssueProvider<IssueAPI> {
        get {
            return SharedProvider.instance
        }
        
        set (newSharedProvider) {
            SharedProvider.instance = newSharedProvider
        }
        
    }
}

/// Issue https://developer.github.com/v3/issues/
///
/// - allIssues: List all issues assigned to the authenticated user across all visible repositories including owned repositories, member repositories, and organization repositories

/// - myIssues: List all issues across owned and member repositories assigned to the authenticated user

/// - orgIssues: List all issues for a given organization assigned to the authenticated user

/// - repoIssues: List issues for a repository
/*
 {
    "page": page
    "per_page"
     milestone  integer or string
                    If an integer is passed, it should refer to a milestone by its number field. If the string * is passed, issues with any milestone are accepted. If the string none is passed, issues without milestones are returned.
     state  string
                    Indicates the state of the issues to return. Can be either open, closed, or all. Default: open
     assignee    string
                    Can be the name of a user. Pass in none for issues with no assigned user, and * for issues assigned to any user.
     creator    string
                    The user that created the issue.
     mentioned    string
                    A user that's mentioned in the issue.
     labels    string
                    A list of comma separated label names. Example: bug,ui,@high
     sort    string
                    What to sort results by. Can be either created, updated, comments. Default: created
     direction    string
                    The direction of the sort. Can be either asc or desc. Default: desc
     since    string
                    Only issues updated at or after this time are returned. This is a timestamp in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ.
 }
 */
/// - repoSigleIssue: Get a single issue
/// - createIssue: Create an issue
/*
 {
    "title": "Found a bug",
    "body": "I'm having a problem with this.",
    "assignees": [
        "octocat"
    ],
    "milestone": 1,
    "labels": [
    "bug"
    ]
 }
 */
/// - editIssue: Edit an issue
/// - lockIssue: Lock an issue
/// - unlockIssue: Unlock an issue
public enum IssueAPI {
    
    case allIssues(page:Int, perpage:Int, filter:String, state:String, labels:String, sort:String, direction:String)
    case myIssues(page:Int, perpage:Int, filter:String, state:String, labels:String, sort:String, direction:String)
    case orgIssues(page:Int, perpage:Int, organization:String, filter:String, state:String, labels:String, sort:String, direction:String)
    case repoIssues(owner:String, repo:String, para: [String: Any])
    case repoSigleIssue(owner:String, repo:String, number:Int)
    case createIssue(owner:String, repo:String, body: [String: Any])
    case editIssue(owner:String, repo:String, number:Int, title:String, body:String, assignee:String, milestone:Int, labels:String)
    case lockIssue(owner:String, repo:String, number:Int)
    case unlockIssue(owner:String, repo:String, number:Int)
    
}

extension IssueAPI: TargetType {
    
    public var headers: [String : String]? {
        var header = ["User-Agent": "BeeFunMac","Authorization": AppToken.shared.access_token ?? "", "timeoutInterval": "15.0", "Accept": "application/vnd.github.v3.star+json"]
        switch self {
        default:
            header = ["User-Agent": "BeeFunMac","Authorization": AppToken.shared.access_token ?? "", "timeoutInterval": "15.0"]
            return header
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        return Alamofire.ParameterEncoding.self as! ParameterEncoding
    }
    public var baseURL: URL {
        switch self {
        default:
            return URL(string: "https://api.github.com")!
        }
    }
    
    public var path: String {
        switch self {
        //issue
        case .allIssues:
            return "/issues"
        case .myIssues:
            return "/user/issues"
        case .orgIssues(_, _, let organization, _, _, _, _, _):
            return "/orgs/\(organization)/issues"
        case .repoIssues(let owner, let repo, _):
            return "/repos/\(owner)/\(repo)/issues"
        case .repoSigleIssue(let owner, let repo, let number):
            return "/repos/\(owner)/\(repo)/issues/\(number)"
        case .createIssue(let owner, let repo, _):
            return "/repos/\(owner)/\(repo)/issues"
        case .editIssue(let owner, let repo, let number, _, _, _, _, _):
            return "/repos/\(owner)/\(repo)/issues/\(number)"
        case .lockIssue(let owner, let repo, let number):
            return "/repos/\(owner)/\(repo)/issues/\(number)/lock"
        case .unlockIssue(let owner, let repo, let number):
            return "/repos/\(owner)/\(repo)/issues/\(number)/lock"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .createIssue(_, _, _):
            return .post
        case .editIssue(_, _, _, _, _, _, _, _):
            return .patch
        case .lockIssue(_, _, _):
            return .put
        case .unlockIssue(_, _, _):
            return .delete
        default:
            return .get
        }
    }
    
    public var parameters: [String : Any]? {
        switch self {
        case .allIssues(let page, let perpage, let filter, let state, let labels, let sort, let direction):
            return [
                "page": page as AnyObject,
                "per_page": perpage as AnyObject,
                "filter": filter as AnyObject,
                "state": state as AnyObject,
                "labels": labels as AnyObject,
                "sort": sort as AnyObject,
                "direction": direction as AnyObject
            ]
        case .myIssues(let page, let perpage, let filter, let state, let labels, let sort, let direction):
            return [
                "page": page as AnyObject,
                "per_page": perpage as AnyObject,
                "filter": filter as AnyObject,
                "state": state as AnyObject,
                "labels": labels as AnyObject,
                "sort": sort as AnyObject,
                "direction": direction as AnyObject
            ]
            
        case .orgIssues(let page, let perpage, _, let filter, let state, let labels, let sort, let direction):
            return [
                "page": page as AnyObject,
                "per_page": perpage as AnyObject,
                "filter": filter as AnyObject,
                "state": state as AnyObject,
                "labels": labels as AnyObject,
                "sort": sort as AnyObject,
                "direction": direction as AnyObject
            ]
        case .repoIssues(_, _, let para):
            return para
        case .createIssue(_, _, let body):
            return body
        case .editIssue(_, _, _, let title, let body, let assignee, let milestone, let labels):
            return [
                "title": title as AnyObject,
                "body": body as AnyObject,
                "assignee": assignee as AnyObject,
                "milestone": milestone as AnyObject,
                "labels": labels as AnyObject
            ]
        default:
            return nil
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


