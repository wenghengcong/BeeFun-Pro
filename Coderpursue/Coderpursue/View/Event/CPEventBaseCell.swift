//
//  CPEventBaseCell.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/6/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

class CPEventBaseCell: CPBaseViewCell {

    var event:ObjEvent? {
        
        didSet {
            eventCell_fillData()
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        eventCell_customView()
    }
    
    func eventCell_customView() {
        
    }
    
    func eventCell_fillData() {
        
    }
    
}
