
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
        reposNameBtn.setTitle(reposName, for: UIControlState())
        
        switch(event!.payload!.ref_type!) {
            
        case CreateEventType.CreateRepositoryEvent.rawValue:
            typeValBtn.isHidden = true
            inLabel.isHidden = true
            
            
        case CreateEventType.CreateBranchEvent.rawValue:
            typeValBtn.isHidden = false
            let branchName = event!.payload!.ref!
            typeValBtn.setTitle(branchName, for: UIControlState())
            
            inLabel.isHidden = false
            
        case CreateEventType.CreateTagEvent.rawValue:
            typeValBtn.isHidden = false
            let tagName = event!.payload!.ref!
            typeValBtn.setTitle(tagName, for: UIControlState())

            inLabel.isHidden = false

            
        default: break
            
            
        }
        //time
        let updateAt:Date = event!.created_at!.toDate(format:DateFormat.iso8601Format(.full))!
        timeLabel.text = updateAt.toString(style: .colloquial)

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
        
        if(inLabel.isHidden == true){
            
            let reposWidth = self.width-createLabel.left-rightPad;
            
            reposNameBtn.snp_remakeConstraints({ (make) -> Void in
                make.leading.equalTo(createLabel.snp_leading)
                make.top.equalTo(createLabel.snp_bottom).offset(0)
                make.width.equalTo(reposWidth)
                make.height.equalTo(lalHeight)
            })
            
        }else{
            
            inLabel.snp_remakeConstraints({ (make) -> Void in
                
                make.leading.equalTo(createLabel.snp_leading)
                make.top.equalTo(createLabel.snp_bottom).offset(0)
                make.width.equalTo(22)
                make.height.equalTo(lalHeight)
                
            })
            
            let reposWidth = self.width-inLabel.right-rightPad;
            
            reposNameBtn.snp_remakeConstraints({ (make) -> Void in
                make.leading.equalTo(inLabel.snp_trailing).offset(5)
                make.top.equalTo(createLabel.snp_bottom).offset(0)
                make.width.equalTo(reposWidth)
                make.height.equalTo(lalHeight)
            })
            
        }
        
    }
    
}
