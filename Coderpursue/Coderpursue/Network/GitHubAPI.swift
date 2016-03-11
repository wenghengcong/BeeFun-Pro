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
import ObjectMapper
import SwiftyJSON

typealias SuccessClosure = (result: AnyObject) -> Void
//typealias SuccessClosure = (result: Mappable) -> Void
typealias FailClosure = (errorMsg: String?) -> Void

// MARK: - Provider setup

// (Endpoint<Target>, NSURLRequest -> Void) -> Void
func endpointResolver() -> MoyaProvider<GitHubAPI>.RequestClosure {
    return { (endpoint, closure) in
        let request: NSMutableURLRequest = endpoint.urlRequest.mutableCopy() as! NSMutableURLRequest
        request.HTTPShouldHandleCookies = false
        closure(request)
    }
}

class GitHupPorvider<Target where Target: TargetType>: MoyaProvider<Target> {
    
    override init(endpointClosure: EndpointClosure = MoyaProvider.DefaultEndpointMapping,
        requestClosure: RequestClosure = MoyaProvider.DefaultRequestMapping,
        stubClosure: StubClosure = MoyaProvider.NeverStub,
        manager: Manager = Manager.sharedInstance,
        plugins: [PluginType] = []) {
            super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, manager: manager, plugins: plugins)
    }
    
    
    
    
}

struct Provider{
    
    private static var endpointsClosure = { (target: GitHubAPI) -> Endpoint<GitHubAPI> in
        
        var endpoint: Endpoint<GitHubAPI> = Endpoint<GitHubAPI>(URL: url(target), sampleResponseClosure: {.NetworkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters)
        // Sign all non-XApp token requests
        
        switch target {
        default:
            print("current token:\( AppToken.sharedInstance.access_token)")
            return endpoint.endpointByAddingHTTPHeaderFields(["Authorization": AppToken.sharedInstance.access_token ?? ""])
        }
    }
    static func stubBehaviour(_: GitHubAPI) -> Moya.StubBehavior {
        return .Never
    }
    
    static func DefaultProvider() -> GitHupPorvider<GitHubAPI> {
        return GitHupPorvider(endpointClosure: endpointsClosure, requestClosure: endpointResolver(), stubClosure:MoyaProvider.NeverStub , manager: Alamofire.Manager.sharedInstance, plugins:[])
    }
    
    private struct SharedProvider {
        static var instance = Provider.DefaultProvider()
    }
    
    static var sharedProvider:GitHupPorvider<GitHubAPI> {
        
        get {
            return SharedProvider.instance
        }
        
        set (newSharedProvider) {
            SharedProvider.instance = newSharedProvider
        }
        
    }
    /*
    static func requestDataWithTarget<T: Mappable>(target: GitHubAPI, type: T.Type , successClosure: SuccessClosure, failClosure: FailClosure) {
        let _ = sharedProvider.request(target).subscribe { (event) -> Void in
            switch event {
            case .Next(let response):
                let info = Mapper<CommonInfo>().map(JSON(data: response.data,options: .AllowFragments).object)
                guard info?.code == RequestCode.success.rawValue else {
                    failClosure(errorMsg: info?.msg)
                    return
                }
                guard let data = info?.data else {
                    failClosure(errorMsg: "数据为空")
                    return
                }
                successClosure(result: data)
            case .Error(let error):
                print("网络请求失败...\(error)")
            default:
                break
            }
        }
    }
    */

    
}

struct APIKeyName {
    
    static let sortKey = "sort"
    static let dirctionKey = "direction"
    
}


public enum GitHubAPI {
    //user
    case MyInfo
    case UserInfo(username:String)
    case UpdateUserInfo(name:String, email:String, blog:String, company:String, location:String,hireable:String,bio:String)
    case AllUsers(page:Int,perpage:Int)
    
    //user email
    case UserEmails
    case AddEmail
    case DelEmail
    
    //user followers
    case UserFollowers(username:String)
    case MyFollowers
    case UserFollowing(username:String)
    case MyFollowing
    case CheckUserFollowing(username:String)
    case CheckFollowing(username:String ,target_user:String)
    case Follow(username:String)
    case Unfollow(username:String)
    
