//
//  CPTrendingShowcaseViewController.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/10/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit
import Moya
import Foundation
import MJRefresh
import ObjectMapper

class CPTrendingShowcaseViewController: CPBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var showcaseInfoV: CPShowcaseInfoView!
    
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    
    var showcase:ObjShowcase!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tsc_setupTableView()
        tsc_updateContentView()
        tsc_getShowcaseRequest()
        self.title = showcase.slug

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tsc_setupTableView() {
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .None
        self.tableView.backgroundColor = UIColor.viewBackgroundColor()
        self.automaticallyAdjustsScrollViewInsets = false
        
        // 下拉刷新
        header.setTitle("Pull down to refresh", forState: .Idle)
        header.setTitle("Release to refresh", forState: .Pulling)
        header.setTitle("Loading ...", forState: .Refreshing)
        header.setRefreshingTarget(self, refreshingAction: #selector(CPTrendingShowcaseViewController.headerRefresh))
        // 现在的版本要用mj_header
        self.tableView.mj_header = header

    }
    // 顶部刷新
    func headerRefresh(){
        print("下拉刷新")

    }

    func tsc_updateContentView() {
        showcaseInfoV.showcase = self.showcase
        self.tableView.reloadData()
    }
    
    func tsc_getShowcaseRequest(){
    
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        Provider.sharedProvider.request(.TrendingShowcase(showcase:showcase.slug!) ) { (result) -> () in
            
            var message = "No data to show"
            
            self.tableView.mj_header.endRefreshing()
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            
            switch result {
            case let .Success(response):
                
                do {
                    if let result:ObjShowcase = Mapper<ObjShowcase>().map(try response.mapJSON() ) {
                        
                        if(self.showcase!.repositories != nil){
                            self.showcase!.repositories!.removeAll()
                        }else{
                            
                        }
                        self.showcase!.repositories = result.repositories!
                        self.tsc_updateContentView()

                    } else {
                        
                    }

                } catch {
                    CPGlobalHelper.sharedInstance.showError(message, view: self.view)
                }
            case let .Failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                CPGlobalHelper.sharedInstance.showError(message, view: self.view)
                
            }
            
        }

    }
}


extension CPTrendingShowcaseViewController : UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(showcase.repositories == nil){
            return 0
        }
        
        let reposCount = showcase.repositories!.count
        return reposCount

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        let cellId = "CPTrendingRepoCellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? CPTrendingRepoCell
        if cell == nil {
            cell = (CPTrendingRepoCell.cellFromNibNamed("CPTrendingRepoCell") as! CPTrendingRepoCell)
        }
        
        //handle line in cell
        if row == 0 {
            cell!.topline = true
        }
        if (row == showcase.repositories!.count-1) {
            cell!.fullline = true
        }else {
            cell!.fullline = false
        }
        
        let repos = self.showcase.repositories![row]
        cell!.objRepos = repos
        
        return cell!;
            
    }
    
}

extension CPTrendingShowcaseViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
 
        return 85
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let repos = self.showcase.repositories![indexPath.row]
        self.performSegueWithIdentifier(SegueTrendingShowRepositoryDetail, sender: repos)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if (segue.identifier == SegueTrendingShowRepositoryDetail){
            
            let reposVC = segue.destinationViewController as! CPTrendingRepositoryViewController
            reposVC.hidesBottomBarWhenPushed = true
            let repos = sender as? ObjRepos
            if(repos != nil){
                reposVC.repos = repos
            }
            
        }
        
    }
    
}

