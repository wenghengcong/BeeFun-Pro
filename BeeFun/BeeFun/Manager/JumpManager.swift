//
//  JumpManager.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/3/30.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

class JumpManager: NSObject {

    
    /// 跳转到Repos detail页面
    ///
    /// - Parameter repos: <#repos description#>
    class func jumpReposDetailView(repos:ObjRepos?){
        if repos != nil && repos?.owner != nil && repos?.name != nil{
            let vc = CPRepoDetailController()
            vc.hidesBottomBarWhenPushed = true
            vc.repos = repos
            jsTopNavigationViewController?.pushViewController(vc, animated: true)
        }
    }
    
}
