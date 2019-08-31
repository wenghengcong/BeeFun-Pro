//
//  BFRepositoryTypeFourCell.swift
//  BeeFun
//
//  Created by WengHengcong on 3/8/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper

class BFRepositoryTypeFourCell: BFBaseCell {

    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var descLabel: UILabel!

    @IBOutlet weak var starImgV: UIImageView!

    @IBOutlet weak var starNumLabel: UILabel!

    @IBOutlet weak var forkImgV: UIImageView!

    @IBOutlet weak var forkNumLabel: UILabel!

    @IBOutlet weak var langLabel: UILabel!

    @IBOutlet weak var trendStarLabel: UILabel!
    
    @IBOutlet weak var starBtn: UIButton!
    
    @IBOutlet weak var descRight: NSLayoutConstraint!
    
    @IBOutlet weak var nameRight: NSLayoutConstraint!
    
    var objRepos: BFGithubTrengingModel? {

        didSet {
            
            if let name = objRepos!.repo_name {
                nameLabel.text = name
            }
            descLabel.text = objRepos!.repo_desc
            if let starCount = objRepos!.star_num {
                starNumLabel.text = "\(starCount)"
            } else {
                starNumLabel.text = "0"
            }
            if let forkNum = objRepos!.fork_num {
                forkNumLabel.text = "\(forkNum)"
            } else {
                forkNumLabel.text = "0"
            }
            
            if let lan = objRepos!.language {
                langLabel.text = "\(lan)"
            } else {
                langLabel.text = "Unknown".localized
            }
            
            if let trend = objRepos?.up_star_num {
                trendStarLabel.text = "\(trend)"
            } else {
                trendStarLabel.text = ""
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
        
//        starBtn.isHidden = !UserManager.shared.isLogin
        starBtn.isHidden = true
        starBtn.backgroundColor = UIColor.white
        starBtn.addBorderAround(UIColor.bfRedColor, radius: 2.0, width: 1.0)
        starBtn.setTitle("Star".localized, for: .normal)
        starBtn.setTitle("Star".localized, for: .highlighted)
        starBtn.titleLabel?.font = UIFont.bfSystemFont(ofSize: 14.0)
        starBtn.setTitleColor(UIColor.bfRedColor, for: .normal)
        starBtn.setTitleColor(UIColor.bfRedColor, for: .highlighted)
        starBtn.addTarget(self, action: #selector(starReposAction), for: .touchUpInside)
    
        nameLabel.textColor = UIColor.iOS11Black
        nameLabel.font = UIFont.largeSizeSystemFont()

        descLabel.textColor = UIColor.bfLabelSubtitleTextColor
        descLabel.font = UIFont.smallSizeSystemFont()
        descLabel.numberOfLines = 0
        
        starNumLabel.textColor = UIColor.bfLabelSubtitleTextColor
        starNumLabel.font = UIFont.smallSizeSystemFont()
        starNumLabel.adjustFontSizeToFitWidth(minScale: 0.5)
        
        forkNumLabel.textColor = UIColor.bfLabelSubtitleTextColor
        forkNumLabel.font = UIFont.smallSizeSystemFont()
        forkNumLabel.adjustFontSizeToFitWidth(minScale: 0.5)
        
        langLabel.textColor = UIColor.bfLabelSubtitleTextColor
        langLabel.textAlignment = .left
        langLabel.font = UIFont.smallSizeSystemFont()
        langLabel.adjustFontSizeToFitWidth(minScale: 0.5)
        
        trendStarLabel.textColor = UIColor.bfLabelSubtitleTextColor
        trendStarLabel.font = UIFont.smallSizeSystemFont()
        trendStarLabel.adjustFontSizeToFitWidth(minScale: 0.5)

        setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        nameRight.constant = -starBtn.width
        descRight.constant = -starBtn.width
    }
    
    @objc func starReposAction() {
        if let login = objRepos?.login, let repoName = objRepos?.repo_name {
            Provider.sharedProvider.request(.starRepo(owner:login, repo:repoName) ) { (result) -> Void in
                switch result {
                case let .success(response):
                    let statusCode = response.statusCode
                    if statusCode == BFStatusCode.noContent.rawValue {
                        //Star成功
                    } else {
                    }
                case .failure:
                    break
                }
            }
        }
    }
}
