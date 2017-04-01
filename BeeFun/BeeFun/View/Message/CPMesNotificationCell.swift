//
//  CPMesNotificationCell.swift
//  BeeFun
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
  
        //test 
        //if you want to change position or size by set frame property,you first disable autolayout.
//        typeImageV.frame = CGRectMake(50, 10, 44, 44);

    }
    
    func notiCell_fillData() {
        
        
        if let type = noti?.subject?.type {
            
            let notiType:SubjectType? = SubjectType( rawValue:type )
            
            if notiType != nil {
                typeImageV.isHidden = false
                
                switch(notiType!) {
                case .Issue:
                    typeImageV.image = UIImage(named:"octicon_issue_25")
                case .PullRequest:
                    typeImageV.image = UIImage(named:"octicon_pull_request_25")
                case .Release:
                    typeImageV.image = UIImage(named:"coticon_tag_25")
                case .Commit:
                    typeImageV.image = UIImage(named:"octicon_commit_25")
                }
            }else{
                typeImageV.isHidden = true
            }
            

        }

        if let title = noti?.subject?.title{
            notificationLabel.text = title
        }
        
        if let name = noti?.repository?.name{
            reposBtn.setTitle(name, for: UIControlState())
        }
        
        if let time = noti?.updated_at {
            //time
            timeLabel.text = TimeHelper.shared.readableTime(rare: time, prefix: nil)

        }
        

    }
    

}
