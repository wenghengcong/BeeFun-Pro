//
//  JSImageCell.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/5/4.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

/// Icon 圆角类型
///
/// - none: 没有圆角，Icon原来是什么，就是什么
/// - oval: 椭圆形圆角，
/// - round: 圆形圆角
enum IconCornerType {
    case none
    case oval
    case round
}

/// 含Icon的Cell
/// |                   |
/// |icon key      value|
/// |                   |
class JSImageCell: JSBaseCell, JSImageCellCustomProtocol {

    /// ICON大小为25*25
    @IBOutlet weak var iconImageV: UIImageView!
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
    
    var cellCornerType: IconCornerType = .none {
        didSet {
            switch cellCornerType {
            case .none:
                break
            case .oval:
                iconImageV.radius = 3.5
            case .round:
                iconImageV.radius = 15
            }
        }
    }
    
    var iconSize: CGFloat = 25.0 {
        didSet {
            iconImageV.frame = CGRect(x: iconImageV.x, y: iconImageV.y, w: iconSize, h: iconSize)
        }
    }
    
    override func customCellView() {
        super.customCellView()
        bottomLineType = .label
        cellCornerType = .none
        isFirst = false
        keyFontSize = 17.0
        valueFontSize = 15.0
        
        disclosureImgV.image = UIImage(named: "arrow_set_right")
        keyLabel.textAlignment = .left
        valueLabel.textAlignment = .right
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
        assert(model?.icon != nil, "Image Cell icon is nil")
        if let iconName = model?.icon {
            iconImageV.image = UIImage(named: iconName)
        }
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
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
            
            let iconX = uiCellLabelLeftMargin
            let iconY: CGFloat = (self.height-iconSize)/2
            iconImageV.frame = CGRect(x: iconX, y: iconY, w: iconSize, h: iconSize)
            
            /// txtWidth 指的是文字长短
            let txtWidth = ScreenSize.width-uiCellImageLeftMargin
            var titW = txtWidth/2.0 - 20
            var detailW = txtWidth/2.0 + 20
            
            let disRightMargin: CGFloat = 15
            let disW: CGFloat = 8
            let disH: CGFloat = 14
            let disY: CGFloat = (self.height-disH)/2
            let disX: CGFloat = ScreenSize.width-disW-disRightMargin
            
            /// discolsure iamge整个大小
            let disAllWidth = disW+disRightMargin+13
            
            if model?.discosure == true {
                disclosureImgV.frame = CGRect(x: disX, y: disY, w: disW, h: disH)
                if model!.value != nil {
                    detailW -= disAllWidth
                } else {
                    titW = txtWidth - disAllWidth
                }
            } else {
                if model!.value != nil {
                    ///无详情箭头，也需要在对齐右边距时，有间隔
                    detailW -= uiCellLabelRightMargin
                } else {
                    titW = txtWidth - uiCellLabelRightMargin
                }
            }
            keyLabel.frame = CGRect(x: uiCellImageLeftMargin, y: 0, w: titW, h: self.height)
            valueLabel.frame = CGRect(x: keyLabel.right, y: 0, w: detailW, h: self.height)
        }
    }
    
}
