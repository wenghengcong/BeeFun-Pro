//
//  JSHMSegmentedControlBridge.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/3/28.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit
import HMSegmentedControl

class JSHMSegmentedBridge: NSObject {

    class func segmentControl(titles: [String]) -> HMSegmentedControl! {

        let segControl = HMSegmentedControl(sectionTitles: titles)!
        segControl.frame = CGRect(x: 0, y: uiTopBarHeight, width: ScreenSize.width, height: 35)
        segControl.verticalDividerColor = UIColor.bfLineBackgroundColor
        segControl.verticalDividerWidth = 0.5
//        segControl.isVerticalDividerEnabled = true
        segControl.selectionStyle = HMSegmentedControlSelectionStyle.fullWidthStripe
        segControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.down
        segControl.selectionIndicatorColor = UIColor.bfRedColor
        segControl.selectionIndicatorHeight = 1
        segControl.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.iOS11Black, NSAttributedString.Key.font: UIFont.middleSizeSystemFont()]
        segControl.selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.bfRedColor, NSAttributedString.Key.font: UIFont.middleSizeSystemFont()]

        return segControl
    }
    
    class func segmentControl() -> HMSegmentedControl! {
        
        let segControl = HMSegmentedControl()
        segControl.verticalDividerColor = UIColor.bfLineBackgroundColor
        segControl.segmentWidthStyle = .dynamic
        segControl.verticalDividerWidth = 0.5
//        segControl.isVerticalDividerEnabled = true
        segControl.segmentEdgeInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        segControl.selectionStyle = .fullWidthStripe
        segControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.down
        segControl.selectionIndicatorColor = UIColor.bfRedColor
        segControl.selectionIndicatorHeight = 1
        segControl.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.iOS11Black, NSAttributedString.Key.font: UIFont.middleSizeSystemFont()]
        segControl.selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.bfRedColor, NSAttributedString.Key.font: UIFont.middleSizeSystemFont()]
        
        return segControl
    }
}
