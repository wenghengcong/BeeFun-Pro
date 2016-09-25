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


class CPGitLoginViewController: CPWebViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Sign In"
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

        Alamofire.request(.POST, "https://github.com/login/oauth/access_token", parameters: para)
            .responseJSON { response in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                let str = String(data: response.data!, encoding: NSUTF8StringEncoding)
                //access_token=7c897cd55113db38df41521eb897f47e395df845&scope=public_repo%2Cuser&token_type=bearer
                print("access: \(str)")
                if str != nil {
                    let arr:[String] = (str!.componentsSeparatedByString("&"))
                    
                    if arr.count > 0 {
                        let accesstoken = arr[0].substringFromIndex(arr[0].startIndex.advancedBy(13))
                        let scope = arr[1].substringFromIndex(arr[1].startIndex.advancedBy(7))
                        let tokentype = arr[2].substringFromIndex(arr[2].startIndex.advancedBy(11))
                        
                        var token = AppToken.sharedInstance
                        token.access_token = String(format: "token %@", accesstoken)
                        //                        token.access_token = accesstoken
                        token.token_type = tokentype
                        token.scope = scope
                        print(token)
                        self.glv_getUserinfo(accesstoken)
                        
                    }
                }
                
        }
        
    }
    
    func glv_getUserinfo(_ token:String){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)

        let provider = Provider.sharedProvider
        provider.request(.myInfo) { (result) -> () in
            print(result)
            
            var message = "No data to show"

            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            
            switch result {
            case let .success(response):
                do {
                    if let gitUser:ObjUser = Mapper<ObjUser>().map(JSONObject: try response.mapJSON()) {
                        ObjUser.saveUserInfo(gitUser)
                        //post successful noti
                        self.navigationController?.popViewController(animated: true)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationGitLoginSuccessful), object:nil)
                        
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
        self.navigationController?.popViewController(animated: true)

    }

}
