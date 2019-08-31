//
//  JSCellUtils.swift
//  BeeFun
//
//  Created by WengHengcong on 06/07/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit

class JSCellUtils: NSObject {
    class func bfSystemFont(ofSize: CGFloat) -> UIFont {
        if iOSVersion.iOS9Later {
            return UIFont(name: "PingFang-SC-Regular", size: ofSize)!
        }
        return UIFont.systemFont(ofSize: ofSize)
    }
}
