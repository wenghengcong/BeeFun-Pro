//
//  CPProfileHeaderView.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/17/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

protocol ProfileHeaderActionProtocol {
    
    func userLoginAction()
    func viewMyReposAction()
    func viewMyFollowerAction()
    func viewMyFollowingAction()
    
}

class CPProfileHeaderView: UIView {

//    @IBOutlet weak var profileBgV: UIView!
    
    @IBOutlet weak var phv_backImgV: UIImageView!
    @IBOutlet weak var phv_avatarImgV: UIImageView!
    @IBOutlet weak var phv_nameLabel: UILabel!
    @IBOutlet weak var phv_emailLabel: UIButton!
    @IBOutlet weak var phv_loginBtn: UIButton!
    @IBOutlet weak var phv_editProfileBtn: UIButton!
    
    @IBOutlet weak var reposBgV: UIView!
    @IBOutlet weak var followerBgV: UIView!
    @IBOutlet weak var followingBgV: UIView!
    
    @IBOutlet weak var phv_numOfReposLabel: UILabel!
    @IBOutlet weak var phv_numOfFollwerLabel: UILabel!
    @IBOutlet weak var phv_numOfFollowingLabel: UILabel!
    
    @IBOutlet weak var phv_reposLabel: UILabel!
    @IBOutlet weak var phv_followersLabel: UILabel!
    @IBOutlet weak var phv_followingLabel: UILabel!
    
    var profileActionDelegate:ProfileHeaderActionProtocol?

    var user:ObjUser?{
        didSet{
            phv_fillData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        phv_customView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    init(obj:ObjUser){
        super.init(frame:CGRectZero)
        self.user = obj
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    func phv_customView() {
        
        self.backgroundColor = UIColor.whiteColor()
        
        phv_avatarImgV.layer.cornerRadius = phv_avatarImgV.width/2
        phv_avatarImgV.layer.masksToBounds = true
        
        phv_nameLabel.textColor = UIColor.whiteColor()
        phv_emailLabel.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        phv_emailLabel.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        
        phv_loginBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        phv_loginBtn.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        phv_loginBtn.addTarget(self, action: "phv_loginAction", forControlEvents: .TouchUpInside)
        phv_loginBtn.backgroundColor = UIColor.clearColor()
        phv_loginBtn.titleLabel?.font = UIFont.systemFontOfSize(25.0)
        phv_loginBtn.setTitle("Sign   In", forState: .Normal)
//        phv_editProfileBtn.addTarget(self, action: "phv_editProfileAction:", forControlEvents: .TouchUpInside)
        
        phv_numOfReposLabel.textColor = UIColor.labelTitleTextColor()
        phv_reposLabel.textColor = UIColor.labelSubtitleTextColor()
        
        phv_numOfFollwerLabel.textColor = UIColor.labelTitleTextColor()
        phv_followersLabel.textColor = UIColor.labelSubtitleTextColor()
        
        phv_numOfFollowingLabel.textColor = UIColor.labelTitleTextColor()
        phv_followingLabel.textColor = UIColor.labelSubtitleTextColor()
        
        //add border to sperator three columns
        reposBgV.addOnePixelAroundBorder(UIColor.lineBackgroundColor())
        reposBgV.userInteractionEnabled = true
        followerBgV.addOnePixelAroundBorder(UIColor.lineBackgroundColor())
        followerBgV.userInteractionEnabled = true
        followingBgV.addOnePixelAroundBorder(UIColor.lineBackgroundColor())
        followingBgV.userInteractionEnabled = true
        
        let reposGes = UITapGestureRecognizer(target: self, action: "phv_reposAction:")
        self.reposBgV.addGestureRecognizer(reposGes)
        
        let followGes = UITapGestureRecognizer(target: self, action: "phv_followAction:")
        self.followerBgV.addGestureRecognizer(followGes)
        
        let followingGes = UITapGestureRecognizer(target: self, action: "phv_followingAction:")
        self.followingBgV.addGestureRecognizer(followingGes)
        
    }
    
    
    func phv_fillData() {
        
        let isLoingin:Bool = UserInfoHelper.sharedInstance.isLoginIn
        phv_avatarImgV.hidden = !isLoingin
        phv_nameLabel.hidden = !isLoingin
        phv_emailLabel.hidden = !isLoingin
        
        //        self.pvc_editProfileBtn.hidden = !isLoingin
//        phv_editProfileBtn.hidden = true
        phv_loginBtn.hidden = isLoingin
        
        if(isLoingin){
            
            if let avatarUrl = user?.avatar_url {
                phv_avatarImgV.kf_setImageWithURL(NSURL(string: avatarUrl)!, placeholderImage: nil)
            }
            phv_nameLabel.text = user?.name
            if let email = user?.email {
                phv_emailLabel.setTitle(email, forState: .Normal)
            }else{
                phv_emailLabel.setTitle("", forState: .Normal)
            }
            
            if let followerCount = user?.followers {
                phv_numOfFollwerLabel.text = String("\(followerCount)")
            }
            if let reposCount = user?.public_repos {
                phv_numOfReposLabel.text = String("\(reposCount)")
            }
            if let followingCount = user?.following {
                phv_numOfFollowingLabel.text = String("\(followingCount)")
            }
            
        }else{
            
            phv_emailLabel.setTitle("", forState: .Normal)
            phv_numOfReposLabel.text = "0"
            phv_numOfFollowingLabel.text = "0"
            phv_numOfFollwerLabel.text = "0"
        }
        
    }
    
    func phv_loginAction() {
        
        if( self.profileActionDelegate != nil ){
            self.profileActionDelegate!.userLoginAction()
        }
        
    }
    
    func phv_followAction(sender: UITapGestureRecognizer) {
        if let followerCount = user?.followers {
            if(followerCount == 0){
                return
            }
        }
        if( self.profileActionDelegate != nil ){
            self.profileActionDelegate!.viewMyFollowerAction()
        }
        
    }
    
    func phv_reposAction(sender: UITapGestureRecognizer) {
        if let reposCount = user?.public_repos {
            if(reposCount == 0){
                return
            }
        }
        if( self.profileActionDelegate != nil ){
            self.profileActionDelegate!.viewMyReposAction()
        }
        
    }
    
    
    func phv_followingAction(sender: UITapGestureRecognizer) {
        if let followingCount = user?.following {
            if(followingCount == 0){
                return
            }
        }
        if( self.profileActionDelegate != nil ){
            self.profileActionDelegate!.viewMyFollowingAction()
        }
        
    }

}
