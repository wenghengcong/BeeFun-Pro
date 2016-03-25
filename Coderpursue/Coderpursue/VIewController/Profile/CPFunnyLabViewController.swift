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
        self.navigationController!.navigationBar.topItem?.title = ""
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Funny Lab"
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

    @IBAction func lag_getAward(sender: AnyObject) {
        
        var awardUrl = ""
        
        if let username = lab_awardNameTf.text {
            awardUrl = "http://github-awards.com/users/search?login=\(username)"
        }else{
            CPGlobalHelper.sharedInstance.showMessage("Input your github username", view: self.view)
            return
        }
        
        let awardVC = CPWebViewController()
        
        awardVC.url = awardUrl
        
        self.navigationController?.pushViewController(awardVC, animated: true)
        
    }
    
}
