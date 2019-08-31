//
//  CPReposPosterView.swift
//  BeeFun
//
//  Created by WengHengcong on 3/9/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

protocol ReposActionProtocol: class {

    func watchReposAction()
    func starReposAction()
    func forkReposAction()

}

/// Repos 头部的代码库的主要信息视图
class CPReposPosterView: UIView {

    var imgV: UIImageView = UIImageView()

    var nameLabel: UILabel = UILabel()
    var descLabel: UILabel = UILabel()
    var timeLabel: UILabel = UILabel()

    var watchBtn: UIButton = UIButton()
    var starBtn: UIButton = UIButton()
    var forkBtn: UIButton = UIButton()

    weak var reposActionDelegate: ReposActionProtocol?
    var dynH: CGFloat = 0.0

    var repo: ObjRepos? {
        didSet {
            rpv_fillData()
        }
    }

    var watched: Bool? {
        didSet {
            if watched! {
                watchBtn.setTitle("Unwatch".localized, for: UIControlState())
                watchBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)

            } else {
                watchBtn.setTitle("Watch".localized, for: UIControlState())
                watchBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 10)

            }
        }
    }

    var stared: Bool? {
        didSet {
            if stared! {
                starBtn.setTitle("Unstar".localized, for: UIControlState())
            } else {
                starBtn.setTitle("Star".localized, for: UIControlState())
            }
        }

    }

    // MARK: - Init
    /// Init
    ///
    /// - Parameter frame: <#frame description#>
    override init(frame: CGRect) {
        super.init(frame: frame)
        rpv_customView()
    }

    convenience init(obj: ObjRepos) {
        self.init(frame:CGRect.zero)
        self.repo = obj
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - View
    func rpv_customView() {

        self.addSubview(self.imgV)
        self.addSubview(self.nameLabel)
        self.addSubview(self.descLabel)
        self.addSubview(self.timeLabel)
        self.addSubview(self.watchBtn)
        self.addSubview(self.forkBtn)
        self.addSubview(self.starBtn)

        self.nameLabel.font = UIFont.bfSystemFont(ofSize: 20.0)
        self.descLabel.font = UIFont.bfSystemFont(ofSize: 13.0)
        self.timeLabel.font = UIFont.bfSystemFont(ofSize: 13.0)

        self.backgroundColor = UIColor.white
        nameLabel.textColor = UIColor.iOS11Black
        nameLabel.backgroundColor = UIColor.white

        descLabel.textColor = UIColor.bfLabelSubtitleTextColor
        descLabel.backgroundColor = UIColor.white
        descLabel.numberOfLines = 3

        timeLabel.backgroundColor = UIColor.white
        timeLabel.textColor = UIColor.hex("#4876FF")

        watchBtn.setImage(UIImage(named: "octicon_watch_red_20"), for: UIControlState())
        watchBtn.setTitle("Watch".localized, for: UIControlState())
        watchBtn.addTarget(self, action: #selector(CPReposPosterView.rpv_watchAction), for: .touchUpInside)

        starBtn.setImage(UIImage(named: "octicon_star_red_20"), for: UIControlState())
        starBtn.setTitle("Star".localized, for: UIControlState())
        starBtn.addTarget(self, action: #selector(CPReposPosterView.rpv_starAction), for: .touchUpInside)

        forkBtn.setImage(UIImage(named: "octicon_fork_red_20"), for: UIControlState())
        forkBtn.setTitle("Fork".localized, for: UIControlState())
        forkBtn.addTarget(self, action: #selector(CPReposPosterView.rpv_forkAction), for: .touchUpInside)

        let margin: CGFloat = 10.0
        let imgW = designBy4_7Inch(80)

        imgV.frame = CGRect(x: margin, y: margin+7.0, width: imgW, height: imgW)

        let nameL: CGFloat = imgV.right+10.0
        let nameW: CGFloat = ScreenSize.width-nameL-margin

        nameLabel.frame = CGRect(x: nameL, y: 10.0, width: nameW, height: 24.0)

        let imgEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 10)
        let cornerRadius: CGFloat = 3.0
        let borderWidth: CGFloat = 0.5

        let top: CGFloat = max(imgV.bottom, timeLabel.bottom)+14.0
        let width = (ScreenSize.width-4*margin)/3
        let height: CGFloat = designBy4_7Inch(30.0)

        let btnArr = [watchBtn, starBtn, forkBtn]

        for (index, btn) in btnArr.enumerated() {

            btn.imageView?.contentMode = .scaleAspectFit
            btn.imageEdgeInsets = imgEdgeInsets
            btn.layer.cornerRadius = cornerRadius
            btn.layer.masksToBounds = true
            btn.layer.borderColor = UIColor.bfRedColor.cgColor
            btn.layer.borderWidth = borderWidth
            btn.setTitleColor(UIColor.bfRedColor, for: UIControlState())
            btn.titleLabel?.font = UIFont.bfSystemFont(ofSize: 15.0)

            let left = CGFloat(index) * (width+margin) + margin
            btn.frame = CGRect(x: left, y: top, width: width, height: height)
        }

    }

    override func layoutSubviews() {
        super.layoutSubviews()

        var descT = nameLabel.bottom+2.0
        var descH = descLabel.requiredHeight(w:nameLabel.width)
        if descH > 47.0 {
            descH = 47.0
        }

        if descH < 18 {
            descT = nameLabel.bottom + 12.0
        } else if descH < 32 {
            descH = nameLabel.bottom + 8.0
        }

        descLabel.frame = CGRect(x: nameLabel.left, y: descT, width:nameLabel.width, height: descH)

        let timeT = imgV.bottom-16
        timeLabel.frame = CGRect(x: nameLabel.left, y: timeT, width: nameLabel.width, height: 21)

    }

    // MARK: - Data
    func rpv_fillData() {

        if let avatarUrl =  repo?.owner?.avatar_url {
            imgV.kf.setImage(with: URL(string: avatarUrl)!)
        }

        if let username = repo!.name {
            nameLabel.text = username
        }

        if let cdescription = repo!.cdescription {
            descLabel.text = cdescription
        }

        if let created_at = repo!.created_at {
            timeLabel.text = BFTimeHelper.shared.readableTime(rare: created_at, prefix: "created at")
        }

        self.setNeedsLayout()
    }

    // MARK: - Action
    @objc func rpv_watchAction() {
        if  self.reposActionDelegate != nil {
            self.reposActionDelegate!.watchReposAction()
        }

    }

     @objc func rpv_starAction() {
        if  self.reposActionDelegate != nil {
            self.reposActionDelegate!.starReposAction()
        }

    }

     @objc func rpv_forkAction() {
        if  self.reposActionDelegate != nil {
            self.reposActionDelegate!.forkReposAction()
        }

    }

}
