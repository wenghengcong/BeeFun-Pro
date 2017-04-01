//
//  CPEventBaseCell.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/6/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

class CPEventBaseCell: CPBaseViewCell {

    var event:ObjEvent? {
        
        didSet {
            eventCell_fillData()
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        eventCell_customView()
    }
    
    func eventCell_customView() {
        
    }
    
    func eventCell_fillData() {
        
    }
    
    func clickReposButton() {
        if event != nil {
            //name = zixun/GodEye
            //拆分为owner.name:zixun
            //name:GodEye
            let subs = event?.repo?.name?.components(separatedBy: "/")
            
            if event?.repo?.owner == nil && subs?.count == 2 {
                let owner = ObjUser()
                owner.login = subs?[0]
                owner.name = owner.login
                event?.repo?.name = subs?[1]
                event?.repo?.owner = owner
            }
            JumpManager.jumpReposDetailView(repos: event?.repo)
        }
    }
    
}
