//
//  CPPersonCardView.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/4/14.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

protocol PersonCardViewActionProtocol: class {
    func userLoginAction()
    func editMyProfileAction()
    func viewMyReposAction()
    func viewMyFollowerAction()
    func viewMyFollowingAction()
}

class CPPersonCardView: UIButton {

    var avatarImgView: UIImageView = UIImageView()
    var nameLabel: UILabel = UILabel()
    var bioLabel: UILabel = UILabel()
//    var blogButton:UIButton = UIButton()
    var loginButton: UIButton = UIButton()
    var editButton: UIButton = UIButton()

    var reposButton: UIButton = UIButton()
    var followerButton: UIButton = UIButton()
    var followingButton: UIButton = UIButton()

    var user: ObjUser? {
        didSet {
            pc_fillData()
        }
    }

    weak var delegate: PersonCardViewActionProtocol?

    override init(frame: CGRect) {
        super.init(frame: frame)
        pc_customeView()
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    convenience init(obj: ObjUser) {
        self.init(frame: CGRect.zero)
        self.user = obj
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func pc_customeView() {

        self.addSubview(avatarImgView)
        self.addSubview(nameLabel)
        self.addSubview(bioLabel)
//        self.addSubview(blogButton)
        self.addSubview(loginButton)
        self.addSubview(editButton)
        self.addSubview(reposButton)
        self.addSubview(followerButton)
        self.addSubview(followingButton)

        avatarImgView.radius = 35

        nameLabel.textColor = UIColor.black

        bioLabel.textColor = UIColor.bfLabelSubtitleTextColor
        bioLabel.font = UIFont.bfSystemFont(ofSize: 13.0)

//        blogButton.setTitleColor(UIColor.blue, for: .normal)
//        blogButton.setTitleColor(UIColor.blue, for: .highlighted)
//        blogButton.contentHorizontalAlignment = .left
//        blogButton.titleLabel?.font = UIFont.bfSystemFont(ofSize: 13.0)

//        editButton.backgroundColor = UIColor.brown
        editButton.addBorderAround(UIColor.bfRedColor, radius: 2.0, width: 1.0)
        editButton.setTitle("Edit".localized, for: .normal)
        editButton.setTitle("Edit".localized, for: .highlighted)
        editButton.titleLabel?.font = UIFont.bfSystemFont(ofSize: 14.0)
        editButton.setTitleColor(UIColor.bfRedColor, for: .normal)
        editButton.setTitleColor(UIColor.bfRedColor, for: .highlighted)
        editButton.addTarget(self, action: #selector(pc_eidtAction), for: .touchUpInside)

        loginButton.addBorderAround(UIColor.bfRedColor, radius: 1.0, width: 1.0)
        loginButton.setTitle("Sign in".localized, for: .normal)
        loginButton.setTitle("Sign in".localized, for: .highlighted)
        loginButton.titleLabel?.font = UIFont.bfSystemFont(ofSize: 16.0)
        loginButton.setTitleColor(UIColor.bfRedColor, for: .normal)
        loginButton.setTitleColor(UIColor.bfRedColor, for: .highlighted)
        loginButton.addTarget(self, action: #selector(pc_loginAction), for: .touchUpInside)

        let loginW: CGFloat = 200
        let loginX = UIView.xSpace(width: loginW)
        let loginY: CGFloat = 40
        let loginH: CGFloat = 40
        loginButton.frame = CGRect(x: loginX, y: loginY, w: loginW, h: loginH)

        let avaX: CGFloat = 20
        let avaW: CGFloat = 70
        let avaY: CGFloat = 20
        avatarImgView.frame = CGRect(x: avaX, y: avaY, w: avaW, h: avaW)

        //
        let editRightSpace: CGFloat = 10
        let editW: CGFloat = 50
        let editX = ScreenSize.width-editW-editRightSpace
        editButton.frame = CGRect(x: editX, y: avaY+15, w: editW, h: 25)

        let nameX = avatarImgView.right + 10
        let nameW = ScreenSize.width-nameX-editRightSpace-editW
        nameLabel.frame = CGRect(x: nameX, y: avaY, w: nameW, h: 30)

        bioLabel.frame = CGRect(x: nameX, y: nameLabel.bottom, w: nameW, h: 30)

//        let blogW:CGFloat = ScreenSize.width-avaX-editRightSpace
//        blogButton.frame = CGRect(x: avaX, y: avatarImgView.bottom+10, w: blogW, h: 30)

        let btns = [reposButton, followerButton, followingButton]
        let btnW = ScreenSize.width/3.0
        let btnY = avatarImgView.bottom + 15
        let btnH: CGFloat = 37

        for (index, btn) in btns.enumerated() {
            let x = CGFloat(index) * btnW
            btn.titleLabel?.lineBreakMode = .byCharWrapping
            btn.titleLabel?.textAlignment = .center
            btn.addBorderAroundInOnePixel(UIColor.bfLineBackgroundColor)
            btn.setTitleColor(UIColor.bfLabelSubtitleTextColor, for: .normal)
            btn.setTitleColor(UIColor.bfLabelSubtitleTextColor, for: .highlighted)
            btn.titleLabel?.font = UIFont.bfSystemFont(ofSize: 13.0)
            btn.frame = CGRect(x: x, y: btnY, w: btnW, h: btnH)
        }

        reposButton.addTarget(self, action: #selector(pc_reposAction(_:)), for: .touchUpInside)
        followerButton.addTarget(self, action: #selector(pc_followAction(_:)), for: .touchUpInside)
        followingButton.addTarget(self, action: #selector(pc_followingAction(_:)), for: .touchUpInside)

    }

    func pc_fillData() {
        let isLoingin: Bool = UserManager.shared.isLogin

        avatarImgView.isHidden = !isLoingin
        nameLabel.isHidden = !isLoingin
        bioLabel.isHidden = !isLoingin
//        blogButton.isHidden = !isLoingin
        editButton.isHidden = !isLoingin

        loginButton.isHidden = isLoingin

        if let avatarUrl = user?.avatar_url {
            avatarImgView.kf.setImage(with: URL(string: avatarUrl)!)
        }

        if let name = user?.name {
            nameLabel.text = name
        } else {
            if let userLogin = UserManager.shared.login {
                nameLabel.text = userLogin
            } else {
                if let email = user?.email {
                    nameLabel.text = email
                }
            }
        }

        if let bio = user?.bio {
            bioLabel.text = bio
        }

//            if let blog = user?.blog {
//                let blogTitle = "Blog:"+blog
//                blogButton.setTitle(blogTitle, for: .normal)
//                blogButton.setTitle(blogTitle, for: .highlighted)
//            }

        let blackAttribute = [NSAttributedStringKey.foregroundColor: UIColor.iOS11Black]

        //
        var repos = "0 \n"+"Repositories".localized
        if let privateReposCount = user?.total_private_repos {

            if let publicReposCount = user?.public_repos {
                let reposCount = privateReposCount + publicReposCount
                repos = String("\(reposCount) \n") + "Repositories".localized
            } else {
                repos = String("\(privateReposCount) \n") + "Repositories".localized
            }
        } else {
            if let publicReposCount = user?.public_repos {
                repos = String("\(publicReposCount) \n") + "Repositories".localized
            }
        }

        let repoAttribute = NSMutableAttributedString(string: repos, attributes: blackAttribute)
        repoAttribute.setSubstringColor("Repositories".localized, color: UIColor.bfLabelSubtitleTextColor)

        reposButton.setAttributedTitle(repoAttribute, for: .normal)
        reposButton.setAttributedTitle(repoAttribute, for: .highlighted)

        var followers = "0 \n"+"Followers".localized
        if let followerCount = user?.followers {
            followers = String("\(followerCount) \n") + "Followers".localized
        }
        let followerAttribute = NSMutableAttributedString(string: followers, attributes: blackAttribute)
        followerAttribute.setSubstringColor("Followers".localized, color: UIColor.bfLabelSubtitleTextColor)

        followerButton.setAttributedTitle(followerAttribute, for: .normal)
        followerButton.setAttributedTitle(followerAttribute, for: .highlighted)

        //
        var following = "0 \n"+"Following".localized
        if let followingCount = user?.following {
            following = String("\(followingCount) \n") + "Following".localized
        }
        let followingAttribute = NSMutableAttributedString(string: following, attributes: blackAttribute)
        followingAttribute.setSubstringColor("Following".localized, color: UIColor.bfLabelSubtitleTextColor)

        followingButton.setAttributedTitle(followingAttribute, for: .normal)
        followingButton.setAttributedTitle(followingAttribute, for: .highlighted)

    }

}

extension CPPersonCardView {

    @objc func pc_loginAction() {
        DispatchQueue.main.async {
            self.delegate?.userLoginAction()
        }
    }

    @objc func pc_eidtAction() {
        DispatchQueue.main.async {
            self.delegate?.editMyProfileAction()
        }
    }

    @objc func pc_followAction(_ sender: UITapGestureRecognizer) {
        if let followerCount = user?.followers {
            if followerCount == 0 || !UserManager.shared.isLogin {
                return
            }
        }
        DispatchQueue.main.async {
            self.delegate?.viewMyFollowerAction()
        }
    }

    @objc func pc_reposAction(_ sender: UITapGestureRecognizer) {
        if let reposCount = user?.public_repos {
            if reposCount == 0 || !UserManager.shared.isLogin {
                return
            }
        }
        DispatchQueue.main.async {
            self.delegate?.viewMyReposAction()
        }
    }

    @objc func pc_followingAction(_ sender: UITapGestureRecognizer) {
        if let followingCount = user?.following {
            if followingCount == 0 || !UserManager.shared.isLogin {
                return
            }
        }
        if self.delegate != nil {
            self.delegate!.viewMyFollowingAction()
        }

    }

}
