//
//  CPProfileReposCell.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/11/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit
import SwiftDate

class CPProfileReposCell: CPBaseViewCell {

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
            logoImgV.kf.setImage(with: URL(string: objRepos!.owner!.avatar_url!)!, placeholder: nil, options: .transition(.fade(1)), progressBlock: nil, completionHandler: nil)
            nameLabel.text = objRepos!.name!
            descLabel.text = objRepos!.cdescription
            let updateAt:Date = objRepos!.pushed_at!.toDate(format: DateFormat.iso8601Format(.full))!
            
            timeLabel.text = updateAt.toString(style: .colloquial)
            starNumLabel.text = "\(objRepos!.stargazers_count!)"
            forkNumLabel.text = "\(objRepos!.forks_count!)"
            if let lan = objRepos!.language {
                langLabel.text = "\(lan)"
            }        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        prc_customView()
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
    
    func prc_customView() {
        
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
