//
//  CPFollowersViewController.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/30.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit
import Moya
import Foundation
import MJRefresh
import ObjectMapper

class CPFollowersViewController: CPBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    //incoming var
    var dic:[String:String]?
    var username:String?
    var viewType:String?
    
    var reposData:[ObjRepos]! = []
    var reposPageVal = 1
    var reposPerpage = 15
    
    var typeVal:String = "owner"
    var sortVal:String = "created"
    var directionVal:String = "desc"
    
}