    //repository
    /**
    *  @param type:String      all, owner, public, private, member. Default: all
    *  @param sort:String      created, updated, pushed, full_name. Default: full_name
    *  @param direction:String asc or desc.
    */
    case MyRepos(type:String, sort:String ,direction:String)
    /**
     *  @param type:String      all, owner, member. Default: owner
     *  @param sort:String       created, updated, pushed, full_name. Default: full_name
     */
    case UserRepos( username:String ,page:Int,perpage:Int,type:String, sort:String ,direction:String)
    case OrgRepos(type:String, organization:String)
    case PubRepos(page:Int,perpage:Int)
    case UserSomeRepo(owner:String, repo:String)
    
    
    //starring
    case ReposStargazers(owner:String ,repo:String)
    case UserStarredRepos(username:String ,sort:String ,direction:String)
    case MyStarredRepos(page:Int,perpage:Int,sort:String ,direction:String)
    case CheckStarred(owner:String ,repo:String)
    case StarRepo(owner:String ,repo:String)
    case UnstarRepo(owner:String ,repo:String)
    
    
    //issue
    case AllIssues(page:Int,perpage:Int,filter:String,state:String,labels:String,sort:String,direction:String)
    case MyIssues(page:Int,perpage:Int,filter:String,state:String,labels:String,sort:String,direction:String)
    case OrgIssues(page:Int,perpage:Int,organization:String,filter:String,state:String,labels:String,sort:String,direction:String)
    case RepoIssues(page:Int,perpage:Int,owner:String,repo:String,milestone:Int,state:String,assignee:String,creator:String,mentioned:String,labels:String,sort:String,direction:String)
    case RepoSigleIssue(owner:String,repo:String,number:Int)
    case CreateIssue(owner:String ,repo:String ,title:String,body:String,assignee:String,milestone:Int,labels:String)
    case EditIssue(owner:String ,repo:String ,number:Int, title:String,body:String,assignee:String,milestone:Int,labels:String)
    case LockIssue(owner:String ,repo:String ,number:Int)
    case UnlockIssue(owner:String ,repo:String ,number:Int)

    //notification
//    case MyNotifications(page:Int,perpage:Int,all:Bool ,participating:Bool,since:String,before:String)

    case MyNotifications(page:Int,perpage:Int,all:String ,participating:String)
    case RepoNotifications(owner:String ,repo:String,all:String ,participating:String)
    case MarkNotificationsAsRead(last_read_at:String)
    case MarkRepoNotificationsAsRead(owner:String ,repo:String,last_read_at:String)
    
    //watching
    case RepoWatchers(page:Int,perpage:Int,owner:String, repo:String)
    case UserWatchedRepos(page:Int,perpage:Int,username:String)
    case MyWatchedRepos(page:Int,perpage:Int)
    case CheckWatched(owner:String, repo:String)
    case WatchingRepo(owner:String, repo:String)
    case UnWatchingRepo(owner:String, repo:String)
    
    //Event
    case PublicEvents(page:Int,perpage:Int)
    case RepoEvents(owner:String, repo:String,page:Int,perpage:Int)
    case RepoIssueEvents(owner:String, repo:String,page:Int,perpage:Int)
    case RepoPublicNetworkEvents(owner:String, repo:String,page:Int,perpage:Int)
    case OrgPublicEvent(organization:String,page:Int,perpage:Int)
    case UserReceivedEvents(username:String ,page:Int,perpage:Int)
    case UserReceivedPublicEvents(username:String ,page:Int,perpage:Int)
    case UserEvents(username:String ,page:Int,perpage:Int)
    case UserPublicEvents(username:String ,page:Int,perpage:Int)
    case OrgEvents(username:String,organization:String,page:Int,perpage:Int)
    
    //trending
    case TrendingRepos(since:String,language:String)
    case TrendingShowcases()
    case TrendingShowcase(showcase:String)
    
    //search
    case SearchUsers(para:ParaSearchUser)
    
}

extension GitHubAPI: TargetType {

    public var baseURL: NSURL {
        switch self {
        case .TrendingRepos:
            return NSURL(string: "http://trending.codehub-app.com/v2")!
        case .TrendingShowcases:
            return NSURL(string: "http://trending.codehub-app.com/v2")!
        case .TrendingShowcase:
            return NSURL(string: "http://trending.codehub-app.com/v2")!
        default:
            return NSURL(string: "https://api.github.com")!
        }
    }
    
