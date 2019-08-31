//
//  BFEventLayout.swift
//  BeeFun
//
//  Created by WengHengcong on 23/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import YYText


// 异步绘制导致的闪烁解决方案：https://github.com/ibireme/YYKit/issues/64
// https://github.com/ibireme/YYText/issues/103

/// 布局样式
///
/// - pullRequest: pull request
/// - pushCommit: push commit
/// - textPicture: 图文布局
/// - text: 文本布局
public enum EventLayoutStyle: Int {
    case pullRequest
    case pushCommit
    case textPicture
    case text
}

class BFEventLayout: NSObject {
    //数据
    var event: ObjEvent?
    var style: EventLayoutStyle = .textPicture         //布局
    var eventTypeActionImage: String? {
        return BFEventParase.actionImage(event: event)
    }
    
    //上下左右留白
    var marginTop: CGFloat = 0
    var marginBottom: CGFloat = 0
    var marginLeft: CGFloat = 0
    var marginRight: CGFloat = 0
    
    //action 图片
    var actionHeight: CGFloat = 0
    var actionSize: CGSize = CGSize.zero
    
    //时间
    var timeHeight: CGFloat = 0
    var timeLayout: YYTextLayout?
    
    //title
    var titleHeight: CGFloat = 0
    var titleLayout: YYTextLayout?
    
    //---->>>> 内容区域 <<<<-------
    var actionContentHeight: CGFloat = 0
    //actor 图片
    var actorHeight: CGFloat = 0
    var actorSize: CGSize = CGSize.zero
    
    //文字content内容
    var textHeight: CGFloat = 0
    var textLayout: YYTextLayout?
    
    //commit 内容
    var commitHeight: CGFloat = 0
    var commitLayout: YYTextLayout?
    
    //pull request detail
    var prDetailWidth: CGFloat = 0      //1 commit with .....文字的宽度
    var prDetailHeight: CGFloat = 0
    var prDetailLayout: YYTextLayout?
    
    var totalHeight: CGFloat = 0
    
    init(event: ObjEvent?) {
        super.init()
        if event == nil {
            return
        }
        self.event = event
        layout()
    }
    /// 布局
    func layout() {
        
        marginTop = 0
        actionHeight = 0
        timeHeight = 0
        titleHeight = 0
        actorHeight = 0
        actionContentHeight = 0
        textHeight = 0
        commitHeight = 0
        prDetailHeight = 0
        marginBottom = 5
        
        _layoutActionImage()
        _layoutTime()
        _layoutTitle()
        _layoutActorImage()
        _layoutTextContent()
        _layoutCommit()
        _layoutPRDetail()
        
        //计算高度
        let timeMargin = BFEventConstants.TIME_Y
        let actorImgMargin = BFEventConstants.ACTOR_IMG_TOP
        let textMargin = BFEventConstants.TEXT_Y
        
        totalHeight = timeMargin+timeHeight+titleHeight+marginBottom

        style = BFEventParase.layoutType(event: event)
        
        switch style {
        case .pullRequest:
            totalHeight += textMargin + max(actorImgMargin+actorHeight, textHeight+prDetailHeight)
        case .pushCommit:
            totalHeight += textMargin + max(actorImgMargin+actorHeight, commitHeight)
        case .textPicture:
            totalHeight += textMargin + max(actorImgMargin+actorHeight, textHeight)
        case .text:
            break
        }
        
        actionContentHeight = totalHeight-timeMargin-timeHeight-titleHeight
    }
    
    private func _layoutActionImage() {
        actionHeight = BFEventConstants.ACTOR_IMG_WIDTH
    }
    
    private func _layoutTime() {
        
        timeHeight = 0
        timeLayout = nil
        if let time = event?.created_at {
            if let showTime = BFTimeHelper.shared.readableTime(rare: time, prefix: nil) {
                let timeAtt = NSMutableAttributedString(string: showTime)
                let container = YYTextContainer(size: CGSize(width: BFEventConstants.TIME_W, height: CGFloat.greatestFiniteMagnitude))
                
                timeAtt.yy_font = UIFont.bfSystemFont(ofSize: BFEventConstants.TIME_FONT_SIZE)
                let layout = YYTextLayout(container: container, text: timeAtt)
                timeLayout = layout
                timeHeight = timeLayout!.textBoundingSize.height
            }
        }
    }
    
