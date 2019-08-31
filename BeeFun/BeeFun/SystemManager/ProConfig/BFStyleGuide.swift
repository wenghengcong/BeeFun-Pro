//
//  BFStyleGuide.swift
//  BeeFun
//
//  Created by wenghengcong on 16/1/6.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import Foundation
import UIKit

class BFStyleGuide {

    class func textFieldPlaceholderAttributes() -> [NSAttributedStringKey: AnyObject] {

        let font = UIFont.middleSizeSystemFont()
        let color = UIColor.iOS11MidGray

        return [
            NSAttributedStringKey.font: font,
            NSAttributedStringKey.foregroundColor: color
        ]
    }

    class func textFieldTextAttributes() -> [NSAttributedStringKey: AnyObject] {

        let font = UIFont.largeSizeSystemFont()
        let color = UIColor.iOS11Black

        return [
            NSAttributedStringKey.font: font,
            NSAttributedStringKey.foregroundColor: color
        ]
    }

    class func navTitleTextAttributes() -> [NSAttributedStringKey: AnyObject] {

        let font = UIFont.hugeSizeSystemFont()
        let color = UIColor.iOS11White
        return [
            NSAttributedStringKey.font: font,
            NSAttributedStringKey.foregroundColor: color
        ]
    }

}
