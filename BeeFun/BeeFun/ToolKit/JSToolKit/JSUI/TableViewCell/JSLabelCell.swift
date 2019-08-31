//
//  JSLabelCell.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/5/4.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

/// 只包含文字的Cell
/// |                   |
/// |key         value >|
/// |                   |
class JSLabelCell: JSBaseCell, JSLabelCellCustomProtocol {

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var disclosureImgV: UIImageView!
    
    var keyFontSize: CGFloat = 17.0 {
        didSet {
            keyLabel.font = JSCellUtils.bfSystemFont(ofSize: keyFontSize)
        }
    }
    
    var valueFontSize: CGFloat = 17.0 {
        didSet {
            valueLabel.font = JSCellUtils.bfSystemFont(ofSize: valueFontSize)
        }
    }
    
    override func customCellView() {
        super.customCellView()
        bottomLineType = .label
        isFirst = false
        disclosureImgV.image = UIImage(named: "arrow_set_right")
        
        keyLabel.textAlignment = .left
        keyFontSize = 17.0
        
        valueLabel.textAlignment = .right
        valueFontSize = 15.0
    }
    
    override func fillData() {
        super.fillData()
        keyLabel.adjustFontSizeToFitWidth(minScale: 0.5)
        valueLabel.adjustFontSizeToFitWidth(minScale: 0.5)
        
        if let attributeKey = model?.attributeKey {
            keyLabel.attributedText = attributeKey
        } else {
            keyLabel.text = model?.key?.localized
        }
        
        if let attributeValue = model?.attributeValue {
            valueLabel.attributedText = attributeValue
        } else {
            valueLabel.text = model?.value?.localized
        }
        
        /// 配置的数据源高于设置
        if let keySize = model?.keySize {
            keyFontSize = keySize
        }
        
        if let valueSize = model?.valueSize {
            valueFontSize = valueSize
        }
        
        if let hasDis = model?.discosure {
            disclosureImgV.isHidden = !hasDis
        }
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //TEST:
//        keyLabel.backgroundColor = UIColor.red
//        valueLabel.backgroundColor = UIColor.green
//        disclosureImgV.backgroundColor = UIColor.blue
        
        let hasModel = (model != nil) ? true : false
        keyLabel.isHidden = !hasModel
        valueLabel.isHidden = !hasModel
        if hasModel {
            var cellWidth = ScreenSize.width
            switch bottomLineType {
            case .label:
                cellWidth -= uiCellLabelLeftMargin
            case .image:
                cellWidth -= uiCellImageLeftMargin
            case .full:
                break
            }
            
            var titW: CGFloat = 0
            var valueW: CGFloat = 0
            var valueX: CGFloat = 0
            
            let disRightMargin: CGFloat = 15
            let disW: CGFloat = 8
            let disH: CGFloat = 14
            let disY: CGFloat = (self.height-disH)/2
            let disX: CGFloat = ScreenSize.width-disW-disRightMargin

            /// discolsure iamge整个大小
            let disAllWidth = disW+disRightMargin+10

            valueLabel.isHidden = (model!.value == nil)
            if model?.discosure == true {
                disclosureImgV.frame = CGRect(x: disX, y: disY, w: disW, h: disH)
                if model!.value != nil {
                    valueW = model!.value!.width(with: self.height, font: valueLabel.font)
                    valueX = ScreenSize.width-disAllWidth-valueW
                    titW = valueX-uiCellLabelLeftMargin
                } else {
                    titW = ScreenSize.width - disAllWidth - uiCellLabelLeftMargin
                }
            } else {
                if model!.value != nil {
                    valueW = model!.value!.width(with: self.height, font: valueLabel.font)
                    valueX = ScreenSize.width-valueW-10-6
                    titW = valueX-uiCellLabelLeftMargin
                } else {
                    titW = ScreenSize.width - uiCellLabelRightMargin
                }
            }
            valueLabel.frame = CGRect(x: valueX, y: 0, w: valueW, h: self.height)
            keyLabel.frame = CGRect(x: uiCellLabelLeftMargin, y: 0, w: titW, h: self.height)
        }
    }
}
