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

typealias SuccessClosure = (_ result: AnyObject) -> Void
//typealias SuccessClosure = (result: Mappable) -> Void
typealias FailClosure = (_ errorMsg: String?) -> Void

// MARK: - Provider setup

// (Endpoint<Target>, NSURLRequest -> Void) -> Void
func endpointResolver() -> MoyaProvider<GitHubAPI>.RequestClosure {
    return { (endpoint, closure) in
        let request: NSMutableURLRequest = endpoint.urlRequest.mutableCopy() as! NSMutableURLRequest
        request.httpShouldHandleCookies = false
        closure(request)
    }
}

class GitHupPorvider<Target>: MoyaProvider<Target> where Target: TargetType {
    
    override init(endpointClosure: EndpointClosure = MoyaProvider.DefaultEndpointMapping,
        requestClosure: RequestClosure = MoyaProvider.DefaultRequestMapping,
        stubClosure: StubClosure = MoyaProvider.NeverStub,
        manager: Manager = Manager.sharedInstance,
        plugins: [PluginType] = []) {
            super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, manager: manager, plugins: plugins)
    }
}

struct Provider{
    
    fileprivate static var endpointsClosure = { (target: GitHubAPI) -> Endpoint<GitHubAPI> in
        
        var endpoint: Endpoint<GitHubAPI> = Endpoint<GitHubAPI>(URL: url(target), sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters)
        // Sign all non-XApp token requests

        switch target {
            
        default:
//            print("current token:\( AppToken.sharedInstance.access_token!)")
            endpoint.endpointByAddingHTTPHeaderFields(["User-Agent":"Coderpursue"])

            return endpoint.endpointByAddingHTTPHeaderFields(["Authorization": AppToken.sharedInstance.access_token ?? ""])
        }
    }
    static func stubBehaviour(_: GitHubAPI) -> Moya.StubBehavior {
        return .never
    }
    
    static func DefaultProvider() -> GitHupPorvider<GitHubAPI> {
        return GitHupPorvider(endpointClosure: endpointsClosure, requestClosure: endpointResolver(), stubClosure:MoyaProvider.NeverStub , manager: Alamofire.Manager.sharedInstance, plugins:[])
    }
    
