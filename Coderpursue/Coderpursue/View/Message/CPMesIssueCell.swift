//
//  CPMesIssueCell.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/7/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit
import SwiftDate

class CPMesIssueCell: CPBaseViewCell {

    
    @IBOutlet weak var issueTitleBtn: UIButton!
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var reposNameLabel: UILabel!
    
    @IBOutlet weak var stateLabel: UILabel!
    
    @IBOutlet weak var assignLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    var issue:ObjIssue? {
        
        didSet {
            notiCell_fillData()
        }
    }
    
    
    override func customCellView() {
        
//        numberLabel.textColor = UIColor.labelSubtitleTextColor()
        reposNameLabel.textColor = UIColor.labelSubtitleTextColor()
        stateLabel.textColor = UIColor.labelSubtitleTextColor()
        assignLabel.textColor = UIColor.labelSubtitleTextColor()
        timeLabel.textColor = UIColor.labelSubtitleTextColor()

    }
    
    func notiCell_fillData() {
        
        let issueTitle = issue!.title
        issueTitleBtn.setTitle(issueTitle, forState: .Normal)
        
        let issueNum = "#\(issue!.number!)"
        numberLabel.text = issueNum
        
        let reposName = issue!.repository!.name
        reposNameLabel.text = reposName
        
        let issueState = issue!.state
        stateLabel.text = issueState
        
        if(issue!.assignee == nil){
            assignLabel.text = "unassignned"
        }else{
            assignLabel.text = issue!.assignee!.login
        }
        
        //time
        let updateAt:NSDate = issue!.created_at!.toDate(DateFormat.ISO8601)!
        timeLabel.text = updateAt.toRelativeString(abbreviated: false, maxUnits:1)!+" ago"
        
    }


}
