//
//  CPDeveloperInfoView.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/10/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit


protocol UserProfileActionProtocol {
    
    func viewFollowAction()
    func viewReposAction()
    func viewFollowingAction()
    
}

class CPDeveloperInfoView: UIView {

    var avatarImgV: UIImageView = UIImageView.init()
    var nameLabel: UILabel = UILabel.init()
    var emailLabel: UILabel = UILabel.init()
    
    var followerBtn: UIButton = UIButton.init()
    var reposBtn: UIButton = UIButton.init()
    var followingBtn: UIButton = UIButton.init()
    
    var userActionDelegate:UserProfileActionProtocol?

    var developer:ObjUser?{
        didSet{
            div_fillData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        div_customView()
    }
    
    init(obj:ObjUser){
        super.init(frame:CGRect.zero)
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
        
        let imgW:CGFloat = 70.0
        let imgX:CGFloat = (ScreenSize.width-imgW)/2.0
        self.avatarImgV.layer.cornerRadius = imgW/2
        self.avatarImgV.layer.masksToBounds = true
        
        avatarImgV.frame = CGRect.init(x: imgX, y: 16.0, width: imgW, height: imgW)
        
        nameLabel.frame = CGRect.init(x: 0, y: avatarImgV.bottom+6.0, width: ScreenSize.width, height: 21.0)
        nameLabel.font = UIFont.systemFont(ofSize: 19.0)
        nameLabel.textColor = UIColor.labelTitleTextColor
        nameLabel.textAlignment = .center

        emailLabel.frame = CGRect.init(x: 0, y: nameLabel.bottom+5.0, width: ScreenSize.width, height: 21.0)
        emailLabel.font = UIFont.systemFont(ofSize: 14.0)
        emailLabel.textColor = UIColor.labelTitleTextColor
        emailLabel.textAlignment = .center
        
        let imgEdgeInsets1 = UIEdgeInsetsMake(0, -5, 0, 10)
        let borderWidth:CGFloat = 0.5
        
        let btnY = emailLabel.bottom+8.0
        let btnW = ScreenSize.width/3.0
        let btnH:CGFloat = 36.0
        
        let btnArr1:[UIButton] = [followerBtn,reposBtn,followingBtn]
        
        for (index,btn) in btnArr1.enumerated() {
            let btnX = btnW*CGFloat(index);
            btn.frame = CGRect.init(x: btnX, y: btnY, width: btnW, height: btnH)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
            btn.backgroundColor = UIColor.white
            btn.imageEdgeInsets = imgEdgeInsets1
            btn.layer.borderColor = UIColor.lineBackgroundColor.cgColor
            btn.layer.borderWidth = borderWidth
            btn.setTitleColor(UIColor.cpRedColor, for: UIControlState())
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
        }else{
            emailLabel.isHidden = true
        }
        
        if let followerCount = developer!.followers {
            followerBtn.setTitle("\(followerCount) \nFollower", for: UIControlState())
        }
        
        if let reposCount = developer!.public_repos {
            reposBtn.setTitle("\(reposCount) \nRepositories", for: UIControlState())
        }
        
        if let followingCount = developer!.following {
            followingBtn.setTitle("\(followingCount) \nFollowing", for: UIControlState())
        }

    }
    
    func div_followAction() {
        if let followerCount = developer!.followers {
            if(followerCount == 0){
                return
            }
        }
        if( self.userActionDelegate != nil ){
            self.userActionDelegate!.viewFollowAction()
        }
        
    }
    
    func div_reposAction() {
        if let reposCount = developer!.public_repos {
            if(reposCount == 0){
                return
            }
        }
        if( self.userActionDelegate != nil ){
            self.userActionDelegate!.viewReposAction()
        }
        
    }
    
    
    func div_followingAction() {
        if let followingCount = developer!.following {
            if(followingCount == 0){
                return
            }
        }
        if( self.userActionDelegate != nil ){
            self.userActionDelegate!.viewFollowingAction()
        }
        
    }
    

}
