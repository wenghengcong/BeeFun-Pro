//
//  JSView.swift
//  LoveYou
//
//  Created by WengHengcong on 2016/11/11.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit

extension UIView {
    
    static func cellFromNib(name nibName:String) -> AnyObject{
        
        var nibContents:Array = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)!
        let xib = nibContents[0]
        return xib as AnyObject
    }
}

