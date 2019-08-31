//
//  BFEventParase.swift
//  BeeFun
//
//  Created by WengHengcong on 29/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit

class BFEventParase: NSObject {
    
    // MARK: - 获取各种类型中的动作图片
    public class func actionImage(event: ObjEvent?) -> String? {
        
        var actionImageName: String? = nil
        if let type = event?.type {
            actionImageName = String(format: "event_%@", type.rawValue)
            switch type {
            case .issuesEvent:
                if let action = event?.payload?.action {
                    actionImageName = String(format: "event_%@_%@", type.rawValue, action.rawValue)
                }
                
            default:
                break
            }
        }
        return actionImageName
    }
    
    // MARK: - 获取各种类型中的Title中用户字段
    public class func actorName(event: ObjEvent?) -> String? {
        if let type = event?.type {
            switch type {
            case .pushEvent:
                return event?.actor?.display_login
            default:
                return event?.actor?.display_login
            }
        }
        return event?.actor?.display_login
    }
    
    // MARK: - 获取各种类型中的Title中repo字段
    public class func repoName(event: ObjEvent?) -> String? {
        if let type = event?.type {
            switch type {
            case .issueCommentEvent:
                return event?.repo?.name
            case .pullRequestEvent:
                return event?.repo?.name
            default:
                return event?.repo?.name
            }
        }
        return event?.repo?.name
    }
    
    // MARK: - 获取各种类型中的文本字段
    public class func contentBody(event: ObjEvent?) -> String? {
        if let type = event?.type {
            switch type {
            case .issuesEvent:
                return event?.payload?.issue?.title
            case .issueCommentEvent:
                return event?.payload?.comment?.body
            case .pullRequestEvent:
                return event?.payload?.pull_request?.title
            case .pullRequestReviewCommentEvent:
                return event?.payload?.comment?.body
            case .releaseEvent:
                return "Source code (zip)"
            case .commitCommentEvent:
                return event?.payload?.comment?.body
            default:
                return nil
            }
        }
        return nil
    }
    
    // MARK: - 获取各种类型中的Title中动作字段
    public class func action(event: ObjEvent?) -> String {
        var actionText = ""
        if let type = event?.type {
            switch type {
            case .issuesEvent:
                if let action = event?.payload?.action {
                    actionText = " "+action.rawValue + " issue"
                }
            case .watchEvent:
                if let act = event?.payload?.action?.rawValue {
                    actionText = " "+act+" "
                }
            case .pushEvent:
                actionText = " pushed to "
            case .issueCommentEvent:
                //commented on issue/pull request
                if event?.payload?.issue?.pull_request != nil {
                    actionText = " commented on pull request"
                } else {
                    actionText =  " commented on issue"
                }
            case .pullRequestEvent:
                if let action = event?.payload?.action {
                    actionText = " "+action.rawValue + " pull request"
                }
            case .pullRequestReviewCommentEvent:
                if event?.payload?.pull_request != nil && event?.payload?.comment != nil {
                    actionText = " commented on pull request"
                }
            case .releaseEvent:
                if event?.payload?.release != nil {
                    actionText = " released "
                }
            case .createEvent:
                if let type = event?.payload?.ref_type {
                    actionText = " created "+type+" "
                }
            case .forkEvent:
                if event?.payload?.forkee != nil {
                    actionText = " forked "
                }
            case .deleteEvent:
                if let type = event?.payload?.ref_type {
                    actionText = " deleted "+type+" "
                }
            case .memberEvent:
                if let action = event?.payload?.action?.rawValue, event?.payload?.member != nil {
                    actionText = " \(action) "
                }
            case .commitCommentEvent:
                if event?.payload?.comment != nil {
                    actionText = " commented on commit "
                }
            case .gollumEvent:
                if let pages = event?.payload?.pages {
                    let page: ObjPage = pages.first!
                    let act = page.action!
                    actionText = " \(act) a wiki page in"
                }
                
            default:
                break
            }
        }
        return actionText
    }
    
    // MARK: - 各种Event的布局类型
    public class func layoutType(event: ObjEvent?) -> EventLayoutStyle {
        if let type = event?.type {
            switch type {
            case .commitCommentEvent:
                return .textPicture
            case .createEvent:
                return .text
            case .deleteEvent:
                return .text
            case .deploymentEvent:
                return .textPicture
            case .deploymentStatusEvent:
                return .textPicture
            case .downloadEvent:
                return .textPicture
            case .followEvent:
                return .text
            case .forkEvent:
                return .text
            case .forkApplyEvent:
                return .text
            case .gistEvent:
                return .textPicture
            case .issuesEvent:
                return .textPicture
            case .issueCommentEvent:
                return .textPicture
            case .memberEvent:
                return .text
            case .membershipEvent:
                return .textPicture
            case .pageBuildEvent:
                return .textPicture
            case .publicEvent:
                return .textPicture
            case .pullRequestEvent:
                return .pullRequest
            case .pullRequestReviewCommentEvent:
                return .textPicture
            case .pushEvent:
                return .pushCommit
            case .releaseEvent:
                return .textPicture
            case .repositoryEvent:
                return .textPicture
            case .statusEvent:
                return .textPicture
            case .teamAddEvent:
                return .textPicture
            case .watchEvent:
                return .text
            case .gollumEvent:
                return .textPicture
            default:
                return .textPicture
            }
        }
        return .textPicture
    }
}
