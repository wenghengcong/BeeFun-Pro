
//
//  CPEventCreateCell.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/6/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit
import SwiftDate

class CPEventCreateCell: CPEventBaseCell {

    @IBOutlet weak var typeImageV: UIImageView!
    
    @IBOutlet weak var createLabel: UILabel!

    @IBOutlet weak var typeValBtn: UIButton!
    
    @IBOutlet weak var inLabel: UILabel!
    
    @IBOutlet weak var reposNameBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    let leftPad:CGFloat = 10
    let rightPad:CGFloat = 10
    
    override func eventCell_customView() {
//        createLabel.backgroundColor = UIColor.orangeColor()
//        typeValBtn.backgroundColor = UIColor.blueColor()
//        reposNameBtn.backgroundColor = UIColor.purpleColor()
    }
    
    override func eventCell_fillData() {
        
        
        let imgName = "coticon_"+event!.payload!.ref_type!+"_25"
        typeImageV.image = UIImage(named: imgName)
        
        let createStr = "create " + event!.payload!.ref_type!
        createLabel.text = createStr
        
        let reposName = event!.repo!.name!
        reposNameBtn.setTitle(reposName, forState: .Normal)
        
        switch(event!.payload!.ref_type!) {
            
        case CreateEventType.CreateRepositoryEvent.rawValue:
            typeValBtn.hidden = true
            inLabel.hidden = true
            
            
        case CreateEventType.CreateBranchEvent.rawValue:
            typeValBtn.hidden = false
            let branchName = event!.payload!.ref!
            typeValBtn.setTitle(branchName, forState: .Normal)
            
            inLabel.hidden = false
            
        case CreateEventType.CreateTagEvent.rawValue:
            typeValBtn.hidden = false
            let tagName = event!.payload!.ref!
            typeValBtn.setTitle(tagName, forState: .Normal)

            inLabel.hidden = false

            
        default: break
            
            
        }
        //time
        let updateAt:NSDate = event!.created_at!.toDate(DateFormat.ISO8601)!
        timeLabel.text = updateAt.toRelativeString(abbreviated: false, maxUnits:1)!+" ago"

        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        
        let firstTop = 9
        let lalHeight = 16
        
        typeImageV.snp_remakeConstraints { (make) -> Void in
            
            make.size.equalTo(CGSize.init(width: 25, height: 25))
            make.leading.equalTo(10)
            make.top.equalTo(20)
        }
        
        createLabel.sizeToFit()
        createLabel.snp_remakeConstraints { (make) -> Void in
            
            make.leading.equalTo(typeImageV.snp_trailing).offset(8)
            make.top.equalTo(firstTop)
            make.width.equalTo(createLabel.width)
            make.height.equalTo(createLabel.height)
        }
        
        let typeValW = self.width-createLabel.right-rightPad
        
        typeValBtn.snp_remakeConstraints { (make) -> Void in
            make.leading.equalTo(createLabel.snp_trailing).offset(5)
            make.top.equalTo(firstTop)
            make.width.equalTo(typeValW)
            make.height.equalTo(lalHeight)
        }
        
        if(inLabel.hidden == true){
            
            let reposWidth = self.width-createLabel.left-rightPad;
            
            reposNameBtn.snp_remakeConstraints(closure: { (make) -> Void in
                make.leading.equalTo(createLabel.snp_leading)
                make.top.equalTo(createLabel.snp_bottom).offset(0)
                make.width.equalTo(reposWidth)
                make.height.equalTo(lalHeight)
            })
            
        }else{
            
            inLabel.snp_remakeConstraints(closure: { (make) -> Void in
                
                make.leading.equalTo(createLabel.snp_leading)
                make.top.equalTo(createLabel.snp_bottom).offset(0)
                make.width.equalTo(22)
                make.height.equalTo(lalHeight)
                
            })
            
            let reposWidth = self.width-inLabel.right-rightPad;
            
            reposNameBtn.snp_remakeConstraints(closure: { (make) -> Void in
                make.leading.equalTo(inLabel.snp_trailing).offset(5)
                make.top.equalTo(createLabel.snp_bottom).offset(0)
                make.width.equalTo(reposWidth)
                make.height.equalTo(lalHeight)
            })
            
        }
        
    }
    
}
