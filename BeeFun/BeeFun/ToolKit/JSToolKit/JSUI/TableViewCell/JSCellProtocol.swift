//
//  JSCellProtocol.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/5/6.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

/// Cell的共有属性
public protocol JSBaseCellProtocol: class {
    /// Cell Type：Image/Label....
    var type: String { get }
    /// Cell Identifier：主要用于didSelected
    var id: String { get }
    /// 自定义Cell的视图
    func customCellView()
    /// 填充数据
    func fillData()
}

/// Label Cell的独有属性
protocol JSLabelCellCustomProtocol: class {
    
    /// key label字体大小，默认17.0
    var keyFontSize: CGFloat { get set }
    /// value label字体大小，默认17.0
    var valueFontSize: CGFloat { get set }
}

/// Image Cell的独有属性
protocol JSImageCellCustomProtocol: class {
    /// key label字体大小，默认17.0
    var keyFontSize: CGFloat { get set }
    /// value label字体大小，默认17.0
    var valueFontSize: CGFloat { get set }
    /// Icon的圆角类型，默认没有圆角：.none
    var cellCornerType: IconCornerType { get set }
    
    /// Icon的大小：默认25*25
    var iconSize: CGFloat { get set }
}