    fileprivate struct SharedProvider {
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
    case myInfo
    case userInfo(username:String)
    case updateUserInfo(name:String, email:String, blog:String, company:String, location:String,hireable:String,bio:String)
    case allUsers(page:Int,perpage:Int)
    
    //user email
    case userEmails
    case addEmail
    case delEmail
    
    //user followers
    case userFollowers(page:Int,perpage:Int,username:String)
    case myFollowers
    case userFollowing(page:Int,perpage:Int,username:String)
    case myFollowing
    case checkUserFollowing(username:String)
    case checkFollowing(username:String ,target_user:String)
    case follow(username:String)
    case unfollow(username:String)
    
    //repository
    case myRepos(type:String, sort:String ,direction:String)
    case userRepos( username:String ,page:Int,perpage:Int,type:String, sort:String ,direction:String)
    case orgRepos(type:String, organization:String)
    case pubRepos(page:Int,perpage:Int)
    case userSomeRepo(owner:String, repo:String)
    
    
    //starring
    case reposStargazers(owner:String ,repo:String)
    case userStarredRepos(username:String ,sort:String ,direction:String)
    case myStarredRepos(page:Int,perpage:Int,sort:String ,direction:String)
    case checkStarred(owner:String ,repo:String)
    case starRepo(owner:String ,repo:String)
    case unstarRepo(owner:String ,repo:String)
    
    
    //issue
    case allIssues(page:Int,perpage:Int,filter:String,state:String,labels:String,sort:String,direction:String)
    case myIssues(page:Int,perpage:Int,filter:String,state:String,labels:String,sort:String,direction:String)
    case orgIssues(page:Int,perpage:Int,organization:String,filter:String,state:String,labels:String,sort:String,direction:String)
    case repoIssues(page:Int,perpage:Int,owner:String,repo:String,milestone:Int,state:String,assignee:String,creator:String,mentioned:String,labels:String,sort:String,direction:String)
    case repoSigleIssue(owner:String,repo:String,number:Int)
    case createIssue(owner:String ,repo:String ,title:String,body:String,assignee:String,milestone:Int,labels:String)
    case editIssue(owner:String ,repo:String ,number:Int, title:String,body:String,assignee:String,milestone:Int,labels:String)
    case lockIssue(owner:String ,repo:String ,number:Int)
    case unlockIssue(owner:String ,repo:String ,number:Int)

    //notification
//    case MyNotifications(page:Int,perpage:Int,all:Bool ,participating:Bool,since:String,before:String)
    case myNotifications(page:Int,perpage:Int,all:String ,participating:String)
    case repoNotifications(owner:String ,repo:String,all:String ,participating:String)
    case markNotificationsAsRead(last_read_at:String)
    case markRepoNotificationsAsRead(owner:String ,repo:String,last_read_at:String)
    
    //watching
    case repoWatchers(page:Int,perpage:Int,owner:String, repo:String)
    case userWatchedRepos(page:Int,perpage:Int,username:String)
    case myWatchedRepos(page:Int,perpage:Int)
    case checkWatched(owner:String, repo:String)
    case watchingRepo(owner:String, repo:String,subscribed:String,ignored:String)
    case unWatchingRepo(owner:String, repo:String)
    
    //Event
    case publicEvents(page:Int,perpage:Int)
    case repoEvents(owner:String, repo:String,page:Int,perpage:Int)
    case repoIssueEvents(owner:String, repo:String,page:Int,perpage:Int)
    case repoPublicNetworkEvents(owner:String, repo:String,page:Int,perpage:Int)
    case orgPublicEvent(organization:String,page:Int,perpage:Int)
    case userReceivedEvents(username:String ,page:Int,perpage:Int)
    case userReceivedPublicEvents(username:String ,page:Int,perpage:Int)
    case userEvents(username:String ,page:Int,perpage:Int)
    case userPublicEvents(username:String ,page:Int,perpage:Int)
    case orgEvents(username:String,organization:String,page:Int,perpage:Int)
    
    //trending
    case trendingRepos(since:String,language:String)
    case trendingShowcases()
    case trendingShowcase(showcase:String)
    
    //search
    case searchUsers(para:ParaSearchUser)
    case searchRepos(para:ParaSearchRepos)
    
    //forks
    case userReposForks(page:Int,perpage:Int,sort:String,owner:String,repo:String)
    case createFork(owner:String,repo:String)
}

extension GitHubAPI: TargetType {

    public var baseURL: URL {
        switch self {
        case .trendingRepos:
            return URL(string: "http://trending.codehub-app.com/v2")!
        case .trendingShowcases:
            return URL(string: "http://trending.codehub-app.com/v2")!
        case .trendingShowcase:
            return URL(string: "http://trending.codehub-app.com/v2")!
        default:
            return URL(string: "https://api.github.com")!
        }
    }
    
