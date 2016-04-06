//
//  CPSearchViewController.swift
//  Coderpursue
//
//  Created by WengHengcong on 4/6/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

class CPSearchViewController: CPBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func svc_initNavBar() {
        
        
        
    }
    
    override func leftItemAction(sender: UIButton?) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
