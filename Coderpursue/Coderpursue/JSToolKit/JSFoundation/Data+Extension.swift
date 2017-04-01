//
//  Data+Extension.swift
//  LoveYou
//
//  Created by WengHengcong on 2017/3/14.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

extension Data{
    
    /// 返回Data的String
    var string:String? {
        return String(data:self, encoding: String.Encoding.utf8)
    }
    
}
