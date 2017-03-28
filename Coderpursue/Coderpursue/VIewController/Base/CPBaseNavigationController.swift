//
//  CPBaseNavigationController.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/7.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit

class CPBaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func customView() {
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
}
