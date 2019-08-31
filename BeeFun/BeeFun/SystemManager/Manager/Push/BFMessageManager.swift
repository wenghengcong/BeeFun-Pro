//
//  BFMessageManager.swift
//  BeeFun
//
//  Created by 翁恒丛 on 2018/6/19.
//  Copyright © 2018年 JungleSong. All rights reserved.
//

import UIKit
import UserNotifications

enum PushMessageService: String {
    case m
    case versionUpgrade
}

class BFMessageManager: NSObject {
    
    static let serviceTypeKey = "serviceType"
    static let landpageUrl = "landpageUrl"
    
    // MARK: - iOS 10以下推送处理
    /// 处理本地推送
    static func receiveLocalNotificaion(notification: UILocalNotification) {
        if let userinfo = notification.userInfo {
            handleLocalNotification(userInfo: userinfo)
        }
    }
    /// 处理远程推送
    static func receiveRemoteNotification(userInfo: [AnyHashable: Any]) {
        handleRemoteNotification(userInfo: userInfo)
    }
    
    // MARK: - iOS 10推送处理
    @available(iOS 10.0, *)
    /// 处理远程推送
    static func receiveResponse(response: UNNotificationResponse) {
        if let userinfo = JPushManager.shared.userinfoWithUNNotification(notification: response),
            let trigger = response.notification.request.trigger {
            if trigger.isKind(of: UNPushNotificationTrigger.self) {
                handleRemoteNotification(userInfo: userinfo)
            } else {
                handleLocalNotification(userInfo: userinfo)
            }
        }
    }
    
    @available(iOS 10.0, *)
    /// 前台处理远程推送
    static func receiveNotification(notification: UNNotification) {
        if let userinfo = JPushManager.shared.userinfoWithUNNotification(notification: notification),
            let trigger = notification.request.trigger {
            if trigger.isKind(of: UNPushNotificationTrigger.self) {
                appActiveHandleRemoteNotification(userInfo: userinfo)
            } else {
                appActiveHandleLocalNotification(userInfo: userinfo)
            }
        }
    }

    // MARK: - 远程推送
    /// 后台处理远程推送
    private static func handleRemoteNotification(userInfo: [AnyHashable: Any]) {
        JPUSHService.handleRemoteNotification(userInfo)
        if UIApplication.shared.applicationState == .inactive {
            appInactiveHandleRemoteNotification(userInfo: userInfo)
        } else {
            appActiveHandleRemoteNotification(userInfo: userInfo)
        }
    }
    
    /// 后台处理远程推送
    private static func appInactiveHandleRemoteNotification(userInfo: [AnyHashable: Any]) {
        if let serviceType: String = userInfo[serviceTypeKey] as? String {
            let type: PushMessageService = PushMessageService(rawValue: serviceType)!
            switch type {
            case .m:
                if let url = userInfo["landpageUrl"] as? String {
                    JumpManager.shared.jumpWebView(url: url)
                }
            default:
                break
            }
        }
    }
    
    /// 前台处理远程推送
    private static func appActiveHandleRemoteNotification(userInfo: [AnyHashable: Any]) {
        
    }
    
    // MARK: - 本地推送
    /// 处理本地推送
    private static func handleLocalNotification(userInfo: [AnyHashable: Any]) {
        if UIApplication.shared.applicationState == .inactive {
            appInactiveHandleLocalNotification(userInfo: userInfo)
        } else {
            appActiveHandleLocalNotification(userInfo: userInfo)
        }
    }
    
    /// 后台处理本地推送
    private static func appInactiveHandleLocalNotification(userInfo: [AnyHashable: Any]) {
        if let serviceType: String = userInfo["serviceType"] as? String {
            let type: PushMessageService = PushMessageService(rawValue: serviceType)!
            switch type {
            case .m:
                break
            default:
                break
            }
        }
    }
    
    /// 前台处理本地推送
    private static func appActiveHandleLocalNotification(userInfo: [AnyHashable: Any]) {
        
    }
    
    /// 是否是静默推送
    static func isSlientPush(userInfo: [AnyHashable: Any]) -> Bool {
        if userInfo.keys.count == 0 {
            return false
        }
        if let aps = userInfo["aps"] as? [AnyHashable: Any] {
            if  let avaiable = aps["content-available"] as? NSNumber {
                if avaiable.intValue == 1 {
                    return true
                }
            }
        } else {
            return false
        }
        return false
    }
    
}
