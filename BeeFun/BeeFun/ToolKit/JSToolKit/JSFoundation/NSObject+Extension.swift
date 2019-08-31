//
//  NSObject+Extension.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/4/13.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

extension NSObject {

    var className: String {
        return String(describing: type(of: self))
    }

    class var className: String {
        return String(describing: self)
    }

}
