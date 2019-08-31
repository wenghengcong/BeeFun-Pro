//
//  AddTagsCell.swift
//  BeeFun
//
//  Created by WengHengcong on 02/06/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit

class AddTagsCell: BFBaseCell {
    
    @IBOutlet weak var textLbl: UILabel!
    @IBOutlet weak var addImageV: UIImageView!
    
    var showtext: String? {
        didSet {
            textLbl.text = showtext
        }
    }
    
    override func p_customCellView() {
        super.p_customCellView()
        let w: CGFloat = 20
        let y = (self.height-w)/2
        addImageV.frame = CGRect(x: 10, y: y, w: w, h: w)
        let txtX = addImageV.right + 15
        textLbl.frame = CGRect(x: txtX, y: 0, w: ScreenSize.width-txtX, h: self.height)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
    }
}
