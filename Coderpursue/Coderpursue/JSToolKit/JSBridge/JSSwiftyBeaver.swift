//
//  JSSwiftyBeaverBridge.swift
//  LoveYou
//
//  Created by WengHengcong on 2016/10/30.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit
import SwiftyBeaver
let JSLog = SwiftyBeaver.self

class JSSwiftyBeaver: NSObject {
    
    public class func bridgeInit()->Void{
    
        // add log destinations. at least one is needed!
        let console = ConsoleDestination()  // log to Xcode Console
        //let file = FileDestination()  // log to default swiftybeaver.log file
        //let cloud = SBPlatformDestination(appID: "foo", appSecret: "bar", encryptionKey: "123") // to cloud
    
        // use custom format and set console output to short time, log level & message
//        console.format = "$DHH:mm:ss$d $L $M"
    
        // add the destinations to SwiftyBeaver
        JSLog.addDestination(console)
        //log.addDestination(file)
        //log.addDestination(cloud)
    }
    
}
