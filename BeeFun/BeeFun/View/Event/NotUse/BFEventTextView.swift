//
//  BFEventActionContentView.swift
//  BeeFun
//
//  Created by WengHengcong on 23/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import YYText

/*
 每个event payload中的具体内容
 例如：
 
 */
class BFEventTextView: UIView {

    //数据
    var cell: BFEventCell?
    var layout: BFEventLayout?

    var textLabel: YYLabel = YYLabel()
    
    override init(frame: CGRect) {
        var newFrame = frame
        if frame.size.width == 0 && frame.size.height == 0 {
            newFrame.size.width = BFEventConstants.TEXT_W
            newFrame.size.height = 1
        }
        super.init(frame: newFrame)
        isUserInteractionEnabled = true

        textLabel.size = CGSize(width: self.width, height: self.height)
        textLabel.displaysAsynchronously = true
        textLabel.ignoreCommonProperties = true
        textLabel.fadeOnAsynchronouslyDisplay = false
        textLabel.fadeOnHighlight = false
        textLabel.numberOfLines = 3
        self.addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout(layout: BFEventLayout) {
        self.layout = layout
//        textLabel.layer.contents = nil
        textLabel.height = self.layout!.textHeight
        textLabel.textLayout = self.layout?.textLayout
    }

}
