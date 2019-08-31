//
//  BFEventView.swift
//  BeeFun
//
//  Created by WengHengcong on 23/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit

/*
 
 event类型1：pull request类型
 
    5 days ago
    ashfurrow opened pull request AFNetworking/AFNetworking#4051
     ╭┈┈┈╮      Exposes C function prototype
     |   |      ------------------------------------------------
     ╰┈┈┈╯      | -0- 1 commit with 1 addition and 0 deletions |
                ------------------------------------------------
 
 */

/*
 
 event类型2：push commit、release类型

 --->>>>>>>> push类型
    4 days ago
    davemachado pushed to master at toddmotto/public-apis
     ╭┈┈┈╮    ╭-╮ 2f9b6f0    Merge pull request #486 from DustyReagan/countio
     |   |    ╰—╯
     ╰┈┈┈╯    ╭-╮ 4e79d6d    Remove '... API' from Description
              ╰—╯
                View comparison for these 2 commits » or
                15 more commits »
 
    注意：后面有两种类型，一种是查看这两个commit的对比，一个是查看更多的commit
 
 --->>>>>>>> release类型
     4 days ago
     davemachado pushed to master at toddmotto/public-apis
     ╭┈┈┈╮    ╭-╮  Source code (zip)
     |   |    ╰—╯
     ╰┈┈┈╯
     注意：点击source code中直接下载zip文件
 */

/*
 
 event类型3：opened issue、commented on issue 等类型
 
    5 days ago
    ashfurrow opened pull request AFNetworking/AFNetworking#4051
     ╭┈┈┈╮
     |   |  Format string warnings
     ╰┈┈┈╯
 
 */

/*
 
 event类型4：starred、forked等类型
    5 days ago
    Bogdan-Lyashenko starred byoungd/english-level-up-tips-for-Chinese
 
 */
class BFEventView: UIView {
    
    var contentView: UIView = UIView()          ///整个视图的容器
    
    /// event 左上角的Action 图标，固定
    var actionImageView = UIImageView()
    var timeView: BFEventTimeView?              /// 时间
    var titleView: BFEventTitleView?            /// title
    
    /// 内容区域
    var actionContentView = UIView()            /// 内容区域的容器
    var actorImageView = UIImageView()          /// event 执行者头像
    var textView: BFEventTextView?              /// 内容，见类型1、3、4部分的文字内容区域
    var prDetailView: BFEventPRDetailView?      /// pull request的部分内容区域，见类型1
    var commitView: BFEventCommitView?          /// push commit的内容区域，见类型2
    
    var topLine: UIView = UIView()
    var bottomLine: UIView = UIView()
    
    //数据
    var cell: BFEventCell?
    var layout: BFEventLayout?
    
