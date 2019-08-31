//
//  ObjUser.swift
//  BeeFun
//
//  Created by wenghengcong on 16/1/12.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit

class AppToken: NSObject {

    enum DefaultsKeys: String {
        case tokenKey = "TokenKey"
        case tokenType = "TokenType"
        case tokenScope = "TokenScope"
        case tokenExpire = "TokenExpiry"
        case tokenExpireDate = "tokenExpireDate"
    }
    
    let defaults: UserDefaults
    
    static let shared = AppToken()
    
    init(defaults: UserDefaults) {
        self.defaults = defaults
    }
    
    override init() {
        self.defaults = UserDefaults.standard
    }
    
    var access_token: String? {
        get {
            let key = defaults.string(forKey: DefaultsKeys.tokenKey.rawValue)
            return key
        }
        set(newToken) {
            defaults.set(newToken, forKey: DefaultsKeys.tokenKey.rawValue)
        }
    }
    var token_type: String? {
        get {
            let key = defaults.string(forKey: DefaultsKeys.tokenType.rawValue)
            return key
        }
        set(newType) {
            defaults.set(newType, forKey: DefaultsKeys.tokenType.rawValue)
        }
    }
    
    var scope: String? {
        get {
            let key = defaults.string(forKey: DefaultsKeys.tokenScope.rawValue)
            return key
        }
        set(newScope) {
            defaults.set(newScope, forKey: DefaultsKeys.tokenScope.rawValue)
        }
    }
    
    var isValid: Bool {
        if let token = access_token {
            return token.isEmpty
        }
        return false
    }
    
    var token_expire_date: Date? {
        get {
            let date = defaults.object(forKey: DefaultsKeys.tokenExpireDate.rawValue) as? Date
            return date
        }
        set(newDate) {
            defaults.set(newDate, forKey: DefaultsKeys.tokenExpireDate.rawValue)
        }
    }
    
    func clear() {
        access_token = nil
        token_type = nil
        scope = nil
        token_expire_date = Date()
    }

}
