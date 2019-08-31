//
//  BFRepositoryTypeThirdCell.swift
//  BeeFun
//
//  Created by wenghengcong on 16/1/30.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit


/// 用于在showcase中的项目展示

/// 有图片，有语言显示
class BFRepositoryTypeThirdCell: BFBaseCell {

    @IBOutlet weak var logoImgV: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var descLabel: UILabel!

    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var starImgV: UIImageView!

    @IBOutlet weak var starNumLabel: UILabel!

    @IBOutlet weak var forkImgV: UIImageView!

    @IBOutlet weak var forkNumLabel: UILabel!

    @IBOutlet weak var langLabel: UILabel!

    var objRepos: ObjRepos? {
        didSet {
            src_fillDataToUI()
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
        
        nameLabel.textColor = UIColor.iOS11Black
        nameLabel.font = UIFont.largeSizeSystemFont()
        
        descLabel.textColor = UIColor.bfLabelSubtitleTextColor
        descLabel.font = UIFont.middleSizeSystemFont()
        
        timeLabel.textColor = UIColor.bfLabelSubtitleTextColor
        timeLabel.font = UIFont.smallSizeSystemFont()
        timeLabel.adjustFontSizeToFitWidth(minScale: 0.5)

        starNumLabel.textColor = UIColor.bfLabelSubtitleTextColor
        starNumLabel.font = UIFont.smallSizeSystemFont()
        starNumLabel.adjustFontSizeToFitWidth(minScale: 0.5)

        forkNumLabel.textColor = UIColor.bfLabelSubtitleTextColor
        forkNumLabel.font = UIFont.smallSizeSystemFont()
        timeLabel.adjustFontSizeToFitWidth(minScale: 0.5)

        langLabel.textColor = UIColor.bfLabelSubtitleTextColor
        langLabel.font = UIFont.smallSizeSystemFont()
        langLabel.adjustFontSizeToFitWidth(minScale: 0.5)

    }
    
    func src_fillDataToUI() {
        if let avatarUrl = objRepos?.owner?.avatar_url {
            if let url = URL(string: avatarUrl) {
                logoImgV.kf.setImage(with: url)
            }
        }
        
        if let name = objRepos!.name {
            nameLabel.text = name
        }
        if let desc = objRepos?.cdescription {
            descLabel.text = desc
        }
        if let push_at = objRepos?.pushed_at {
            timeLabel.text = BFTimeHelper.shared.readableTime(rare: push_at, prefix: nil)
        } else if let showcaseUpdate = objRepos?.trending_showcase_update_text {
            timeLabel.text = showcaseUpdate
        }
        if let starCount = objRepos?.stargazers_count {
            starNumLabel.text = "\(starCount)"
        } else if let trend_star = objRepos?.trending_star_text {
            starNumLabel.text = trend_star
        } else {
            starNumLabel.text = "0"
        }
        
        if let forkNum = objRepos!.forks_count {
            forkNumLabel.text = "\(forkNum)"
        } else if let trend_fork = objRepos?.trending_fork_text {
            forkNumLabel.text = trend_fork
        } else {
            forkNumLabel.text = "0"
        }
        
        if let lan = objRepos!.language {
            langLabel.text = "\(lan)"
        } else {
            langLabel.text = "Unknown".localized
        }
    }

}
