//
//  PayManager.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/3/30.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

class PayManager: NSObject {

    class func aliPayMe() {
        let aliURL = URL(string: kAliPayMe)!
        if UIApplication.shared.canOpenURL(aliURL) {
            UIApplication.shared.openURL(aliURL)
        }
    }

}
