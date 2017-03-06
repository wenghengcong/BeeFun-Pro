//
//  AppDelegate.swift
//  Coderpursue
//
//  Created by wenghengcong on 15/12/22.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,WXApiDelegate {

    var window: UIWindow?
    var tabBarController:CPBaseTabBarController?
    var storyBoard:UIStoryboard?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.sharedManager().enable = true
        
        //bug 
//        CrashReporter.sharedInstance().enableLog(true)
        Bugly.start(withAppId: TencentBuglyAppID)
        
        //Umeng Social
        ShareHelper.sharedInstance.configUMSocailPlatforms()
        
        //Umeng 
        MobClick.start(withAppkey: UMengAppSecret, reportPolicy: BATCH, channelId: nil)
        
        tabBarController = self.window!.rootViewController as! CPBaseTabBarController?
        storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        
        tabBarController = storyBoard?.instantiateViewController(withIdentifier: "tabbarController") as! CPBaseTabBarController?
        
        return true
    }

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
        UMSocialSnsService.applicationDidBecomeActive()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return UMSocialSnsService.handleOpen(url, wxApiDelegate: nil)
    }

    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return UMSocialSnsService.handleOpen(url)
    }

}

