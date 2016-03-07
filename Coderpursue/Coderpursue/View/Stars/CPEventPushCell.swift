

//
//  CPEventPushCell.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/6/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit
import SwiftDate

class CPEventPushCell: CPEventBaseCell {

    @IBOutlet weak var typeImageV: UIImageView!
    
    @IBOutlet weak var pushToLabel: UILabel!
    
    @IBOutlet weak var branchBtn: UIButton!
    
    @IBOutlet weak var atLabel: UILabel!
    
    @IBOutlet weak var reposNameBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    let leftPad:CGFloat = 10
    let rightPad:CGFloat = 10
    var commits:[ObjCommit] = [ObjCommit]()
    var commitLabels:[UILabel] = [UILabel]()
    var commitBtns:[UIButton] = [UIButton]()
    
    var commitTag = 1000000
    
    override func eventCell_customView() {
        
    }
    
    override func eventCell_fillData() {
        
        let ref = event!.payload!.ref!
        let branchArr:Array = ref.componentsSeparatedByString("/")
        let branchName = branchArr.last
        branchBtn.setTitle(branchName!, forState: .Normal)
        
        let reposName = event!.repo!.name!
        reposNameBtn.setTitle(reposName, forState: .Normal)
        
        commits = event!.payload!.commits!
        let subViews = self.contentView.subviews
        for subview in subViews{
            if subview.tag >= 1000000 {
                subview.removeFromSuperview()
            }
        }
        commitLabels.removeAll()
        commitBtns.removeAll()
        
        for (var index = 0 ;index < commits.count; index++) {
            
            let commit:ObjCommit = commits[index]
            
            let shaBtn:UIButton = UIButton.init()
            let index = commit.sha!.startIndex.advancedBy(6)
            let shaStr = commit.sha!.substringToIndex(index)+"-"
            shaBtn.tag = commitTag++
            shaBtn.setTitle(shaStr, forState: .Normal)
            shaBtn.setTitleColor(UIColor.cpBlackColor(), forState: .Normal)
            shaBtn.setTitleColor(UIColor.cpBlackColor(), forState: .Highlighted)
            shaBtn.titleLabel!.font = UIFont.systemFontOfSize(15)
            shaBtn.titleLabel!.textAlignment = .Left
//            shaBtn.backgroundColor = UIColor.orangeColor()
            self.contentView.addSubview(shaBtn)
            commitBtns.append(shaBtn)
            
            let commitLabel:UILabel = UILabel.init()
            commitLabel.tag = commitTag++
            commitLabel.text = commit.message
            commitLabel.font = UIFont.systemFontOfSize(15)
            commitLabel.textColor = UIColor.cpBlackColor()
            self.contentView.addSubview(commitLabel)
            commitLabels.append(commitLabel)
            
        }

        //time
        let updateAt:NSDate = event!.created_at!.toDate(DateFormat.ISO8601)!
        timeLabel.text = updateAt.toRelativeString(abbreviated: false, maxUnits:1)!+" ago"
        
    }

    override func layoutSubviews() {
        
        let btnW = 70
        let lalW = self.width-110-10
        
        for (var index = 0 ;index < commitBtns.count; index++) {
            
            let commitBtn:UIButton = commitBtns[index]
            let commitLabel:UILabel = commitLabels[index]
            
            if (index == 0) {

                commitBtn.snp_makeConstraints(closure: { (make) -> Void in
                    
                    make.leading.equalTo(atLabel.snp_leading)
                    make.top.equalTo(reposNameBtn.snp_bottom).offset(5)
                    make.width.equalTo(btnW)
                    make.height.equalTo(20)
                    
                })
                
                commitLabel.snp_makeConstraints(closure: { (make) -> Void in
                    
                    make.leading.equalTo(commitBtn.snp_trailing).offset(0)
                    make.top.equalTo(commitBtn.snp_top)
                    make.width.equalTo(lalW)
                    make.height.equalTo(20)
                    
                })
                
            }else{
                
                let lastBtn:UIButton = commitBtns[index-1]
                
                commitLabel.sizeToFit()
                commitBtn.snp_makeConstraints(closure: { (make) -> Void in
                    
                    make.leading.equalTo(lastBtn.snp_leading)
                    make.top.equalTo(lastBtn.snp_bottom).offset(0)
                    make.width.equalTo(btnW)
                    make.height.equalTo(20)
                    
                })
                
                commitLabel.snp_makeConstraints(closure: { (make) -> Void in
                    
                    make.leading.equalTo(commitBtn.snp_trailing).offset(0)
                    make.top.equalTo(commitBtn.snp_top)
                    make.width.equalTo(lalW)
                    make.height.equalTo(20)
                    
                })
                
            }
            

        }
        
    }
    
}
