//
//  CPTrendingDeveloperCell.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/9/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

class CPTrendingDeveloperCell: CPBaseViewCell {

    @IBOutlet weak var noLabel: UILabel!
    
    @IBOutlet weak var avatarImgV: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var userNo:Int? {
        
        didSet{
            noLabel.text = "\(userNo!+1)"
            self.setNeedsLayout()
        }
        
    }
    
    var user:ObjUser? {
        
        didSet{
            
            avatarImgV.kf.setImage(with: URL(string: (user!.avatar_url!))!)
            nameLabel.text = user!.login
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tdc_customView()
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
    
    func tdc_customView() {
        
        avatarImgV.layer.cornerRadius = avatarImgV.width/2
        avatarImgV.layer.masksToBounds = true
        
//        noLabel.backgroundColor = UIColor.blueColor
        
    }
    
    override func layoutSubviews() {
        
//        if(userNo < 3){
//            
//            noLabel.textColor = UIColor.cpRedColor
//            nameLabel.textColor = UIColor.cpRedColor
//            
//        }else{
        
            noLabel.textColor = UIColor.cpBlackColor
            nameLabel.textColor = UIColor.cpBlackColor
//        }
        
//        noLabel.sizeToFit()
        
    }

}
