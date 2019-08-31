//
//  CPDeveloperInfoView.swift
//  BeeFun
//
//  Created by WengHengcong on 3/10/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

protocol UserProfileActionProtocol: class {

    func viewFollowAction()
    func viewReposAction()
    func viewFollowingAction()

}

class CPDeveloperInfoView: UIView {

    var avatarImgV: UIImageView = UIImageView()
    var nameLabel: UILabel = UILabel()
    var emailLabel: UILabel = UILabel()

    var followerBtn: UIButton = UIButton()
    var reposBtn: UIButton = UIButton()
    var followingBtn: UIButton = UIButton()

    weak var userActionDelegate: UserProfileActionProtocol?

    var developer: ObjUser? {
        didSet {
            div_fillData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        div_customView()
    }

    init(obj: ObjUser) {
        super.init(frame: CGRect.zero)
        self.developer = obj
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }

    func div_customView() {

        addSubview(avatarImgV)
        addSubview(nameLabel)
        addSubview(emailLabel)
        addSubview(followerBtn)
        addSubview(reposBtn)
        addSubview(followingBtn)

        backgroundColor = UIColor.white

        let imgW: CGFloat = 70.0
        let imgX: CGFloat = (ScreenSize.width-imgW)/2.0
        self.avatarImgV.layer.cornerRadius = imgW/2
        self.avatarImgV.layer.masksToBounds = true

        avatarImgV.frame = CGRect(x: imgX, y: 16.0, width: imgW, height: imgW)

        nameLabel.frame = CGRect(x: 0, y: avatarImgV.bottom+6.0, width: ScreenSize.width, height: 21.0)
        nameLabel.font = UIFont.bfSystemFont(ofSize: 19.0)
        nameLabel.textColor = UIColor.iOS11Black
        nameLabel.textAlignment = .center

        emailLabel.frame = CGRect(x: 0, y: nameLabel.bottom+5.0, width: ScreenSize.width, height: 21.0)
        emailLabel.font = UIFont.bfSystemFont(ofSize: 14.0)
        emailLabel.textColor = UIColor.iOS11Black
        emailLabel.textAlignment = .center

        let imgEdgeInsets1 = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 10)
        let borderWidth: CGFloat = 0.5

        let btnY = emailLabel.bottom+8.0
        let btnW = ScreenSize.width/3.0
        let btnH: CGFloat = 36.0

        let btnArr1: [UIButton] = [followerBtn, reposBtn, followingBtn]

        for (index, btn) in btnArr1.enumerated() {
            let btnX = btnW*CGFloat(index)
            btn.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
            btn.titleLabel?.font = UIFont.bfSystemFont(ofSize: 12.0)
            btn.backgroundColor = UIColor.white
            btn.imageEdgeInsets = imgEdgeInsets1
            btn.layer.borderColor = UIColor.bfLineBackgroundColor.cgColor
            btn.layer.borderWidth = borderWidth
            btn.setTitleColor(UIColor.bfRedColor, for: UIControlState())
            btn.titleLabel?.numberOfLines = 0
            btn.titleLabel?.textAlignment = .center
        }

        followerBtn.setTitle("0 \n"+"Follower".localized, for: UIControlState())
        followerBtn.addTarget(self, action: #selector(CPDeveloperInfoView.div_followAction), for: .touchUpInside)

        reposBtn.setTitle("0 \n"+"Repositories".localized, for: UIControlState())
        reposBtn.addTarget(self, action: #selector(CPDeveloperInfoView.div_reposAction), for: .touchUpInside)

        followingBtn.setTitle("0 \n"+"Following".localized, for: UIControlState())
        followingBtn.addTarget(self, action: #selector(CPDeveloperInfoView.div_followingAction), for: .touchUpInside)

    }

    func div_fillData() {

        if let avatarUrl = developer!.avatar_url {
            avatarImgV.kf.setImage(with: URL(string: avatarUrl)!)
        }

        nameLabel.text = developer!.name

        if let email = developer!.email {
            emailLabel.isHidden = false
            emailLabel.text = email
        } else {
            emailLabel.isHidden = true
        }

        if let followerCount = developer!.followers {
            followerBtn.setTitle("\(followerCount) \n"+"Follower".localized, for: UIControlState())
        }

        if let reposCount = developer!.public_repos {
            reposBtn.setTitle("\(reposCount) \n"+"Repositories".localized, for: UIControlState())
        }

        if let followingCount = developer!.following {
            followingBtn.setTitle("\(followingCount) \n"+"Following".localized, for: UIControlState())
        }

    }

    @objc func div_followAction() {
        if let followerCount = developer!.followers {
            if followerCount == 0 {
                return
            }
        }
        if  self.userActionDelegate != nil {
            self.userActionDelegate!.viewFollowAction()
        }

    }

    @objc func div_reposAction() {
        if let reposCount = developer!.public_repos {
            if reposCount == 0 {
                return
            }
        }
        if  self.userActionDelegate != nil {
            self.userActionDelegate!.viewReposAction()
        }

    }

    @objc func div_followingAction() {
        if let followingCount = developer!.following {
            if followingCount == 0 {
                return
            }
        }
        if  self.userActionDelegate != nil {
            self.userActionDelegate!.viewFollowingAction()
        }

    }

}
