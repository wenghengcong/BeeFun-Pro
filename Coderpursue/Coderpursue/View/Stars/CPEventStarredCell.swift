//
//  CPEventStarredCell.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/5/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit
import SwiftDate

class CPEventStarredCell: CPEventBaseCell {

    @IBOutlet weak var reposBtn: UIButton!

    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func eventCell_customView() {
        
    }
    
    override func eventCell_fillData() {
        
        reposBtn.setTitle(event?.repo?.name, for:UIControlState())
        
        let updateAt:Date = event!.created_at!.toDate(format:DateFormat.iso8601Format(.full))!
        timeLabel.text = updateAt.toString(style: .colloquial)

    }
    
}
