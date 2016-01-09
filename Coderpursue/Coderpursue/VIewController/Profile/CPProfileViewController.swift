//
//  CPProfileViewController.swift
//  Coderpursue
//
//  Created by wenghengcong on 15/12/30.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

import UIKit

class CPProfileViewController: CPBaseViewController {

    @IBOutlet weak var pvc_loginBtn: UIButton!
    
    @IBOutlet weak var pvc_editProfileBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        pvc_addButtonTarget()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pvc_addButtonTarget() {
        pvc_editProfileBtn.addTarget(self, action: "pvc_editProfileAction:", forControlEvents: .TouchUpInside)
        pvc_loginBtn.addTarget(self, action: "pvc_loginAction:", forControlEvents: .TouchUpInside)

    }
    
    func pvc_editProfileAction(sender:UIButton!) {
    }
    
    func pvc_loginAction(sender:UIButton) {
        
        let loginVC = CPWebViewController()
        loginVC.url = "m.hao123.com"
        loginVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(loginVC, animated: true)

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
