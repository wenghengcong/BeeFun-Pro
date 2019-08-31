//
//  JPushManager.swift
//  BeeFun
//
//  Created by WengHengcong on 2018/6/9.
//  Copyright © 2018年 JungleSong. All rights reserved.
//

import UIKit
import UserNotifications

class JPushManager: NSObject {
    
    static let shared = JPushManager()
    //Check list: 上线打开推送开关
    var apsProduction: Bool = true

    override init() {
        super.init()
    }
    
    convenience init(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        self.init()

        NotificationCenter.default.addObserver(self, selector: #selector(setAlias), name: NSNotification.Name.BeeFun.DidLogin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteAlias), name: NSNotification.Name.BeeFun.DidLogout, object: nil)
        register(launchOptions: launchOptions)
    }
    
    func register(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        JPUSHService.setup(withOption: launchOptions, appKey: JPushAppKey, channel: JPushChannel, apsForProduction: apsProduction)
        let pushConfig = JPUSHRegisterEntity.init()
        let pushSwitch = (UIUserNotificationType.badge.rawValue|UIUserNotificationType.sound.rawValue|UIUserNotificationType.alert.rawValue)
        pushConfig.types = Int(pushSwitch)
        JPUSHService.register(forRemoteNotificationConfig: pushConfig, delegate: nil)
    }
    
    func checkAlias() {
        if UserManager.shared.isLogin {
            UserManager.shared.updateUserInfo()
            setAlias()
        } else {
            deleteAlias()
        }
    }
    
    @objc private func setAlias() {
        if let userlogin = UserManager.shared.login {
            JPUSHService.setAlias(userlogin, completion: { (_, _, _) in
                
            }, seq: 0)

        }
    }
    
    @objc private func deleteAlias() {
        JPUSHService.deleteAlias({ (_, _, _) in
            
        }, seq: 0)
    }
    
    //    取出通知中对应的Userinfo
    func userinfoWithUNNotification(notification: AnyObject) -> [AnyHashable: Any]? {
        if #available(iOS 10.0, *) {
            if notification.isKind(of: UNNotification.self) {
                if let noti: UNNotification = notification as? UNNotification {
                    return noti.request.content.userInfo
                }
            } else if notification.isKind(of: UNNotificationResponse.self) {
                if let noti: UNNotificationResponse = notification as? UNNotificationResponse {
                    return noti.notification.request.content.userInfo
                }
            }
            return nil
        }
        return nil
    }
}
