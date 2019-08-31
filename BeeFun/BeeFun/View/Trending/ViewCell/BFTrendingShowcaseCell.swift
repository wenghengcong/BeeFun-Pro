//
//  BFTrendingShowcaseCell.swift
//  BeeFun
//
//  Created by WengHengcong on 3/8/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit
import Kingfisher

class BFTrendingShowcaseCell: BFBaseCell {

    @IBOutlet weak var bgImageV: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var descLabel: UILabel!

    @IBOutlet weak var bottomLineV: UIView!

    @IBOutlet weak var repoLabel: UILabel!
    
    @IBOutlet weak var langLabel: UILabel!
    
    var showcase: ObjShowcase? {
        didSet {
            fillDataToUI()
        }
    }

    override func p_customCellView() {
        super.p_customCellView()
        contentView.backgroundColor = UIColor.bfViewBackgroundColor
        
        bgImageV.backgroundColor = UIColor.clear
        bgImageV.image = UIImage(color: UIColor.clear)

        nameLabel.textColor = UIColor.iOS11Black
        nameLabel.font = UIFont.bfSystemFont(ofSize: 20.0)
        nameLabel.adjustFontSizeToFitWidth(minScale: 0.5)

        descLabel.numberOfLines = 0
        descLabel.font = UIFont.middleSizeSystemFont()
        descLabel.textColor = UIColor.hex("#111111", alpha: 1.0)

        repoLabel.textColor = UIColor.bfLabelSubtitleTextColor
        repoLabel.textAlignment = .left
        repoLabel.font = UIFont.smallSizeSystemFont()
        repoLabel.adjustFontSizeToFitWidth(minScale: 0.5)
        
        langLabel.textColor = UIColor.bfLabelSubtitleTextColor
        langLabel.textAlignment = .left
        langLabel.font = UIFont.smallSizeSystemFont()
        langLabel.adjustFontSizeToFitWidth(minScale: 0.5)
        
        bottomLineV.backgroundColor = UIColor.bfLineBackgroundColor

    }
    
    func fillDataToUI() {
        
        if let name = showcase?.name {
            nameLabel.text = name
        }
        
        if let desc = showcase?.cdescription {
            descLabel.text = desc
        }
        
        if let reponame = showcase?.trend_repo_text {
            repoLabel.text = reponame
        }
        
        if let lan = showcase?.trend_lan_text {
            langLabel.text = lan
        }
        setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        
    }
    
}
