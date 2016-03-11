//
//  CPReposViewController.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/30.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit
import Moya
import Foundation
import MJRefresh

class CPReposViewController: CPBaseViewController {

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
    
    
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        rvc_addNaviBarButtonItem()
        rvc_setupTableView()
        rvc_selectDataSource()
    }
    
    func rvc_addNaviBarButtonItem() {
        
        /*
        let btnName = UIButton()
        btnName.setImage(UIImage(named: "bubble_consulting_chat-512"), forState: .Normal)
        btnName.frame = CGRectMake(0, 0, 30, 30)
        btnName.addTarget(self, action: Selector("tvc_rightButtonTouch"), forControlEvents: .TouchUpInside)
        
        //.... Set Right/Left Bar Button item
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = btnName
        self.navigationItem.rightBarButtonItem = rightBarButton
        */
        
        if let uname = self.username {
            self.title = uname
        }else{
            self.title = "Repositories"
        }
        
    }
    
    func rvc_rightButtonTouch() {
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func rvc_setupTableView() {
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .None
        self.tableView.backgroundColor = UIColor.viewBackgroundColor()
        self.automaticallyAdjustsScrollViewInsets = false
        
        // 下拉刷新
        header.setTitle("Pull down to refresh", forState: .Idle)
        header.setTitle("Release to refresh", forState: .Pulling)
        header.setTitle("Loading ...", forState: .Refreshing)
        header.setRefreshingTarget(self, refreshingAction: Selector("headerRefresh"))
        // 现在的版本要用mj_header
        self.tableView.mj_header = header
        
        // 上拉刷新
        footer.setTitle("Click or drag up to refresh", forState: .Idle)
        footer.setTitle("Loading more ...", forState: .Pulling)
        footer.setTitle("No more data", forState: .NoMoreData)
        footer.setRefreshingTarget(self, refreshingAction: Selector("footerRefresh"))
        footer.refreshingTitleHidden = true
        self.tableView.mj_footer = footer
    }
    
    // 顶部刷新
    func headerRefresh(){
        print("下拉刷新")
        reposPageVal = 1
        rvc_selectDataSource()
    }
    
    // 底部刷新
    func footerRefresh(){
        print("上拉刷新")
        reposPageVal++
        rvc_selectDataSource()
    }
    
    func rvc_updateViewContent() {
        
        self.tableView.reloadData()
    }
    
    func rvc_selectDataSource() {
        
        if(self.viewType == "myrepositories") {
            rvc_getMyReposRequest()
        }else if(self.viewType == "watched"){
            rvc_getWatchedReposRequest()
        }else if(self.viewType == "forked"){
            rvc_getForkedReposRequst()
        }else{
            rvc_getMyReposRequest()
        }
        
    }
    
    // MARK: request for repos
    
    func rvc_getMyReposRequest() {
        
        if (username == nil){
            return
        }
        
        Provider.sharedProvider.request( .UserRepos( username:self.username!,page:self.reposPageVal,perpage:self.reposPerpage,type:self.typeVal, sort:self.sortVal ,direction:self.directionVal ) ) { (result) -> () in
            print(result)
            
            var success = true
            var message = "Unable to fetch from GitHub"
            
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            switch result {
            case let .Success(response):
                
                do {
                    if let repos:[ObjRepos]? = try response.mapArray(ObjRepos){
                        if(self.reposPageVal == 1) {
                            self.reposData.removeAll()
                            self.reposData = repos!
                        }else{
                            self.reposData = self.reposData+repos!
                        }
                        self.rvc_updateViewContent()
                        
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
    
    func rvc_getWatchedReposRequest() {
        if (username == nil){
            return
        }
        
        Provider.sharedProvider.request( .UserWatchedRepos( page:self.reposPageVal,perpage:self.reposPerpage,username:self.username! ) ) { (result) -> () in
            print(result)
            
            var success = true
            var message = "Unable to fetch from GitHub"
            
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            switch result {
            case let .Success(response):
                
                do {
                    if let repos:[ObjRepos]? = try response.mapArray(ObjRepos){
                        if(self.reposPageVal == 1) {
                            self.reposData.removeAll()
                            self.reposData = repos!
                        }else{
                            self.reposData = self.reposData+repos!
                        }
                        self.rvc_updateViewContent()
                        
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
    
    func rvc_getForkedReposRequst() {
        
    }


    
}


extension CPReposViewController : UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  self.reposData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        var cellId = ""
        if(self.viewType == "myrepositories") {
            cellId = "CPMyReposCellIdentifier"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? CPMyReposCell
            if cell == nil {
                cell = (CPMyReposCell.cellFromNibNamed("CPMyReposCell") as! CPMyReposCell)
            }
            
            //handle line in cell
            if row == 0 {
                cell!.topline = true
            }
            if (row == reposData.count-1) {
                cell!.fullline = true
            }else {
                cell!.fullline = false
            }
            
            let repos = self.reposData[row]
            cell!.objRepos = repos
            
            return cell!;
        }
        
        cellId = "CPProfileReposCellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? CPProfileReposCell
        if cell == nil {
            cell = (CPProfileReposCell.cellFromNibNamed("CPProfileReposCell") as! CPProfileReposCell)
        }
        
        //handle line in cell
        if row == 0 {
            cell!.topline = true
        }
        if (row == reposData.count-1) {
            cell!.fullline = true
        }else {
            cell!.fullline = false
        }
        
        let repos = self.reposData[row]
        cell!.objRepos = repos
        
        return cell!;
        
        
    }
    
}
extension CPReposViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 85
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let repos = self.reposData[indexPath.row]
        self.performSegueWithIdentifier(SegueProfileShowRepositoryDetail, sender: repos)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == SegueProfileShowRepositoryDetail){
            let reposVC = segue.destinationViewController as! CPTrendingRepositoryViewController
            reposVC.hidesBottomBarWhenPushed = true
            
            let repos = sender as? ObjRepos
            if(repos != nil){
                reposVC.repos = repos
            }
            
        }
    }
}

