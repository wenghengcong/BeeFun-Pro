//
//  GitV3API.swift
//  BeeFun
//
//  Created by wenghengcong on 16/1/10.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit
import Foundation
import Moya
import Alamofire
import ObjectMapper

typealias SuccessClosure = (_ result: AnyObject) -> Void
//typealias SuccessClosure = (result: Mappable) -> Void
typealias FailClosure = (_ errorMsg: String?) -> Void

// MARK: - Provider setup
class GitHupPorvider<Target>: MoyaProvider<Target> where Target: TargetType {

    override init(endpointClosure: @escaping (Target) -> Endpoint, requestClosure: @escaping (Endpoint, @escaping MoyaProvider<GitHubAPI>.RequestResultClosure) -> Void, stubClosure: @escaping (Target) -> StubBehavior, callbackQueue: DispatchQueue?, manager: Manager, plugins: [PluginType], trackInflights: Bool) {
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, callbackQueue: callbackQueue, manager: manager, plugins: plugins, trackInflights: trackInflights)
    }

}

struct Provider {
    
    fileprivate static var endpointsClosure = { (target: GitHubAPI) -> Endpoint in
        
        var endpoint: Endpoint = Endpoint(url: url(target), sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: target.headers)
        return endpoint
    }
    static func stubBehaviour(_: GitHubAPI) -> Moya.StubBehavior {
        return .never
    }
    
    static func DefaultProvider() -> GitHupPorvider<GitHubAPI> {
        
        return GitHupPorvider(endpointClosure: endpointsClosure, requestClosure: MoyaProvider<GitHubAPI>.defaultRequestMapping, stubClosure: MoyaProvider.neverStub, callbackQueue: DispatchQueue.main, manager: Alamofire.SessionManager.default, plugins: [], trackInflights: false)
    }
    
    fileprivate struct SharedProvider {
        static var instance = Provider.DefaultProvider()
    }
    
    static var sharedProvider: GitHupPorvider<GitHubAPI> {
        
        get {
            return SharedProvider.instance
        }
        
        set (newSharedProvider) {
            SharedProvider.instance = newSharedProvider
        }
        
    }
}

struct APIKeyName {
    static let sortKey = "sort"
    static let dirctionKey = "direction"
}

public enum GitHubAPI {
    //url
    case gerUrl(url:String)
    case postUrl(url:String)
    case headtUrl(url:String)
    case putUrl(url:String)
    case patchUrl(url:String)
    case deleteUrl(url:String)
    case traceUrl(url:String)
    case connectUrl(url:String)

    //user
    case myInfo
    case userInfo(username:String)
    case updateUserInfo(name:String, email:String, blog:String, company:String, location:String, hireable:Bool, bio:String)
    case allUsers(page:Int, perpage:Int)

    //user email
    case userEmails
    case addEmail
    case delEmail

    //user followers
    case userFollowers(page:Int, perpage:Int, username:String)
    case myFollowers
    case userFollowing(page:Int, perpage:Int, username:String)
    case myFollowing
    case checkUserFollowing(username:String)
    case checkFollowing(username:String, target_user:String)
    case follow(username:String)
    case unfollow(username:String)

    //repository
    case myRepos(page:Int, perpage:Int, type:String, sort:String, direction:String)
    case userRepos( username:String, page:Int, perpage:Int, type:String, sort:String, direction:String)
    case orgRepos(type:String, organization:String)
    case pubRepos(page:Int, perpage:Int)
    case userSomeRepo(owner:String, repo:String)

    //starring
    case reposStargazers(owner:String, repo:String)
    case userStarredRepos(username:String, sort:String, direction:String)
    case myStarredRepos(page:Int, perpage:Int, sort:String, direction:String)
    case allMyStarredRepos(sort:String, direction:String)
    case checkStarred(owner:String, repo:String)
    case starRepo(owner:String, repo:String)
    case unstarRepo(owner:String, repo:String)

    //notification
//    case MyNotifications(page:Int,perpage:Int,all:Bool ,participating:Bool,since:String,before:String)
    case myNotifications(page:Int, perpage:Int, all:String, participating:String)
    case repoNotifications(owner:String, repo:String, all:String, participating:String)
    case markNotificationsAsRead(last_read_at:String)
    case markRepoNotificationsAsRead(owner:String, repo:String, last_read_at:String)

    //watching
    case repoWatchers(page:Int, perpage:Int, owner:String, repo:String)
    case userWatchedRepos(page:Int, perpage:Int, username:String)
    case myWatchedRepos(page:Int, perpage:Int)
    case checkWatched(owner:String, repo:String)
    case watchingRepo(owner:String, repo:String, subscribed:String, ignored:String)
    case unWatchingRepo(owner:String, repo:String)

