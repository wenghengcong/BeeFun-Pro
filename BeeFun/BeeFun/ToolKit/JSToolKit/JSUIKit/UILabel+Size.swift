//
//  UILabel+Size.swift
//  LoveYou
//
//  Created by WengHengcong on 2017/3/10.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

extension UILabel {
    
    /// UILabel文本的高度：宽度是UILabel中原有的宽度
    var requiredHeight: CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = self.font
        label.text = self.text
        label.sizeToFit()
        return label.frame.height
    }

    /// UILabel文本的高度
    ///
    /// - Parameter width: 宽度
    func requiredHeight(w: CGFloat) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: w, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = self.font
        label.text = self.text
        label.sizeToFit()
        return label.frame.height

    }
    
    /// UILabel文本的宽度：宽度是UILabel中原有的高度
    var requiredWidth: CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: .greatestFiniteMagnitude, height:height ))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = self.font
        label.text = self.text
        label.sizeToFit()
        return label.frame.width
    }
    
    /// UILabel文本的宽度
    ///
    /// - Parameter width: 高度
    func requiredWidth(h: CGFloat) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: .greatestFiniteMagnitude, height:h ))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = self.font
        label.text = self.text
        label.sizeToFit()
        return label.frame.width
        
    }
}
