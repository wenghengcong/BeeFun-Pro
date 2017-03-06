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
    
    func readableTime(rare:String? ,prefix:String?) -> String? {
        
        if let rareStr:String = rare {
            do {
                let createAt:DateInRegion =  try rareStr.date(format: DateFormat.iso8601(options: .withFullTime))
                var readable = createAt.string()
                if prefix != nil {
                   readable = prefix! + readable
                }
                return readable
            } catch  {
                return nil
            }
        }
        
        return nil
    }
}
