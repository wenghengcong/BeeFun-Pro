//
//  CPRepositoryViewController.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/9/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit
import Moya
import Foundation
import MJRefresh
import ObjectMapper

class CPTrendingRepositoryViewController: CPBaseViewController {

    @IBOutlet weak var reposPoseterV: CPReposPosterView!
    
    @IBOutlet weak var reposInfoV: CPReposInfoView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var repos:ObjRepos?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        rvc_customView()
        rvc_updateViewContent()
//        rvc_getReopsRequest()
    }
    func rvc_customView(){
        self.title = repos!.name!
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.view.backgroundColor = UIColor.whiteColor()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func svc_setupTableView() {
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .None
        self.tableView.backgroundColor = UIColor.viewBackgroundColor()
        self.automaticallyAdjustsScrollViewInsets = false
        
    }

    
    func rvc_getReopsRequest(){
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let owner = repos!.owner!.login!
        let repoName = repos!.name!
        Provider.sharedProvider.request(.UserSomeRepo(owner:owner,repo:repoName) ) { (result) -> () in
            
            var success = true
            var message = "Unable to fetch from GitHub"
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            
            switch result {
            case let .Success(response):
                
                do {
                    if let result:ObjRepos = Mapper<ObjRepos>().map(try response.mapJSON() ) {
                        
                        self.repos = result
                        self.rvc_updateViewContent()

                    } else {
                        success = false
                    }
                } catch {
                    success = false
                    CPGlobalHelper.sharedInstance.showError(message, view: self.view)
                }
            case let .Failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                success = false
                CPGlobalHelper.sharedInstance.showError(message, view: self.view)
                
            }
        }

        
    }

    func rvc_updateViewContent() {
        
        let objRepo = repos!
        reposPoseterV.repo = objRepo
        reposInfoV.repo = objRepo
    }
    
}


extension CPTrendingRepositoryViewController : UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = indexPath.row

        var cellId = "CPEventStarredCellIdentifier"
        var cell = tableView .dequeueReusableCellWithIdentifier(cellId) as? CPEventStarredCell
        if cell == nil {
            cell = (CPEventStarredCell.cellFromNibNamed("CPEventStarredCell") as! CPEventStarredCell)
        }

        cell!.topline = true
        cell!.fullline = true
        
        return cell!;
        
    }
    
}
extension CPTrendingRepositoryViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}