    //forks
    case userReposForks(page:Int, perpage:Int, sort:String, owner:String, repo:String)
    case createFork(owner:String, repo:String)

    //gist

}

extension GitHubAPI: TargetType {

    public var headers: [String : String]? {
        var header = ["User-Agent": "BeeFunMac","Authorization": AppToken.shared.access_token ?? "", "timeoutInterval": "15.0", "Accept": "application/vnd.github.v3.star+json"]
        switch self {
        case .reposStargazers( _, _):
            return header
        case .myStarredRepos:
            return header
        case .allMyStarredRepos:
            return header
        case .userStarredRepos(_ , _, _):
            return header
        case .checkStarred( _, _):
            return header
        case .starRepo( _, _):
            return header
        case .unstarRepo( _, _):
            return header
        default:
            header = ["User-Agent": "BeeFunMac", "Authorization": AppToken.shared.access_token ?? "", "timeoutInterval": "15.0"]
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
        //url
        case .gerUrl(let url):
            return url
        case .postUrl(let url):
            return url
        case .headtUrl(let url):
            return url
        case .putUrl(let url):
            return url
        case .patchUrl(let url):
            return url
        case .deleteUrl(let url):
            return url
        case .traceUrl(let url):
            return url
        case .connectUrl(let url):
            return url

          //user
        case .myInfo:
            return "/user"
        case .userInfo(let username):
            return "/users/\(username)"
        case .updateUserInfo:
            return "/user"
        case .allUsers(_, _):
            return "/users"
        //user email
        case .userEmails:
            return "/user/emails"
        case .addEmail:
            return "/user/emails"
        case .delEmail:
            return "/user/emails"

        //user followers
        case .userFollowers(_, _, let username):
            return "/users/\(username)/followers"
        case .myFollowers:
            return "/users/followers"
        case .userFollowing(_, _, let username):
            return "/users/\(username)/following"
        case .myFollowing:
            return "/users/following"
        case .checkUserFollowing(let username):
            return "/user/following/\(username)"
        case .checkFollowing(let username, let target_user):
            return "/users/\(username)/following/\(target_user)"
        case .follow(let username):
            return "/user/following/\(username)"
        case .unfollow(let username):
            return "/user/following/\(username)"

        case .myRepos:
            return "/user/repos"
        case .userRepos(let username, _, _, _, _, _):
            return "/users/\(username)/repos"

        case .orgRepos(_, let organization):
            return "/orgs/\(organization)/repos"
        case .pubRepos:
            return "/repositories"
        case .userSomeRepo(let owner, let repo):
            return "/repos/\(owner)/\(repo)"

        //starring
        case .reposStargazers(let owner, let repo):
            return "/repos/\(owner)/\(repo)/stargazers"
        case .myStarredRepos:
            return "/user/starred"
        case .allMyStarredRepos:
            return "/user/starred"
        case .userStarredRepos(let username, _, _):
            return "/users/\(username)/starred"
        case .checkStarred(let owner, let repo):
            return "/user/starred/\(owner)/\(repo)"
        case .starRepo(let owner, let repo):
            return "/user/starred/\(owner)/\(repo)"
        case .unstarRepo(let owner, let repo):
            return "/user/starred/\(owner)/\(repo)"

               //notification
        case .myNotifications:
            return "/notifications"
        case .repoNotifications(let owner, let repo, _, _):
            return "/repos/\(owner)/\(repo)/notifications"
        case .markNotificationsAsRead:
            return "/notifications"
        case .markRepoNotificationsAsRead(let owner, let repo, _):
            return "/repos/\(owner)/\(repo)/notifications"

        //watching
        case .repoWatchers(_, _, let owner, let repo):
            return "/repos/\(owner)/\(repo)/subscribers"
        case .userWatchedRepos(_, _, let username):
            return "/users/\(username)/subscriptions"
        case .myWatchedRepos:
            return "/user/subscriptions"
        case .checkWatched(let owner, let repo):
            return "/repos/\(owner)/\(repo)/subscription"
        case .watchingRepo(let owner, let repo, _, _):
            return "/user/subscriptions/\(owner)/\(repo)"
        case .unWatchingRepo(let owner, let repo):
            return "/repos/\(owner)/\(repo)/subscription"
        //forks
        case .userReposForks(_, _, _, let owner, let repo):
            return "/repos/\(owner)/\(repo)/forks"
        case .createFork(let owner, let repo):
            return "/repos/\(owner)/\(repo)/forks"
        }
    }

