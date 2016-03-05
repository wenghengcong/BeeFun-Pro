//
//  CPStarredReposCell.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/30.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit
import SwiftDate

class CPStarredReposCell: CPBaseViewCell {
    
    @IBOutlet weak var logoImgV: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    @IBOutlet weak var starImgV: UIImageView!
    
    @IBOutlet weak var starNumLabel: UILabel!
    
    @IBOutlet weak var forkImgV: UIImageView!
    
    @IBOutlet weak var forkNumLabel: UILabel!
    
    @IBOutlet weak var langLabel: UILabel!
    
    var objRepos:ObjRepos? {
        
        didSet {
            logoImgV.kf_setImageWithURL(NSURL(string: objRepos!.owner!.avatar_url!)!, placeholderImage: nil)
            nameLabel.text = objRepos!.name!
            descLabel.text = objRepos!.cdescription
            let updateAt:NSDate = objRepos!.pushed_at!.toDate(DateFormat.ISO8601)!
            
            timeLabel.text = updateAt.toRelativeString(abbreviated: false, maxUnits:1)!+" ago"
            starNumLabel.text = "\(objRepos!.stargazers_count!)"
            forkNumLabel.text = "\(objRepos!.forks_count!)"
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        src_customView()
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func src_customView() {
        
        logoImgV.layer.cornerRadius = logoImgV.width/2
        logoImgV.layer.masksToBounds = true
        
        nameLabel.textColor = UIColor.labelTitleTextColor()
        nameLabel.font = UIFont.largeSizeSystemFont()
        
        descLabel.textColor = UIColor.labelSubtitleTextColor()
        descLabel.font = UIFont.middleSizeSystemFont()
        
        timeLabel.textColor = UIColor.labelSubtitleTextColor()
        timeLabel.font = UIFont.smallSizeSystemFont()
        
        starNumLabel.textColor = UIColor.labelSubtitleTextColor()
        starNumLabel.font = UIFont.smallSizeSystemFont()
        
        forkNumLabel.textColor = UIColor.labelSubtitleTextColor()
        forkNumLabel.font = UIFont.smallSizeSystemFont()
        
        langLabel.textColor = UIColor.labelSubtitleTextColor()
        langLabel.font = UIFont.smallSizeSystemFont()
        
    }
    
}
