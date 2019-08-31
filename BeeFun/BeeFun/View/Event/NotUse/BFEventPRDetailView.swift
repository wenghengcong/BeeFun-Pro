//
//  BFEventCommitDetailView.swift
//  BeeFun
//
//  Created by WengHengcong on 23/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import YYText
/*
 
 在opened pull request时，会有这个pull request详情
 
 ------------------------------------------------
 | -0- 1 commit with 1 addition and 0 deletions |
 ------------------------------------------------
 */
class BFEventPRDetailView: UIView {

    //数据
    var cell: BFEventCell?
    var layout: BFEventLayout?

    var detailLabel: YYLabel = YYLabel()

    override init(frame: CGRect) {
        var newFrame = frame
        if frame.size.width == 0 && frame.size.height == 0 {
            newFrame.size.width = BFEventConstants.PRDETAIL_W
            newFrame.size.height = 1
        }
        super.init(frame: newFrame)
        isUserInteractionEnabled = true

        detailLabel.size = CGSize(width: self.width, height: self.height)
        detailLabel.backgroundColor = UIColor.hex("#eaf5ff")
        detailLabel.numberOfLines = 1
        detailLabel.displaysAsynchronously = true
        detailLabel.ignoreCommonProperties = true
        detailLabel.fadeOnAsynchronouslyDisplay = false
        detailLabel.fadeOnHighlight = false
        self.addSubview(detailLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout(layout: BFEventLayout) {
        self.layout = layout
//        detailLabel.layer.contents = nil
        detailLabel.width = self.layout!.prDetailWidth
        detailLabel.height = self.layout!.prDetailHeight
        detailLabel.textLayout = self.layout?.prDetailLayout
    }

}
