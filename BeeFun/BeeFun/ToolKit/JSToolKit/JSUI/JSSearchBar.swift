//
//  JSSearchBar.swift
//  BeeFun
//
//  Created by WengHengcong on 13/10/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit

class JSSearchBar: UISearchBar {

    /// 保留iOS 11 之前的风格
    var keepBeforeStyle: Bool? {
        didSet {
            if keepBeforeStyle! {
                self.heightAnchor.constraint(equalToConstant: uiNavigationBarHeight).isActive = true
                contentInset = UIEdgeInsets(top: 3, left: 0, bottom: 3, right: -4)
            } else {
                self.heightAnchor.constraint(equalToConstant: 56).isActive = true
                contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
        }
    }
    
    var contentInset: UIEdgeInsets? {
        didSet {
            self.layoutSubviews()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // view是searchBar中的唯一的直接子控件
        for view in self.subviews {
            // UISearchBarBackground与UISearchBarTextField是searchBar的简介子控件
            for subview in view.subviews {
                // 找到UISearchBarTextField
                if subview.isKind(of: UITextField.classForCoder()) {
                    if let textFieldContentInset = contentInset { // 若contentInset被赋值
                        // 根据contentInset改变UISearchBarTextField的布局
                        let x = subview.x + textFieldContentInset.left
                        let y = subview.y + textFieldContentInset.top
                        let w = subview.width - textFieldContentInset.left - textFieldContentInset.right
                        let h = subview.height - textFieldContentInset.top - textFieldContentInset.bottom
                        
                        subview.frame = CGRect(x: x, y: y, width: w, height: h)
                    }
//                    else { // 若contentSet未被赋值
//                        // 设置UISearchBar中UISearchBarTextField的默认边距
//                        let top: CGFloat = (self.bounds.height - 28.0) / 2.0
//                        let bottom: CGFloat = top
//                        let left: CGFloat = 8.0
//                        let right: CGFloat = left
//                        contentInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
//                    }
                }
            }
        }
    }
}
