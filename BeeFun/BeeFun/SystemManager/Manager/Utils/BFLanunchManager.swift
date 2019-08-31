//
//  BFLanunchManager.swift
//  BeeFun
//
//  Created by WengHengcong on 2018/6/19.
//  Copyright © 2018年 JungleSong. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Fabric
import Crashlytics

class BFLanunchManager: NSObject {

    static let shared = BFLanunchManager()
    
    // MARK: - Appdelegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        launchBeeFunService(application, didFinishLaunchingWithOptions: launchOptions)
        launchThirdParty(application, didFinishLaunchingWithOptions: launchOptions)
        launchDataAnalysis(application, didFinishLaunchingWithOptions: launchOptions)
        launchPushAndShare(application, didFinishLaunchingWithOptions: launchOptions)
        launchNetworkMonitor(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        //UMSocialSnsService.applicationDidBecomeActive()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    // MARK: - Launch
    func launchBeeFunService(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        JSCellFactory.registerCellInfo()
        //启动从Github拉取数据，更新服务端数据库
        BeeFunDBManager.shared.updateServerDB(showTips: false, first: false)
        //设置语言
        JSLanguage.initUserLanguage()
        UserManager.shared.updateUserInfo()
        //从GitHub获取语言列表，获取后固化为plist，不再需要
//        LanguageManager.shared.requestForLanguage()
    }
    
    func launchThirdParty(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        //JSLog
        JSSwiftyBeaver.bridgeInit()
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        // Define a Region in Rome/Italy and set it as default region
        // Our Region also uses Gregorian Calendar and Italy Locale
//        let romeRegion = Region(tz: TimeZoneName.asiaShanghai, cal: CalendarName.gregorian, loc: LocaleName.chineseSimplified)
//        Date.setDefaultRegion(romeRegion)
    }
    
    func launchDataAnalysis(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        //友盟分析
        UMAnalyticsConfig.sharedInstance().appKey = UMengAppSecret
        //发送策略：BATCH启动，SEND_INTERVAL，间隔发送
        UMAnalyticsConfig.sharedInstance().ePolicy = SEND_INTERVAL
        MobClick.setAppVersion(JSApp.appVersion)
        MobClick.start(withConfigure: UMAnalyticsConfig.sharedInstance())
        //bug
        //        CrashReporter.shared().enableLog(true)
        //        Bugly.start(withAppId: TencentBuglyAppID)
        //Fabric
        Fabric.with([Crashlytics.self])
        Fabric.with([Answers.self])
        #if DEBUG
        //        GDPerformanceMonitor.sharedInstance.startMonitoring()
        #endif
    }
    
    func launchPushAndShare(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        //JPush
        _ = JPushManager.init(launchOptions: launchOptions)
        JPushManager.shared.checkAlias()
        //ShareSDK
        //        ShareManager.shared.register()
    }
    
    func launchNetworkMonitor(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        BFMonitor.shared.start()
        _ = BFNetworkManager.shared.startListening()
    }
}
