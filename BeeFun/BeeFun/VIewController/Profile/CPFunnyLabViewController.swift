//
//  CPFunnyLabViewController.swift
//  BeeFun
//
//  Created by WengHengcong on 3/25/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

class CPFunnyLabViewController: CPBaseViewController {

    @IBOutlet weak var lab_awardNameTf: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Funny Lab"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func leftItemAction(_ sender: UIButton?) {
        _ = self.navigationController?.popViewController(animated: true)
    }

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
            // TODO: localized
            JSMBHUDBridge.showMessage("Input your github username", view: self.view)
            return
        }
        

        
    }
    
    
}
