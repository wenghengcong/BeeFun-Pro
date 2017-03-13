//
//  CPGitLoginViewController.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/9.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import Moya
import Foundation


/// 使用Github的登录页面
class CPGitLoginViewController: CPWebViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Sign In".localized
//        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func webViewDidStartLoad(_ webView: UIWebView) {
        
        super.webViewDidStartLoad(webView)
        
    }
    
    override func webViewDidFinishLoad(_ webView: UIWebView) {
        
        super.webViewDidFinishLoad(webView)        
        //get code = ""
        let urlStr:String = (webView.request?.url?.absoluteString)!
        
        let codePrefix: String = "code="
        
        if urlStr.contains(codePrefix) {
            
            let range:Range = urlStr.range(of: codePrefix)!
            let index: Int = urlStr.characters.distance(from: urlStr.startIndex, to: range.lowerBound)+5
            
            let codeRange = (urlStr.characters.index(urlStr.startIndex, offsetBy: index) ..< urlStr.characters.index(urlStr.startIndex, offsetBy: index+20))
            
            let codeStr = urlStr.substring(with: codeRange)
            
            
            glvc_SignIn(codeStr)
        }
    }
    
    
    func glvc_SignIn(_ code :String) {
        
        let para = [
            "client_id":GithubAppClientId,
            "client_secret":GithubAppClientSecret,
            "code":code,
            "redirect_uri":GithubAppRedirectUrl,
            "state":"junglesong"
            ]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)

        //POST请求
        Alamofire.request("https://github.com/login/oauth/access_token",method:.post,parameters: para)
            .responseJSON { response in
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                let str = String(data: response.data!, encoding: String.Encoding.utf8)
                //access_token=7c897cd55113db38df41521eb897f47e395df845&scope=public_repo%2Cuser&token_type=bearer
//                print("access: \(str)")
                if str != nil {
                    let arr:[String] = (str!.components(separatedBy: ("&")))
                    
                    if arr.count > 0 {
                        let accesstoken = arr[0].substring(from:arr[0].index(arr[0].startIndex ,offsetBy:13))
                        let scope = arr[1].substring(from:arr[1].index(arr[1].startIndex ,offsetBy:7))
                        let tokentype = arr[2].substring(from:arr[2].index(arr[2].startIndex ,offsetBy:11))
                        
                        var token = AppToken.shared
                        token.access_token = String(format: "token %@", accesstoken)
                        //                        token.access_token = accesstoken
                        token.token_type = tokentype
                        token.scope = scope
//                        print(token)
                        self.glv_getUserinfo(accesstoken)
                        
                    }
                }
                
        }
        
    }
    
    func glv_getUserinfo(_ token:String){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)

        let provider = Provider.sharedProvider
        provider.request(.myInfo) { (result) -> () in
//            print(result)
            
            var message = kNoMessageTip
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            
            switch result {
            case let .success(response):
                do {
                    if let gitUser:ObjUser = Mapper<ObjUser>().map(JSONObject: try response.mapJSON()) {
                        ObjUser.saveUserInfo(gitUser)
                        //post successful noti
                        _ = self.navigationController?.popViewController(animated: true)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue:kNotificationDidGitLogin), object:nil)
                        
                    } else {
                    }
                } catch {
                }
                //                self.tableView.reloadData()
            case let .failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
            }

        }
        
    }
    
    override func leftItemAction(_ sender: UIButton?) {
        _ = self.navigationController?.popViewController(animated: true)

    }

}
