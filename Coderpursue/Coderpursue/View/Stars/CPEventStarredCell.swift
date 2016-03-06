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
        
        reposBtn.setTitle(event?.repo?.name, forState:.Normal)
        
        let updateAt:NSDate = event!.created_at!.toDate(DateFormat.ISO8601)!
        timeLabel.text = updateAt.toRelativeString(abbreviated: false, maxUnits:1)!+" ago"

    }
    
}
