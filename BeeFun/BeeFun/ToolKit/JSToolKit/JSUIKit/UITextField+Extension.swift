//
//  UITextField+Extension.swift
//  BeeFun
//
//  Created by WengHengcong on 16/07/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit

extension UITextField {

    /// 设置字体大小自适应
    ///
    /// - Parameter fontsize: 最小的字体大小
    func adjustFontSizeToFitWidth(minFont fontsize: CGFloat) {
        self.adjustsFontSizeToFitWidth = true
        self.minimumFontSize = fontsize
    }
}