    private func _layoutTitle() {
        titleHeight = 0
        titleLayout = nil
        
        let titleText: NSMutableAttributedString = NSMutableAttributedString()

        //用户名
        if let actorName = BFEventParase.actorName(event: event) {
            let actorAttriText = NSMutableAttributedString(string: actorName)
            actorAttriText.yy_setTextHighlight(actorAttriText.yy_rangeOfAll(), color: UIColor.blue, backgroundColor: UIColor.white, userInfo: nil, tapAction: { (_, _, _, _) in
                JumpManager.shared.jumpUserDetailView(user: self.event?.actor)
            }, longPressAction: nil)
        
            titleText.append(actorAttriText)
        }
        
        let actionText = NSMutableAttributedString(string: BFEventParase.action(event: event))
        titleText.append(actionText)
        
        //介于actor与repo中间的部分
        if let type = event?.type {
            if type == .pushEvent {
                //[aure] pushed to [develop] at [AudioKit/AudioKit]
                if let ref = event?.payload?.ref {
                    if let reponame = event?.repo?.name, let branch = ref.components(separatedBy: "/").last {
                        //https://github.com/AudioKit/AudioKit/tree/develop
                        let url = "https://github.com/"+reponame+"/tree/"+branch
                        let branchText = NSMutableAttributedString(string: branch)
                        branchText.yy_setTextHighlight(branchText.yy_rangeOfAll(), color: UIColor.blue, backgroundColor: UIColor.white, userInfo: nil, tapAction: { (_, _, _, _) in
                            JumpManager.shared.jumpWebView(url: url)
                        }, longPressAction: nil)
                        titleText.append(branchText)
                    }
                }
            } else if type == .releaseEvent {
                //[ckrey] released [Session Manager and CoreDataPersistence] at [ckrey/MQTT-Client-Framework]
                if let releaseName = event?.payload?.release?.name, let releaseUrl = event?.payload?.release?.html_url {
                    let releaseText = NSMutableAttributedString(string: releaseName)
                    releaseText.yy_setTextHighlight(releaseText.yy_rangeOfAll(), color: UIColor.blue, backgroundColor: UIColor.white, userInfo: nil, tapAction: { (_, _, _, _) in
                        JumpManager.shared.jumpWebView(url: releaseUrl)
                    }, longPressAction: nil)
                    titleText.append(releaseText)
                    titleText.append(NSMutableAttributedString(string: " at "))
                }
            } else if type == .createEvent {
                //[ckrey] created [tag] [0.9.9] at [ckrey/MQTT-Client-Framework]
                if let tag = event?.payload?.ref {
                    let tagText = NSMutableAttributedString(string: tag)
                    tagText.yy_setTextHighlight(tagText.yy_rangeOfAll(), color: UIColor.blue, backgroundColor: UIColor.white, userInfo: nil, tapAction: { (_, _, _, _) in
                        //https://github.com/user/repo/tree/tag
                        if let repoName = self.event?.repo?.name {
                            let url = "https://github.com/"+repoName+"/tree/"+tag
                            JumpManager.shared.jumpWebView(url: url)
                        }
                    }, longPressAction: nil)
                    titleText.append(tagText)
                    titleText.append(NSMutableAttributedString(string: " at "))
                }
            } else if type == .forkEvent {
                //[cloudwu] forked [bkaradzic/bx] to [cloudwu/bx]
                if let repo = BFEventParase.repoName(event: event) {
                    let repoAttrText = NSMutableAttributedString(string: repo)
                    repoAttrText.yy_setTextHighlight(repoAttrText.yy_rangeOfAll(), color: UIColor.blue, backgroundColor: UIColor.white, userInfo: nil, tapAction: { (_, _, _, _) in
                        JumpManager.shared.jumpReposDetailView(repos: self.event?.repo, from: .other)
                    }, longPressAction: nil)
                    titleText.append(repoAttrText)
                    titleText.append(NSMutableAttributedString(string: " to "))
                }
            } else if type == .deleteEvent {
                if let branch = event?.payload?.ref {
                    let branchText = NSMutableAttributedString(string: branch)
                    branchText.yy_setTextHighlight(branchText.yy_rangeOfAll(), color: UIColor.bfLabelSubtitleTextColor, backgroundColor: UIColor.white, userInfo: nil, tapAction: { (_, _, _, _) in
                        
                    }, longPressAction: nil)
                    titleText.append(branchText)
                    titleText.append(NSMutableAttributedString(string: " at "))
                }
            } else if type == .memberEvent {
                if let memberName = event?.payload?.member?.login {
                    let memberText = NSMutableAttributedString(string: memberName)
                    memberText.yy_setTextHighlight(memberText.yy_rangeOfAll(), color: UIColor.blue, backgroundColor: UIColor.white, userInfo: nil, tapAction: { (_, _, _, _) in
                        JumpManager.shared.jumpReposDetailView(repos: self.event?.repo, from: .other)
                    }, longPressAction: nil)
                    titleText.append(memberText)
                    titleText.append(NSMutableAttributedString(string: " to "))
                }
            }
        }
        
        //repos
        if let type = event?.type {
            if type == .forkEvent {
                if let user = BFEventParase.actorName(event: event), let repoName = event?.payload?.forkee?.name {
                    let repoAttrText = NSMutableAttributedString(string: user+repoName)
                    repoAttrText.yy_setTextHighlight(repoAttrText.yy_rangeOfAll(), color: UIColor.blue, backgroundColor: UIColor.white, userInfo: nil, tapAction: { (_, _, _, _) in
                        JumpManager.shared.jumpReposDetailView(repos: self.event?.repo, from: .other)
                    }, longPressAction: nil)
                    titleText.append(repoAttrText)
                }
            } else {
                if let repo = BFEventParase.repoName(event: event) {
                    var actionNumberStr = ""
                    if let actionNumber = event?.payload?.issue?.number {
                        actionNumberStr = "#\(actionNumber)"
                    } else if let actionNumber = event?.payload?.pull_request?.number {
                        //https://github.com/user/repo/pull/number
                        actionNumberStr = "#\(actionNumber)"
                    }
                    let repoAttrText = NSMutableAttributedString(string: " " + repo + "\(actionNumberStr)")
                    repoAttrText.yy_setTextHighlight(repoAttrText.yy_rangeOfAll(), color: UIColor.blue, backgroundColor: UIColor.white, userInfo: nil, tapAction: { (_, _, _, _) in
                        
                        if let eventType = self.event?.type {
                            switch eventType {
                            case .pullRequestEvent:
                                JumpManager.shared.jumpWebView(url: self.event?.payload?.pull_request?.html_url)
                                return
                            default:
                                break
                            }
                        }

                        if let comment = self.event?.payload?.comment {
                            JumpManager.shared.jumpWebView(url: comment.html_url)
                        } else {
                            JumpManager.shared.jumpReposDetailView(repos: self.event?.repo, from: .other)
                        }
                    }, longPressAction: nil)
                    titleText.append(repoAttrText)
                }
            }
        }

        titleText.yy_font = UIFont.bfSystemFont(ofSize: BFEventConstants.TITLE_FONT_SIZE)
        let container = YYTextContainer(size: CGSize(width: BFEventConstants.TITLE_W, height: CGFloat.greatestFiniteMagnitude))
        let layout = YYTextLayout(container: container, text: titleText)
        titleHeight = layout!.textBoundingSize.height
        titleLayout = layout
    }
    
