//
//  CPReposInfoView.swift
//  BeeFun
//
//  Created by WengHengcong on 3/9/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

/// Repos 底部的代码库的详细信息视图
class CPReposInfoView: UIView {

    var watchBtn: UIButton = UIButton()
    var starBtn: UIButton = UIButton()
    var forkBtn: UIButton = UIButton()

    var lanBtn: UIButton = UIButton()
    var privateBtn: UIButton = UIButton()

    var issueBtn: UIButton = UIButton()
    var filesizeBtn: UIButton = UIButton()

    var repo: ObjRepos? {
        didSet {
            riv_fillData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        riv_customView()
    }

    convenience init(obj: ObjRepos) {
        self.init(frame:CGRect.zero)
        self.repo = obj
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /// view
    func riv_customView() {

        self.addSubview(self.watchBtn)
        self.addSubview(self.starBtn)
        self.addSubview(self.forkBtn)
        self.addSubview(self.lanBtn)
        self.addSubview(self.privateBtn)
        self.addSubview(self.issueBtn)
        self.addSubview(self.filesizeBtn)

        self.backgroundColor = UIColor.white

        watchBtn.setImage(UIImage(named: "repos_watch"), for: UIControlState())
        starBtn.setImage(UIImage(named: "repos_star"), for: UIControlState())
        forkBtn.setImage(UIImage(named: "repos_fork"), for: UIControlState())

        lanBtn.setImage(UIImage(named: "repos_lan"), for: UIControlState())
        privateBtn.setImage(UIImage(named: "repos_unlock"), for: UIControlState())
        issueBtn.setImage(UIImage(named: "repos_issue"), for: UIControlState())
        filesizeBtn.setImage(UIImage(named: "repos_file"), for: UIControlState())

        let widthBy3Part = UIScreen.width/3
        let widthBy2Part = UIScreen.width/2
        let lineH = designBy4_7Inch(30.0)

        let imgEdgeInsets1 = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        let borderWidth: CGFloat = 0.5

        let btnArr1: [UIButton] = [watchBtn, starBtn, forkBtn]
        let line1Y: CGFloat = 0.0

        for (index, btn) in btnArr1.enumerated() {
            let x = CGFloat(index) * widthBy3Part
            btn.frame = CGRect(x: x, y: line1Y, width: widthBy3Part, height: lineH)
            btn.imageView?.contentMode = .scaleAspectFit
            btn.imageEdgeInsets = imgEdgeInsets1
            btn.layer.borderColor = UIColor.bfLineBackgroundColor.cgColor
            btn.layer.borderWidth = borderWidth
            btn.titleLabel?.font = UIFont.bfSystemFont(ofSize: 15.0)
            btn.setTitleColor(UIColor.iOS11Black, for: UIControlState())
        }

        let imgEdgeInsets2 = UIEdgeInsets(top: 0, left: -40, bottom: 0, right: 10)
        let btnArr2: [UIButton] = [lanBtn, privateBtn, issueBtn, filesizeBtn]

        for (index, btn) in btnArr2.enumerated() {

            let x = CGFloat(index%2) * widthBy2Part
            let y = (index < 2) ? lineH : (2*lineH)
            btn.tag = index
            btn.frame = CGRect(x: x, y: y, width: widthBy2Part, height: lineH)
            btn.imageView?.contentMode = .scaleAspectFit
            btn.imageEdgeInsets = imgEdgeInsets2
            btn.titleLabel?.font = UIFont.bfSystemFont(ofSize: 15.0)
            btn.layer.borderColor = UIColor.bfLineBackgroundColor.cgColor
            btn.layer.borderWidth = borderWidth
            btn.setTitleColor(UIColor.iOS11Black, for: UIControlState())
            btn.addTarget(self, action:#selector(jumpWebView(sender:)), for: .touchUpInside)
        }

    }

    // MARK: - layout
    override func layoutSubviews() {
        super.layoutSubviews()

    }

    // MARK: - data
    func riv_fillData() {

        if let watchCount = repo?.subscribers_count {
            watchBtn.setTitle("\(watchCount)", for: UIControlState())
        }

        if let stargazersCount = repo?.stargazers_count {
            starBtn.setTitle("\(stargazersCount)", for: UIControlState())
        }

        if let forksCount = repo?.forks_count {
            forkBtn.setTitle("\(forksCount)", for: UIControlState())
        }

        if let lan = repo?.language {
            lanBtn.setTitle("\(lan)", for: UIControlState())
        } else {
            lanBtn.setTitle("Unknown".localized, for: UIControlState())
        }

        if let cprivate = repo?.cprivate {
            if cprivate {
                privateBtn.setTitle("Private".localized, for: UIControlState())
                privateBtn.setImage(UIImage(named: "repos_lock"), for: UIControlState())
            } else {
                privateBtn.setTitle("Public".localized, for: UIControlState())
                privateBtn.setImage(UIImage(named: "repos_unlock"), for: UIControlState())
            }
        }

        if let issueCount = repo?.open_issues_count {
            if issueCount <= 1 {
                issueBtn.setTitle("\(issueCount) issue", for: UIControlState())
            } else {
                issueBtn.setTitle("\(issueCount) issues", for: UIControlState())
            }
        }
        if let fileMB = repo?.size {
            let fileMB = String(format: "%.2f", ((Double)(fileMB)/1024.0) )
            filesizeBtn.setTitle("\(fileMB) MB", for: UIControlState())
        }

        self.setNeedsLayout()

    }

    func riv_settingButtons() {

    }

   @objc func jumpWebView(sender: UIButton) {
    }

}
