//
//  JSCellModel.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/5/4.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

class JSCellModel: NSObject {

    /**************************     数据源字段（Plist）   ***********************/
    // MARK: - 必选字段
    /// Cell类型
    var type: String?
    /// key作为cell的标识
    var identifier: String?
    
    // MARK: - 可选字段
    
    /*** 适用JSLabelCell/JSSubLabelCell/JSImageCell/JSSelectedCell/JSSwitchCell/JSEditCell类型  ***/
    /// 左边标题
    var key: String?
    
    /***  适用JSSubLabelCell  ***/
    /// 左边标题下部的标题
    var subkey: String?
    
    /***  适用JSLabelCell/JSSubLabelCell/JSEditCell  ***/
    /// 右边详情描述
    var value: String?

    /***  适用JSImageCell  ***/
    /// 左边在标题前边的icon
    var icon: String?
    /// icon大小，正方形
    var iconSize: CGFloat = jsCellIconSize
    
    /***  适用JSSelectedCell  ***/
    /// 右边是否选中
    var selected: Bool = false
    
    /***  适用JSImageCell/JSLabelCell/JSSubLabelCell  ***/
    /// 是否显示详情图标
    var discosure: Bool = false
    
    /***  适用JSSwitchCell  ***/
    /// switch开关
    var switched: Bool = false
    /***  适用JSEditCell  ***/
    var placeholder: String?

    /// key对应的KeyLabel的字体大小
    var keySize: CGFloat = jsCellDefaultSize
    
    /// value对应的valueLabel的字体大小
    var valueSize: CGFloat = jsCellDefaultSize
    
    /**************************     setter字段   ***********************/
    /// 左边标题,attributetext，只能通过setter方法设置，不能从plist等数据源获取该部分
    var attributeKey: NSAttributedString?
    /// 右边详情描述,attributetext可用，只能通过setter方法设置，不能从plist等数据源获取该部分
    var attributeValue: NSAttributedString?
    /// cellModel didSelect closure
    var didSelectClosure: CellDidSelectHandler
    
    /// cellModel didSelect closure
    var switchValueChangeClosure: SwitchValueChangeHandler
    
    override init() {
        super.init()
    }
    
    // MARK: - 解析
    /// 从数据源解析数据方法
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        return
    }
    
    /// 从plist或者网络获取到的值，设置到model
    override func setValuesForKeys(_ keyedValues: [String : Any]) {
        let cellType = keyedValues[JSCellModelKeyType] as? String
        assert(cellType != nil, "cell type undefined")
        identifier = keyedValues[JSCellModelKeyId] as? String

        type = cellType
        //if attributeKey not nil,ignore key
        key = keyedValues[JSCellModelKeyKey] as? String
        subkey = keyedValues[JSCellModelKeySubKey] as? String
        value = keyedValues[JSCellModelKeyValue] as? String
        icon = keyedValues[JSCellModelKeyIcon] as? String
        
        if let keysize = keyedValues[JSCellModelKeyKSize] as? CGFloat {
            keySize = keysize
        }
        if let valuesize = keyedValues[JSCellModelKeyVSize] as? CGFloat {
            valueSize = valuesize
        }
        
        if let iconsize = keyedValues[JSCellModelKeyIconSize] as? CGFloat {
            iconSize = iconsize
        }
        
        if let seled = keyedValues[JSCellModelKeySeleted] {
            if seled is String {
                selected = (seled as! String).bool!
            } else if seled is Bool {
                selected = seled as! Bool
            } else {
                assertionFailure("cell model selected datatype is incorrect")
                selected = false
            }
        }
        if let dised = keyedValues[JSCellModelKeyDisclosure] {
            if dised is String {
                discosure = (dised as! String).bool!
            } else if dised is Bool {
                discosure = dised as! Bool
            } else {
                assertionFailure("cell model discosure datatype is incorrect")
                discosure = false
            }
        }
        if let swed = keyedValues[JSCellModelKeySeleted] {
            if swed is String {
                switched = (swed as! String).bool!
            } else if swed is Bool {
                switched = swed as! Bool
            } else {
                assertionFailure("cell model switched datatype is incorrect")
                switched = false
            }
        }
    }
}
