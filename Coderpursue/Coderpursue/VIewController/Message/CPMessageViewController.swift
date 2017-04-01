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
import MBProgressHUD
import HMSegmentedControl

class CPMessageViewController: CPBaseViewController,UIAlertViewDelegate {

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
        NotificationCenter.default.addObserver(self, selector: #selector(mvc_loginSuccessful), name: NSNotification.Name(rawValue: kNotificationDidGitLogin), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(mvc_logoutSuccessful), name: NSNotification.Name(rawValue: kNotificationDidGitLogOut), object: nil)
        self.leftItem?.isHidden = true
        self.title = "Message"
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    /// 登录成功的通知
    func mvc_loginSuccessful() {
        
        mvc_updateNetrokData()
    }
    /// 注销成功的通知
    func mvc_logoutSuccessful() {
        
        issuesData.removeAll()
        notificationsData.removeAll()
        tableView.reloadData()
    }
    
    func mvc_isLogin()->Bool{
        if( !(UserManager.shared.checkUserLogin()) ){
            notificationsData.removeAll()
            issuesData.removeAll()
            tableView.reloadData()
            return false
        }
        return true
    }
    
    func mvc_updateNetrokData() {
        
        if (UserManager.shared.checkUserLogin()){
            //已登录
            tableView.mj_footer.isHidden = false
            if(segControl.selectedSegmentIndex == 0 ) {
                mvc_getNotificationsRequest(self.notisPageVal)
            }else if(segControl.selectedSegmentIndex == 1){
                mvc_getIssuesRequest(self.issuesPageVal)
            }
            
        }else{
            //加载未登录的页面
            tableView.mj_header.endRefreshing()
            tableView.mj_footer.endRefreshing()
            tableView.mj_footer.isHidden = true
            
        }
    }

    func mvc_setupSegmentView() {
        
        self.view.addSubview(segControl)
        segControl.verticalDividerColor = UIColor.lineBackgroundColor()
        segControl.verticalDividerWidth = 1
        segControl.isVerticalDividerEnabled = true
        segControl.selectionStyle =  HMSegmentedControlSelectionStyle.fullWidthStripe
        segControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.down
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
        
        segControl.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(64)
            make.height.equalTo(44)
            make.width.equalTo(self.view)
            make.left.equalTo(0)
        }
        
    }
    
    func mvc_setupTableView() {
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.viewBackgroundColor()
        self.tableView.allowsSelection = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        // 下拉刷新
        header.setTitle("", for: .idle)
        header.setTitle("Release to refresh", for: .pulling)
        header.setTitle("Loading ...", for: .refreshing)
        header.setRefreshingTarget(self, refreshingAction: #selector(CPMessageViewController.headerRefresh))
        // 现在的版本要用mj_header
        self.tableView.mj_header = header
        
        // 上拉刷新
        footer.setTitle("", for: .idle)
        footer.setTitle("Loading more ...", for: .pulling)
        footer.setTitle("No more data", for: .noMoreData)
        footer.setRefreshingTarget(self, refreshingAction: #selector(CPMessageViewController.footerRefresh))
        footer.isRefreshingTitleHidden = true
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
    
    func mvc_getNotificationsRequest(_ pageVal:Int) {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Provider.sharedProvider.request( .myNotifications(page:pageVal,perpage:15,all:notiAllPar ,participating:notiPartPar) ) { (result) -> () in
            
            var message = kNoMessageTip
            
            if(pageVal == 1) {
                self.tableView.mj_header.endRefreshing()
            }else{
                self.tableView.mj_footer.endRefreshing()
            }
            
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            
            switch result {
            case let .success(response):
                
                do {

                    if let notis:[ObjNotification]? = try response.mapArray(ObjNotification.self){
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

                    CPGlobalHelper.showError(message, view: self.view)
                }
            case let .failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                CPGlobalHelper.showError(message, view: self.view)
                
            }
        }
        
    }

    
    func mvc_getIssuesRequest(_ pageVal:Int) {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Provider.sharedProvider.request(.allIssues( page:pageVal,perpage:10,filter:issueFilterPar,state:issueStatePar,labels:issueLabelsPar,sort:issueSortPar,direction:issueDirectionPar) ) { (result) -> () in
            
            var message = kNoMessageTip
            
            if(pageVal == 1) {
                self.tableView.mj_header.endRefreshing()
            }else{
                self.tableView.mj_footer.endRefreshing()
            }
            
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            
            switch result {
            case let .success(response):
                
                do {
                    if let issues:[ObjIssue]? = try response.mapArray(ObjIssue.self){
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
                    CPGlobalHelper.showError(message, view: self.view)
                }
            case let .failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                CPGlobalHelper.showError(message, view: self.view)
                
            }
        }
        
    }

}

extension CPMessageViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if (segControl.selectedSegmentIndex == 0) {
            return self.notificationsData.count
        }
        
        return self.issuesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = (indexPath as NSIndexPath).row
        
        var cellId = ""
        
        if segControl.selectedSegmentIndex == 0 {
            cellId = "CPMesNotificationCellIdentifier"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? CPMesNotificationCell
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
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? CPMesIssueCell
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if segControl.selectedSegmentIndex == 0 {
            return 55
        }
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

