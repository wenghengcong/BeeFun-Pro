//
//  UserInfoHelper.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/16.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit

class UserInfoHelper: NSObject {
    
    static let sharedInstance = UserInfoHelper()

    var user:ObjUser? {
        get {
            let user:ObjUser? = ObjUser.loadUserInfo()
            return user
        }
        
        set(newUser) {
            ObjUser.saveUserInfo(newUser)
        }
    }
    
    var isLoginIn:Bool {
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
            if (isLoginIn && ( (user!.type!) == "User" )) {
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
            var token = AppToken.sharedInstance
            token.access_token = newtoken
        }
    }
    
    
    
}
