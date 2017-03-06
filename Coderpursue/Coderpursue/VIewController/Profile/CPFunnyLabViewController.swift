//
//  CPFunnyLabViewController.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/25/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

class CPFunnyLabViewController: CPBaseViewController {

    @IBOutlet weak var lab_awardNameTf: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Funny Lab"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func leftItemAction(_ sender: UIButton?) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func lag_getAward(_ sender: AnyObject) {
        
        let userDefault = UserDefaults.standard
        
        var awardUrl = ""
//      auth url: github-awards.com/auth/github
        if let username = lab_awardNameTf.text {
            
            let firstNeedAuth = userDefault.object(forKey: "\(username)needauth")
            
            if ( firstNeedAuth == nil ){
                awardUrl = "http://github-awards.com/auth/github"
            }else{
                awardUrl = "http://github-awards.com/users/search?login=\(username)"
            }
            
            let awardVC = CPFunnyAwardViewController()
            awardVC.username = username
            awardVC.url = awardUrl
            
            self.navigationController?.pushViewController(awardVC, animated: true)
            
        }else{
            CPGlobalHelper.showMessage("Input your github username", view: self.view)
            return
        }
        

        
    }
    
    
}
