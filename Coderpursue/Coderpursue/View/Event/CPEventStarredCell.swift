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
        reposBtn.addTarget(self, action: #selector(clickReposButton), for: .touchUpInside)
    }
    
    override func eventCell_fillData() {
        
        reposBtn.setTitle(event?.repo?.name, for:UIControlState())
        timeLabel.text = TimeHelper.shared.readableTime(rare: event!.created_at, prefix: nil)

    }
    
}