    public var path: String {
        switch self {
          //user
        case .myInfo:
            return "/user"
        case .userInfo(let username):
            return "/users/\(username)"
        case .updateUserInfo:
            return "/user"
        case .allUsers(_,_):
            return "/users"
        //user email
        case .userEmails:
            return "/user/emails"
        case .addEmail:
            return "/user/emails"
        case .delEmail:
            return "/user/emails"
            
        //user followers
        case .userFollowers(_,_,let username):
            return "/users/\(username)/followers"
        case .myFollowers:
            return "/users/followers"
        case .userFollowing(_,_,let username):
            return "/users/\(username)/following"
        case .myFollowing:
            return "/users/following"
        case .checkUserFollowing(let username):
            return "/user/following/\(username)"
        case .checkFollowing(let username ,let target_user):
            return "/users/\(username)/following/\(target_user)"
        case .follow(let username):
            return "/user/following/\(username)"
        case .unfollow(let username):
            return "/user/following/\(username)"
            
        case .myRepos:
            return "/user/repos"
        case .userRepos(let username,_,_,_,_,_):
            return "/users/\(username)/repos"
            
        case .orgRepos(_ ,let organization):
            return "/orgs/\(organization)/repos"
        case .pubRepos:
            return "/repositories"
        case .userSomeRepo(let owner,let repo):
            return "/repos/\(owner)/\(repo)"

            
        //starring
        case .reposStargazers(let owner ,let repo):
            return "/repos/\(owner)/\(repo)/stargazers"
        case .myStarredRepos:
            return "/user/starred"
        case .userStarredRepos(let username ,_ ,_):
            return "/users/\(username)/starred"
        case .checkStarred(let owner ,let repo):
            return "/user/starred/\(owner)/\(repo)"
        case .starRepo(let owner ,let repo):
            return "/user/starred/\(owner)/\(repo)"
        case .unstarRepo(let owner ,let repo):
            return "/user/starred/\(owner)/\(repo)"
           
            
        //issue
        case .allIssues:
            return "/issues"
        case .myIssues:
            return "/user/issues"
        case .orgIssues(_,_,let organization,_,_,_,_,_):
            return "/orgs/\(organization)/issues"
        case .repoIssues(_,_,let owner,let repo,_,_,_,_,_,_,_,_):
            return "/repos/\(owner)/\(repo)/issues"
        case .repoSigleIssue(let owner,let repo,let number):
            return "/repos/\(owner)/\(repo)/issues/\(number)"
        case .createIssue(let owner ,let repo ,_,_,_,_,_):
            return "/repos/\(owner)/\(repo)/issues"
        case .editIssue(let owner ,let repo ,let number,_,_,_,_,_):
            return "/repos/\(owner)/\(repo)/issues/\(number)"
        case .lockIssue(let owner ,let repo ,let number):
            return "/repos/\(owner)/\(repo)/issues/\(number)/lock"
        case .unlockIssue(let owner ,let repo ,let number):
            return "/repos/\(owner)/\(repo)/issues/\(number)/lock"
            
        //notification
        case .myNotifications:
            return "/notifications"
        case .repoNotifications(let owner,let repo,_,_):
            return "/repos/\(owner)/\(repo)/notifications"
        case .markNotificationsAsRead:
            return "/notifications"
        case .markRepoNotificationsAsRead(let owner ,let repo,_):
            return "/repos/\(owner)/\(repo)/notifications"
            
        //watching
        case .repoWatchers(_,_,let owner,let repo):
            return "/repos/\(owner)/\(repo)/subscribers"
        case .userWatchedRepos(_,_,let username):
            return "/users/\(username)/subscriptions"
        case .myWatchedRepos:
            return "/user/subscriptions"
        case .checkWatched(let owner,let repo):
            return "/repos/\(owner)/\(repo)/subscription"
        case .watchingRepo(let owner,let repo,_,_):
            return "/user/subscriptions/\(owner)/\(repo)"
        case .unWatchingRepo(let owner,let repo):
            return "/repos/\(owner)/\(repo)/subscription"

            //Event
        case .publicEvents:
            return "/events"
        case .repoEvents(let owner, let repo,_,_):
            return "/repos/\(owner)/\(repo)/events"

        case .repoIssueEvents(let owner, let repo,_,_):
            return "/repos/\(owner)/\(repo)/issues/events"

        case .repoPublicNetworkEvents(let owner,let repo,_,_):
            return "/networks/\(owner)/\(repo)/events"

        case .orgPublicEvent(let organization,_,_):
            return "/orgs/\(organization)/events"

        case .userReceivedEvents(let username ,_,_):
            return "/users/\(username)/received_events"

        case .userReceivedPublicEvents(let username ,_,_):
            return "/users/\(username)/received_events/public"
        case .userEvents(let username ,_,_):
            return "/users/\(username)/events"
        case .userPublicEvents(let username ,_,_):
            return "/users/\(username)/events/public"
        case .orgEvents(let username,let organization,_,_):
            return "/users/\(username)/events/orgs/\(organization)"

        //trending
        case .trendingRepos:
            return "/trending"
        case .trendingShowcases:
            return "/showcases"
        case .trendingShowcase(let showcase):
            return "/showcases/\(showcase)"

        //search
        case .searchUsers:
            return "/search/users"
        case .searchRepos:
            return "/search/repositories"

            
        //forks
        case .userReposForks(_,_,_,let owner,let repo):
            return "/repos/\(owner)/\(repo)/forks"
        case .createFork(let owner,let repo):
            return "/repos/\(owner)/\(repo)/forks"

            
        }
        
    }

    public var method: Moya.Method {
        
        switch self {
        case .updateUserInfo:
            return .PATCH
            //user email
        case .addEmail:
            return .POST
        case .delEmail:
            return .DELETE
        //user followers
        case .follow(_):
            return .PUT
        case .unfollow(_):
            return .DELETE
            
        //starring
        case .starRepo(_,_):
            return .PUT
        case .unstarRepo(_,_):
            return .DELETE
        case .createIssue(_,_,_,_,_,_,_):
            return .POST
        case .editIssue(_,_,_,_,_,_,_,_):
            return .PATCH
        case .lockIssue(_,_,_):
            return .PUT
        case .unlockIssue(_,_,_):
            return .DELETE
        case .markRepoNotificationsAsRead:
            return .PUT
        case .markNotificationsAsRead:
            return .PUT
            
        //watching
        case .watchingRepo:
            return .PUT
        case .unWatchingRepo:
            return .DELETE
   
        case .createFork:
            return .POST
        default:
            return .GET

        }
    }
    
