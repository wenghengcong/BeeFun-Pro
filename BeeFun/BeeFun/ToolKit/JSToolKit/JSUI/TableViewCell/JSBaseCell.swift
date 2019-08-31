//
//  JSBaseCell.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/5/4.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

/// Cell底部线的类型
/// 参考Apple Settings app的值
/// - full: 线铺满整个屏幕
/// - label: 线对齐Label，默认距离左边距15
/// - image: 线对齐Image，默认距离左边距60
enum CellLineType {
    case label
    case image
    case full
}

class JSBaseCell: UITableViewCell, JSBaseCellProtocol {

    var model: JSCellModel? {
        didSet {
            fillData()
        }
    }
    
    var type: String {
        if let typeFormModel = model?.type {
            return typeFormModel
        } else {
            assertionFailure("Undefined type")
            return ""
        }
    }
    
    var id: String {
        if let identifier = model?.identifier {
            return identifier
        } else {
            return ""
        }
    }
    
    /**
     *  是否为完整的底部灰线
     */
    var bottomLineType: CellLineType = .label {
        didSet {
            let retinaPixelSize = 1.0 / (UIScreen.main.scale)
            let bottomY = self.height - retinaPixelSize
            
            let botView: UIView = UIView()
            botView.backgroundColor = UIColor.bfLineBackgroundColor
            self.addSubview(botView)
            switch bottomLineType {
            case .full:
                botView.frame = CGRect(x: 0, y: bottomY, w: ScreenSize.width, h: retinaPixelSize)
            case .label:
                botView.frame = CGRect(x: uiCellLabelLeftMargin, y: bottomY, w: ScreenSize.width-uiCellLabelLeftMargin, h: retinaPixelSize)
            case .image:
                botView.frame = CGRect(x: uiCellImageLeftMargin, y: bottomY, w: ScreenSize.width-uiCellImageLeftMargin, h: retinaPixelSize)
            }
        }
    }
    /**
     *  是否有顶部线条
     */
    var isFirst: Bool = false {
        didSet {
            let retinaPixelSize = 1.0 / (UIScreen.main.scale)
            if isFirst {
                let topView: UIView = UIView()
                topView.backgroundColor = UIColor.bfLineBackgroundColor
                self.addSubview(topView)
                topView.frame = CGRect(x: 0, y: 0, w: ScreenSize.width, h: retinaPixelSize)
            }
        }
    }
    /// 从View中获取Cell
    static func cellFromNibNamed(_ nibName: String) -> AnyObject {
        var nibContents: Array = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)!
        let xibBasedCell = nibContents[0]
        return xibBasedCell as AnyObject
    }
    /// 自定义界面
    override func awakeFromNib() {
        super.awakeFromNib()
        customCellView()
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    /// 自定义界面代码
    func customCellView() {
    }
    
    /// 刷新填充UI数据
    func fillData() {
        
    }
    
    /// 设置Cell的头部和尾部的分割线
    ///
    /// - Parameters:
    ///   - current: 当前cell所在row
    ///   - rowsOfSection: 当前cell所在section的row总行数
    func bothEndsLine(_ current: Int, all rowsOfSection: Int) {
        isFirst = current==0
        let oriBottomLineType = bottomLineType
        bottomLineType = (current == rowsOfSection-1 ? .full : oriBottomLineType)
    }
    
}
