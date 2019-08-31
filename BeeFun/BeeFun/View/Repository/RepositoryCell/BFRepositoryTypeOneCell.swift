//
//  BFRepositoryTypeOneCell.swift
//  BeeFun
//
//  Created by WengHengcong on 16/07/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit

@IBDesignable

/// 只用语Star项目中展示，会有star tag的显示

/// 无语言显示
class BFRepositoryTypeOneCell: BFBaseCell {
    
    @IBOutlet weak var logoImgV: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var starImgV: UIImageView!
    @IBOutlet weak var starNumLabel: UILabel!
    @IBOutlet weak var forkImgV: UIImageView!
    @IBOutlet weak var forkNumLabel: UILabel!
    
    @IBInspectable var titleColor: UIColor? = UIColor.iOS11Black {
        didSet {
            nameLabel?.textColor = titleColor
        }
    }
    @IBInspectable var subTitleColor: UIColor? = UIColor.bfLabelSubtitleTextColor {
        didSet {
            timeLabel?.textColor = subTitleColor
            starNumLabel?.textColor = subTitleColor
            forkNumLabel?.textColor = subTitleColor
            descLabel?.textColor = subTitleColor
        }
    }
    
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
        
        nameLabel.font = UIFont.largeSizeSystemFont()
        
        descLabel.font = UIFont.middleSizeSystemFont()
        
        timeLabel.font = UIFont.smallSizeSystemFont()
        timeLabel.adjustFontSizeToFitWidth(minScale: 0.5)
        
        starNumLabel.font = UIFont.smallSizeSystemFont()
        starNumLabel.adjustFontSizeToFitWidth(minScale: 0.5)
        
        forkNumLabel.font = UIFont.smallSizeSystemFont()
        forkNumLabel.adjustFontSizeToFitWidth(minScale: 0.5)
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
        if let push_at = objRepos?.starred_at {
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
        
        if let allTags = objRepos?.star_tags {
            var allBtns: [UIButton] = []
            for (index, tag) in allTags.enumerated() {
                let tagB = UIButton()
                tagB.tag = index
                tagB.setTitle(tag, for: .normal)
                tagB.setTitleColor(UIColor.black, for: .normal)
                tagB.setTitleColor(UIColor.bfRedColor, for: .selected)
                tagB.titleLabel?.font = UIFont.bfSystemFont(ofSize: 12.0)
                tagB.radius = 10.0
                tagB.borderWidth = 1.0/UIScreen.main.scale
                tagB.tag = index
                //按钮不可点击
                tagB.isUserInteractionEnabled = false
                allBtns.append(tagB)
                self.contentView.addSubview(tagB)
            }
            
            var lastF = CGRect.zero
            let btnY: CGFloat = forkNumLabel.y
            var btnX = forkNumLabel.x+forkNumLabel.width+10
            
            /// 按钮内部两边的间距宽度
            let btnInsideMargin: CGFloat = 15
            let btnOutsideMargin: CGFloat = 3.0
            
            let lineH: CGFloat = 30
            /// 按钮的高度
            let btnH: CGFloat = 20
            var btnW: CGFloat = 0

            for (index, btn) in allBtns.enumerated() {
                if let tagsTitle = btn.currentTitle {
                    btnW = tagsTitle.width(with: lineH, font: btn.titleLabel!.font) + btnInsideMargin
                }
                
                if index == 0 {
                    btnX = ScreenSize.width-btnW-10
                } else {
                    lastF = allBtns[index-1].frame
                    btnX = lastF.x - btnOutsideMargin - btnW
                }
                if btnX >= forkNumLabel.x+15 {
                    let nowF = CGRect(x: btnX, y: btnY, w: btnW, h: btnH)
                    btn.frame = nowF
                }

            }
        }

    }
    
}
