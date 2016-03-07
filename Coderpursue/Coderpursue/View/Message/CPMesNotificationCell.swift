//
//  CPMesNotificationCell.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/7/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit
import SwiftDate

class CPMesNotificationCell: CPBaseViewCell {

    @IBOutlet weak var typeImageV: UIImageView!
    
    @IBOutlet weak var notificationLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var reposBtn: UIButton!
    
    var noti:ObjNotification? {
        
        didSet {
            notiCell_fillData()
        }
    }
    
    
    override func customCellView() {
        
    }
    
    func notiCell_fillData() {
        
        let notiType:SubjectType = SubjectType( rawValue: (noti!.subject!.type!) )!
        
        switch(notiType) {
        case .Issue:
            typeImageV.image = UIImage(named:"octicon_issue_25")
        case .PullRequest:
            typeImageV.image = UIImage(named:"octicon_pull_request_25")
        }
        
        notificationLabel.text = noti!.subject!.title
        reposBtn.setTitle(noti!.repository!.name, forState: .Normal)
        
        //time
        let updateAt:NSDate = noti!.updated_at!.toDate(DateFormat.ISO8601)!
        timeLabel.text = updateAt.toRelativeString(abbreviated: false, maxUnits:1)!+" ago"
    }
    

}
