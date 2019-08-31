//
//  OAuthManager.swift
//  BeeFunMac
//
//  Created by WengHengcong on 2018/1/24.
//  Copyright © 2018年 LuCi. All rights reserved.
//

import OAuthSwift
import ObjectMapper
import Alamofire

class OAuthManager: NSObject {
    
    static let shared = OAuthManager()
    var oauthswift: OAuthSwift?
    
    lazy var internalWebViewController: OAuthGithubWebController = {
        let controller = OAuthGithubWebController()
        controller.delegate = self
        controller.viewDidLoad() // allow WebViewController to use this ViewController as parent to be presented
        return controller
    }()
    
    // MARK: - Github Oauth and save Token
    func beginOauth() {
        BFNetworkManager.clearCache()
        BFNetworkManager.clearCookies()
        
        //全局通知：将要登录
        NotificationCenter.default.post(name: NSNotification.Name.BeeFun.WillLogout, object: nil)
        let oauthswift = OAuth2Swift(
            consumerKey: GithubAppClientId,
            consumerSecret: GithubAppClientSecret,
            authorizeUrl: "https://github.com/login/oauth/authorize",
            accessTokenUrl: "https://github.com/login/oauth/access_token",
            responseType: "code"
        )
        self.oauthswift = oauthswift
        oauthswift.authorizeURLHandler = getURLHandler(external: false)
        let state = generateState(withLength: 20)
        _ = oauthswift.authorize(withCallbackURL: nil, scope: GithubAppScope, state: state, completionHandler: { ( result ) in
            switch result {
            case .success(let (credential, _, parameters)):
                print(credential.oauthToken)
                if credential != nil && parameters != nil &&  parameters.keys.count > 0 {
                    NotificationCenter.default.post(name: NSNotification.Name.BeeFun.GetOAuthToken, object: nil)
                    self.saveOauthToken(credential: credential, parameters: parameters)
                }
            // Do your request
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func getURLHandler(external: Bool) -> OAuthSwiftURLHandlerType {
        if external {
            return OAuthSwiftOpenURLExternally.sharedInstance
        } else {
            if internalWebViewController.parent == nil {
                BFTabbarManager.shared.jsTopViewController()?.addChildViewController(internalWebViewController)
            }
            return internalWebViewController
        }
    }

    func saveOauthToken(credential: OAuthSwiftCredential, parameters: [String: Any]) {
        
        let token = AppToken.shared
        token.access_token = String(format: "token %@", credential.oauthToken)
        if let token_type: String = parameters["token_type"] as? String {
            token.token_type = token_type
        }
        if let token_scope: String = parameters["scope"] as? String {
            token.scope = token_scope
        }
        if let token_expireDate: Date = credential.oauthTokenExpiresAt {
            token.token_expire_date = token_expireDate
        }
        
        print(credential.oauthToken)
        self.getUserinfo(token.access_token!)
    }
    
    // MARK: - 获取个人信息
    private func getUserinfo(_ token: String) {
        self.internalWebViewController.showHud()
        let provider = Provider.sharedProvider
        provider.request(.myInfo) { (result) -> Void in
            switch result {
            case let .success(response):
                do {
                    if let gitUser: ObjUser = Mapper<ObjUser>().map(JSONObject: try response.mapJSON()) {
                        ObjUser.saveUserInfo(gitUser)
                        //全局通知：已经登录
                        self.internalWebViewController.hideHud()
                        self.didLogin()
                    } else {
                        
                    }
                } catch {
                }
            case .failure:
                break
            }
        }
    }
    
    private func didLogin() {
        NotificationCenter.default.post(name: NSNotification.Name.BeeFun.DidLogin, object: nil)
        NotificationCenter.default.post(name: NSNotification.Name.BeeFun.GetUserInfo, object: nil)
        BFTabbarManager.shared.jsTopNavigationViewController()?.popViewController(animated: true)
        UserManager.shared.updateUserInfo()
    }
    
}

// MARK: - OAuthWebViewControllerDelegate
extension OAuthManager: OAuthWebViewControllerDelegate {
    
    func oauthWebViewControllerDidPresent() {
        
    }
    
    func oauthWebViewControllerDidDismiss() {
        
    }
    
    func oauthWebViewControllerWillAppear() {
        
    }
    
    func oauthWebViewControllerDidAppear() {
        
    }
    
    func oauthWebViewControllerWillDisappear() {
        
    }
    
    func oauthWebViewControllerDidDisappear() {
        // Ensure all listeners are removed if presented web view close
        oauthswift?.cancel()
    }
}
