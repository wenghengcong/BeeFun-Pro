//
//  CPMesIssueCell.swift
//  BeeFun
//
//  Created by WengHengcong on 3/7/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

class CPMesIssueCell: BFBaseCell {

    @IBOutlet weak var issueTitleBtn: UIButton!

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var reposNameLabel: UILabel!

    @IBOutlet weak var stateLabel: UILabel!

    @IBOutlet weak var assignLabel: UILabel!

    @IBOutlet weak var timeLabel: UILabel!

    var issue: ObjIssue? {

        didSet {
            notiCell_fillData()
        }
    }

    override func p_customCellView() {
        super.p_customCellView()
//        numberLabel.textColor = UIColor.bfLabelSubtitleTextColor
        issueTitleBtn.isUserInteractionEnabled = false
        reposNameLabel.textColor = UIColor.bfLabelSubtitleTextColor
        stateLabel.textColor = UIColor.bfLabelSubtitleTextColor
        assignLabel.textColor = UIColor.bfLabelSubtitleTextColor
        timeLabel.textColor = UIColor.bfLabelSubtitleTextColor

    }

    func notiCell_fillData() {

        let issueTitle = issue!.title
        issueTitleBtn.setTitle(issueTitle, for: UIControlState())

        if let number = issue?.number {
            let issueNum = "#\(number)"
            numberLabel.text = issueNum
        } else {
            numberLabel.text = ""
        }

        if let reposName = issue?.repository?.name {
            reposNameLabel.text = reposName
        } else {
            if let repoUrl = issue?.repository_url {
                if let repoName = repoUrl.components(separatedBy: "/").last {
                    reposNameLabel.text = repoName
                }
            }
        }

        if let issueState = issue?.state {
            stateLabel.text = issueState
        } else {
            stateLabel.text = ""
        }

        if issue!.assignee == nil {
            assignLabel.text = "unassignned"
        } else {
            assignLabel.text = issue!.assignee!.login
        }

        //time
        if (issue?.created_at) != nil {
            timeLabel.text = BFTimeHelper.shared.readableTime(rare: issue!.created_at, prefix: nil)
        } else {
            timeLabel.text = ""
        }
    }

}
