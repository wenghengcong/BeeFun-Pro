//
//  AppDelegate.swift
//  BeeFun
//
//  Created by wenghengcong on 15/12/22.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

import UIKit
import UserNotifications
//import SwiftyStoreKit
import OAuthSwift
import Alamofire

#if DEBUG
//import GDPerformanceView_Swift
#endif

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var tabBarController: BFBaseTabBarController?    
    class var sharedInstance: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions
                     launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        BFLanunchManager.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        tabBarController = BFBaseTabBarController()
        window?.rootViewController = tabBarController
        //User Notification
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        } else {
            // Fallback on earlier versions
        }
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

    // MARK: - iOS 10 以下
    // MARK: Action Notification
    /**
     *  Called when your app has been activated by the user selecting an action from a remote notification.
     *  8.0 above
     *  当操作交互式通知时，进入这里
     */
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    /**
     *  Called when your app has been activated by the user selecting an action from a remote notification.
     *  9.0 above
     */
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable: Any], withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    /**
     *  Called when your app has been activated by the user selecting an action from a local notification.
     *  8.0 above
     */
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    /**
     *  Called when your app has been activated by the user selecting an action from a local notification.
     *  9.0 above
     */
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, withResponseInfo responseInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    // MARK: Local Notification
    /**
     * iOS 10之前，在前台，收到本地通知，会进入这里
     * iOS 10之前，在后台，点击本地通知，会进入这里
     * 假如未设置UNUserNotificationCenter代理，iOS 10收到本地通知也会进入这里。
     */
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        BFMessageManager.receiveLocalNotificaion(notification: notification)
    }
    
    /**
     *  iOS 10之前，若未实现该代理application didReceiveRemoteNotification: fetchCompletionHandler:
     不管在前台还是在后台，收到远程通知（包括静默通知）会进入didReceiveRemoteNotification代理方法；
     *  假如实现了，收到远程通知（包括静默通知）就会进入application didReceiveRemoteNotification: fetchCompletionHandler:方法
     *  假如未设置UNUserNotificationCenter代理，iOS 10收到远程通知也会进入这里。
     */
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        BFMessageManager.receiveRemoteNotification(userInfo: userInfo)
    }
    
    /*! This delegate method offers an opportunity for applications with the "remote-notification" background mode to fetch appropriate new data in response to an incoming remote notification. You should call the fetchCompletionHandler as soon as you're finished performing that operation, so the system can accurately estimate its power and data cost.
     
     This method will be invoked even if the application was launched or resumed because of the remote notification. The respective delegate methods will be invoked first. Note that this behavior is in contrast to application:didReceiveRemoteNotification:, which is not called in those cases, and which will not be invoked if this method is implemented. !*/
    /**
     *  iOS 10之前，不管在前台还是在后台，收到远程通知会进入此处；
     *  iOS 10之前，若未实现该代理，不管在前台还是在后台，收到远程通知会进入didReceiveRemoteNotification代理方法；
     *  iOS 10之前，静默通知，会进入到这里；
     *  iOS 10之后，在前台，静默通知，也会进入到这里
     如果为设置代理，再调用- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler。
     否则，不会调用上面方法；
     *  iOS 10之后，在后台，收到静默推送，也会进到这里。
     */
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
    }
    
    // MARK: - iOS 10 UNUserNotificationCenterDelegate

    /**
     * 在用户与你通知的通知进行交互时被调用，包括用户通过通知打开了你的应用，或者点击或者触发了某个action
     * 后台收到远程通知，点击进入
     * 后台收到本地通知，点击进入
     */
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response)
        BFMessageManager.receiveResponse(response: response)
        completionHandler()
    }

    /**
     *  在前台如何处理，通过completionHandler指定。如果不想显示某个通知，可以直接用空 options 调用 completionHandler:
     // completionHandler(0)
     *  前台收到远程通知，进入这里
     *  前台收到本地通知，进入这里
     *  前台收到带有其他字段alert/sound/badge的静默通知，进入这里
     *  后台收到静默通知不会调用该方法
     */
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(notification)
        BFMessageManager.receiveNotification(notification: notification)
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
        BFLanunchManager.shared.applicationDidBecomeActive(application)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

    }

    // MARK: - Open URL
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {

        //return UMSocialSnsService.handleOpen(url, wxApiDelegate: nil)
        applicationHandle(url: url)
        return true
    }

    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        //return UMSocialSnsService.handleOpen(url)
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        applicationHandle(url: url)
        return true
    }

    func applicationHandle(url: URL) {
        if url.host == AppOfficeShortSite {
            OAuthSwift.handle(url: url)
        } else {
            // Google provider is the only one wuth your.bundle.id url schema.
            OAuthSwift.handle(url: url)
        }
    }
}
