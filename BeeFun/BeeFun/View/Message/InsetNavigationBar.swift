//
//  InsetButtonsNavigationBar.swift
//  BeeFun
//
//  Created by WengHengcong on 13/10/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit

class InsetNavigationBar: UINavigationBar {
    override func layoutSubviews() {
        super.layoutSubviews()
        for view in subviews {
            // Setting the layout margins to 0 lines the bar buttons items up at
            // the edges of the screen. You can set this to any number to change
            // the spacing.
            view.layoutMargins = .zero
        }
    }
}
