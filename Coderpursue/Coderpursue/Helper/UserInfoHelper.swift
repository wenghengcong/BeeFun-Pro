//
//  UserInfoHelper.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/16.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit

class UserInfoHelper: NSObject {
    
    static let shared = UserInfoHelper()

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
    
    func checkUserLogin() -> Bool{
        if(isLogin){
            //已登录，返回true
            return true
        }else{
            //未登录，进行登录流程
            popLoginView()
            return false
        }
    }
    
    func popLoginView() {
        
        NetworkHelper.clearCookies()
        
        let loginVC = CPGitLoginViewController()
        let url = String(format: "https://github.com/login/oauth/authorize/?client_id=%@&state=%@&redirect_uri=%@&scope=%@",GithubAppClientId,"junglesong",GithubAppRedirectUrl,"user,user:email,user:follow,public_repo,repo,repo_deployment,repo:status,delete_repo,notifications,gist,read:repo_hook,write:repo_hook,admin:repo_hook,admin:org_hook,read:org,write:org,admin:org,read:public_key,write:public_key,admin:public_key" )
        loginVC.url = url
        loginVC.hidesBottomBarWhenPushed = true
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.tabBarController?.currentNavigationViewController()?.pushViewController(loginVC, animated: true)
        
    }
    
    func loginTipAlertController() -> UIAlertController {
        let alertController = UIAlertController.init(title: "Login Now?", message: "these data ask your github account.", preferredStyle: .alert)
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
