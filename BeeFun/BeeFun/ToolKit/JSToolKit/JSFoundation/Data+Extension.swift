//
//  Data+Extension.swift
//  LoveYou
//
//  Created by WengHengcong on 2017/3/14.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

extension Data {

    /// 返回Data的String
    var string: String? {
        return String(data:self, encoding: String.Encoding.utf8)
    }

}

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif


// MARK: - Methods
public extension Data {
    
    /// SwifterSwift: String by encoding Data using the given encoding (if applicable).
    ///
    /// - Parameter encoding: encoding.
    /// - Returns: String by encoding Data using the given encoding (if applicable).
    public func string(encoding: String.Encoding) -> String? {
        return String(data: self, encoding: encoding)
    }
    
}
