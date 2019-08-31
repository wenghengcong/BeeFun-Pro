//
//  JSApperenceExtension.swift
//  LoveYou
//
//  Created by WengHengcong on 2016/10/26.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit

class JSApperence: NSObject {

    public class func setTabbarTextColor(_ color: UIColor, for state: UIControlState) {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: color], for: state)
    }

    public class func setTabbarTextAttributes(_ attributes: [NSAttributedStringKey : Any]?, for state: UIControlState) {
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: state)
    }
}
