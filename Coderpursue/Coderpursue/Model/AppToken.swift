//
//  ObjUser.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/12.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit

struct AppToken {
    
    enum DefaultsKeys: String {
        case TokenKey = "TokenKey"
        case TokenType = "TokenType"
        case TokenScope = "TokenScope"
        case TokenExpiry = "TokenExpiry"
    }
    
    let defaults: NSUserDefaults
    
    static let sharedInstance = AppToken()
    
    
    init(defaults:NSUserDefaults) {
        self.defaults = defaults
    }
    
    init() {
        self.defaults = NSUserDefaults.standardUserDefaults()
    }
    
    var access_token:String? {
        get {
            let key = defaults.stringForKey(DefaultsKeys.TokenKey.rawValue)
            return key
        }
        set(newToken) {
            defaults.setObject(newToken, forKey: DefaultsKeys.TokenKey.rawValue)
        }
    }
    var token_type:String? {
        get {
            
            let key = defaults.stringForKey(DefaultsKeys.TokenType.rawValue)
            return key
        }
        set(newType) {
            defaults.setObject(newType, forKey: DefaultsKeys.TokenType.rawValue)
        }
    }
    
    var scope:String? {
        get {
            let key = defaults.stringForKey(DefaultsKeys.TokenScope.rawValue)
            return key
        }
        set(newScope) {
            defaults.setObject(newScope, forKey: DefaultsKeys.TokenScope.rawValue)
        }
    }

    var isValid: Bool {
        if let token = access_token {
            return token.isEmpty
        }
        return false
    }
    
    
}
