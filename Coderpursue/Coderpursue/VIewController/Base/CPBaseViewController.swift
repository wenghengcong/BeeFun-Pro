//
//  CPBaseViewController.swift
//  Coderpursue
//
//  Created by wenghengcong on 15/12/30.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

import UIKit

class CPBaseViewController: UIViewController {

    var needDoWork = false
    var topOffset: CGFloat = 64.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customView()
    }
    
    func customView() {
        self.view.backgroundColor = UIColor.viewBackgroundColor()
        //下面语句添加在CPBaseNavigationController中无效
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationBarBackgroundColor()
        self.navigationController?.navigationBar.titleTextAttributes = CPStyleGuide.navTitleTextAttributes()
        //返回按钮颜色与文字
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem?.title = ""  //no change
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}


extension CPBaseViewController : NavigationControllerBackButtonDelegate {
    
    func navigationShouldPopOnBackButton() -> Bool {
        print("back button pressed")
        if needDoWork {
            navBack()
            return false
        }
        return true
    }
    
    func navBack() {
        print("do something")

    }
}

