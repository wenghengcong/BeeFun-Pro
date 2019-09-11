//
//  BeeFunAPI.swift
//  BeeFun
//
//  Created by WengHengcong on 2018/4/22.
//  Copyright © 2018年 JungleSong. All rights reserved.
//

import UIKit
import Foundation
import Moya
import Alamofire
import ObjectMapper

class InsideBeeFunProvider<Target>: MoyaProvider<Target> where Target: TargetType {

    override init(endpointClosure: @escaping (Target) -> Endpoint, requestClosure: @escaping (Endpoint, @escaping
        MoyaProvider<BeeFunAPI>.RequestResultClosure) -> Void, stubClosure: @escaping (Target) -> StubBehavior, callbackQueue: DispatchQueue?, manager: Manager, plugins: [PluginType], trackInflights: Bool) {
        
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, callbackQueue: callbackQueue, manager: manager, plugins: plugins, trackInflights: trackInflights)
    }
}

struct BeeFunProvider {
    
    fileprivate static var endpointsClosure = { (target: BeeFunAPI) -> Endpoint in
        
        var endpoint: Endpoint = Endpoint(url: url(target), sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: target.headers)
        return endpoint
    }
    static func stubBehaviour(_: BeeFunAPI) -> Moya.StubBehavior {
        return .never
    }
    
    static func DefaultProvider() -> InsideBeeFunProvider<BeeFunAPI> {
        
        return InsideBeeFunProvider(endpointClosure: endpointsClosure, requestClosure: MoyaProvider<BeeFunAPI>.defaultRequestMapping, stubClosure: MoyaProvider.neverStub, callbackQueue: DispatchQueue.main, manager: Alamofire.SessionManager.default, plugins: [], trackInflights: false)
    }
    
    fileprivate struct SharedProvider {
        static var instance = BeeFunProvider.DefaultProvider()
    }
    static var sharedProvider: InsideBeeFunProvider<BeeFunAPI> {
        get {
            return SharedProvider.instance
        }
        
        set (newSharedProvider) {
            SharedProvider.instance = newSharedProvider
        }
        
    }
}

public enum BeeFunAPI {
    
    //更新数据库
    //1. 每次启动时 2.
    case updateServerDB(first: Bool, update: Bool)
    
    // User
    case addUser(user: ObjUser)
    
    //从BeeFun获取到github starrd 的页数，每页100
    case repoPage(owner: String)
    case repos(tag: String, language: String, page: Int, perpage: Int, sort: String, direction: String)
    case delRepo(repoid: Int)
    case addRepo(repo: ObjRepos)
    
    //tag
    // MARK: - page或perpage传0，就返回所有数据
    case getAllTags(filter: [String: Any])
    case getTag(name: String)
    case addTag(tagModel: ObjTag)
    case addTagToRepo(change:Bool, star_tags: String, delete_tags:[String], repoId: Int)
    case updateTag(name: String, to: String)
    case deleteTag(name: String)
    //language
    case getLanguages(page:Int, perpage:Int, sort:String, direction:String)
    
    // MARK: - Tringding
    case getGithubTrending(model: BFGithubTrendingRequsetModel)
}

extension BeeFunAPI: TargetType {
    
    public var headers: [String: String]? {
        let token = AppToken.shared.access_token ?? ""
        let owner = UserManager.shared.login ?? ""
        var header = ["User-Agent": "BeeFuniOS", "Authorization": token, "timeoutInterval": "15.0", "owner": owner]
        switch self {
        case .addUser(_):
            header = ["User-Agent": "BeeFuniOS", "Authorization": token, "timeoutInterval": "15.0", "owner": owner, "Content-Type": "application/json"]
            return header
        case .addTag(_):
            header = ["User-Agent": "BeeFuniOS", "Authorization": token, "timeoutInterval": "15.0", "owner": owner, "Content-Type": "application/json"]
            return header
        default:
            header = ["User-Agent": "BeeFuniOS", "Authorization": token, "timeoutInterval": "15.0", "owner": owner]
            return header
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        return Alamofire.ParameterEncoding.self as! ParameterEncoding
    }
    
    public var baseURL: URL {
        switch self {
        default:
            //Check list:  修改上线环境及证书
            // beefun.top 已经下线
            return URL(string: "https://www.beefun.top:8082/beefun")!                    //远程环境
//            return URL(string: "http://localhost:8082")!                                  //本地测试环境
        }
    }
    
    public var path: String {
        switch self {
        case .addRepo(_):
            return "/v1/repo/client"
            
        case .updateServerDB(_, _):
            return "/v1/db/update"
            
        case .addUser(_):
            return "/v1/user"
            
        case .repoPage(let owner):
            return "/v1/reponum/\(owner)"
        case .repos(let tag, _, _, _, _, _):
            return "/v1/repos/\(tag)"
        case .delRepo(let repoid):
            return "/v1/repo/\(repoid)"
            
        case .getGithubTrending(_):
            return "/v1/explore/trending"
            
            // tag操作
        case .getAllTags(_):
            return "/v2/tags"
        case .getTag(let name):
            return "/v1/tag/\(name)"
        case .addTag(_):
            return "/v1/tag"
        case .addTagToRepo(_, _, _, let repoId):
            return "/v1/repo/tag/\(repoId)"
        case .updateTag(let name, _):
            return "/v1/tag/\(name)"
        case .deleteTag(let name):
            return "/v1/tag/\(name)"
        case .getLanguages(_, _, _, _):
            return "/v1/lans"
        }
        
    }
    
    public var method: Moya.Method {
        
        switch self {
        case .addUser(_):
            return .post
        case .addRepo(_):
            return .post
        case .addTag(_):
            return .post
        case .updateTag(_, _):
            return .put
        case .deleteTag(_):
            return .delete
        case .addTagToRepo(_, _,_, _):
            return .post
        case .delRepo(_):
            return .delete
        default:
            return .get
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .updateServerDB(let first, let update):
            return [
                "first": first as AnyObject,
                "update": update as AnyObject
            ]
        case .addUser(let user):
            return user.toJSON()
        case .addRepo(let repo):
            return repo.toJSON()
        case .getGithubTrending(let model):
            return model.toJSON()
        case .getAllTags(let filter):
            return filter
        case .updateTag(_, let to):
            return [
                "to": to
            ]
        case .addTag(let tagModel):
            return tagModel.toJSON()
            
        case .addTagToRepo(let change, let star_tags, let delete_tags, _):
            return [
                "change": change,
                "star_tags": star_tags,
                "del_tags": delete_tags
            ]
        case .repos(_,let language, let page, let perpage, let sort, let direction):
            return [
                "source" : 0,
                "language": language as AnyObject,
                "page": page as AnyObject,
                "perpage": perpage as AnyObject,
                "sort": sort as AnyObject,
                "direction": direction as AnyObject
            ]
        case .getLanguages(let page, let perpage, let sort, let direction):
            return [
                "page": page as AnyObject,
                "perpage": perpage as AnyObject,
                "sort": sort as AnyObject,
                "direction": direction as AnyObject
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
