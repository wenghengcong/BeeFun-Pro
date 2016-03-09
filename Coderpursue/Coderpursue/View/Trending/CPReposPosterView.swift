//
//  CPReposPosterView.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/9/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit
import SwiftDate

class CPReposPosterView: UIView {

    @IBOutlet weak var imgV: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    
    @IBOutlet weak var watchBtn: UIButton!
    @IBOutlet weak var starBtn: UIButton!
    @IBOutlet weak var forkBtn: UIButton!

    var repo:ObjRepos? {
        didSet{
            rpc_fillData()
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
        
        watchBtn.imageView?.contentMode = .ScaleAspectFit
        watchBtn.imageEdgeInsets = imgEdgeInsets
        watchBtn.setImage(UIImage(named: "octicon_watch_red_20"), forState: .Normal)
        watchBtn.setTitle("Watch", forState: .Normal)
        watchBtn.layer.cornerRadius = cornerRadius
        watchBtn.layer.masksToBounds = true
        watchBtn.layer.borderColor = UIColor.cpRedColor().CGColor
        watchBtn.layer.borderWidth = borderWidth
        watchBtn.setTitleColor(UIColor.cpRedColor(), forState: .Normal)
        
        starBtn.imageView?.contentMode = .ScaleAspectFit
        starBtn.imageEdgeInsets = imgEdgeInsets
        starBtn.setImage(UIImage(named: "octicon_star_red_20"), forState: .Normal)
        starBtn.setTitle("Star", forState: .Normal)
        starBtn.layer.cornerRadius = cornerRadius
        starBtn.layer.masksToBounds = true
        starBtn.layer.borderColor = UIColor.cpRedColor().CGColor
        starBtn.layer.borderWidth = borderWidth
        starBtn.setTitleColor(UIColor.cpRedColor(), forState: .Normal)
        
        
        forkBtn.imageView?.contentMode = .ScaleAspectFit
        forkBtn.imageEdgeInsets = imgEdgeInsets
        forkBtn.setImage(UIImage(named: "octicon_fork_red_20"), forState: .Normal)
        forkBtn.setTitle("Fork", forState: .Normal)
        forkBtn.layer.cornerRadius = cornerRadius
        forkBtn.layer.masksToBounds = true
        forkBtn.layer.borderColor = UIColor.cpRedColor().CGColor
        forkBtn.layer.borderWidth = borderWidth
        forkBtn.setTitleColor(UIColor.cpRedColor(), forState: .Normal)
        
    }
    
    
    func rpc_fillData() {
        
        imgV.kf_setImageWithURL(NSURL(string: repo!.owner!.avatar_url!)!, placeholderImage: nil)
        nameLabel.text = repo!.name!
        descLabel.text = repo!.cdescription
        let createAt:NSDate = repo!.created_at!.toDate(DateFormat.ISO8601)!
        timeLabel.text = "created at: "+createAt.toString()!
        
        
    }

}
