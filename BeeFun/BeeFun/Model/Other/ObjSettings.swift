//
//  ObjSettings.swift
//  BeeFun
//
//  Created by wenghengcong on 16/1/19.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit

class ObjSettings: NSObject {

    var itemKey: String?
    var itemName: String?
    var itemValue: String?
    var itemIcon: String?
    var itemDisclosure: Bool?

    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        return
    }

    override func setValuesForKeys(_ keyedValues: [String : Any]) {

        itemKey = keyedValues["itemKey"] as? String
        itemName = keyedValues["itemName"] as? String
        itemValue = keyedValues["itemValue"] as? String
        itemIcon = keyedValues["itemIcon"] as? String
        itemDisclosure = keyedValues["itemDisclosure"] as? Bool

    }
}
