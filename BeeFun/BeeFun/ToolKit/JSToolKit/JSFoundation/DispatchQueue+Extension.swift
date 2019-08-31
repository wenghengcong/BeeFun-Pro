//
//  DispatchQueue+Extension.swift
//  BeeFun
//
//  Created by WengHengcong on 24/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit


// MARK: - dispatch once
/*
 example: 
 DispatchQueue.once {
    setupUI()
 }
 
 DispatchQueue.once(token: "com.me.project") {
    setupUI()
 }
 */
public extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    public class func once(file: String = #file, function: String = #function, line: Int = #line, block: ()-> Void) {
        let token = file + ":" + function + ":" + String(line)
        once(token: token, block: block)
    }
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    public class func once(token: String, block: ()-> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        if _onceTracker.contains(token) {
            return
        }
        _onceTracker.append(token)
        block()
    }
}
