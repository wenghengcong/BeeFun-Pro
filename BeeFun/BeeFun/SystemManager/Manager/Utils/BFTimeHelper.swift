//
//  BFTimeHelper.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/3/6.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit
import SwiftDate

class BFTimeHelper: NSObject {
    static let shared = BFTimeHelper()

    
    
    /// 返回互联网时间
    ///
    /// - Parameters:
    ///   - rare: 原来的字符串
    ///   - prefix: 时间前缀
    /// - Returns: 返回互联网时间
    func internetTime(rare: String?, prefix: String?) -> String? {

        if let rareStr: String = rare {
            let createAt: Date = rareStr.date(withFormat: DateFormats.iso8601)!

            var internet = createAt.toString()
            if prefix != nil {
               internet = prefix!.localized + " :" + internet
            }
            return internet
            
        }
        return nil
    }

    /// 返回可读时间
    ///
    /// - Parameters:
    ///   - rare: 原来的时间字符串
    ///   - prefix: 时间前缀
    /// - Returns: 返回可读时间
    func readableTime(rare: String?, prefix: String?) -> String? {

        if let rareStr: String = rare {
                let createAt: DateInRegion =  rareStr.toDate()!
                var readable = createAt.toRelative()
                if prefix != nil {
                    readable = prefix!.localized + " :"  + readable
                }
                return readable
        }
        return nil
    }

}

extension Date {
    
    /// 获取当前 秒级 时间戳 - 10位
    var timeStamp: Int {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return timeStamp
    }
    
    /// 获取当前 毫秒级 时间戳 - 13位
    var milliStamp: Int64 {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return millisecond
    }
    
    
    /// 获取当前 秒级 时间戳 - 10位
    var timeStampString: String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }
    
    /// 获取当前 毫秒级 时间戳 - 13位
    var milliStampString: String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
}
