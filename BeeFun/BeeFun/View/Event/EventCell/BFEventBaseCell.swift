//
//  BFEventBaseCell.swift
//  BeeFun
//
//  Created by WengHengcong on 23/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit

class BFEventBaseCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        for view in self.subviews where view.isKind(of: UIScrollView.self) {
//            let scroll = view as? UIScrollView
//            scroll?.canCancelContentTouches = true
//            scroll?.delaysContentTouches = false
//            break
//        }
        selectionStyle = .none
        backgroundView?.backgroundColor = .clear
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