    public var parameters: [String: AnyObject]? {
        
        switch self {
            
        //follower
        case .userFollowers(let page,let perpage, _):
            return [
                "page":page as AnyObject,
                "per_page":perpage as AnyObject
            ]
        case .userFollowing(let page,let perpage, _):
            return [
                "page":page as AnyObject,
                "per_page":perpage as AnyObject
            ]
            
        case .updateUserInfo(let name,let email,let blog,let company,let location,let hireable,let bio):
            return [
                    "name": name as AnyObject,
                    "email": email as AnyObject,
                    "blog": blog as AnyObject,
                    "company": company as AnyObject,
                    "location": location as AnyObject,
                    "hireable":hireable as AnyObject,
                    "bio":bio as AnyObject
                ]
        case .allUsers(let page, let perpage):
            return [
                "page":page as AnyObject,
                "per_page":perpage as AnyObject
            ]
        case .myRepos(let type, let sort ,let direction):
            return [
                "type":type as AnyObject,
                "sort":sort as AnyObject,
                "direction":direction as AnyObject
            ]
        case .userRepos(_,let page, let perpage,let type, let sort ,let direction):
            return [
                "page":page as AnyObject,
                "per_page":perpage as AnyObject,
                "type":type as AnyObject,
                "sort":sort as AnyObject,
                "direction":direction as AnyObject
            ]
        case .orgRepos(let type, _):
            return [
                "type":type as AnyObject,
            ]
        case .pubRepos(let page, let perpage):
            return [
                "page":page as AnyObject,
                "per_page":perpage as AnyObject
            ]
            
        //starring
        case .userStarredRepos(_ ,let sort ,let direction):
            return [
                "sort":sort as AnyObject,
                "direction":direction as AnyObject
            ]
        case .myStarredRepos( let page,let perpage ,let sort ,let direction):
            return [
                "sort":sort as AnyObject,
                "direction":direction as AnyObject,
                "page":page as AnyObject,
                "per_page":perpage as AnyObject
            ]
        case .allIssues(let page,let perpage,let filter,let state,let labels,let sort,let direction):
            return [
                "page":page as AnyObject,
                "per_page":perpage as AnyObject,
                "filter":filter as AnyObject,
                "state":state as AnyObject,
                "labels":labels as AnyObject,
                "sort":sort as AnyObject,
                "direction":direction as AnyObject,
            ]
        case .myIssues(let page,let perpage,let filter,let state,let labels,let sort,let direction):
            return [
                "page":page as AnyObject,
                "per_page":perpage as AnyObject,
                "filter":filter as AnyObject,
                "state":state as AnyObject,
                "labels":labels as AnyObject,
                "sort":sort as AnyObject,
                "direction":direction as AnyObject,
            ]

        case .orgIssues(let page,let perpage, _, let filter,let state,let labels,let sort,let direction):
            return [
                "page":page as AnyObject,
                "per_page":perpage as AnyObject,
                "filter":filter as AnyObject,
                "state":state as AnyObject,
                "labels":labels as AnyObject,
                "sort":sort as AnyObject,
                "direction":direction as AnyObject,
            ]
        case .repoIssues(let page,let perpage,_,_,let milestone,let state,let assignee,let creator,let mentioned,let labels,let sort,let direction):
            return [
                "page":page as AnyObject,
                "per_page":perpage as AnyObject,
                "milestone":milestone as AnyObject,
                "state":state as AnyObject,
                "assignee":assignee as AnyObject,
                "creator":creator as AnyObject,
                "mentioned":mentioned as AnyObject,
                "labels":labels as AnyObject,
                "sort":sort,
                "direction":direction,
            ]

        case .createIssue(_,_ ,let title,let body,let assignee,let milestone,let labels):
            return [
                "title":title as AnyObject,
                "body":body as AnyObject,
                "assignee":assignee as AnyObject,
                "milestone":milestone as AnyObject,
                "labels":labels as AnyObject
            ]
        case .editIssue(_ ,_ ,_, let title,let body,let assignee,let milestone,let labels):
            return [
                
                "title":title as AnyObject,
                "body":body as AnyObject,
                "assignee":assignee as AnyObject,
                "milestone":milestone as AnyObject,
                "labels":labels as AnyObject
            ]
            
        //notification
        case .myNotifications(let page,let perpage,let all ,let participating):
            return [
                "all":all as AnyObject,
                "participating":participating as AnyObject,
                "page":page as AnyObject,
                "per_page":perpage as AnyObject
            ]
        case .repoNotifications(_,_,let all ,let participating):
            return [
                "all":all as AnyObject,
                "participating":participating as AnyObject,
            ]
        case .markNotificationsAsRead(let last_read_at):
            return [
                "last_read_at":last_read_at as AnyObject
            ]
        case .markRepoNotificationsAsRead(_,_,let last_read_at):
            return [
                "last_read_at":last_read_at as AnyObject
            ]
            
        //watching
        case .repoWatchers(let page,let perpage,_,_):
            return [
                "page":page as AnyObject,
                "per_page":perpage as AnyObject,
            ]
        case .userWatchedRepos(let page,let perpage,_):
            return [
                "page":page as AnyObject,
                "per_page":perpage as AnyObject,
            ]
        case .myWatchedRepos(let page,let perpage):
            return [
                "page":page as AnyObject,
                "per_page":perpage as AnyObject,
            ]
            
//        case WatchingRepo(_,_,let subscribed,let ignored):
//            return [
//                "subscribed":subscribed,
//                "ignored":ignored
//            ]
            
            //Event
        case .publicEvents(let page,let perpage):
            return [
                "page":page as AnyObject,
                "per_page":perpage as AnyObject,
            ]
        case .repoEvents(_,_,let page,let perpage):
            return [
                "page":page as AnyObject,
                "per_page":perpage as AnyObject,
            ]
        case .repoIssueEvents(_,_,let page,let perpage):
            return [
                "page":page as AnyObject,
                "per_page":perpage as AnyObject,
            ]
        case .repoPublicNetworkEvents(_,_,let page,let perpage):
            return [
                "page":page as AnyObject,
                "per_page":perpage as AnyObject,
            ]
        case .orgPublicEvent(_,let page,let perpage):
            return [
                "page":page as AnyObject,
                "per_page":perpage as AnyObject,
            ]
        case .userReceivedEvents(_,let page,let perpage):
            return [
                "page":page as AnyObject,
                "per_page":perpage as AnyObject,
            ]
        case .userReceivedPublicEvents(_,let page,let perpage):
            return [
                "page":page as AnyObject,
                "per_page":perpage as AnyObject,
            ]
        case .userEvents(_,let page,let perpage):
            return [
                "page":page as AnyObject,
                "per_page":perpage as AnyObject,
            ]
        case .userPublicEvents(_,let page,let perpage):
            return [
                "page":page as AnyObject,
                "per_page":perpage as AnyObject,
            ]
        case .orgEvents(_,_,let page,let perpage):
            return [
                "page":page as AnyObject,
                "per_page":perpage as AnyObject,
            ]
        //trending
        case .trendingRepos(let since,let language):
            return [
                "since":since as AnyObject,
                "language":language as AnyObject,
            ]
            
        case .searchUsers(let para):
            return [
                "q":para.q as AnyObject,
                "sort":para.sort as AnyObject,
                "order":para.order as AnyObject,
                "page":para.page as AnyObject,
                "per_page":para.perPage as AnyObject,
            ]
        case .searchRepos(let para):
            return [
                "q":para.q as AnyObject,
                "sort":para.sort as AnyObject,
                "order":para.order as AnyObject,
                "page":para.page as AnyObject,
                "per_page":para.perPage as AnyObject,
            ]
            
            //forks
        case .userReposForks(let page,let perpage,let sort,_,_):
            return [
                "page":page as AnyObject,
                "per_page":perpage as AnyObject,
                "sort":sort as AnyObject
            ]
            
        default:
            return nil
            
        }
        
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
private extension String {
    var URLEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
}

public func url(_ route: TargetType) -> String {
    print("api:\(route.baseURL.URLByAppendingPathComponent(route.path).absoluteString)")
    return route.baseURL.URLByAppendingPathComponent(route.path).absoluteString
}

