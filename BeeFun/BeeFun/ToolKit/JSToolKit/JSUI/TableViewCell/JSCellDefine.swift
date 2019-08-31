//
//  JSCellDefine.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/5/5.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

/// CellModel数据源可定制字段说明
///
/// - type: 必选字段：Cell类型
/// - id: 必选字段：key作为cell的标识，在同一个tableview中要保持唯一
/// - key: 可选字段：左边标题
/// - subkey: 可选字段：左边标题下部的标题
/// - value: 可选字段：右边详情描述
/// - icon: 可选字段：左边在标题前边的icon
/// - ksize: 可选字段：key对应的KeyLabel的字体大小
/// - vsize: 可选字段：value对应的valueLabel的字体大小
/// - iconsize: 可选字段：icon大小，正方形
/// - seleted: 可选字段：右边是否选中
/// - disclosure: 可选字段：是否显示详情图标
/// - switched: 可选字段：switch开关
enum JSCellModelKey: String {
    case type
    case id
    case key            /*** 适用JSLabelCell/JSSubLabelCell/JSImageCell/JSSelectedCell/JSSwitchCell类型  ***/
    case subkey         /***  适用JSSubLabelCell  ***/
    case value          /***  适用JSLabelCell/JSSubLabelCell  ***/
    case icon           /***  适用JSImageCell  ***/
    case ksize          /*** 适用JSLabelCell/JSSubLabelCell/JSImageCell/JSSelectedCell/JSSwitchCell类型  ***/
    case vsize          /*** 适用JSLabelCell/JSSubLabelCell/JSImageCell/JSSelectedCell/JSSwitchCell类型  ***/
    case iconsize       /***  适用JSImageCell  ***/
    case seleted        /***  适用JSSelectedCell  ***/
    case disclosure     /***  适用JSImageCell/JSLabelCell/JSSubLabelCell  ***/
    case switched       /***  适用JSSwitchCell  ***/
}

/// Cell类型
///
/// - label: Cell中只有Label
/// - image: Cell中左边含有Icon
/// - selected: Cell中右边含有选中按钮
/// - switched: Cell中含有UISwitch控件
enum JSCellType: String {
    case label
    case image
    case selected
    case switched
    case edit
}

let jsCellDefaultSize: CGFloat = 17.0
let jsCellIconSize: CGFloat = 25.0

/******************************** CellModel中字段 ********************************/
/// - type: 必选字段：Cell类型
let JSCellModelKeyType = "type"
/// - id: 必选字段：key作为cell的标识，在同一个tableview中要保持唯一
let JSCellModelKeyId = "id"
/// - key: 可选字段：左边标题
let JSCellModelKeyKey = "key"
/// - subkey: 可选字段：左边标题下部的标题
let JSCellModelKeySubKey = "subkey"
/// - value: 可选字段：右边详情描述
let JSCellModelKeyValue = "value"
/// - icon: 可选字段：左边在标题前边的icon
let JSCellModelKeyIcon = "icon"
/// - ksize: 可选字段：key对应的KeyLabel的字体大小
let JSCellModelKeyKSize = "ksize"
/// - vsize: 可选字段：value对应的valueLabel的字体大小
let JSCellModelKeyVSize = "vsize"
/// - iconsize: 可选字段：icon大小，正方形
let JSCellModelKeyIconSize = "iconsize"
/// - seleted: 可选字段：右边是否选中
let JSCellModelKeySeleted = "seleted"
/// - disclosure: 可选字段：是否显示详情图标
let JSCellModelKeyDisclosure = "disclosure"
/// - switched: 可选字段：switch开关
let JSCellModelKeySwitched = "switched"

/******************************** CellModel的类型 ********************************/
/// - label: Cell中只有Label
let JSCellModelTypeLabel                = "label"
/// - image: Cell中左边含有Icon
let JSCellModelTypeImage                = "image"
/// - selected: Cell中右边含有选中按钮
let JSCellModelTypeSeleted              = "selected"
/// - switched: Cell中含有UISwitch控件
let JSCellModelTypeSwitched             = "switched"
/// - edit: Cell中含有UITextField控件
let JSCellModelTypeEdit                 = "edit"

/******************************** CellModel 动作 ********************************/

typealias CellDidSelectHandler = ((_ tableView: UITableView, _ indexPath: IndexPath, _ model: JSCellModel) -> Void)?

typealias SwitchValueChangeHandler = ((_ switcher: UISwitch, _ on: Bool, _ model: JSCellModel) -> Void)?
