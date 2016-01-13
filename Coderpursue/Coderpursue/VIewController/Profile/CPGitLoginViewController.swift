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

class CPGitLoginViewController: CPWebViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Sign In"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func webViewDidStartLoad(webView: UIWebView) {
        super.webViewDidStartLoad(webView)
    }
    
    override func webViewDidFinishLoad(webView: UIWebView) {
        super.webViewDidFinishLoad(webView)
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
            "client_id":GitHubKey.githubClientID(),
            "client_secret":GitHubKey.githubClientSecret(),
            "code":code,
            "redirect_uri":GitHubKey.githubRedirectUrl(),
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
                        
                        var token = AppToken()
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
        provider.request(.User) { (result) -> () in
            print(result)
            switch result {
            case let .Success(response):
                let json = response
   
            case let .Failure(error):
                let eror = error

            }
        }
        
        let requestUrl = String(format: "https://api.github.com/user?access_token=%@", token)
        
        Alamofire.request(.GET, requestUrl, parameters:nil)
            .responseJSON { response in
                
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }

        
    }

}
