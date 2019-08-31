//
//  BFEventCommitView.swift
//  BeeFun
//
//  Created by WengHengcong on 23/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import YYText

/*
  user pushed to repos
  ╭┈┈┈╮
  |   | 76027aa Merge pull request #489 from ahstro/patch-1
  ╰┈┈┈╯
 
 说明：
    ╭┈┈┈╮
    |   |          76027aa          Merge pull request #489 from ahstro/patch-1
    ╰┈┈┈╯
  user avatar      commit hash      commit conent
 
 */
// 以上由于头像图不好拿，故略去
class BFEventCommitView: UIView {

    //数据
    var cell: BFEventCell?
    var layout: BFEventLayout?

    var commitLabel: YYLabel = YYLabel()
    
    override init(frame: CGRect) {
        var newFrame = frame
        if frame.size.width == 0 && frame.size.height == 0 {
            newFrame.size.width = BFEventConstants.PRDETAIL_W
            newFrame.size.height = 1
        }
        super.init(frame: newFrame)
        isUserInteractionEnabled = true

        commitLabel.size = CGSize(width: self.width, height: self.height)
//        commitLabel.backgroundColor = UIColor.hex("#eaf5ff")
        commitLabel.numberOfLines = 1

        commitLabel.displaysAsynchronously = true
        commitLabel.ignoreCommonProperties = true
        commitLabel.fadeOnAsynchronouslyDisplay = false
        commitLabel.fadeOnHighlight = false
        self.addSubview(commitLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout(layout: BFEventLayout) {
        self.layout = layout
//        commitLabel.layer.contents = nil
        commitLabel.height = self.layout!.commitHeight
        commitLabel.textLayout = self.layout?.commitLayout
    }
}
