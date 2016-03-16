//
//  CPSettingsCell.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/17.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit

class CPSettingsCell: CPBaseViewCell {

    @IBOutlet weak var iconImgV: UIImageView!
    
    @IBOutlet weak var setTitleLabel: UILabel!
    
    @IBOutlet weak var discolsureImgV: UIImageView!
    
    var objSettings:ObjSettings? {
        
        didSet {
            iconImgV.image = UIImage.init(named: (objSettings?.itemIcon)!)
            setTitleLabel.text = objSettings?.itemName
            if ( (objSettings?.itemDisclosure)! ) {
                discolsureImgV.hidden = false
            }else {
                discolsureImgV.hidden = true
            }
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cpc_customView()
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cpc_customView(){
        discolsureImgV.image = UIImage.init(named: "arrow_right")

    }

}
