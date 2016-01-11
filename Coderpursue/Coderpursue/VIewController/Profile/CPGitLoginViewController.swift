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
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                let str = String(data: response.data!, encoding: NSUTF8StringEncoding)
                //access_token=7c897cd55113db38df41521eb897f47e395df845&scope=public_repo%2Cuser&token_type=bearer
                print("access: \(str)")
                
                
                
        }
        
        
    }

}
