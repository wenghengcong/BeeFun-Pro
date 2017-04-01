//
//  TimeHelper.swift
//  Coderpursue
//
//  Created by WengHengcong on 2017/3/6.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit
import SwiftDate

class TimeHelper: NSObject {
    static let shared = TimeHelper()
    
    /// 返回互联网时间
    ///
    /// - Parameters:
    ///   - rare: <#rare description#>
    ///   - prefix: <#prefix description#>
    /// - Returns: <#return value description#>
    func internetTime(rare:String? ,prefix:String?) -> String? {
        
        if let rareStr:String = rare {
            do {
                let createAt:DateInRegion =  try rareStr.date(format: DateFormat.iso8601(options: .withInternetDateTime))!
                
                var internet = createAt.string()
                if prefix != nil {
                   internet = prefix!.localized + " :" + internet
                }
                return internet
            } catch  {
                return nil
            }
        }
        
        return nil
    }
    
    
    /// 返回可读时间
    ///
    /// - Parameters:
    ///   - rare: <#rare description#>
    ///   - prefix: <#prefix description#>
    /// - Returns: <#return value description#>
    func readableTime(rare:String? ,prefix:String?) -> String? {
        
        if let rareStr:String = rare {
            do {
                let createAt:DateInRegion =  try rareStr.date(format: DateFormat.iso8601(options: .withInternetDateTime))!
                
                var (readable,_) = try createAt.colloquialSinceNow()
                if prefix != nil {
                    readable = prefix!.localized + " :"  + readable
                }
                return readable
            } catch  {
                return nil
            }
        }
        
        return nil
    }

}
