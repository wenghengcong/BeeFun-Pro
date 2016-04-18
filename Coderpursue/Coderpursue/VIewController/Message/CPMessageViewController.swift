//
//  CPMessageViewController.swift
//  Coderpursue
//
//  Created by wenghengcong on 15/12/30.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

import UIKit
import Moya
import Foundation
import MJRefresh

class CPMessageViewController: CPBaseViewController {

    @IBOutlet weak var tableView: UITableView!

    var segControl:HMSegmentedControl! = HMSegmentedControl.init(sectionTitles: ["Notifications","Issues"])
    
    var notificationsData:[ObjNotification]! = []
    var issuesData:[ObjIssue]! = []

    var sortVal:String = "created"
    var directionVal:String = "desc"
    
    var notisPageVal = 1
    var issuesPageVal = 1

    // MARK: request parameters

    //notification
    var notiAllPar:String = "false"
    var notiPartPar:String = "false"
    
    //issue
    var issueFilterPar:String = "all"
    var issueStatePar:String = "all"
    var issueLabelsPar:String = ""
    var issueSortPar:String = "created"
    var issueDirectionPar:String = "desc"

    let header = MJRefreshNormalHeader()
    let footer = MJRefreshAutoNormalFooter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mvc_setupSegmentView()
        mvc_setupTableView()
        mvc_updateNetrokData()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(mvc_loginSuccessful), name: NotificationGitLoginSuccessful, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(mvc_logoutSuccessful), name: NotificationGitLogOutSuccessful, object: nil)
        self.leftItem?.hidden = true
        self.title = "Message"
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func mvc_loginSuccessful() {
        
        mvc_updateNetrokData()
    }
    
    func mvc_logoutSuccessful() {
        
        issuesData.removeAll()
        notificationsData.removeAll()
        tableView.reloadData()
    }
    
    func mvc_isLogin()->Bool{
        if( !(UserInfoHelper.sharedInstance.isLogin) ){
            CPGlobalHelper.sharedInstance.showMessage("You Should Login first!", view: self.view)
            notificationsData.removeAll()
            issuesData.removeAll()
            tableView.reloadData()
            return false
        }
        return true
    }
    
    func mvc_updateNetrokData() {
        
        if mvc_isLogin(){
            
            tableView.mj_footer.hidden = false
            if(segControl.selectedSegmentIndex == 0 ) {
                mvc_getNotificationsRequest(self.notisPageVal)
            }else if(segControl.selectedSegmentIndex == 1){
                mvc_getIssuesRequest(self.issuesPageVal)
            }
        }else{
            //加载未登录的页面
            tableView.mj_header.endRefreshing()
            tableView.mj_footer.endRefreshing()
            tableView.mj_footer.hidden = true
            
        }
    }

    func mvc_setupSegmentView() {
        
        self.view.addSubview(segControl)
        segControl.verticalDividerColor = UIColor.lineBackgroundColor()
        segControl.verticalDividerWidth = 1
        segControl.verticalDividerEnabled = true
        segControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe
        segControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
        segControl.selectionIndicatorColor = UIColor.cpRedColor()
        segControl.selectionIndicatorHeight = 2
        segControl.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.labelTitleTextColor(),NSFontAttributeName:UIFont.hugeSizeSystemFont()];
        
        segControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName : UIColor.cpRedColor(),NSFontAttributeName:UIFont.hugeSizeSystemFont()];
        
        segControl.indexChangeBlock = {
            (index:Int)-> Void in
            
            if(!self.mvc_isLogin()){
                return
            }
            
            if( (self.segControl.selectedSegmentIndex == 0)&&self.notificationsData.isEmpty ){
                self.mvc_getNotificationsRequest(self.notisPageVal)
            }else if( (self.segControl.selectedSegmentIndex == 1)&&self.issuesData.isEmpty ){
                self.mvc_getIssuesRequest(self.issuesPageVal)
            }else{
                self.tableView.reloadData()
            }
        
        }
        
        segControl.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(64)
            make.height.equalTo(44)
            make.width.equalTo(self.view)
            make.left.equalTo(0)
        }
        
    }
    
    func mvc_setupTableView() {
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .None
        self.tableView.backgroundColor = UIColor.viewBackgroundColor()
        self.tableView.allowsSelection = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        // 下拉刷新
        header.setTitle("Pull down to refresh", forState: .Idle)
        header.setTitle("Release to refresh", forState: .Pulling)
        header.setTitle("Loading ...", forState: .Refreshing)
        header.setRefreshingTarget(self, refreshingAction: #selector(CPMessageViewController.headerRefresh))
        // 现在的版本要用mj_header
        self.tableView.mj_header = header
        
        // 上拉刷新
        footer.setTitle("Click or drag up to refresh", forState: .Idle)
        footer.setTitle("Loading more ...", forState: .Pulling)
        footer.setTitle("No more data", forState: .NoMoreData)
        footer.setRefreshingTarget(self, refreshingAction: #selector(CPMessageViewController.footerRefresh))
        footer.refreshingTitleHidden = true
        self.tableView.mj_footer = footer
    }
    
    // 顶部刷新
    func headerRefresh(){
        print("下拉刷新")
        if(segControl.selectedSegmentIndex == 0) {
            self.notisPageVal = 1
        }else if(segControl.selectedSegmentIndex == 1){
            self.issuesPageVal = 1
        }
        mvc_updateNetrokData()
    }
    
    // 底部刷新
    func footerRefresh(){
        print("上拉刷新")
        if(segControl.selectedSegmentIndex == 0) {
            self.notisPageVal += 1
        }else if(segControl.selectedSegmentIndex == 1){
            self.issuesPageVal += 1
        }
        mvc_updateNetrokData()
    }

    // MARK: fetch data form request
    
    func mvc_getNotificationsRequest(pageVal:Int) {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        Provider.sharedProvider.request( .MyNotifications(page:pageVal,perpage:15,all:notiAllPar ,participating:notiPartPar) ) { (result) -> () in
            
            var message = "No data to show"
            
            if(pageVal == 1) {
                self.tableView.mj_header.endRefreshing()
            }else{
                self.tableView.mj_footer.endRefreshing()
            }
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            
            switch result {
            case let .Success(response):
                
                do {

                    if let notis:[ObjNotification]? = try response.mapArray(ObjNotification){
                        if(pageVal == 1) {
                            self.notificationsData.removeAll()
                            self.notificationsData = notis!
                        }else{
                            self.notificationsData = self.notificationsData+notis!
                        }                        
                        self.tableView.reloadData()
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

    
    func mvc_getIssuesRequest(pageVal:Int) {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        Provider.sharedProvider.request(.AllIssues( page:pageVal,perpage:10,filter:issueFilterPar,state:issueStatePar,labels:issueLabelsPar,sort:issueSortPar,direction:issueDirectionPar) ) { (result) -> () in
            
            var message = "No data to show"
            
            if(pageVal == 1) {
                self.tableView.mj_header.endRefreshing()
            }else{
                self.tableView.mj_footer.endRefreshing()
            }
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            
            switch result {
            case let .Success(response):
                
                do {
                    if let issues:[ObjIssue]? = try response.mapArray(ObjIssue){
                        if(pageVal == 1) {
                            self.issuesData.removeAll()
                            self.issuesData = issues!
                        }else{
                            self.issuesData = self.issuesData+issues!
                        }
                        
                        self.tableView.reloadData()
                        
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

extension CPMessageViewController : UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if (segControl.selectedSegmentIndex == 0) {
            return self.notificationsData.count
        }
        
        return self.issuesData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        var cellId = ""
        
        if segControl.selectedSegmentIndex == 0 {
            cellId = "CPMesNotificationCellIdentifier"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? CPMesNotificationCell
            if cell == nil {
                cell = (CPMesNotificationCell.cellFromNibNamed("CPMesNotificationCell") as! CPMesNotificationCell)
                
            }
            
            //handle line in cell
            if row == 0 {
                cell!.topline = true
            }
            if (row == notificationsData.count-1) {
                cell!.fullline = true
            }else {
                cell!.fullline = false
            }
            
            let noti = self.notificationsData[row]
            cell!.noti = noti
            
            return cell!;

            
        }
        
        cellId = "CPMesIssueCellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? CPMesIssueCell
        if cell == nil {
            cell = (CPMesIssueCell.cellFromNibNamed("CPMesIssueCell") as! CPMesIssueCell)
            
        }
        
        //handle line in cell
        if row == 0 {
            cell!.topline = true
        }
        if (row == issuesData.count-1) {
            cell!.fullline = true
        }else {
            cell!.fullline = false
        }
        let issue = self.issuesData[row]
        cell!.issue = issue
        return cell!;
        
    }
    
}
extension CPMessageViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if segControl.selectedSegmentIndex == 0 {
            return 55
        }
        return 75
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}

