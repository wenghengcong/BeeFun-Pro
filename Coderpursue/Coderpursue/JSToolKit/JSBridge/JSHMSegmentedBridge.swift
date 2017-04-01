//
//  JSHMSegmentedControlBridge.swift
//  Coderpursue
//
//  Created by WengHengcong on 2017/3/28.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit
import HMSegmentedControl

class JSHMSegmentedBridge: NSObject {
    
    class func segmentControl(titles:[String]) -> HMSegmentedControl!{
        
        let segControl = HMSegmentedControl.init(sectionTitles: titles)!
        segControl.frame = CGRect.init(x: 0, y: uiTopBarHeight, width: ScreenSize.width, height: 35)
        segControl.verticalDividerColor = UIColor.lineBackgroundColor
        segControl.verticalDividerWidth = 0.5
        segControl.isVerticalDividerEnabled = true
        segControl.selectionStyle = HMSegmentedControlSelectionStyle.fullWidthStripe
        segControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.down
        segControl.selectionIndicatorColor = UIColor.cpRedColor
        segControl.selectionIndicatorHeight = 1
        segControl.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.labelTitleTextColor,NSFontAttributeName:UIFont.middleSizeSystemFont()];
        segControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName : UIColor.cpRedColor,NSFontAttributeName:UIFont.middleSizeSystemFont()];
        
        return segControl
    }
}
