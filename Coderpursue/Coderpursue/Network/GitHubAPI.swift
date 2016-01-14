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
            return endpoint.endpointByAddingHTTPHeaderFields(["Authorization": AppToken().access_token ?? ""])
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


public enum GitHubAPI {
    
    case User
    
}

extension GitHubAPI: TargetType {

    public var baseURL: NSURL { return NSURL(string: "https://api.github.com")! }
    public var path: String {
        switch self {
            
        case .User:
            return "/user"

        }
    }

    public var method: Moya.Method {
        
        switch self {
            
        case .User:
            return .GET

        default:
            return .GET
        }
    }
    
    public var parameters: [String: AnyObject]? {
        
        switch self {
            
        default:
            return nil
            
        }
        
        
    }
    
    //Any target you want to hit must provide some non-nil NSData that represents a sample response. This can be used later for tests or for providing offline support for developers. This should depend on self.
    public var sampleData: NSData {
        switch self {
        case .User:
            return "get user info.".dataUsingEncoding(NSUTF8StringEncoding)!
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