    public var method: Moya.Method {

        switch self {

        //url
        case .gerUrl:
            return .get
        case .postUrl:
            return .post
        case .headtUrl:
            return .head
        case .putUrl:
            return .put
        case .patchUrl:
            return .patch
        case .deleteUrl:
            return .delete
        case .traceUrl:
            return .trace
        case .connectUrl:
            return .connect

        case .updateUserInfo:
            return .patch
            //user email
        case .addEmail:
            return .post
        case .delEmail:
            return .delete
        //user followers
        case .follow(_):
            return .put
        case .unfollow(_):
            return .delete

        //starring
        case .starRepo(_, _):
            return .put
        case .unstarRepo(_, _):
            return .delete
        case .markRepoNotificationsAsRead:
            return .put
        case .markNotificationsAsRead:
            return .put

        //watching
        case .watchingRepo:
            return .put
        case .unWatchingRepo:
            return .delete

        case .createFork:
            return .post
        default:
            return .get

        }
    }

    public var parameters: [String: Any]? {
        switch self {
        //follower
        case .userFollowers(let page, let perpage, _):
            return [
                "page": page as AnyObject,
                "per_page": perpage as AnyObject
            ]
        case .userFollowing(let page, let perpage, _):
            return [
                "page": page as AnyObject,
                "per_page": perpage as AnyObject
            ]

        case .updateUserInfo(let name, let email, let blog, let company, let location, let hireable, let bio):
            return [
                    "name": name as AnyObject,
                    "email": email as AnyObject,
                    "blog": blog as AnyObject,
                    "company": company as AnyObject,
                    "location": location as AnyObject,
                    "hireable": hireable as AnyObject,
                    "bio": bio as AnyObject
                ]
        case .allUsers(let page, let perpage):
            return [
                "page": page as AnyObject,
                "per_page": perpage as AnyObject
            ]
        case .myRepos(let page, let perpage, let type, let sort, let direction):
            return [
                "page": page as AnyObject,
                "per_page": perpage as AnyObject,
                "type": type as AnyObject,
                "sort": sort as AnyObject,
                "direction": direction as AnyObject
            ]
        case .userRepos(_, let page, let perpage, let type, let sort, let direction):
            return [
                "page": page as AnyObject,
                "per_page": perpage as AnyObject,
                "type": type as AnyObject,
                "sort": sort as AnyObject,
                "direction": direction as AnyObject
            ]
        case .orgRepos(let type, _):
            return [
                "type": type as AnyObject
            ]
        case .pubRepos(let page, let perpage):
            return [
                "page": page as AnyObject,
                "per_page": perpage as AnyObject
            ]

        //starring
        case .userStarredRepos(_, let sort, let direction):
            return [
                "sort": sort as AnyObject,
                "direction": direction as AnyObject
            ]
        case .myStarredRepos( let page, let perpage, let sort, let direction):
            return [
                "sort": sort as AnyObject,
                "direction": direction as AnyObject,
                "page": page as AnyObject,
                "per_page": perpage as AnyObject
            ]
        case .allMyStarredRepos(let sort, let direction):
            return [
                "sort": sort as AnyObject,
                "direction": direction as AnyObject,
            ]
        //notification
        case .myNotifications(let page, let perpage, let all, let participating):
            return [
                "all": all as AnyObject,
                "participating": participating as AnyObject,
                "page": page as AnyObject,
                "per_page": perpage as AnyObject
            ]
        case .repoNotifications(_, _, let all, let participating):
            return [
                "all": all as AnyObject,
                "participating": participating as AnyObject
            ]
        case .markNotificationsAsRead(let last_read_at):
            return [
                "last_read_at": last_read_at as AnyObject
            ]
        case .markRepoNotificationsAsRead(_, _, let last_read_at):
            return [
                "last_read_at": last_read_at as AnyObject
            ]

        //watching
        case .repoWatchers(let page, let perpage, _, _):
            return [
                "page": page as AnyObject,
                "per_page": perpage as AnyObject
            ]
        case .userWatchedRepos(let page, let perpage, _):
            return [
                "page": page as AnyObject,
                "per_page": perpage as AnyObject
            ]
        case .myWatchedRepos(let page, let perpage):
            return [
                "page": page as AnyObject,
                "per_page": perpage as AnyObject
            ]

//        case WatchingRepo(_,_,let subscribed,let ignored):
//            return [
//                "subscribed":subscribed,
//                "ignored":ignored
//            ]

       
            //forks
        case .userReposForks(let page, let perpage, let sort, _, _):
            return [
                "page": page as AnyObject,
                "per_page": perpage as AnyObject,
                "sort": sort as AnyObject
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
        case .myInfo:
            return "get user info.".data(using: String.Encoding.utf8)!
        case .myRepos:
            return "get user repos.".data(using: String.Encoding.utf8)!

        default :
            return "default".data(using: String.Encoding.utf8)!
        }

    }

}

// MARK: - Provider support
public extension String {
    var URLEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
}

public func url(_ route: TargetType) -> String {
    print("api:\(route.baseURL.appendingPathComponent(route.path).absoluteString)")
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}
