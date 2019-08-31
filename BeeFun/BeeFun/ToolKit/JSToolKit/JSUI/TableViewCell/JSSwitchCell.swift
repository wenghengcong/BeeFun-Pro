//
//  JSSwitchCell.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/5/4.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

/// 右边是UISWitch控件
/// |                   |
/// |key             ⊂∤⊃|
/// |                   |
class JSSwitchCell: JSBaseCell {
    
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueSwitch: UISwitch!
    
    var value:Bool {
        set {
            self.value = newValue
            valueSwitch.isOn = newValue
        }
        get {
           return valueSwitch.isOn
        }
    }
    
    var keyFontSize: CGFloat = 17.0 {
        didSet {
            keyLabel.font = JSCellUtils.bfSystemFont(ofSize: keyFontSize)
        }
    }
    
    override func customCellView() {
        super.customCellView()
        
        bottomLineType = .full
        keyFontSize = 17.0
        keyLabel.textAlignment = .left

    }
    
    override func fillData() {
        super.fillData()
        keyLabel.adjustFontSizeToFitWidth(minScale: 0.5)
        
        if let m = model {
            keyLabel.text = m.key
            valueSwitch.isOn = m.switched
            /// 配置的数据源高于设置
            if let keySize = model?.keySize {
                keyFontSize = keySize
            }
            
            valueSwitch.addTarget(self, action: #selector(switchValueChange), for: .valueChanged)
        }
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var cellWidth = ScreenSize.width
        switch bottomLineType {
        case .label:
            cellWidth -= uiCellLabelLeftMargin
        case .image:
            cellWidth -= uiCellImageLeftMargin
        case .full:
            break
        }
        
        let hasModel = (model != nil) ? true : false
        keyLabel.isHidden = !hasModel
        if hasModel {
            let swiRightMargin: CGFloat = 15
            let swiW: CGFloat = 51
            let swiX: CGFloat = ScreenSize.width - swiW - swiRightMargin
            let swiH: CGFloat = 31
            let swiY: CGFloat = (self.height-swiH)/2.0
            valueSwitch.frame = CGRect(x: swiX, y: swiY, w: swiW, h: swiH)
            
            let keyW = cellWidth-(ScreenSize.width-valueSwitch.left)-10
            keyLabel.frame = CGRect(x: uiCellLabelLeftMargin, y: 0, w: keyW, h: self.height)
        }
    
    }
    
    @objc func switchValueChange() {
        if let closure = model?.switchValueChangeClosure {
            closure(valueSwitch, valueSwitch.isOn , model!)
        }
    }
    
}
