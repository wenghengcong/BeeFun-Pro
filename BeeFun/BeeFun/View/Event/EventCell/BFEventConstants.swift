//
//  BFEventConstants.swift
//  BeeFun
//
//  Created by WengHengcong on 23/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit


/// 以下使用top\left\right\bottom即为该控件的margin
/// 使用x\y\w\h即该空间的大小位置
class BFEventConstants {
   
    //action image
    static let ACTION_IMG_TOP: CGFloat = 8
    static let ACTION_IMG_LEFT: CGFloat = 8
    static let ACTION_IMG_RIGHT: CGFloat = 5
    static let ACTION_IMG_BOTTOM: CGFloat = 5
    static let ACTION_IMG_WIDTH: CGFloat = 25
    
    //Time
    static let TIME_X = BFEventConstants.ACTION_IMG_LEFT + BFEventConstants.ACTION_IMG_WIDTH + BFEventConstants.ACTION_IMG_RIGHT
    static let TIME_Y: CGFloat = 2
    static let TIME_W: CGFloat = ScreenSize.width - TIME_X
    static let TIME_FONT_SIZE: CGFloat = 13.0
    
    //title
    static let TITLE_X: CGFloat = TIME_X
    static let TITLE_W: CGFloat = TIME_W
    static let TITLE_FONT_SIZE: CGFloat = 14.0

    //----->>>>>> 下面是针对action contentView ，而不是针对整个cell <<<<<<------
    //注意在设置时，对齐time的左边距与上边距
    static let ACTION_CONTENT_WIDTH = TIME_W
    
    //actor iamge
    static let ACTOR_IMG_TOP: CGFloat = 3
    static let ACTOR_IMG_LEFT: CGFloat =  0
    static let ACTOR_IMG_RIGHT: CGFloat = 5
    static let ACTOR_IMG_BOTTOM: CGFloat = 5
    static let ACTOR_IMG_WIDTH: CGFloat = 20
    
    //text
    static let TEXT_X: CGFloat = ACTOR_IMG_LEFT + ACTOR_IMG_WIDTH + ACTOR_IMG_RIGHT
    static let TEXT_Y: CGFloat = 3
    static let TEXT_W: CGFloat = ACTION_CONTENT_WIDTH - TEXT_X
    static let TEXT_FONT_SIZE: CGFloat = 14.0
    
    //pull request detil
    static let PRDETAIL_X: CGFloat = TEXT_X
    static let PRDETAIL_Y: CGFloat = TEXT_Y
    static let PRDETAIL_W: CGFloat = TEXT_W
    static let PRDETAIL_FONT_SIZE: CGFloat = 14.0
    
    //commit
    static let COMMIT_X: CGFloat = TEXT_X
    static let COMMIT_Y: CGFloat = TEXT_Y
    static let COMMIT_W: CGFloat = TEXT_W
    static let COMMIT_FONT_SIZE: CGFloat = 14.0
    
}
