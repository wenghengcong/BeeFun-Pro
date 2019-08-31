//
//  BFSwipeCell.swift
//  BeeFun
//
//  Created by WengHengcong on 20/06/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import SnapKit
import SwipeCellKit

class BFSwipeCell: SwipeTableViewCell {

    let topView: UIView = UIView()
    let botView: UIView = UIView()

    /**
     *  是否为完整的底部灰线
     */
    var fullBottomline: Bool?
    /**
     *  是否有顶部线条
     */
    var topline: Bool?
    
    static func cellFromNibNamed(_ nibName: String) -> AnyObject {
        
        var nibContents: Array = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)!
        let xibBasedCell = nibContents[0]
        return xibBasedCell as AnyObject
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        customCellView()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        customCellView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func customCellView() {
        botView.backgroundColor = UIColor.bfLineBackgroundColor
        self.contentView.addSubview(botView)
        let retinaPixelSize = 1
        botView.snp.remakeConstraints({ (make) -> Void in
            make.left.equalTo(10)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(retinaPixelSize)
        })
        
        topView.backgroundColor = UIColor.bfLineBackgroundColor
        topView.isHidden = true
        self.contentView.addSubview(topView)
        topView.snp.remakeConstraints({ (make) -> Void in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(0)
            make.height.equalTo(retinaPixelSize)
        })
    }
    
    func setBothEndsLines(_ current: Int, all rowsOfSection: Int) {
        self.topline = nil
        self.fullBottomline = nil
        
        if current == 0 {
            self.topline = true
        } else if current > 0 {
            self.topline = false
        }
        if rowsOfSection > 0 {
            if current == rowsOfSection-1 {
                self.fullBottomline = true
            } else {
                self.fullBottomline = false
            }
        }
        self.layoutSubFrames()
    }
    
    func layoutSubFrames() {

        if topline != nil {
            topView.isHidden = !(topline!)
        }
        
        if let fullBottom = fullBottomline {
            let retinaPixelSize: CGFloat = 0.5
            
            if fullBottom {
                botView.snp.remakeConstraints({ (make) -> Void in
                    make.left.equalTo(0)
                    make.right.equalTo(0)
                    make.bottom.equalTo(0.5)
                    make.height.equalTo(retinaPixelSize)
                })
                
            } else {
                botView.snp.remakeConstraints({ (make) -> Void in
                    make.left.equalTo(10)
                    make.right.equalTo(0)
                    make.bottom.equalTo(0.5)
                    make.height.equalTo(retinaPixelSize)
                })
            }
        }
    }
}
