//
//  UserManager.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/16.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit
import SwiftMessages

class UserManager: NSObject {
    
    static let shared = UserManager()

    var user:ObjUser? {
        get {
            let user:ObjUser? = ObjUser.loadUserInfo()
            return user
        }
        
        set(newUser) {
            ObjUser.saveUserInfo(newUser)
        }
    }
    
    var isLogin:Bool {
        get {
            if user != nil {
                if ( ((user!.name) != nil) && !((user!.name!).isEmpty) && (AppToken().access_token != nil)){
                    return true
                }
            }
            return false
        }
    }
    
    var isUser:Bool {
        get {
            if (isLogin && ( (user!.type!) == "User" )) {
                return true
            }
            return false
        }
    }
    
    var userToken:String {
        get {
            return AppToken().access_token!
        }
        set(newtoken) {
            var token = AppToken.shared
            token.access_token = newtoken
        }
    }
    
    func deleteUser() {
        
        ObjUser.deleteUserInfo()
    }
    
    
    /// 检查是否登录，未登录时，弹出提示
    ///
    func checkUserLogin() -> Bool{
        if(isLogin){
            //已登录，返回true
            return true
        }else{
            //未登录，显示提示
            showNotLoginTips()
            return false
        }
    }
    
    
    /// 需要登录，未登录弹出登录页面
    ///
    func needLogin() -> Bool {
        if(isLogin){
            //已登录，返回true
            return true
        }else{
            //未登录，弹出登录界面
            popLoginView()
            return false
        }
    }
    
    /// 弹出登录页面
    func popLoginView() {
        
        NetworkHelper.clearCookies()
        
        let loginVC = CPGitLoginViewController()
        let url = String(format: "https://github.com/login/oauth/authorize/?client_id=%@&state=%@&redirect_uri=%@&scope=%@",GithubAppClientId,"junglesong",GithubAppRedirectUrl,"user,user:email,user:follow,public_repo,repo,repo_deployment,repo:status,delete_repo,notifications,gist,read:repo_hook,write:repo_hook,admin:repo_hook,admin:org_hook,read:org,write:org,admin:org,read:public_key,write:public_key,admin:public_key" )
        loginVC.url = url
        loginVC.hidesBottomBarWhenPushed = true
        
        cpAppDelegate.tabBarController?.currentNavigationViewController()?.pushViewController(loginVC, animated: true)
        
    }
    
    /// 显示登录tip
    func showNotLoginTips()  {
        
        let status = MessageView.viewFromNib(layout: .MessageView)
        status.configureContent(title: "Login Now?", body: "These data ask your github account", iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "Login", buttonTapHandler: { _ in
            SwiftMessages.hide()
            self.popLoginView()
        })
        status.configureTheme(.error)
        status.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        status.bodyLabel?.font = UIFont.systemFont(ofSize: 13.0)
        status.button?.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        
        var statusConfig = SwiftMessages.defaultConfig
        statusConfig.duration = .seconds(seconds: 1.0)
        statusConfig.presentationContext = .automatic
        SwiftMessages.show(config: statusConfig, view: status)
    }
    
    
    /// 登录提示Alert
    ///
    func loginTipAlertController() -> UIAlertController {
        
        let alertController = UIAlertController.init(title: "Sign in Now?", message: "these data ask your github account.", preferredStyle: .alert)
        let cancelAct = UIAlertAction.init(title: "Cancel", style: .destructive, handler: { action in
            
        })
        
        let okAct = UIAlertAction.init(title: "Go", style: .default, handler: { (action) in
            self.popLoginView()
        })
        
        alertController.addAction(cancelAct)
        alertController.addAction(okAct)
        return alertController
    }
    
}