    private func _layoutActorImage() {
        actorHeight = BFEventConstants.ACTOR_IMG_WIDTH
    }
    
    private func _layoutTextContent() {
        textHeight = 0
        textLayout = nil
        
        let textText: NSMutableAttributedString = NSMutableAttributedString()
        
        if let type = event?.type {
            if type == .issueCommentEvent || type == .pullRequestReviewCommentEvent || type == .commitCommentEvent {
                if let commentBody = BFEventParase.contentBody(event: event) {
                    let clipLength = 130
                    let commentBodyAttText = NSMutableAttributedString(string: commentBody)
                    if commentBodyAttText.length > clipLength {
                        let moreRange = NSRange(location: clipLength, length: commentBodyAttText.length-clipLength)
                        commentBodyAttText.replaceCharacters(in: moreRange, with: YYTextManager.moreDotCharacterAttribute(count: 3))
                    }
                    textText.append(commentBodyAttText)
                }
            } else if type == .issuesEvent {
                if let issueBody = BFEventParase.contentBody(event: event) {
                    let clipLength = 130
                    let commentBodyAttText = NSMutableAttributedString(string: issueBody)
                    if commentBodyAttText.length > clipLength {
                        let moreRange = NSRange(location: clipLength, length: commentBodyAttText.length-clipLength)
                        commentBodyAttText.replaceCharacters(in: moreRange, with: YYTextManager.moreDotCharacterAttribute(count: 3))
                    }
                    textText.append(commentBodyAttText)
                }
            } else if type == .releaseEvent {
                if let releaseText = BFEventParase.contentBody(event: event) {
                    let releaseAttText = NSMutableAttributedString(string: releaseText)
                    textText.append(releaseAttText)
                }
            } else if type == .pullRequestEvent {
                if let pullRequestText = BFEventParase.contentBody(event: event) {
                    let clipLength = 130
                    let pullRequestAttText = NSMutableAttributedString(string: pullRequestText)
                    if pullRequestAttText.length > clipLength {
                        let moreRange = NSRange(location: clipLength, length: pullRequestAttText.length-clipLength)
                        pullRequestAttText.replaceCharacters(in: moreRange, with: YYTextManager.moreDotCharacterAttribute(count: 3))
                    }
                    textText.append(pullRequestAttText)
                }
            } else if type == .gollumEvent {
                if let pages = event?.payload?.pages {
                    let page: ObjPage = pages.first!
                    let act = page.action!
                    let actText = NSMutableAttributedString(string: act)
                    textText.append(actText)
                    
                    textText.addBlankSpaceCharacterAttribute(1)

                    //AFNetworking 3.0 Migration Guide 跳转
                    if let pageName = page.title {
                        let pageNameText = NSMutableAttributedString(string: pageName)
                        pageNameText.yy_setTextHighlight(pageNameText.yy_rangeOfAll(), color: UIColor.blue, backgroundColor: UIColor.white, userInfo: nil, tapAction: { (_, _, _, _) in
                            JumpManager.shared.jumpWebView(url: page.html_url)
                        }, longPressAction: nil)
                        textText.append(pageNameText)
                        textText.addBlankSpaceCharacterAttribute(1)
                    }
                    
                    //View the diff
                    if let sha = page.sha {
                        let shaText = NSMutableAttributedString(string: "View the diff>>")
                        
                        if let html_url = page.html_url {
                            let jump_url = html_url + "/_compare/"+sha
                            shaText.yy_setTextHighlight(shaText.yy_rangeOfAll(), color: UIColor.blue, backgroundColor: UIColor.white, userInfo: nil, tapAction: { (_, _, _, _) in
                                JumpManager.shared.jumpWebView(url: jump_url)
                            }, longPressAction: nil)
                        }
                        textText.append(shaText)
                    }
                }
            }
            
            textText.yy_font = UIFont.bfSystemFont(ofSize: BFEventConstants.TEXT_FONT_SIZE)
            let container = YYTextContainer(size: CGSize(width: BFEventConstants.TEXT_W, height: CGFloat.greatestFiniteMagnitude))
            let layout = YYTextLayout(container: container, text: textText)
            textHeight = layout!.textBoundingSize.height
            textLayout = layout
        }
    }
    
