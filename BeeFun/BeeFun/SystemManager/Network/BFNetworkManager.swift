//
//  BFNetworkManager.swift
//  BeeFun
//
//  Created by wenghengcong on 16/1/10.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit
import WebKit
import Reachability

class BFNetworkManager: NSObject {

    static let shared = BFNetworkManager()
    var lastState: Reachability.Connection = .none
    
    let reachabilityManager = Reachability()!
 
    var isReachable: Bool {
        lastState = reachabilityManager.connection
        return reachabilityManager.connection != .none
    }
    
    var isReachableOnCellular: Bool {
        lastState = reachabilityManager.connection
        return reachabilityManager.connection == .cellular
    }
    
    var isReachableOnWiFi: Bool {
        lastState = reachabilityManager.connection
        return reachabilityManager.connection == .wifi
    }

    func startListening() {
        reachabilityManager.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("The network is reachable via WiFi: \(self.reachabilityManager.connection)")
                NotificationCenter.default.post(name: NSNotification.Name.BeeFun.ReachableWiFi, object: nil)
            } else {
                print("The network is reachable via Cellular: \(self.reachabilityManager.connection)")
                NotificationCenter.default.post(name: NSNotification.Name.BeeFun.ReachableCellular, object: nil)
            }
            if self.lastState == .none && (reachability.connection == .wifi || reachability.connection == .cellular) {
                print("The network is reachable after unreachable: \(self.reachabilityManager.connection)")
                NotificationCenter.default.post(name: NSNotification.Name.BeeFun.ReachableAfterUnreachable, object: nil)
            }
            self.lastState = reachability.connection
        }
        reachabilityManager.whenUnreachable = { reachability in
            print("The network is not reachable: \(self.reachabilityManager.connection)")
            NotificationCenter.default.post(name: NSNotification.Name.BeeFun.NotReachable, object: nil)
            if (self.lastState == .wifi || self.lastState == .cellular) && reachability.connection == .none {
                print("The network is not reachable after reachable: \(self.reachabilityManager.connection)")
                NotificationCenter.default.post(name: NSNotification.Name.BeeFun.UnReachableAfterReachable, object: nil)
            }
            self.lastState = reachability.connection
        }
        
        do {
            try reachabilityManager.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func stopListening() {
        lastState = .none
        reachabilityManager.stopNotifier()
    }
    
    // MARK: - 清除工具
    /// 清除Cookies
    class func clearCookies() {
        let storage: HTTPCookieStorage = HTTPCookieStorage.shared
        for cookie in storage.cookies! {
            storage.deleteCookie(cookie)
        }
    }

    /// 清除缓存
    class func clearCache() {
        if #available(iOS 9.0, *) {
            let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeOfflineWebApplicationCache, WKWebsiteDataTypeCookies, WKWebsiteDataTypeSessionStorage, WKWebsiteDataTypeLocalStorage])
            let date = NSDate(timeIntervalSince1970: 0)

            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date as Date, completionHandler: { })
        } else {
            var libraryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, false).first!
            libraryPath += "/Cookies"

            do {
                try FileManager.default.removeItem(atPath: libraryPath)
            } catch {
                print("error")
            }
            URLCache.shared.removeAllCachedResponses()
        }
    }
    
}
