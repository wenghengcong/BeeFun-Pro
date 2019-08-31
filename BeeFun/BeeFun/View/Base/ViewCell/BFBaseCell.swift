//
//  BFBaseCell.swift
//  BeeFun
//
//  Created by wenghengcong on 16/1/17.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit

class BFBaseCell: UITableViewCell {

    var topLineView: UIView?
    var botLineView: UIView?
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
        p_customCellView()
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        p_customCellView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func p_customCellView() {
        if botLineView == nil {
            botLineView = UIView()
            botLineView?.backgroundColor = UIColor.bfLineBackgroundColor
            self.contentView.addSubview(botLineView!)
        }
        let retinaPixelSize: CGFloat = 1
        botLineView?.frame = CGRect(x: 10, y: self.contentView.height-retinaPixelSize, w: ScreenSize.width-10, h: retinaPixelSize)
        
        if topLineView == nil {
            topLineView = UIView()
            topLineView?.backgroundColor = UIColor.bfLineBackgroundColor
            topLineView?.frame = CGRect(x: 0, y: 0, w: ScreenSize.width, h: retinaPixelSize)
            self.contentView.addSubview(topLineView!)
            topLineView?.isHidden = true
        }
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
            topLineView?.isHidden = !(topline!)
        }
        
        if let fullBottom = fullBottomline {
            let retinaPixelSize: CGFloat = 0.5
            
            if fullBottom {
                botLineView?.frame = CGRect(x: 0, y: self.contentView.height-retinaPixelSize, w: ScreenSize.width, h: retinaPixelSize)
            } else {
                botLineView?.frame = CGRect(x: 10, y: self.contentView.height-retinaPixelSize, w: ScreenSize.width-10, h: retinaPixelSize)
            }
        }
        
    }
}