    private func _layoutCommit() {
        
        commitHeight = 0
        commitLayout = nil
        
        if let eventtype = event?.type {
            if eventtype != .pushEvent {
                return
            }
        }
        let pushText: NSMutableAttributedString = NSMutableAttributedString()
        let font = UIFont.bfSystemFont(ofSize: BFEventConstants.COMMIT_FONT_SIZE)
        
        if let commits = event?.payload?.commits {
            let allCommitText = NSMutableAttributedString()
            for (index, commit) in commits.reversed().enumerated() where index < 2 {
                if let hashStr = commit.sha?.substring(to: 6), let message = commit.message {
                    
                    let commitText = NSMutableAttributedString(string: hashStr)
                    commitText.yy_setTextHighlight(commitText.yy_rangeOfAll(), color: UIColor.blue, backgroundColor:  UIColor.white, userInfo: nil, tapAction: { (_, _, _, _) in
                        //跳转到具体commit
                        if let reponame = self.event?.repo?.name, let sha = commit.sha {
                            //https://github.com/user/repo/commit/sha
                            let url = "https://github.com/"+reponame+"/commit/"+sha
                            JumpManager.shared.jumpWebView(url: url)
                        }
                        
                    }, longPressAction: nil)
                    let messageText = NSMutableAttributedString(string: message)
                    commitText.addBlankSpaceCharacterAttribute(2)
                    commitText.append(messageText)
                    commitText.addLineBreakCharacterAttribute()
                    allCommitText.append(commitText)
                }
            }
            pushText.append(allCommitText)
            if commits.count == 2 {
                let moreText = NSMutableAttributedString(string: "View comparison for these 2 commits »")
                moreText.yy_setTextHighlight(moreText.yy_rangeOfAll(), color: UIColor.blue, backgroundColor:  UIColor.white, userInfo: nil, tapAction: { (_, _, _, _) in
                    if let reponame = self.event?.repo?.name, let before = self.event?.payload?.before, let head = self.event?.payload?.head {
                        //https://github.com/user/repo/comare/before_sha...header_sha
                        let url = "https://github.com/"+reponame+"/compare/"+before+"..."+head
                        JumpManager.shared.jumpWebView(url: url)
                    }
                }, longPressAction: nil)
                pushText.append(moreText)
            } else if commits.count > 2 {
                //commist.count > 2
                if let all = event?.payload?.distinct_size {
                    let more = all - 2
                    var moreStr = "\(more) more cmmmit"
                    if more > 0 {
                        if more > 1 {
                            moreStr.append("s >>")
                        } else if more == 1 {
                            moreStr.append(" >>")
                        }
                        let moreText = NSMutableAttributedString(string: moreStr)
                        moreText.yy_setTextHighlight(moreText.yy_rangeOfAll(), color: UIColor.blue, backgroundColor:  UIColor.white, userInfo: nil, tapAction: { (_, _, _, _) in
                            if let reponame = self.event?.repo?.name, let before = self.event?.payload?.before, let head = self.event?.payload?.head {
                                //https://github.com/user/repo/comare/before_sha...header_sha
                                let url = "https://github.com/"+reponame+"/compare/"+before+"..."+head
                                JumpManager.shared.jumpWebView(url: url)
                            }
                        }, longPressAction: nil)
                        pushText.append(moreText)
                    }
                }
            }
            
            pushText.yy_font = font
            let container = YYTextContainer(size: CGSize(width: BFEventConstants.COMMIT_W, height: CGFloat.greatestFiniteMagnitude))
            let layout = YYTextLayout(container: container, text: pushText)
            commitHeight = layout!.textBoundingSize.height
            commitLayout = layout
        }
        
    }
    
