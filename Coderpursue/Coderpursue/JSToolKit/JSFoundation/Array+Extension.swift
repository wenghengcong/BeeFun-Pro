//
//  Array+Extension.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/3/18.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

extension Array {
    
    /// 检查当前index是否超过数组边界
    ///
    /// - Parameter index: <#index description#>
    /// - Returns: <#return value description#>
    func isBeyond(index:Int) -> Bool{
        if ( (index >= self.count) && ( index < 0)) {
            return true
        }
        return false
    }
    
}
