//
//  CPTrendingShowcaseCell.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/8/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit
import Kingfisher

class CPTrendingShowcaseCell: CPBaseViewCell {
    
    @IBOutlet weak var bgImageV: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descBgView: UIView!
    
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var bottomLineV: UIView!
    
    var showcase:ObjShowcase? {
        
        didSet {
            if let imgagUrl = showcase!.image_url {
                let url = URL(string: imgagUrl)
                self.bgImageV.kf.setImage(with: url)
            }
            nameLabel.text = showcase!.name!
            descLabel.text = showcase!.cdescription
        
        }

    }
 
    override func customCellView() {
    
        self.bgImageV.backgroundColor = UIColor.clear
        
        nameLabel.textColor = UIColor.white
        
        descBgView.backgroundColor = UIColor.hex("#f7f7f7", alpha: 1.0)
        descLabel.numberOfLines = 0
        descLabel.textColor = UIColor.hex("#333333", alpha: 1.0)
        
        bottomLineV.backgroundColor = UIColor.lineBackgroundColor

    }
}
