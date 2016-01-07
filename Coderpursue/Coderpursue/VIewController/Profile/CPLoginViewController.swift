//
//  CPLoginViewController.swift
//  Coderpursue
//
//  Created by wenghengcong on 15/12/30.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

import UIKit

class CPLoginViewController: CPBaseViewController {
    
    @IBOutlet weak var inputTextBgV: UIView!
    // MARK: - Properties
    @IBOutlet weak var seplineV: UIView!
    @IBOutlet weak var usernameTF: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var passwordTF: UITextField!
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lvc_customView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MAEK: - view
    func lvc_customView() {
        
        seplineV.backgroundColor = UIColor.lineBackgroundColor()
        
        inputTextBgV.layer.borderColor = UIColor.lineBackgroundColor().CGColor
        inputTextBgV.layer.borderWidth = 0.5
        
        usernameTF.attributedPlaceholder = NSAttributedString.init(string: "username or email", attributes: CPStyleGuide.textFieldPlaceholderAttributes())
        passwordTF.attributedPlaceholder = NSAttributedString.init(string: "password", attributes: CPStyleGuide.textFieldPlaceholderAttributes())
        
        usernameTF.textColor = UIColor.textViewTextColor()
        usernameTF.font = UIFont.hugeSizeSystemFont()
        passwordTF.textColor = UIColor.textViewTextColor()
        passwordTF.font = UIFont.hugeSizeSystemFont()
        
        signInButton.layer.cornerRadius = 5
        signInButton.layer.masksToBounds = true
        signInButton.backgroundColor = UIColor.buttonRedBackgroundColor()
        signInButton.setTitleColor(UIColor.buttonWihteTitleTextColor(), forState: UIControlState.Normal)
        signInButton.addTarget(self, action: "lvc_singInAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
    }
    
    func lvc_singInAction(sender:UIButton!) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controlle r.
    }
    */

//    override func navBack() {
//        print("sign back")
//    }
    
}
