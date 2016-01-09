//
//  Key+Project.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/8.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit

struct GitHubKey {
    
    static let gitClientId = "294e97e63b0e68f456ad";
    static let gitClientSecret = "d208e4cc6b9afcdea382e6afae58c8b27bf18377";
    static let gitRedirectUrl = "http://www.wenghengcong.com"

    
    static func githubClientID() -> String{
        return gitClientId
    }
    
    static func githubClientSecret() -> String {
        return gitClientSecret
    }
    
    static func githubRedirectUrl() -> String {
        return gitRedirectUrl
    }
}
