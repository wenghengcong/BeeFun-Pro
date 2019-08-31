//
//  BFShowcaseHeaderView.swift
//  BeeFun
//
//  Created by WengHengcong on 05/07/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit

/// 实现xib方式一: 
/*
 1. 不要填写File‘s’ Owner,填写对应Custom Class
 2. 实现loadViewFromNib方法，返回一个视图
 3. 其他实现一致
 */

/*
 1. 填写填写File‘s’ Owner,不要填写对应Custom Class
 2. 实现
 */
class BFShowcaseHeaderView: UIView {
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customView()
    }
    
    static func loadViewFromNib() -> BFShowcaseHeaderView {
        var nibContents: Array = Bundle.main.loadNibNamed("BFShowcaseHeaderView", owner: self, options: nil)!
        let xibBasedCell = nibContents[0]
        return xibBasedCell as! BFShowcaseHeaderView
    }
    
    func customView() {
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
}
