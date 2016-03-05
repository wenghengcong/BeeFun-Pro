//
//  CPReposViewController.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/30.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit

class CPReposViewController: CPBaseViewController {

    // MARK: request for repos
    
    func rvc_getUserReposRequest() {
        
        Provider.sharedProvider.request(.MyRepos(type: "",sort: "",direction: "")) { (result) -> () in
            print(result)
            
            var success = true
            var message = "Unable to fetch from GitHub"
            
            switch result {
            case let .Success(response):
                
                do {
                    if let repos:[ObjRepos]? = try response.mapArray(ObjRepos){
                        print(repos)
                        
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
    
}
