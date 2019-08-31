//
//  DeviceCfg.swift
//  BeeFun
//
//  Created by wenghengcong on 16/1/3.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

extension Notification.Name {
    
    public struct BeeFun {
        public static let WillLogin = Notification.Name(rawValue: "com.luci.beefun.mac.willlogin")
        public static let DidLogin = Notification.Name(rawValue: "com.luci.beefun.mac.didlogin")
        
        /// 获取到oauth token
        public static let GetOAuthToken = Notification.Name(rawValue: "com.luci.beefun.mac.gettoken")
        /// 登录后，获取到用户信息
        public static let GetUserInfo = Notification.Name(rawValue: "com.luci.beefun.mac.getuserinfo")
        
        /// 用户操作改变了数据库
        public static let databaseChanged = Notification.Name(rawValue: "com.luci.beefun.mac.databaseChanged")
    
        /// 同步操作
        public static let SyncStarRepoStart = Notification.Name(rawValue: "com.luci.beefun.mac.syncStarRepoStart")
        public static let SyncStarRepoEnd = Notification.Name(rawValue: "com.luci.beefun.mac.syncStarRepoEnd")

        public static let WillLogout = Notification.Name(rawValue: "com.luci.beefun.mac.willlogout")
        public static let DidLogout = Notification.Name(rawValue: "com.luci.beefun.mac.didlogout")
        public static let AddTag = Notification.Name(rawValue: "com.luci.beefun.mac.addtag")
        public static let UpdateTag = Notification.Name(rawValue: "com.luci.beefun.mac.updatetag")
        public static let DelTag = Notification.Name(rawValue: "com.luci.beefun.mac.deltag")
        public static let RepoUpdateTag = Notification.Name(rawValue: "com.luci.beefun.mac.repoupdatetag")

        /// Network reachablity
        public static let NotReachable = Notification.Name(rawValue: "com.luci.beefun.mac.NotReachable")
        public static let Unknown = Notification.Name(rawValue: "com.luci.beefun.mac.Unknown")
        public static let ReachableAfterUnreachable = Notification.Name(rawValue: "com.luci.beefun.mac.ReachableAfterUnreachable")
        public static let ReachableWiFi = Notification.Name(rawValue: "com.luci.beefun.mac.ReachableWiFi")
        public static let ReachableCellular = Notification.Name(rawValue: "com.luci.beefun.mac.ReachableCellular")
        public static let UnReachableAfterReachable = Notification.Name(rawValue: "com.luci.beefun.mac.UnReachableAfterReachable")

        /// Star Action
        public static let didStarRepo = Notification.Name(rawValue: "com.luci.beefun.mac.didStarRepo")
        
        /// UnStar Action
        public static let didUnStarRepo = Notification.Name(rawValue: "com.luci.beefun.mac.ddiUnStarRepo")
    }
}
