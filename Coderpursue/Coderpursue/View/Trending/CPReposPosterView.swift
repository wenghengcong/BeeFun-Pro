//
//  CPReposPosterView.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/9/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit
import SwiftDate

protocol ReposActionProtocol {
    
    func watchReposAction()
    func starReposAction()
    func forkReposAction()
    
}

class CPReposPosterView: UIView {

    @IBOutlet weak var imgV: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    
    @IBOutlet weak var watchBtn: UIButton!
    @IBOutlet weak var starBtn: UIButton!
    @IBOutlet weak var forkBtn: UIButton!

    var reposActionDelegate:ReposActionProtocol?
    
    var repo:ObjRepos? {
        didSet{
            rpc_fillData()
        }
    }
    
    var watched:Bool?{
        didSet{
            if(watched!){
                watchBtn.setTitle("Unwatch", forState: .Normal)
                watchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10)

            }else{
                watchBtn.setTitle("Watch", forState: .Normal)
                watchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 10)

            }
        }
    }
    
    var stared:Bool?{
        didSet{
            if(stared!){
                starBtn.setTitle("Unstar", forState: .Normal)
            }else{
                starBtn.setTitle("Star", forState: .Normal)
            }
        }

    }

    override func awakeFromNib() {
        super.awakeFromNib()
        rpv_customView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    init(obj:ObjRepos){
        super.init(frame:CGRectZero)
        self.repo = obj
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }

    
    func rpv_customView() {
        
        self.backgroundColor = UIColor.hexStr("#e8e8e8", alpha: 1.0)
        nameLabel.textColor = UIColor.blackColor()
        descLabel.textColor = UIColor.darkGrayColor()
        timeLabel.textColor = UIColor.darkGrayColor()
        
        let imgEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 10)
        let cornerRadius:CGFloat = 5.0
        let borderWidth:CGFloat = 0.5
        
        let btnArr = [watchBtn,starBtn,forkBtn]
        
        for btn in btnArr {
            
            btn.imageView?.contentMode = .ScaleAspectFit
            btn.imageEdgeInsets = imgEdgeInsets
            btn.layer.cornerRadius = cornerRadius
            btn.layer.masksToBounds = true
            btn.layer.borderColor = UIColor.cpRedColor().CGColor
            btn.layer.borderWidth = borderWidth
            btn.setTitleColor(UIColor.cpRedColor(), forState: .Normal)
            
        }
        watchBtn.setImage(UIImage(named: "octicon_watch_red_20"), forState: .Normal)
        watchBtn.setTitle("Watch", forState: .Normal)
        watchBtn.addTarget(self, action: "rpc_watchAction", forControlEvents: .TouchUpInside)

        starBtn.setImage(UIImage(named: "octicon_star_red_20"), forState: .Normal)
        starBtn.setTitle("Star", forState: .Normal)
        starBtn.addTarget(self, action: "rpc_starAction", forControlEvents: .TouchUpInside)

        forkBtn.setImage(UIImage(named: "octicon_fork_red_20"), forState: .Normal)
        forkBtn.setTitle("Fork", forState: .Normal)
        forkBtn.addTarget(self, action: "rpc_forkAction", forControlEvents: .TouchUpInside)

    }
    
    
    func rpc_fillData() {
        
        if let avatarUrl =  repo!.owner!.avatar_url {
            imgV.kf_setImageWithURL(NSURL(string: avatarUrl)!, placeholderImage: nil)
        }
        
        if let username = repo!.name {
            nameLabel.text = username
        }
        
        if let cdescription = repo!.cdescription {
            descLabel.text = cdescription
        }
        
        if let created_at = repo!.created_at {
            let createAt:NSDate = created_at.toDate(DateFormat.ISO8601)!
            timeLabel.text = "created at: "+createAt.toString()!
        }
        
        
    }
    
    func rpc_watchAction() {
        if( self.reposActionDelegate != nil ){
            self.reposActionDelegate!.watchReposAction()
        }
        
    }
    
    func rpc_starAction() {
        if( self.reposActionDelegate != nil ){
            self.reposActionDelegate!.starReposAction()
        }
        
    }
    
    func rpc_forkAction() {
        if( self.reposActionDelegate != nil ){
            self.reposActionDelegate!.forkReposAction()
        }
        
    }
    

}