    public var path: String {
        switch self {
          //user
        case .MyInfo:
            return "/user"
        case .UserInfo(let username):
            return "/users/\(username)"
        case .UpdateUserInfo:
            return "/user"
        case AllUsers(_,_):
            return "/users"
        //user email
        case .UserEmails:
            return "/user/emails"
        case .AddEmail:
            return "/user/emails"
        case .DelEmail:
            return "/user/emails"
            
        //user followers
        case UserFollowers(let username):
            return "/user/\(username)/followers"
        case MyFollowers:
            return "/user/followers"
        case UserFollowing(let username):
            return "/user/\(username)/following"
        case MyFollowing:
            return "/user/following"
        case CheckUserFollowing(let username):
            return "/user/following/\(username)"
        case CheckFollowing(let username ,let target_user):
            return "/users/\(username)/following/\(target_user)"
        case Follow(let username):
            return "/user/following/\(username)"
        case Unfollow(let username):
            return "/user/following/\(username)"
            
        case MyRepos:
            return "/user/repos"
        case UserRepos(let username,_,_,_,_,_):
            return "/users/\(username)/repos"
            
        case OrgRepos(_ ,let organization):
            return "/orgs/\(organization)/repos"
        case PubRepos:
            return "/repositories"
        case UserSomeRepo(let owner,let repo):
            return "/repos/\(owner)/\(repo)"

            
        //starring
        case ReposStargazers(let owner ,let repo):
            return "/repos/\(owner)/\(repo)/stargazers"
        case MyStarredRepos:
            return "/user/starred"
        case UserStarredRepos(let username ,_ ,_):
            return "/users/\(username)/starred"
        case CheckStarred(let owner ,let repo):
            return "/user/starred/\(owner)/\(repo)"
        case StarRepo(let owner ,let repo):
            return "/user/starred/\(owner)/\(repo)"
        case UnstarRepo(let owner ,let repo):
            return "/user/starred/\(owner)/\(repo)"
           
            
        //issue
        case AllIssues:
            return "/issues"
        case MyIssues:
            return "/user/issues"
        case OrgIssues(_,_,let organization,_,_,_,_,_):
            return "/orgs/\(organization)/issues"
        case RepoIssues(_,_,let owner,let repo,_,_,_,_,_,_,_,_):
            return "/repos/\(owner)/\(repo)/issues"
        case RepoSigleIssue(let owner,let repo,let number):
            return "/repos/\(owner)/\(repo)/issues/\(number)"
        case CreateIssue(let owner ,let repo ,_,_,_,_,_):
            return "/repos/\(owner)/\(repo)/issues"
        case EditIssue(let owner ,let repo ,let number,_,_,_,_,_):
            return "/repos/\(owner)/\(repo)/issues/\(number)"
        case LockIssue(let owner ,let repo ,let number):
            return "/repos/\(owner)/\(repo)/issues/\(number)/lock"
        case .UnlockIssue(let owner ,let repo ,let number):
            return "/repos/\(owner)/\(repo)/issues/\(number)/lock"
            
        //notification
        case MyNotifications:
            return "/notifications"
        case RepoNotifications(let owner,let repo,_,_):
            return "/repos/\(owner)/\(repo)/notifications"
        case MarkNotificationsAsRead:
            return "/notifications"
        case MarkRepoNotificationsAsRead(let owner ,let repo,_):
            return "/repos/\(owner)/\(repo)/notifications"
            
        //watching
        case RepoWatchers(_,_,let owner,let repo):
            return "/repos/\(owner)/\(repo)/subscribers"
        case UserWatchedRepos(_,_,let username):
            return "/users/\(username)/subscriptions"
        case MyWatchedRepos:
            return "/user/subscriptions"
        case CheckWatched(let owner,let repo):
            return "/repos/\(owner)/\(repo)/subscription"
        case WatchingRepo(let owner,let repo):
            return "/repos/\(owner)/\(repo)/subscription"
        case UnWatchingRepo(let owner,let repo):
            return "/repos/\(owner)/\(repo)/subscription"

            //Event
        case PublicEvents:
            return "/events"
        case RepoEvents(let owner, let repo,_,_):
            return "/repos/\(owner)/\(repo)/events"

        case RepoIssueEvents(let owner, let repo,_,_):
            return "/repos/\(owner)/\(repo)/issues/events"

        case RepoPublicNetworkEvents(let owner,let repo,_,_):
            return "/networks/\(owner)/\(repo)/events"

        case OrgPublicEvent(let organization,_,_):
            return "/orgs/\(organization)/events"

        case UserReceivedEvents(let username ,_,_):
            return "/users/\(username)/received_events"

        case UserReceivedPublicEvents(let username ,_,_):
            return "/users/\(username)/received_events/public"
        case UserEvents(let username ,_,_):
            return "/users/\(username)/events"
        case UserPublicEvents(let username ,_,_):
            return "/users/\(username)/events/public"
        case OrgEvents(let username,let organization,_,_):
            return "/users/\(username)/events/orgs/\(organization)"

        //trending
        case TrendingRepos:
            return "/trending"
        case TrendingShowcases:
            return "/showcases"
        case TrendingShowcase(let showcase):
            return "/showcases/\(showcase)"

        //search
        case SearchUsers:
            return "/search/users"

        }
        
    }

