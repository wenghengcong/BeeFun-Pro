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

    @IBOutlet weak var avatarImgV: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var followerBtn: UIButton!
    @IBOutlet weak var reposBtn: UIButton!
    @IBOutlet weak var followingBtn: UIButton!
    
    var userActionDelegate:UserProfileActionProtocol?

    var developer:ObjUser?{
        didSet{
            div_fillData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        div_customView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    init(obj:ObjUser){
        super.init(frame:CGRectZero)
        self.developer = obj
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    func div_customView() {
        
        self.backgroundColor = UIColor.whiteColor()
        
        self.avatarImgV.layer.cornerRadius = avatarImgV.width/2
        self.avatarImgV.layer.masksToBounds = true

        self.nameLabel.textColor = UIColor.labelTitleTextColor()
        self.emailLabel.textColor = UIColor.labelTitleTextColor()
        
        let imgEdgeInsets1 = UIEdgeInsetsMake(0, -5, 0, 10)
        let borderWidth:CGFloat = 0.5
        
        let btnArr1:[UIButton] = [followerBtn,reposBtn,followingBtn]
        
        for btn in btnArr1 {
            btn.backgroundColor = UIColor.whiteColor()
            btn.imageEdgeInsets = imgEdgeInsets1
            btn.layer.borderColor = UIColor.lineBackgroundColor().CGColor
            btn.layer.borderWidth = borderWidth
            btn.setTitleColor(UIColor.cpRedColor(), forState: .Normal)
            btn.titleLabel?.numberOfLines = 0
            btn.titleLabel?.textAlignment = .Center
        }
        
        followerBtn.setTitle("0 \nFollower", forState: .Normal)
        followerBtn.addTarget(self, action: "div_followAction", forControlEvents: .TouchUpInside)

        reposBtn.setTitle("0 \nRepositories", forState: .Normal)
        reposBtn.addTarget(self, action: "div_reposAction", forControlEvents: .TouchUpInside)

        followingBtn.setTitle("0 \nFollowing", forState: .Normal)
        followingBtn.addTarget(self, action: "div_followingAction", forControlEvents: .TouchUpInside)

    }
    
    
    func div_fillData() {
        
        if let avatarUrl = developer!.avatar_url {
            avatarImgV.kf_setImageWithURL(NSURL(string: avatarUrl)!, placeholderImage: nil)
   
        }
        
        nameLabel.text = developer!.name
        
        if let email = developer!.email {
            emailLabel.hidden = false
            emailLabel.text = email
        }else{
            emailLabel.hidden = true
        }
        
        if let followerCount = developer!.followers {
            followerBtn.setTitle("\(followerCount) \nFollower", forState: .Normal)
        }
        
        if let reposCount = developer!.public_repos {
            reposBtn.setTitle("\(reposCount) \nRepositories", forState: .Normal)
        }
        
        if let followingCount = developer!.following {
            followingBtn.setTitle("\(followingCount) \nFollowing", forState: .Normal)
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
