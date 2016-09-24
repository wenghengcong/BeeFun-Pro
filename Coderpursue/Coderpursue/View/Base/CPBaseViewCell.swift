//
//  CPBaseViewCell.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/17.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit
import SnapKit

class CPBaseViewCell: UITableViewCell {
    
    /**
    *  是否为完整的底部灰线
    */
    var fullline:Bool? {
        didSet {
            let retinaPixelSize = 1.0 / (UIScreen.main.scale)
            let botView:UIView = UIView()
            botView.backgroundColor = UIColor.lineBackgroundColor()
            self.addSubview(botView)
            
            if (fullline!) {
                botView.snp_remakeConstraints({ (make) -> Void in
                    make.left.equalTo(0)
                    make.right.equalTo(0)
                    make.bottom.equalTo(0)
                    make.height.equalTo(retinaPixelSize)
                })
            }else {
                botView.snp_remakeConstraints({ (make) -> Void in
                    make.left.equalTo(10)
                    make.right.equalTo(0)
                    make.bottom.equalTo(0)
                    make.height.equalTo(retinaPixelSize)
                })
            }
        }
    }
    /**
    *  是否有顶部线条
    */
    var topline:Bool? {
        didSet {
            
            let retinaPixelSize = 1.0 / (UIScreen.main.scale)
            if (topline != nil) {
                let topView:UIView = UIView()
                topView.backgroundColor = UIColor.lineBackgroundColor()
                self.addSubview(topView)
                topView.snp_remakeConstraints({ (make) -> Void in
                    make.left.equalTo(0)
                    make.right.equalTo(0)
                    make.top.equalTo(0)
                    make.height.equalTo(retinaPixelSize)
                })
            }
        }
    }
    
    static func cellFromNibNamed(_ nibName:String) -> AnyObject{
        
        var nibContents:Array = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        let xibBasedCell = nibContents[0]
        return xibBasedCell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        customCellView()
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
    
    func customCellView(){
        
    }

}
