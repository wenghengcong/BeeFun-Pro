//
//  BFUserDefaultKey.swift
//  BeeFun
//
//  Created by WengHengcong on 2018/1/30.
//  Copyright © 2018年 JungleSong. All rights reserved.
//

import UIKit

public class BFUserDefaultManager {
    
    static let shared = BFUserDefaultManager()
    fileprivate let userDefaults = UserDefaults.standard

    // MARK: - Key
    // MARK:  搜索记录
    fileprivate let searchHistoryKey        = "searchHistoryKey"
    
    // MARK: - Private
    fileprivate init() {
        registerUserDefault()
    }
    
    fileprivate func registerUserDefault() {

    }
    
    // MARK: - Public for use
    /// 搜索结果记录
    var searchHistory: [String]? {
        get {
            return userDefaults.object(forKey: searchHistoryKey) as? [String]
        }
        set {
            userDefaults.set(newValue, forKey: searchHistoryKey)
            userDefaults.synchronize()
        }
    }
}

