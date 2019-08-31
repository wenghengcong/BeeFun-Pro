//
//  JSCellModelFactory.swift
//  BeeFun
//
//  Created by WengHengcong on 25/06/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit

/// Model工厂
class JSCellModelFactory {
    
    // MARK: - Label
    static func labelInit(type: String, id: String, key: String?, value: String?, discosure: Bool?) -> JSCellModel {
        let cellM = JSCellModel.init(type: type, id: id, key: key, value: value, discosure: false)
        return cellM
    }
    
    static func labelInit(type: String, id: String, key: String?, value: String?, discosure: Bool?, keySize: CGFloat?, valueSize: CGFloat?) -> JSCellModel {
        let cellM = JSCellModel.init(type: type, id: id, key: key, value: value, discosure: discosure, keySize: keySize, valueSize: valueSize)
        return cellM
    }
    
    // MARK: - Image

    static func imageInit(type: String, id: String, key: String?, value: String?, icon: String?, discosure: Bool?) -> JSCellModel {
        let cellM = JSCellModel.init(type: type, id: id, key: key, value: value, icon: icon, discosure: discosure)
        return cellM
    }
    
    static func imageInit(type: String, id: String, key: String?, value: String?, icon: String?, discosure: Bool?, keySize: CGFloat?, valueSize: CGFloat?) -> JSCellModel {
        let cellM = JSCellModel.init(type: type, id: id, key: key, value: value, icon: icon, discosure: discosure, keySize: keySize, valueSize: valueSize)
        return cellM
    }
    
    // MARK: - Edit

    static func eidtInit(type: String, id: String, key: String?, value: String?, placeholder: String?) -> JSCellModel {
        let cellM = JSCellModel.init(type: type, id: id, key: key, value: value, placeholder: placeholder)
        return cellM
    }
    
    static func eidtInit(type: String, id: String, key: String?, value: String?, placeholder: String?, keySize: CGFloat?, valueSize: CGFloat?) -> JSCellModel {
        let cellM = JSCellModel.init(type: type, id: id, key: key, value: value, placeholder: placeholder, keySize: keySize, valueSize: valueSize)
        return cellM
    }
    
    // MARK: - Switch

    static func switchInit(type: String, id: String, key: String?, switched: Bool?) -> JSCellModel {
        let cellM = JSCellModel.init(type: type, id: id, key: key, switched: switched)
        return cellM
    }
    
    static func switchInit(type: String, id: String, key: String?, switched: Bool?, keySize: CGFloat?) -> JSCellModel {
        let cellM = JSCellModel.init(type: type, id: id, key: key, switched: switched, keySize: keySize)
        return cellM
    }
    
}