    public var method: Moya.Method {
        
        switch self {
        case .UpdateUserInfo:
            return .PATCH
            //user email
        case .AddEmail:
            return .POST
        case .DelEmail:
            return .DELETE
        //user followers
        case Follow(_):
            return .PUT
        case Unfollow(_):
            return .DELETE
            
        //starring
        case StarRepo(_,_):
            return .PUT
        case UnstarRepo(_,_):
            return .DELETE
        case CreateIssue(_,_,_,_,_,_,_):
            return .POST
        case .EditIssue(_,_,_,_,_,_,_,_):
            return .PATCH
        case .LockIssue(_,_,_):
            return .PUT
        case .UnlockIssue(_,_,_):
            return .DELETE
        case .MarkRepoNotificationsAsRead:
            return .PUT
        case .MarkNotificationsAsRead:
            return .PUT
            
        //watching
        case WatchingRepo:
            return .PUT
        case UnWatchingRepo:
            return .DELETE
   
            
        default:
            return .GET

        }
    }
    
    public var parameters: [String: AnyObject]? {
        
        switch self {
        case .UpdateUserInfo(let name,let email,let blog,let company,let location,let hireable,let bio):
            return [
                    "name": name,
                    "email": email,
                    "blog": blog,
                    "company": company,
                    "location": location,
                    "hireable":hireable,
                    "bio":bio
                ]
        case .AllUsers(let page, let perpage):
            return [
                "page":page,
                "per_page":perpage
            ]
        case MyRepos(let type, let sort ,let direction):
            return [
                "type":type,
                "sort":sort,
                "direction":direction
            ]
        case UserRepos(_,let page, let perpage,let type, let sort ,let direction):
            return [
                "page":page,
                "per_page":perpage,
                "type":type,
                "sort":sort,
                "direction":direction
            ]
        case OrgRepos(let type, _):
            return [
                "type":type,
            ]
        case PubRepos(let page, let perpage):
            return [
                "page":page,
                "per_page":perpage
            ]
            
        //starring
        case UserStarredRepos(_ ,let sort ,let direction):
            return [
                "sort":sort,
                "direction":direction
            ]
        case MyStarredRepos( let page,let perpage ,let sort ,let direction):
            return [
                "sort":sort,
                "direction":direction,
                "page":page,
                "per_page":perpage
            ]
        case AllIssues(let page,let perpage,let filter,let state,let labels,let sort,let direction):
            return [
                "page":page,
                "per_page":perpage,
                "filter":filter,
                "state":state,
                "labels":labels,
                "sort":sort,
                "direction":direction,
            ]
        case MyIssues(let page,let perpage,let filter,let state,let labels,let sort,let direction):
            return [
                "page":page,
                "per_page":perpage,
                "filter":filter,
                "state":state,
                "labels":labels,
                "sort":sort,
                "direction":direction,
            ]

        case OrgIssues(let page,let perpage, _, let filter,let state,let labels,let sort,let direction):
            return [
                "page":page,
                "per_page":perpage,
                "filter":filter,
                "state":state,
                "labels":labels,
                "sort":sort,
                "direction":direction,
            ]
        case RepoIssues(let page,let perpage,_,_,let milestone,let state,let assignee,let creator,let mentioned,let labels,let sort,let direction):
            return [
                "page":page,
                "per_page":perpage,
                "milestone":milestone,
                "state":state,
                "assignee":assignee,
                "creator":creator,
                "mentioned":mentioned,
                "labels":labels,
                "sort":sort,
                "direction":direction,
            ]

        case CreateIssue(_,_ ,let title,let body,let assignee,let milestone,let labels):
            return [
                "title":title,
                "body":body,
                "assignee":assignee,
                "milestone":milestone,
                "labels":labels
            ]
        case EditIssue(_ ,_ ,_, let title,let body,let assignee,let milestone,let labels):
            return [
                
                "title":title,
                "body":body,
                "assignee":assignee,
                "milestone":milestone,
                "labels":labels
            ]
            
        //notification
        case MyNotifications(let page,let perpage,let all ,let participating):
            return [
                "all":all,
                "participating":participating,
                "page":page,
                "per_page":perpage
            ]
        case RepoNotifications(_,_,let all ,let participating):
            return [
                "all":all,
                "participating":participating,
            ]
        case MarkNotificationsAsRead(let last_read_at):
            return [
                "last_read_at":last_read_at
            ]
        case MarkRepoNotificationsAsRead(_,_,let last_read_at):
            return [
                "last_read_at":last_read_at
            ]
            
        //watching
        case RepoWatchers(let page,let perpage,_,_):
            return [
                "page":page,
                "per_page":perpage,
            ]
        case UserWatchedRepos(let page,let perpage,_):
            return [
                "page":page,
                "per_page":perpage,
            ]
        case MyWatchedRepos(let page,let perpage):
            return [
                "page":page,
                "per_page":perpage,
            ]
            
            //Event
        case PublicEvents(let page,let perpage):
            return [
                "page":page,
                "per_page":perpage,
            ]
        case RepoEvents(_,_,let page,let perpage):
            return [
                "page":page,
                "per_page":perpage,
            ]
        case RepoIssueEvents(_,_,let page,let perpage):
            return [
                "page":page,
                "per_page":perpage,
            ]
        case RepoPublicNetworkEvents(_,_,let page,let perpage):
            return [
                "page":page,
                "per_page":perpage,
            ]
        case OrgPublicEvent(_,let page,let perpage):
            return [
                "page":page,
                "per_page":perpage,
            ]
        case UserReceivedEvents(_,let page,let perpage):
            return [
                "page":page,
                "per_page":perpage,
            ]
        case UserReceivedPublicEvents(_,let page,let perpage):
            return [
                "page":page,
                "per_page":perpage,
            ]
        case UserEvents(_,let page,let perpage):
            return [
                "page":page,
                "per_page":perpage,
            ]
        case UserPublicEvents(_,let page,let perpage):
            return [
                "page":page,
                "per_page":perpage,
            ]
        case OrgEvents(_,_,let page,let perpage):
            return [
                "page":page,
                "per_page":perpage,
            ]
        //trending
        case TrendingRepos(let since,let language):
            return [
                "since":since,
                "language":language,
            ]
            
        case SearchUsers(let para):
            return [
                "q":para.q,
                "sort":para.sort,
                "order":para.order,
                "page":para.page,
                "per_page":para.perPage,
            ]
        default:
            return nil
            
        }
        
    }
    
    //Any target you want to hit must provide some non-nil NSData that represents a sample response. This can be used later for tests or for providing offline support for developers. This should depend on self.
    public var sampleData: NSData {
        switch self {
        case .MyInfo:
            return "get user info.".dataUsingEncoding(NSUTF8StringEncoding)!
        case .MyRepos:
            return "get user repos.".dataUsingEncoding(NSUTF8StringEncoding)!
            
        default :
            return "default".dataUsingEncoding(NSUTF8StringEncoding)!
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
    print("api:\(route.baseURL.URLByAppendingPathComponent(route.path).absoluteString)")
    return route.baseURL.URLByAppendingPathComponent(route.path).absoluteString
}

