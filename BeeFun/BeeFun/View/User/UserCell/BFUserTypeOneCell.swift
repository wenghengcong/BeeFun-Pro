//
//  BFUserTypeOneCell.swift
//  BeeFun
//
//  Created by WengHengcong on 3/9/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

class BFUserTypeOneCell: BFBaseCell {

    @IBOutlet weak var noLabel: UILabel!

    @IBOutlet weak var avatarImgV: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var followBtn: UIButton!
    
    @IBOutlet weak var reposLabel: UILabel!
    
    //距离上：29
    @IBOutlet weak var repoTopToSupview: NSLayoutConstraint!
    //高：33
    @IBOutlet weak var repoHeight: NSLayoutConstraint!
    //13
    @IBOutlet weak var repoRight: NSLayoutConstraint!
    
    var userNo: Int? {
        didSet {
            noLabel.text = "\(userNo!+1)"
            self.setNeedsLayout()
        }
    }
    
    var followed: Bool = false

    var user: BFGithubTrengingModel? {
        didSet {
            fillDataToUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tdc_customView()
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - View
    func tdc_customView() {
        avatarImgV.layer.cornerRadius = 3.0
        avatarImgV.layer.masksToBounds = true
        
        followBtn.isHidden = true
        followBtn.backgroundColor = UIColor.white
        followBtn.addBorderAround(UIColor.bfRedColor, radius: 2.0, width: 1.0)
        followBtn.titleLabel?.font = UIFont.bfSystemFont(ofSize: 13.0)
        followBtn.setTitleColor(UIColor.bfRedColor, for: .normal)
        followBtn.setTitleColor(UIColor.bfRedColor, for: .highlighted)
        followBtn.addTarget(self, action: #selector(followSomeOneAction), for: .touchUpInside)
        
        noLabel.textColor = UIColor.iOS11Black
        noLabel.font = UIFont.largeSizeSystemFont()
        
        nameLabel.textColor = UIColor.iOS11Black
        nameLabel.font = UIFont.largeSizeSystemFont()
        nameLabel.adjustFontSizeToFitWidth(minScale: 0.5)
        
        reposLabel.font = .smallSizeSystemFont()
        reposLabel.textAlignment = .left
        reposLabel.numberOfLines = 2
        reposLabel.textColor = .iOS11Black
        reposLabel.backgroundColor = UIColor.clear
    
        let ges = UITapGestureRecognizer(target: self, action: #selector(gotoReposDetailAction))
        reposLabel.addGestureRecognizer(ges)
        //HCTODO: checkUserFollowed()
    }
    
    override func layoutSubviews() {
        if followBtn.isHidden {
            repoRight.constant = -followBtn.width
        } else {
            repoRight.constant = 13.0
        }
        let textH = reposLabel.text?.height(with: reposLabel.width, font: reposLabel.font)
        //16.33.42.57
        if textH! > CGFloat(20.0) {
            repoHeight.constant = 34.0
        } else {
            repoHeight.constant = 20.0
        }
        
    }
    
    // MARK: - Aciont
    @objc func followSomeOneAction() {
        if let login = user?.login {
            if followBtn.currentTitle == "Follow".localized {
                followSomeOne(login: login)
            } else {
                unFollowSomeOne(login: login)
            }
        }
    }
    
    @objc func gotoReposDetailAction() {
        let repos = ObjRepos()
        repos.name = user?.repo_name
        let objUser = ObjUser()
        objUser.login = user?.login
        repos.owner = objUser
        JumpManager.shared.jumpReposDetailView(repos: repos, from: .other)
    }
    
    // MARK: - Data
    func fillDataToUI() {
        if let avatarUrl = user?.user_avatar {
            avatarImgV.kf.setImage(with: URL(string: avatarUrl))
        }
        if let login = user?.login {
            if user?.login != nil {
                //HCTODO:
                //由于从html网页中解析出来的除英文外可能有乱码，所以，将name先不加上
                //let compose = login+name
                nameLabel.text = login
            } else {
                nameLabel.text = login
            }
        }
        
        if let repoName = user?.repo_name, let repoDesc = user?.repo_desc {
            let repo = repoName + "/" + repoDesc
            reposLabel.text = repo
        }
        
        if user?.login != nil && user?.repo_name != nil {
            reposLabel.isUserInteractionEnabled = true
        } else {
            reposLabel.isUserInteractionEnabled = false
        }
        
        /*
        if let follow = user!.trend_user_follow {
            if  UserManager.shared.isLogin {
                followBtn.isHidden = false
                followBtn.setTitle(follow, for: .normal)
                followBtn.setTitle(follow, for: .highlighted)
            } else {
                followBtn.isHidden = true
            }
        } else {
            followBtn.isHidden = true
        }
        */
        setNeedsDisplay()
    }
    
    // MARK: - Follow
    func checkUserFollowed() {
        if let login = user?.login {
            Provider.sharedProvider.request(.checkUserFollowing(username:login) ) { (result) -> Void in
                switch result {
                case let .success(response):
                    let statusCode = response.statusCode
                    if statusCode == BFStatusCode.noContent.rawValue {
                        self.followed = true
                    } else {
                        self.followed = false
                    }
                    self.updageFollowState()
                case .failure:
                    break
                }
            }
        }
    }
    
    func followSomeOne(login: String) {
        Provider.sharedProvider.request(.follow(username:login) ) { (result) -> Void in
            switch result {
            case let .success(response):
                let statusCode = response.statusCode
                if statusCode == BFStatusCode.noContent.rawValue {
                    self.followed = true
                    self.updageFollowState()
                }
            case .failure:
                break
            }
        }
    }
    
    func unFollowSomeOne(login: String) {
        Provider.sharedProvider.request(.unfollow(username:login) ) { (result) -> Void in
            switch result {
            case let .success(response):
                
                let statusCode = response.statusCode
                if statusCode == BFStatusCode.noContent.rawValue {
                    self.followed = false
                    self.updageFollowState()
                }
            case .failure:
                break
                
            }
        }
    }
    
    func updageFollowState() {
        //登录且关注
        if UserManager.shared.isLogin && followed {
            followBtn.isHidden = false
        } else {
            followBtn.isHidden = true
        }
        //关注时，显示取消关注
        if followed {
            followBtn.setTitle("Unfollow".localized, for: .normal)
            followBtn.setTitle("Unfollow".localized, for: .highlighted)
        } else {
            followBtn.setTitle("Follow".localized, for: .normal)
            followBtn.setTitle("Follow".localized, for: .highlighted)
        }
        
        setNeedsLayout()
    }
    
}
