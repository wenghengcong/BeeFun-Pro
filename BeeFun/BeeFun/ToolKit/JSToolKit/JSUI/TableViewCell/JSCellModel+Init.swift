//
//  JSCellModel+Init.swift
//  BeeFun
//
//  Created by WengHengcong on 25/06/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit

extension JSCellModel {
    
    // MARK: - 初始化
    convenience init(_ keyvalues: [String : Any]) {
        self.init()
        setValuesForKeys(keyvalues)
    }
    
    /// Label Cell Model 初始化
    ///
    /// - Parameters:
    ///   - type: Cell类型
    ///   - id: key作为cell的标识
    ///   - key: 左边标题
    ///   - value: 右边详情描述
    ///   - discosure: 是否显示详情图标
    convenience init(type: String, id: String, key: String?, value: String?, discosure: Bool?) {
        self.init(type: type, id: id, key: key, value: value, discosure: false, keySize: jsCellDefaultSize, valueSize: jsCellDefaultSize)
    }
    
    /// Label Cell Model 初始化
    ///
    /// - Parameters:
    ///   - type: Cell类型
    ///   - id: key作为cell的标识
    ///   - key: 左边标题
    ///   - value: 右边详情描述
    ///   - discosure: 是否显示详情图标
    ///   - keySize: key对应字体大小
    ///   - valueSize: valud对应字体大小
    convenience init(type: String, id: String, key: String?, value: String?, discosure: Bool?, keySize: CGFloat?, valueSize: CGFloat?) {
        self.init()
        self.type = type
        self.identifier = id
        self.key = key
        self.value = value
        if let dis = discosure {
            self.discosure = dis
        }
        if let ksize = keySize {
            self.keySize = ksize
        }
        if let vsize = valueSize {
            self.valueSize = vsize
        }
    }
    
    /// Image Cell Model 初始化
    ///
    /// - Parameters:
    ///   - type: Cell类型
    ///   - id: key作为cell的标识
    ///   - key: 左边标题
    ///   - value: 右边详情描述
    ///   - icon: 图片名
    ///   - discosure: 是否显示详情图标
    convenience init(type: String, id: String, key: String?, value: String?, icon: String?, discosure: Bool?) {
        self.init(type: type, id: id, key: key, value: value, icon: icon, discosure: discosure, keySize: jsCellDefaultSize, valueSize: jsCellDefaultSize)
    }
    
    /// Image Cell Model 初始化
    ///
    /// - Parameters:
    ///   - type: Cell类型
    ///   - id: key作为cell的标识
    ///   - key: 左边标题
    ///   - value: 右边详情描述
    ///   - discosure: 是否显示详情图标
    ///   - keySize: key对应字体大小
    ///   - valueSize: valud对应字体大小
    convenience init(type: String, id: String, key: String?, value: String?, icon: String?, discosure: Bool?, keySize: CGFloat?, valueSize: CGFloat?) {
        self.init()
        self.type = type
        self.identifier = id
        self.key = key
        self.value = value
        self.icon = icon
        if let dis = discosure {
            self.discosure = dis
        }
        if let ksize = keySize {
            self.keySize = ksize
        }
        if let vsize = valueSize {
            self.valueSize = vsize
        }
    }
    /// Edit Cell Model 初始化
    ///
    /// - Parameters:
    ///   - type: Cell类型
    ///   - id: key作为cell的标识
    ///   - key: 左边标题
    ///   - value: 右边详情描述
    ///   - placeholder: 占位符
    convenience init(type: String, id: String, key: String?, value: String?, placeholder: String?) {
        self.init(type: type, id: id, key: key, value: value, placeholder: placeholder, keySize: jsCellDefaultSize, valueSize: jsCellDefaultSize)
    }
    /// Edit Cell Model 初始化
    ///
    /// - Parameters:
    ///   - type: Cell类型
    ///   - id: key作为cell的标识
    ///   - key: 左边标题
    ///   - value: 右边详情描述
    ///   - placeholder: 占位符
    ///   - keySize: key对应字体大小
    ///   - valueSize: valud对应字体大小
    convenience init(type: String, id: String, key: String?, value: String?, placeholder: String?, keySize: CGFloat?, valueSize: CGFloat?) {
        self.init()
        self.type = type
        self.identifier = id
        self.key = key
        self.value = value
        self.placeholder = placeholder
        if let ksize = keySize {
            self.keySize = ksize
        }
        if let vsize = valueSize {
            self.valueSize = vsize
        }
    }
    
    
    /// Switched Cell Model 初始化
    ///
    /// - Parameters:
    ///   - type: Cell类型
    ///   - id: key作为cell的标识
    ///   - key: 左边标题
    ///   - switched: 开关值
    convenience init(type: String, id: String, key: String?, switched: Bool?) {
        self.init(type: type, id: id, key: key, switched: switched, keySize: jsCellDefaultSize)
    }
    
    /// Switched Cell Model 初始化
    ///
    /// - Parameters:
    ///   - type: Cell类型
    ///   - id: key作为cell的标识
    ///   - key: 左边标题
    ///   - switched: 开关值
    ///   - keySize: key对应字体大小
    convenience init(type: String, id: String, key: String?, switched: Bool?, keySize: CGFloat?) {
        self.init()
        self.type = type
        self.identifier = id
        self.key = key
        if let swi = switched {
            self.switched = swi
        } else {
            self.switched = false
        }
        
        if let ksize = keySize {
            self.keySize = ksize
        }
        
    }
}
