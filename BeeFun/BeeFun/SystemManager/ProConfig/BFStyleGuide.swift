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

    class func textFieldPlaceholderAttributes() -> [NSAttributedString.Key: Any] {

        let font = UIFont.middleSizeSystemFont()
        let color = UIColor.iOS11MidGray

        return [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ]
    }

    class func textFieldTextAttributes() -> [NSAttributedString.Key: Any] {

        let font = UIFont.largeSizeSystemFont()
        let color = UIColor.iOS11Black

        return [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ]
    }

    class func navTitleTextAttributes() -> [NSAttributedString.Key: Any] {

        let font = UIFont.hugeSizeSystemFont()
        let color = UIColor.iOS11White
        return [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ]
    }

}
