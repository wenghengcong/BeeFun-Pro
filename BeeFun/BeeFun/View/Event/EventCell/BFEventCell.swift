//
//  BFEventCell.swift
//  BeeFun
//
//  Created by WengHengcong on 23/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import YYText

class BFEventCell: BFEventBaseCell {
    
    var eventView: BFEventView?
    var layout: BFEventLayout?
    
    var actionImageView = UIImageView()

    var timeLabel: YYLabel = YYLabel()
    var titleLabel: YYLabel = YYLabel()
    
    var actorButton = UIButton()          /// event 执行者头像
    var commitLabel: YYLabel = YYLabel()
    var prDetailLabel: YYLabel = YYLabel()
    var contentLabel: YYLabel = YYLabel()
    
    var topLine: UIView = UIView()
    var bottomLine: UIView = UIView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupInitCell()
        setupActionImageView()
        setupTimeLabel()
        setupTitleLabel()
        setupActorImageView()
        setupCommitLabel()
        setupDetailLabel()
        setupContentLabel()
        setupLines()
    }
    
    func setupInitCell() {
        var newFrame = frame
        newFrame.size.width = ScreenSize.width
        newFrame.size.height = 1
        self.frame = newFrame
        contentView.isUserInteractionEnabled = true
        isUserInteractionEnabled = true
    }
    
    func setupActionImageView() {
        actionImageView.frame = CGRect(x: BFEventConstants.ACTION_IMG_LEFT, y: BFEventConstants.ACTION_IMG_TOP, w: BFEventConstants.ACTION_IMG_WIDTH, h: BFEventConstants.ACTION_IMG_WIDTH)
        //        actionImageView.isHidden = true
        actionImageView.image = UIImage(named: "git-comment-discussion_50")
        actionImageView.isUserInteractionEnabled = true
        contentView.addSubview(actionImageView)
    }
    
    func setupTimeLabel() {
        timeLabel.size = CGSize(width: self.width, height: self.height)
        timeLabel.ignoreCommonProperties = true
        timeLabel.displaysAsynchronously = true
        timeLabel.fadeOnAsynchronouslyDisplay = false
        timeLabel.fadeOnHighlight = false
        contentView.addSubview(timeLabel)
    }
    
    func setupTitleLabel() {
        titleLabel.size = CGSize(width: self.width, height: self.height)
        titleLabel.displaysAsynchronously = true
        titleLabel.ignoreCommonProperties = true
        titleLabel.fadeOnAsynchronouslyDisplay = false
        titleLabel.fadeOnHighlight = false
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
    }
    
    func setupActorImageView() {
        //actor image view
        actorButton.frame = CGRect(x: 0, y: 0, w: BFEventConstants.ACTOR_IMG_WIDTH, h: BFEventConstants.ACTOR_IMG_WIDTH)
        contentView.addSubview(actorButton)
    }
    
    func setupCommitLabel() {
        commitLabel.size = CGSize(width: self.width, height: self.height)
        //        commitLabel.backgroundColor = UIColor.hex("#eaf5ff")
        commitLabel.numberOfLines = 1
        commitLabel.displaysAsynchronously = true
        commitLabel.ignoreCommonProperties = true
        commitLabel.fadeOnAsynchronouslyDisplay = false
        commitLabel.fadeOnHighlight = false
        contentView.addSubview(commitLabel)
    }
    
    func setupDetailLabel() {
        prDetailLabel.size = CGSize(width: self.width, height: self.height)
        prDetailLabel.backgroundColor = UIColor.hex("#eaf5ff")
        prDetailLabel.numberOfLines = 1
        prDetailLabel.displaysAsynchronously = true
        prDetailLabel.ignoreCommonProperties = true
        prDetailLabel.fadeOnAsynchronouslyDisplay = false
        prDetailLabel.fadeOnHighlight = false
        contentView.addSubview(prDetailLabel)

    }
    
    func setupContentLabel() {
        contentLabel.size = CGSize(width: self.width, height: self.height)
        contentLabel.displaysAsynchronously = true
        contentLabel.ignoreCommonProperties = true
        contentLabel.fadeOnAsynchronouslyDisplay = false
        contentLabel.fadeOnHighlight = false
        contentLabel.numberOfLines = 3
        contentView.addSubview(contentLabel)
    }
    
    func setupLines() {
        //line
        let retinaPixelSize = 1.0 / (UIScreen.main.scale)
        topLine.backgroundColor = UIColor.bfLineBackgroundColor
        topLine.frame = CGRect(x: 0, y: 0, w: self.width, h: retinaPixelSize)
        contentView.addSubview(topLine)

        bottomLine.backgroundColor = UIColor.bfLineBackgroundColor
        bottomLine.size = CGSize(width: self.width, height: retinaPixelSize)
        contentView.addSubview(bottomLine)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout(layout: BFEventLayout) {
        self.layout = layout
        self.height = layout.totalHeight
        
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
        timeLabel.origin = CGPoint(x: BFEventConstants.TIME_X, y: BFEventConstants.TIME_Y)
        //        timeView?.backgroundColor = UIColor.red
        if layout.timeHeight > 0 {
            timeLabel.isHidden = false
            timeLabel.height = layout.timeHeight
            timeLabel.textLayout = layout.timeLayout
        } else {
            timeLabel.isHidden = true
        }
        
        //title
        titleLabel.origin = CGPoint(x: timeLabel.left, y: timeLabel.bottom)
        //        titleView?.backgroundColor = UIColor.green
        if layout.titleHeight > 0 {
            titleLabel.isHidden = false
            titleLabel.height = layout.titleHeight
            titleLabel.textLayout = layout.titleLayout
        } else {
            titleLabel.isHidden = true
        }
        
        //-------------->>>>>> action content 内容区域 <<<<<<<-------------
        //左边的起始距离，就是time的左边距
        let actionContentLeft = titleLabel.left
        let actionContentTop = titleLabel.bottom
        
        //actor image
        if let avatarUrl = layout.event?.actor?.avatar_url, let url = URL(string: avatarUrl) {
            actorButton.isHidden = false
            actorButton.origin = CGPoint(x: actionContentLeft + BFEventConstants.ACTOR_IMG_LEFT, y: actionContentTop + BFEventConstants.ACTOR_IMG_TOP)
            actorButton.kf.setImage(with: url, for: .normal)
            actorButton.kf.setImage(with: url, for: .highlighted)
            actorButton.addTarget(self, action: #selector(clickActor), for: .touchUpInside)
        } else {
            actorButton.isHidden = true
        }
        
        if let type = layout.event?.type {
            if type == .watchEvent {
                actorButton.isHidden = true
            }
        }
        if layout.prDetailHeight > 0 {
            //pull request 中，同样有text
            contentLabel.origin = CGPoint(x: actionContentLeft + BFEventConstants.TEXT_X, y: actionContentTop + BFEventConstants.TEXT_Y)
            //            textView?.backgroundColor = .red
            if layout.textHeight > 0 {
                contentLabel.isHidden = false
                contentLabel.height = layout.textHeight
                contentLabel.textLayout = layout.textLayout
            } else {
                contentLabel.isHidden = true
            }
            commitLabel.isHidden = true
            prDetailLabel.isHidden = false
            prDetailLabel.origin = CGPoint(x: contentLabel.left, y: contentLabel.bottom)
            prDetailLabel.height = layout.prDetailHeight
            prDetailLabel.textLayout = layout.prDetailLayout
            
        } else if layout.commitHeight > 0 {
            prDetailLabel.isHidden = true
            contentLabel.isHidden = true
            commitLabel.isHidden = false
            
            commitLabel.origin = CGPoint(x: actionContentLeft + BFEventConstants.COMMIT_X, y: actionContentTop + BFEventConstants.COMMIT_Y)
            commitLabel.height = layout.commitHeight
            commitLabel.textLayout = layout.commitLayout
            
        } else {
            prDetailLabel.isHidden = true
            commitLabel.isHidden = true
            //text
            contentLabel.origin = CGPoint(x: actionContentLeft + BFEventConstants.TEXT_X, y: actionContentTop + BFEventConstants.TEXT_Y)
            if layout.textHeight > 0 {
                contentLabel.isHidden = false
                contentLabel.height = layout.textHeight
                contentLabel.textLayout = layout.textLayout
            } else {
                contentLabel.isHidden = true
            }
        }
        
        let retinaPixelSize = 1.0 / (UIScreen.main.scale)
        topLine.origin = CGPoint(x: 0, y: 0)
        bottomLine.origin = CGPoint(x: 0, y: layout.totalHeight-retinaPixelSize)

        switch layout.style {
        case .pullRequest:
            break
        case .pushCommit:
            break
        case .textPicture:
            break
        case .text:
            actorButton.isHidden = true
            commitLabel.isHidden = true
            prDetailLabel.isHidden = true
            contentLabel.isHidden = true
        }
    }
    
    @objc func clickActor() {
        JumpManager.shared.jumpUserDetailView(user: self.layout?.event?.actor)
    }
}
