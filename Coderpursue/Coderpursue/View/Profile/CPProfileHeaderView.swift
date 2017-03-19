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
        super.init(frame:CGRect.zero)
        self.user = obj
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    func phv_customView() {
        
        self.backgroundColor = UIColor.white
        
        phv_backImgV.image = UIImage.init(named: "profile_bg")
        
        phv_avatarImgV.layer.cornerRadius = phv_avatarImgV.width/2
        phv_avatarImgV.layer.masksToBounds = true
        
        phv_nameLabel.textColor = UIColor.white
        phv_emailLabel.setTitleColor(UIColor.white, for: UIControlState())
        phv_emailLabel.setTitleColor(UIColor.white, for: .highlighted)
        
        phv_loginBtn.setTitleColor(UIColor.white, for: UIControlState())
        phv_loginBtn.setTitleColor(UIColor.white, for: .highlighted)
        phv_loginBtn.addTarget(self, action: #selector(CPProfileHeaderView.phv_loginAction), for: .touchUpInside)
        phv_loginBtn.backgroundColor = UIColor.clear
        phv_loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 25.0)
        phv_loginBtn.setTitle("Sign In".localized, for: UIControlState())
//        phv_editProfileBtn.addTarget(self, action: "phv_editProfileAction:", forControlEvents: .TouchUpInside)
        
        phv_numOfReposLabel.textColor = UIColor.labelTitleTextColor
        phv_reposLabel.textColor = UIColor.labelSubtitleTextColor
        
        phv_numOfFollwerLabel.textColor = UIColor.labelTitleTextColor
        phv_followersLabel.textColor = UIColor.labelSubtitleTextColor
        
        phv_numOfFollowingLabel.textColor = UIColor.labelTitleTextColor
        phv_followingLabel.textColor = UIColor.labelSubtitleTextColor
        
        //add border to sperator three columns
        reposBgV.addOnePixelAroundBorder(UIColor.lineBackgroundColor)
        reposBgV.isUserInteractionEnabled = true
        followerBgV.addOnePixelAroundBorder(UIColor.lineBackgroundColor)
        followerBgV.isUserInteractionEnabled = true
        followingBgV.addOnePixelAroundBorder(UIColor.lineBackgroundColor)
        followingBgV.isUserInteractionEnabled = true
        
        let reposGes = UITapGestureRecognizer(target: self, action: #selector(CPProfileHeaderView.phv_reposAction(_:)))
        self.reposBgV.addGestureRecognizer(reposGes)
        
        let followGes = UITapGestureRecognizer(target: self, action: #selector(CPProfileHeaderView.phv_followAction(_:)))
        self.followerBgV.addGestureRecognizer(followGes)
        
        let followingGes = UITapGestureRecognizer(target: self, action: #selector(CPProfileHeaderView.phv_followingAction(_:)))
        self.followingBgV.addGestureRecognizer(followingGes)
        
    }
    
    
    func phv_fillData() {
        
        let isLoingin:Bool = UserManager.shared.isLogin
        phv_avatarImgV.isHidden = !isLoingin
        phv_nameLabel.isHidden = !isLoingin
        phv_emailLabel.isHidden = !isLoingin
        
        //        self.pvc_editProfileBtn.hidden = !isLoingin
//        phv_editProfileBtn.hidden = true
        phv_loginBtn.isHidden = isLoingin
        
        if(isLoingin){
            
            if let avatarUrl = user?.avatar_url {
                phv_avatarImgV.kf.setImage(with: URL(string: avatarUrl)!)
            }
            
            phv_nameLabel.text = user?.name
            if let email = user?.email {
                phv_emailLabel.setTitle(email, for: UIControlState())
            }else{
                phv_emailLabel.setTitle("", for: UIControlState())
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
            
            phv_emailLabel.setTitle("", for: UIControlState())
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
    
    func phv_followAction(_ sender: UITapGestureRecognizer) {
        if let followerCount = user?.followers {
            if(followerCount == 0){
                return
            }
        }
        if( self.profileActionDelegate != nil ){
            self.profileActionDelegate!.viewMyFollowerAction()
        }
        
    }
    
    func phv_reposAction(_ sender: UITapGestureRecognizer) {
        if let reposCount = user?.public_repos {
            if(reposCount == 0){
                return
            }
        }
        if( self.profileActionDelegate != nil ){
            self.profileActionDelegate!.viewMyReposAction()
        }
        
    }
    
    
    func phv_followingAction(_ sender: UITapGestureRecognizer) {
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
