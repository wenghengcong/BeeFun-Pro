//
//  CPBaseTabBarController.swift
//  Coderpursue
//
//  Created by wenghengcong on 15/12/30.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

import UIKit

class CPBaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customView()
    }
    
    func customView() {
        self.tabBar.barTintColor = UIColor.tabBarBackgroundColor()  //背景色
        self.tabBar.tintColor = UIColor.tabBarTitleTextColor()//文字颜色
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
