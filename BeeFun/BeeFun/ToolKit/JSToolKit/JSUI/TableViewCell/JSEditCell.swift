//
//  JSEditCell.swift
//  BeeFun
//
//  Created by WengHengcong on 25/06/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit

class JSEditCell: JSBaseCell {
    
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueText: UITextField!
    
    var value: String? {
        set {
            self.value = newValue
            valueText.text = value
        }
        get {
            return valueText.text
        }
    }
    
    var keyFontSize: CGFloat = 17.0 {
        didSet {
            keyLabel.font = JSCellUtils.bfSystemFont(ofSize: keyFontSize)
        }
    }
    
    var valueFontSize: CGFloat = 17.0 {
        didSet {
            valueText.font = JSCellUtils.bfSystemFont(ofSize: valueFontSize)
        }
    }
    
    override func customCellView() {
        super.customCellView()
        bottomLineType = .label
        isFirst = false
        
        keyLabel.textAlignment = .left
        keyFontSize = 17.0
        
        valueText.textAlignment = .right
        valueFontSize = 15.0
    }
    
    override func fillData() {
        super.fillData()
        //TEST:
//        keyLabel.backgroundColor = UIColor.red
//        valueText.backgroundColor = UIColor.green
        
        keyLabel.adjustFontSizeToFitWidth(minScale: 0.5)
        valueText.adjustFontSizeToFitWidth(minFont: valueFontSize/2.0)
        
        if let attributeKey = model?.attributeKey {
            keyLabel.attributedText = attributeKey
        } else {
            keyLabel.text = model?.key?.localized
        }
        
        if let attributeValue = model?.attributeValue {
            valueText.attributedText = attributeValue
        } else {
            valueText.text = model?.value?.localized
        }
        
        /// 配置的数据源高于设置
        if let keySize = model?.keySize {
            keyFontSize = keySize
        }
        
        if let valueSize = model?.valueSize {
            valueFontSize = valueSize
        }
        
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let hasModel = (model != nil) ? true : false
        keyLabel.isHidden = !hasModel
        if hasModel {
            let cellWidth = ScreenSize.width
            let keyW: CGFloat = 70
            let valueW = cellWidth-keyW-10-uiCellLabelLeftMargin
            keyLabel.frame = CGRect(x: uiCellLabelLeftMargin, y: 0, w: keyW, h: self.height)
            valueText.frame = CGRect(x: keyLabel.right, y: 0, w: valueW, h: self.height)
        }
    }

}
