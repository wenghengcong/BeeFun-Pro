//
//  ObjSettings.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/19.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit

class ObjSettings: NSObject {
    
    var itemKey:String?
    var itemName:String?
    var itemValue:String?
    var itemIcon:String?
    var itemDisclosure:Bool?

    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        return
    }
    
    override func setValuesForKeysWithDictionary(keyedValues: [String : AnyObject]) {
        
        itemKey = keyedValues["itemKey"] as? String
        itemName = keyedValues["itemName"] as? String
        itemValue = keyedValues["itemValue"] as? String
        itemIcon = keyedValues["itemIcon"] as? String
        itemDisclosure = keyedValues["itemDisclosure"] as? Bool

    }
}
