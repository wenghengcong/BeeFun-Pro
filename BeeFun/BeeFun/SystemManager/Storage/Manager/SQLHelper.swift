//
//  SQLManagerHelper.swift
//  BeeFun
//
//  Created by WengHengcong on 23/05/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import SQLite


/// sql order
///
/// - asc: 升序
/// - desc: 降序
enum SQLOrder {
    case asc
    case desc
}

struct SQLHelper {
    
    static func SQLBlob(stringarray: [String]?) -> Blob {
        let blob = NSKeyedArchiver.archivedData(withRootObject: stringarray ?? [String]() ).datatypeValue
        return blob
    }
    
    static func SQLBlob(intarray: [Int]?) -> Blob {
        let blob = NSKeyedArchiver.archivedData(withRootObject: intarray ?? [Int]() ).datatypeValue
        return blob
    }
    
    static func stringArray(blob: Blob? ) -> [String] {
        var array: [String] = []
        if blob != nil {
            let data = Data.fromDatatypeValue(blob!)
            array = NSKeyedUnarchiver.unarchiveObject(with: data) as! [String]
        }
        return array
    }
    
    static func intArray(blob: Blob? ) -> [Int] {
        var array: [Int] = []
        if blob != nil {
            let data = Data.fromDatatypeValue(blob!)
            array = NSKeyedUnarchiver.unarchiveObject(with: data) as! [Int]
        }
        return array
    }
    
}
