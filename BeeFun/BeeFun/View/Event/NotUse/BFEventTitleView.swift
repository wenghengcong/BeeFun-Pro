//
//  BFEventActionView.swift
//  BeeFun
//
//  Created by WengHengcong on 23/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import YYText
/*
    event title
    每个event的简短描述
 例如：
    aure commented on issue AudioKit/AudioKit#1053
    jldunk opened issue AudioKit/AudioKit#1054
    jcavar opened pull request ckrey/MQTT-Client-Framework#376
    jashkenas created repository jashkenas/lil-license
 */
class BFEventTitleView: UIView {

    //数据
    var cell: BFEventCell?
    var layout: BFEventLayout?

    var titleLabel: YYLabel = YYLabel()

    override init(frame: CGRect) {
        var newFrame = frame
        if frame.size.width == 0 && frame.size.height == 0 {
            newFrame.size.width = BFEventConstants.TITLE_W
            newFrame.size.height = 1
        }
        super.init(frame: newFrame)
        isUserInteractionEnabled = true

        titleLabel.size = CGSize(width: self.width, height: self.height)
        titleLabel.displaysAsynchronously = true
        titleLabel.ignoreCommonProperties = true
        titleLabel.fadeOnAsynchronouslyDisplay = false
        titleLabel.fadeOnHighlight = false
        titleLabel.numberOfLines = 0
        self.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout(layout: BFEventLayout) {
        self.layout = layout
//        titleLabel.layer.contents = nil
        titleLabel.height = self.layout!.titleHeight
        titleLabel.textLayout = self.layout?.titleLayout
//        titleLabel.attributedText = layout.titleAttreText
    }
}