    private func _layoutPRDetail() {
        
        prDetailHeight = 0
        prDetailLayout = nil
        
        if let eventtype = event?.type {
            if eventtype != .pullRequestEvent {
                return
            }
        }
        let prDetailText: NSMutableAttributedString = NSMutableAttributedString()
        let font = UIFont.bfSystemFont(ofSize: BFEventConstants.PRDETAIL_FONT_SIZE)
        
        if let pull_request = event?.payload?.pull_request {

            if let commits = pull_request.commits, let additions = pull_request.additions, let deletions = pull_request.deletions {
                //图片
                let size = CGSize(width: 10, height: 10)
                var image = UIImage(named: "event_commit_icon")
                if image != nil {
                    image = UIImage(cgImage: image!.cgImage!, scale: 2.0, orientation: UIImageOrientation.up)
                    let imageText = NSMutableAttributedString.yy_attachmentString(withContent: image, contentMode: .center, attachmentSize: size, alignTo: font, alignment: .center)
                    prDetailText.append(imageText)
                    prDetailText.addBlankSpaceCharacterAttribute(1)
                }
                
                //1 commit with 1 addition and 0 deletions
                let commitStirng = commits <= 1 ? "commit" : "commits"
                let additionString = additions == 1 ? "addition" : "additions"
                let deletionString = deletions == 1 ? "deletion" : "deletions"
                let detailString = "\(pull_request.commits!) " + commitStirng + " with " + "\(pull_request.additions!) " + additionString + " and " + "\(pull_request.deletions!) " + deletionString
                let textText = NSMutableAttributedString(string: detailString)
                prDetailText.append(textText)
                
                prDetailText.yy_font = font
                let container = YYTextContainer(size: CGSize(width: BFEventConstants.PRDETAIL_W, height: CGFloat.greatestFiniteMagnitude))
                let layout = YYTextLayout(container: container, text: prDetailText)
                prDetailHeight = layout!.textBoundingSize.height
                prDetailWidth = layout!.textBoundingRect.width
                prDetailLayout = layout
            }
        }
    }
}
