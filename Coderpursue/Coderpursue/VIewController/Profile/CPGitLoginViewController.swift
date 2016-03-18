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
import SwiftyJSON
import Moya
import Foundation


class CPGitLoginViewController: CPWebViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController!.navigationBar.topItem?.title = ""

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Sign In"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func webViewDidStartLoad(webView: UIWebView) {
        
        super.webViewDidStartLoad(webView)
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        
    }
    
    override func webViewDidFinishLoad(webView: UIWebView) {
        
        super.webViewDidFinishLoad(webView)
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        
        //get code = ""
        let urlStr:String = (webView.request?.URL?.absoluteString)!
        
        let codePrefix: String = "code="
        
        if urlStr.containsString(codePrefix) {
            
            let range:Range = urlStr.rangeOfString(codePrefix)!
            let index: Int = urlStr.startIndex.distanceTo(range.startIndex)+5
            
            let codeRange = Range(start: urlStr.startIndex.advancedBy(index), end: urlStr.startIndex.advancedBy(index+20))
            
            let codeStr = urlStr.substringWithRange(codeRange)
            
            
            glvc_SignIn(codeStr)
        }
    }
    
    
    func glvc_SignIn(code :String) {
        
        let para = [
            "client_id":GithubAppClientId,
            "client_secret":GithubAppClientSecret,
            "code":code,
            "redirect_uri":GithubAppRedirectUrl,
            "state":"junglesong"
            ]
        
        Alamofire.request(.POST, "https://github.com/login/oauth/access_token", parameters: para)
            .responseJSON { response in
                
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
                        self.getUserinfo(accesstoken)

                    }
                }
                
        }
        
    }
    
    
    func getUserinfo(token:String){
        
        let provider = Provider.sharedProvider
        provider.request(.MyInfo) { (result) -> () in
            print(result)
            
            var success = true
            var message = "No data to show"

            switch result {
            case let .Success(response):
                do {
                    if let gitUser:ObjUser = Mapper<ObjUser>().map(try response.mapJSON()) {
                        ObjUser.saveUserInfo(gitUser)
                        //post successful noti
                        self.navBack()
                        NSNotificationCenter.defaultCenter().postNotificationName(NotificationGitLoginSuccessful, object:nil)
                        
                    } else {
                        success = false
                    }
                } catch {
                    success = false
                }
                //                self.tableView.reloadData()
            case let .Failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                success = false
            }

        }
        
    }
    
    override func navBack() {
        super.navBack()
        self.navigationController?.popViewControllerAnimated(true)
    }

}