    override init(frame: CGRect) {
        var newFrame = frame
        if frame.size.width == 0 && frame.size.height == 0 {
            newFrame.size.width = ScreenSize.width
            newFrame.size.height = 1
        }
        super.init(frame: newFrame)
        
        isUserInteractionEnabled = true
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.isUserInteractionEnabled = true
        contentView.width = ScreenSize.width
        contentView.height = 1.0
        self.addSubview(contentView)
        
        //line 
        let retinaPixelSize = 1.0 / (UIScreen.main.scale)
        topLine.backgroundColor = UIColor.bfLineBackgroundColor
        topLine.frame = CGRect(x: 0, y: 0, w: self.width, h: retinaPixelSize)
        contentView.addSubview(topLine)
        
        bottomLine.backgroundColor = UIColor.bfLineBackgroundColor
        bottomLine.frame = CGRect(x: 0, y: self.height-retinaPixelSize, w: self.width, h: retinaPixelSize)
        contentView.addSubview(bottomLine)
        
        //action image name
        actionImageView.frame = CGRect(x: BFEventConstants.ACTION_IMG_LEFT, y: BFEventConstants.ACTION_IMG_TOP, w: BFEventConstants.ACTION_IMG_WIDTH, h: BFEventConstants.ACTION_IMG_WIDTH)
//        actionImageView.isHidden = true
        actionImageView.image = UIImage(named: "git-comment-discussion_50")
        actionImageView.isUserInteractionEnabled = true
        contentView.addSubview(actionImageView)

        //time
        timeView = BFEventTimeView()
//        timeView?.isHidden = true
        contentView.addSubview(timeView!)
        
        //title
        titleView = BFEventTitleView()
//        titleView?.isHidden = true
        contentView.addSubview(titleView!)
        
        //内容区域
        actionContentView.backgroundColor = .clear
        actionContentView.isUserInteractionEnabled = true
//        actionContentView.isHidden = true
        contentView.addSubview(actionContentView)
        
        //actor image view
        actorImageView.frame = CGRect(x: 0, y: 0, w: BFEventConstants.ACTOR_IMG_WIDTH, h: BFEventConstants.ACTOR_IMG_WIDTH)
        actorImageView.isHidden = true
        actionContentView.addSubview(actorImageView)
        
        //text view
        textView = BFEventTextView()
        textView?.isHidden = true
        actionContentView.addSubview(textView!)
        
        //pull request detail view
        prDetailView = BFEventPRDetailView()
        prDetailView?.isHidden = true
        actionContentView.addSubview(prDetailView!)
        
        //commit view
        commitView = BFEventCommitView()
        commitView?.isHidden = true
        actionContentView.addSubview(commitView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout(layout: BFEventLayout) {
        
        self.layout = layout
        //contnet view的位置
        contentView.top = layout.marginTop
        contentView.height = layout.totalHeight - layout.marginTop - layout.marginBottom
        contentView.left = layout.marginLeft
        contentView.right = ScreenSize.width - layout.marginLeft
        
        //action image
        if let actionImageName = layout.eventTypeActionImage {
            actionImageView.image = UIImage(named: actionImageName)
        }
        
        //time
        timeView?.origin = CGPoint(x: BFEventConstants.TIME_X, y: BFEventConstants.TIME_Y)
//        timeView?.backgroundColor = UIColor.red
        if layout.timeHeight > 0 {
            timeView?.isHidden = false
            timeView?.height = layout.timeHeight
            timeView?.setLayout(layout: layout)
        } else {
            timeView?.isHidden = true
        }
        
        //title
        titleView?.origin = CGPoint(x: timeView!.left, y: timeView!.bottom)
//        titleView?.backgroundColor = UIColor.green
        if layout.titleHeight > 0 {
            titleView?.isHidden = false
            titleView?.height = layout.titleHeight
            titleView?.setLayout(layout: layout)
        } else {
            titleView?.isHidden = true
        }
        
        //-------------->>>>>> actionContentView 内容区域 <<<<<<<-------------
        
        actionContentView.origin = CGPoint(x: titleView!.left, y: titleView!.bottom)
//        actionContentView.backgroundColor = UIColor.red
        actionContentView.width = BFEventConstants.ACTION_CONTENT_WIDTH
        actionContentView.height = layout.actionContentHeight
        
        //actor image
        if let avatarUrl = layout.event?.actor?.avatar_url, let url = URL(string: avatarUrl) {
            actorImageView.isHidden = false
            actorImageView.origin = CGPoint(x: BFEventConstants.ACTOR_IMG_LEFT, y: BFEventConstants.ACTOR_IMG_TOP)
            actorImageView.kf.setImage(with: url)
        } else {
            actorImageView.isHidden = true
        }
        
        if let type = layout.event?.type {
            if type == .watchEvent {
                actorImageView.isHidden = true
            }
        }
        if layout.prDetailHeight > 0 {
            //pull request 中，同样有text
            textView?.origin = CGPoint(x: BFEventConstants.TEXT_X, y: BFEventConstants.TEXT_Y)
//            textView?.backgroundColor = .red
            if layout.textHeight > 0 {
                textView?.isHidden = false
                textView?.height = layout.textHeight
                textView?.setLayout(layout: layout)
            } else {
                textView?.isHidden = true
            }
            commitView?.isHidden = true
            prDetailView?.isHidden = false
            prDetailView?.origin = CGPoint(x: textView!.left, y: textView!.bottom)
            prDetailView?.height = layout.prDetailHeight
            prDetailView?.setLayout(layout: layout)
            
        } else if layout.commitHeight > 0 {
            prDetailView?.isHidden = true
            textView?.isHidden = true
            commitView?.isHidden = false
            
            commitView?.origin = CGPoint(x: BFEventConstants.COMMIT_X, y: BFEventConstants.COMMIT_Y)
            commitView?.height = layout.commitHeight
            commitView?.setLayout(layout: layout)
            
        } else {
            prDetailView?.isHidden = true
            commitView?.isHidden = true
            //text
            textView?.origin = CGPoint(x: BFEventConstants.TEXT_X, y: BFEventConstants.TEXT_Y)
            if layout.textHeight > 0 {
                textView?.isHidden = false
                textView?.height = layout.textHeight
                textView?.setLayout(layout: layout)
            } else {
                textView?.isHidden = true
            }
        }
        
        switch layout.style {
        case .pullRequest:
            actionContentView.isHidden = false
        case .pushCommit:
            actionContentView.isHidden = false
        case .textPicture:
            actionContentView.isHidden = false
        case .text:
            actionContentView.isHidden = true
            break
        }
    }
    
}
