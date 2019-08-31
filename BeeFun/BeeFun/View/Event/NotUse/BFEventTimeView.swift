//
//  BFEventTimeView.swift
//  BeeFun
//
//  Created by WengHengcong on 23/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import YYText

class BFEventTimeView: UIView {

    var timeLabel: YYLabel = YYLabel()
    //数据
    var cell: BFEventCell?
    var layout: BFEventLayout?

    override init(frame: CGRect) {
        var newFrame = frame
        if frame.size.width == 0 && frame.size.height == 0 {
            newFrame.size.width = BFEventConstants.TIME_W
            newFrame.size.height = 1
        }
        super.init(frame: newFrame)
        isUserInteractionEnabled = true
        timeLabel.size = CGSize(width: self.width, height: self.height)
        timeLabel.ignoreCommonProperties = true
        timeLabel.displaysAsynchronously = true
        timeLabel.fadeOnAsynchronouslyDisplay = false
        timeLabel.fadeOnHighlight = false
        self.addSubview(timeLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout(layout: BFEventLayout) {
        self.layout = layout
        timeLabel.layer.contents = nil
        timeLabel.height = self.layout!.timeHeight
        timeLabel.textLayout = self.layout?.timeLayout
    }    
}
