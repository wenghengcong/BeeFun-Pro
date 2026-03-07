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
        // iOS now throws if we mutate layout margins on private nav bar subviews.
        // Keep customization on the public UINavigationBar instance only.
        layoutMargins = .zero
    }
}
