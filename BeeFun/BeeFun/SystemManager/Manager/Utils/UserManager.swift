//
//  UserManager.swift
//  BeeFun
//
//  Created by wenghengcong on 16/1/16.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftMessages
import Crashlytics

class UserManager: NSObject {

    static let shared = UserManager()

    override init() {
        super.init()

        if isLogin {
            //去请求一次用户数据
            let provider = Provider.sharedProvider
            provider.request(.myInfo) { (result) -> Void in

                switch result {
                case let .success(response):
                    do {
                        if let gitUser: ObjUser = Mapper<ObjUser>().map(JSONObject: try response.mapJSON()) {
                            if gitUser.login != nil {
                                self.user = gitUser
                                self.setCrashlytics()
                            }
                        } else {
                        }
                    } catch {
                    }
                case .failure:
                    break
                }

            }
        }
    }

    /// 初始化Crashlytics参数
    func setCrashlytics() {
        if let username = self.user?.name {
            Crashlytics.sharedInstance().setUserName(username)
        }

        if let email = self.user?.email {
            Crashlytics.sharedInstance().setUserEmail(email)
        }

        if let login = self.user?.login {
            Crashlytics.sharedInstance().setUserIdentifier(login)
        }

        AnswerManager.logLogin(method: "AutoLogin", success: true, attributes: [:])
    }

    /// 用户对象
    var user: ObjUser? {

        get {
            let user: ObjUser? = ObjUser.loadUserInfo()
            return user
        }

        set(newUser) {
            ObjUser.saveUserInfo(newUser)
        }

    }

    /// 是否登录，不作登录操作
    var isLogin: Bool {
        if user != nil {
            if ((user!.login) != nil) && !((user!.login!).isEmpty) && (AppToken().access_token != nil) {
                return true
            }
        }
        return false
    }

    /// 判断用户类型
    var isUser: Bool {
        if isLogin && ( (user!.type!) == "User") {
            return true
        }
        return false
    }

    /// 用户名，可能不唯一，也有可能为空
    var name: String? {
        return user?.name
    }

    /// 登录名，唯一，目前看来，不为空
    var login: String? {
        return user?.login
    }

    /// user token
    var userToken: String {
        get {
            return AppToken().access_token!
        }
        set(newtoken) {
            let token = AppToken.shared
            token.access_token = newtoken
            user?.token = newtoken
        }
    }

    var rewardSwitch: Bool = false

    /// 重载用户对象
    func reloadUser() {
        self.user = ObjUser.loadUserInfo()
    }

    /// 保存用户对象
    func saveUser(user: ObjUser) {
        ObjUser.saveUserInfo(user)
        self.reloadUser()
    }

    /// 删除用户对象
    func deleteUser() {
        ObjUser.deleteUserInfo()
        self.reloadUser()
    }
    
    /// 用户登录
    func userSignIn() {
        OAuthManager.shared.beginOauth()
    }
    
    /// 用户登出
    func userSignOut() {
        NotificationCenter.default.post(name: NSNotification.Name.BeeFun.WillLogout, object: nil)
        BFNetworkManager.clearCache()
        BFNetworkManager.clearCookies()
        UserManager.shared.deleteUser()
        AppToken.shared.clear()
        NotificationCenter.default.post(name: NSNotification.Name.BeeFun.DidLogout, object: nil)
    }

    /// 检查是否登录，未登录时，弹出提示
    ///
    func checkUserLogin() -> Bool {
        if isLogin {
            //已登录，返回true
            return true
        } else {
            //未登录，显示提示
            showNotLoginTips()
            return false
        }
    }
    
    /// 未登录需要提醒
    func needLoginAlert() -> Bool {
        return checkUserLogin()
    }

    /// 需要登录，未登录弹出登录页面
    ///
    func needLogin() -> Bool {
        if isLogin {
            //已登录，返回true
            return true
        } else {
            //未登录，弹出登录界面
            self.userSignIn()
            return false
        }
    }
    
    /// 显示登录tip
    fileprivate func showNotLoginTips() {
        let status = MessageView.viewFromNib(layout: .messageView)
        status.configureContent(title: "Sign in Now?".localized, body: "access data ask github account".localized, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "Sign in".localized, buttonTapHandler: { _ in
            SwiftMessages.hide()
            self.userSignIn()
        })
        status.configureTheme(.error)
        status.titleLabel?.font = UIFont.bfSystemFont(ofSize: 14.0)
        status.bodyLabel?.font = UIFont.bfSystemFont(ofSize: 12.0)
        status.button?.titleLabel?.font = UIFont.bfSystemFont(ofSize: 14.0)

//        var statusConfig = SwiftMessages.defaultConfig
//        statusConfig.presentationStyle = .top
//        statusConfig.duration = .seconds(seconds: 1.0)
//        SwiftMessages.show(config: statusConfig, view: status)
        SwiftMessages.show(view: status)
    }
    
    /// 更新User（BeeFun）
    func updateUserInfo() {
        if !UserManager.shared.isLogin {
            return
        }
        if let user = UserManager.shared.user {
            user.token = AppToken.shared.access_token
            BeeFunProvider.sharedProvider.request(BeeFunAPI.addUser(user: user)) { (result) in
                switch result {
                case let .success(response):
                    do {
                        if let userResponse: BeeFunResponseModel = Mapper<BeeFunResponseModel>().map(JSONObject: try response.mapJSON()) {
                            if let code = userResponse.codeEnum, code == BFStatusCode.bfOk {
                                
                            }
                        }
                    } catch {
                    }
                case .failure:
                    break
                }
            }
        }
    }
}
