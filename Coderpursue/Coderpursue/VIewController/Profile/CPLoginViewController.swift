//
//  CPLoginViewController.swift
//  Coderpursue
//
//  Created by wenghengcong on 15/12/30.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftyJSON
import Moya
import Foundation

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
        lvc_checkInputText()
        
        let username = usernameTF.text!
        let password = passwordTF.text!
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSASCIIStringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        let authorizationHeaderStr = "Basic \(base64LoginString)"
        
        let headers = [
            "Authorization": authorizationHeaderStr,
        ]
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)

        Alamofire.request(.GET, "https://api.github.com/user", headers: headers)
            .response { request, response, data, error  in
                
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)

                debugPrint(response)
                if(error == nil){
                    self.lvc_saveAuthorization(authorizationHeaderStr)
                    self.lvc_saveUserInfoData(data!)
                }
                
        }
    }
    
    func lvc_checkInputText(){
        
        if( (usernameTF.text!.isEmpty) || (passwordTF.text!.isEmpty) ){
            CPGlobalHelper.sharedInstance.showMessage("Input username or password", view: self.view)
            return
        }
        
    }
    
    
    func lvc_saveAuthorization(auth:String){
        
        var token = AppToken.sharedInstance
        token.access_token = auth
        
    }
    
    func lvc_saveUserInfoData(data:NSData){
        
        let str = String(data: data, encoding: NSUTF8StringEncoding)
        
        if let gitUser:ObjUser = Mapper<ObjUser>().map(str) {
            
            ObjUser.saveUserInfo(gitUser)
            //post successful noti
            self.navigationController?.popViewControllerAnimated(true)
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationGitLoginSuccessful, object:nil)
            
        }else {
            
        }
    }

}
