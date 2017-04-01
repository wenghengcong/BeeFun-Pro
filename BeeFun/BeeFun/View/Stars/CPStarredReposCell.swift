//
//  CPStarredReposCell.swift
//  BeeFun
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
            
            if let avatarURl = objRepos!.owner!.avatar_url {
                
                logoImgV.kf.setImage(with: URL(string:avatarURl)!)
            }
            
            nameLabel.text = objRepos!.name!
            descLabel.text = objRepos!.cdescription
            
            timeLabel.text = TimeHelper.shared.readableTime(rare: objRepos!.updated_at, prefix: nil)

            starNumLabel.text = "\(objRepos!.stargazers_count!)"
            forkNumLabel.text = "\(objRepos!.forks_count!)"
            
            if let lan = objRepos!.language {
                langLabel.text = "\(lan)"
            }
            

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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func src_customView() {
        
        logoImgV.layer.cornerRadius = logoImgV.width/2
        logoImgV.layer.masksToBounds = true
        
        nameLabel.textColor = UIColor.labelTitleTextColor
        nameLabel.font = UIFont.largeSizeSystemFont()
        
        descLabel.textColor = UIColor.labelSubtitleTextColor
        descLabel.font = UIFont.middleSizeSystemFont()
        
        timeLabel.textColor = UIColor.labelSubtitleTextColor
        timeLabel.font = UIFont.smallSizeSystemFont()
        
        starNumLabel.textColor = UIColor.labelSubtitleTextColor
        starNumLabel.font = UIFont.smallSizeSystemFont()
        
        forkNumLabel.textColor = UIColor.labelSubtitleTextColor
        forkNumLabel.font = UIFont.smallSizeSystemFont()
        
        langLabel.textColor = UIColor.labelSubtitleTextColor
        langLabel.font = UIFont.smallSizeSystemFont()
        
    }
    
}
