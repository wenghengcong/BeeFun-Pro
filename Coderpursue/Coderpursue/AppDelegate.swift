//
//  AppDelegate.swift
//  Coderpursue
//
//  Created by wenghengcong on 15/12/22.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import UserNotifications
import SwiftDate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var tabBarController:CPBaseTabBarController?
    var storyBoard:UIStoryboard?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //JSLog
        JSSwiftyBeaver.bridgeInit()
        
        //设置语言
        JSLanguage.initUserLanguage()
        
        // Override point for customization after application launch.
        IQKeyboardManager.sharedManager().enable = true
        
        //bug 
//        CrashReporter.shared().enableLog(true)
        Bugly.start(withAppId: TencentBuglyAppID)
    
        //ShareSDK
        ShareManager.shared.register()
        
        //友盟分析
        UMAnalyticsConfig.sharedInstance().appKey = UMengAppSecret
        //发送策略：BATCH启动，SEND_INTERVAL，间隔发送
        UMAnalyticsConfig.sharedInstance().ePolicy = SEND_INTERVAL
        MobClick.setAppVersion(JSApp.appVersion)
        MobClick.start(withConfigure: UMAnalyticsConfig.sharedInstance())
        
        
        //JPush
        // TODO: channel改为正式
        JPUSHService.setup(withOption: launchOptions, appKey: JPushAppKey, channel: JPushChannel, apsForProduction: false)

        let pushConfig = JPUSHRegisterEntity.init()
        let pushSwitch = (UIUserNotificationType.badge.rawValue|UIUserNotificationType.sound.rawValue|UIUserNotificationType.alert.rawValue)
        pushConfig.types = Int(pushSwitch)
        JPUSHService.register(forRemoteNotificationConfig: pushConfig, delegate: nil)
        
        
        //User Notification
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        } else {
            // Fallback on earlier versions
        }
        
        
        tabBarController = self.window!.rootViewController as! CPBaseTabBarController?
        storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        
        tabBarController = storyBoard?.instantiateViewController(withIdentifier: "tabbarController") as! CPBaseTabBarController?
        
        // Define a Region in Rome/Italy and set it as default region
        // Our Region also uses Gregorian Calendar and Italy Locale
//        let romeRegion = Region(tz: TimeZoneName.asiaShanghai, cal: CalendarName.gregorian, loc: LocaleName.chineseSimplified)
//        Date.setDefaultRegion(romeRegion)
        
        return true
    }
    
    // MARK: - Device token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("device token \(deviceTokenString)")
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("did fail to register for remote notifications with error: \(error)")
    }
    
    // MARK: - UNUserNotificationCenterDelegate

    //后台收到通知
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response)
        completionHandler()
    }
    
    //前台收到通知
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(notification)
        // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
        
        let option = ( UNNotificationPresentationOptions.badge.rawValue|UNNotificationPresentationOptions.alert.rawValue|UNNotificationPresentationOptions.sound.rawValue )
        completionHandler(UNNotificationPresentationOptions(rawValue: option))
    }
    
    
    
    // MARK: - App Life cycle

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //UMSocialSnsService.applicationDidBecomeActive()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    
    // MARK: - Open URL
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        //return UMSocialSnsService.handleOpen(url, wxApiDelegate: nil)
        return true
    }

    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        //return UMSocialSnsService.handleOpen(url)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }

}

