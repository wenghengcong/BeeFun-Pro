//
//  BFUserTypeSecCell.swift
//  BeeFun
//
//  Created by WengHengcong on 04/07/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit

class BFUserTypeSecCell: BFBaseCell {
    
    @IBOutlet weak var noLabel: UILabel!
    
    @IBOutlet weak var avatarImgV: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var userNo: Int? {
        
        didSet {
            noLabel.text = "\(userNo!+1)"
            self.setNeedsLayout()
        }
        
    }
    
    var user: ObjUser? {
        didSet {
            if let avatarUrl = user?.avatar_url {
                avatarImgV.kf.setImage(with: URL(string: avatarUrl))
            }
            if let name = user?.login {
                nameLabel.text = name
            }
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
        //            noLabel.textColor = UIColor.bfRedColor
        //            nameLabel.textColor = UIColor.bfRedColor
        //
        //        }else{
        
        noLabel.textColor = UIColor.iOS11Black
        nameLabel.textColor = UIColor.iOS11Black
        //        }
        
        //        noLabel.sizeToFit()
        
    }

}
