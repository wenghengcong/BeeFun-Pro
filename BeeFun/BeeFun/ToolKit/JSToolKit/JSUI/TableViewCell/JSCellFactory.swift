//
//  JSCellFactory.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/5/4.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

class JSCellFactory: NSObject {
    /// cell 类型与类的字典
    static var cellMap: [String:String]?
    
    /// 注册类
    class func registerCellInfo() {
        registCell("label", cellClass: "JSLabelCell")
        registCell("sublabel", cellClass: "JSSubLabelCell")
        registCell("image", cellClass: "JSImageCell")
        registCell("selected", cellClass: "JSSelectedCell")
        registCell("switched", cellClass: "JSSwitchCell")
        registCell("edit", cellClass: "JSEditCell")
    }
    
    /// 注册对应类与类型
    class func registCell(_ type: String?, cellClass: String?) {
        assert(type != nil, "type is nil")
        assert(cellClass != nil, "identifier is nil")
        if cellMap == nil {
            cellMap = [type!: cellClass!]
        } else {
            cellMap![type!] = cellClass!
        }
    }
    
    /// 返回对应type的Cell Class
    class func cell(type: String) -> AnyObject? {
        if cellMap == nil {
            return UITableViewCell()
        }

        if let cellClassName = cellMap![type] {
            var cellClass = JSBaseCell.cellFromNibNamed(cellClassName)
            switch cellClassName {
            case "JSLabelCell":
                cellClass = JSLabelCell.cellFromNibNamed(cellClassName)
            case "JSImageCell":
                cellClass = JSImageCell.cellFromNibNamed(cellClassName)
            case "JSSelectedCell":
                cellClass = JSSelectedCell.cellFromNibNamed(cellClassName)
            case "JSSwitchCell":
                cellClass = JSSwitchCell.cellFromNibNamed(cellClassName)
            case "JSEditCell":
                cellClass = JSEditCell.cellFromNib(name: cellClassName)
            default:
                break
            }
            return cellClass
        } else {
            assertionFailure("Cell key has not register")
        }
        return UITableViewCell()
    }
    
    /// 返回对应type的Cell Class String
    class func cellClass(type: String) -> String {
        if cellMap == nil {
            return ""
        }
        
        if let cellClassName = cellMap![type] {
            return cellClassName
        } else {
            assertionFailure("Cell key has not register")
        }
        return ""

    }
}
