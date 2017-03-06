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
import Moya
import Foundation


/// 自己绘制的登录页面
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

    override func leftItemAction(_ sender: UIButton?) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MAEK: - view
    func lvc_customView() {
        
        seplineV.backgroundColor = UIColor.lineBackgroundColor()
        
        inputTextBgV.layer.borderColor = UIColor.lineBackgroundColor().cgColor
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
        signInButton.setTitleColor(UIColor.buttonWihteTitleTextColor(), for: UIControlState())
        signInButton.addTarget(self, action: #selector(CPLoginViewController.lvc_singInAction(_:)), for: UIControlEvents.touchUpInside)
        
        
    }
    
    func lvc_singInAction(_ sender:UIButton!) {
        lvc_checkInputText()
        
        let username = usernameTF.text!
        let password = passwordTF.text!
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: Data = loginString.data(using: String.Encoding.ascii.rawValue)!
        let base64LoginString = loginData.base64EncodedString(options: .lineLength64Characters)
        let authorizationHeaderStr = "Basic \(base64LoginString)"
        
        let urlString = "https://api.github.com/user"
        let headers = ["Authorization": authorizationHeaderStr]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Alamofire.request(urlString, parameters: ["":""], headers: headers).responseJSON { response in

            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            
            debugPrint(response)
            switch response.result{
                case let .success(response):
                    self.lvc_saveAuthorization(authorizationHeaderStr)
                    self.lvc_saveUserInfoData((response as AnyObject).data!)
                case .failure(_): break
                
            }
        }
        
    }
    
    func lvc_checkInputText(){
        
        if( (usernameTF.text!.isEmpty) || (passwordTF.text!.isEmpty) ){
            CPGlobalHelper.shared.showMessage("Input username or password", view: self.view)
            return
        }
        
    }
    
    
    func lvc_saveAuthorization(_ auth:String){
        
        var token = AppToken.shared
        token.access_token = auth
        
    }
    
    func lvc_saveUserInfoData(_ data:Data){
        
        let str = String(data: data, encoding: String.Encoding.utf8)
        
        if let gitUser:ObjUser = Mapper<ObjUser>().map(JSONString:str!) {
            
            ObjUser.saveUserInfo(gitUser)
            //post successful noti
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: Notification.Name(rawValue: kNotificationDidGitLogin), object:nil)
            
        }else {
            
        }
    }

}
