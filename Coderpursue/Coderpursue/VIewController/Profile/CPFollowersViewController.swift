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
    
    // MARK: request parameters
    var userData:[ObjUser]! = []
    var userPageVal = 1
    var userPerpageVal = 15
    
    var typeVal:String = "owner"
    var sortVal:String = "created"
    var directionVal:String = "desc"
    
    let header = MJRefreshNormalHeader()
    let footer = MJRefreshAutoNormalFooter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        fvc_addNaviBarButtonItem()
        fvc_setupTableView()
        fvc_selectDataSource()
        self.navigationController!.navigationBar.topItem?.title = ""

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if(viewType == "follower"){
            self.title = "Follower"
        }else if(viewType == "following"){
            self.title = "Following"
        }

    }
    
    func fvc_addNaviBarButtonItem() {
        
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


    }
    
    func fvc_rightButtonTouch() {
        
    }
    
    func fvc_setupTableView() {
        
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
        userPageVal = 1
        fvc_selectDataSource()
    }
    
    // 底部刷新
    func footerRefresh(){
        userPageVal++
        fvc_selectDataSource()
    }

    func fvc_updateViewContent() {
        
        self.tableView.reloadData()
    }
    
    func fvc_selectDataSource() {
        
        if(self.viewType == "follower") {
            tvc_getUserFollowerRequest()
        }else if(self.viewType == "following"){
            tvc_getUserFollowingRequst()
        }
        
    }
    
    // MARK: fetch data form request
    func tvc_getUserFollowerRequest() {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        Provider.sharedProvider.request(.UserFollowers(page:self.userPageVal,perpage:self.userPerpageVal,username:self.username!) ) { (result) -> () in
            
            var success = true
            var message = "Unable to fetch from GitHub"
            
            if(self.userPageVal == 1) {
                self.tableView.mj_header.endRefreshing()
            }else{
                self.tableView.mj_footer.endRefreshing()
            }
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            
            switch result {
            case let .Success(response):
                
                do {
                    if let userResult:[ObjUser]? = try response.mapArray(ObjUser) {
                        if(self.userPageVal == 1) {
                            self.userData.removeAll()
                            self.userData = userResult
                        }else{
                            self.userData = self.userData+userResult!
                        }
                        
                        self.fvc_updateViewContent()
                        
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
    
    func tvc_getUserFollowingRequst() {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        Provider.sharedProvider.request(.UserFollowing(page:self.userPageVal,perpage:self.userPerpageVal,username:self.username!) ) { (result) -> () in
            
            var success = true
            var message = "Unable to fetch from GitHub"
            
            if(self.userPageVal == 1) {
                self.tableView.mj_header.endRefreshing()
            }else{
                self.tableView.mj_footer.endRefreshing()
            }
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            
            switch result {
            case let .Success(response):
                
                do {
                    if let userResult:[ObjUser]? = try response.mapArray(ObjUser) {
                        if(self.userPageVal == 1) {
                            self.userData.removeAll()
                            self.userData = userResult
                        }else{
                            self.userData = self.userData+userResult!
                        }
                        
                        self.fvc_updateViewContent()
                        
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

}

extension CPFollowersViewController : UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.userData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        let cellId = "CPTrendingDeveloperCellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? CPTrendingDeveloperCell
        if cell == nil {
            cell = (CPTrendingDeveloperCell.cellFromNibNamed("CPTrendingDeveloperCell") as! CPTrendingDeveloperCell)
            
        }
        
        //handle line in cell
        if row == 0 {
            cell!.topline = true
        }
        if (row == userData.count-1) {
            cell!.fullline = true
        }else {
            cell!.fullline = false
        }
        
        let user = self.userData[row]
        cell!.user = user
        cell!.userNo = row
        
        return cell!;
        
    }
    
}

extension CPFollowersViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 71
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
        let user = self.userData[indexPath.row]
        self.performSegueWithIdentifier(SegueTrendingShowDeveloperDetail, sender: user)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if(segue.identifier == SegueProfileShowDeveloperDetail){
            
            let devVC = segue.destinationViewController as! CPTrendingDeveloperViewController
            devVC.hidesBottomBarWhenPushed = true
            
            let dev = sender as? ObjUser
            if(dev != nil){
                devVC.developer = dev
            }
        }
        
        
    }
    
}
