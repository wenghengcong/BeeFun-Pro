

//
//  CPEventPushCell.swift
//  BeeFun
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
        reposNameBtn.addTarget(self, action: #selector(clickReposButton), for: .touchUpInside)
    }
    
    override func eventCell_fillData() {
        
        let ref = event!.payload!.ref!
        let branchArr:Array = ref.components(separatedBy: "/")
        let branchName = branchArr.last
        branchBtn.setTitle(branchName!, for: UIControlState())
        
        let reposName = event!.repo!.name!
        reposNameBtn.setTitle(reposName, for: UIControlState())
        
        commits = event!.payload!.commits!
        let subViews = self.contentView.subviews
        for subview in subViews{
            if subview.tag >= 1000000 {
                subview.removeFromSuperview()
            }
        }
        commitLabels.removeAll()
        commitBtns.removeAll()
        
        for i  in 0...commits.count-1 {
            
            let commit:ObjCommit = commits[i]
            
            let shaBtn:UIButton = UIButton.init()
            let index = commit.sha!.characters.index(commit.sha!.startIndex, offsetBy: 6)
            let shaStr = commit.sha!.substring(to: index)+"-"
            shaBtn.tag = commitTag+i
            shaBtn.setTitle(shaStr, for: UIControlState())
            shaBtn.setTitleColor(UIColor.cpBlackColor, for: UIControlState())
            shaBtn.setTitleColor(UIColor.cpBlackColor, for: .highlighted)
            shaBtn.titleLabel!.font = UIFont.systemFont(ofSize: 15)
            shaBtn.titleLabel!.textAlignment = .left
//            shaBtn.backgroundColor = UIColor.orangeColor
            self.contentView.addSubview(shaBtn)
            commitBtns.append(shaBtn)
            
            let commitLabel:UILabel = UILabel.init()
            commitLabel.tag = commitTag+i
            commitLabel.text = commit.message
            commitLabel.font = UIFont.systemFont(ofSize: 15)
            commitLabel.textColor = UIColor.cpBlackColor
            self.contentView.addSubview(commitLabel)
            commitLabels.append(commitLabel)
            
        }

        //time

        timeLabel.text = TimeHelper.shared.readableTime(rare: event!.created_at!, prefix: nil)
    }

    override func layoutSubviews() {
        
        let btnW = 70
        let lalW = self.width-110-10
        
        for i in 0...commitBtns.count-1 {
            
            let commitBtn:UIButton = commitBtns[i]
            let commitLabel:UILabel = commitLabels[i]
            
            if (i == 0) {

                commitBtn.snp.makeConstraints({ (make) -> Void in
                    
                    make.leading.equalTo(atLabel.snp.leading)
                    make.top.equalTo(reposNameBtn.snp.bottom).offset(5)
                    make.width.equalTo(btnW)
                    make.height.equalTo(20)
                    
                })
                
                commitLabel.snp.makeConstraints({ (make) -> Void in
                    
                    make.leading.equalTo(commitBtn.snp.trailing).offset(0)
                    make.top.equalTo(commitBtn.snp.top)
                    make.width.equalTo(lalW)
                    make.height.equalTo(20)
                    
                })
                
            }else{
                
                let lastBtn:UIButton = commitBtns[i-1]
                
                commitLabel.sizeToFit()
                commitBtn.snp.makeConstraints({ (make) -> Void in
                    
                    make.leading.equalTo(lastBtn.snp.leading)
                    make.top.equalTo(lastBtn.snp.bottom).offset(0)
                    make.width.equalTo(btnW)
                    make.height.equalTo(20)
                    
                })
                
                commitLabel.snp.makeConstraints({ (make) -> Void in
                    
                    make.leading.equalTo(commitBtn.snp.trailing).offset(0)
                    make.top.equalTo(commitBtn.snp.top)
                    make.width.equalTo(lalW)
                    make.height.equalTo(20)
                    
                })
                
            }
            

        }
        
    }
    
}
