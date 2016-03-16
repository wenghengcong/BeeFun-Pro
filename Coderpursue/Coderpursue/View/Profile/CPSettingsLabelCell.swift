//
//  CPSettingsLabelCell.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/16/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

class CPSettingsLabelCell: CPBaseViewCell {
    
    @IBOutlet weak var setTitleLabel: UILabel!
    
    @IBOutlet weak var discolsureImgV: UIImageView!
    
    @IBOutlet weak var setValueLabel: UILabel!
    
    var objSettings:ObjSettings? {
        
        didSet {
            
            setTitleLabel.text = objSettings?.itemName
            if ( (objSettings?.itemDisclosure)! ) {
                discolsureImgV.hidden = false
            }else {
                discolsureImgV.hidden = true
            }
            
            if let rightValue = objSettings!.itemValue{
                setValueLabel.text = rightValue
            }else{
                setValueLabel.text = ""
            }
            
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        plc_customView()
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
    
    func plc_customView(){
        
        discolsureImgV.image = UIImage.init(named: "arrow_right")
        
    }

}
