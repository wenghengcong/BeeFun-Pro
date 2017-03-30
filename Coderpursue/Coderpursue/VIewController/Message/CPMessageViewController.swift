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

    var segControl:HMSegmentedControl! = JSHMSegmentedBridge.segmentControl(titles: ["Notifications".localized,"Issues".localized,"Event".localized])
    
    var notificationsData:[ObjNotification]! = []
    var issuesData:[ObjIssue]! = []
    var eventsData:[ObjEvent]! = []

    var sortVal:String = "created"
    var directionVal:String = "desc"
    
    var notisPageVal = 1
    var issuesPageVal = 1
    var eventPageVal = 1

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
        self.title = "Message".localized
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
        eventsData.removeAll()
        tableView.reloadData()
    }
    
    func mvc_isLogin()->Bool{
        if( !(UserManager.shared.checkUserLogin()) ){
            notificationsData.removeAll()
            issuesData.removeAll()
            eventsData.removeAll()
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
            }else if(segControl.selectedSegmentIndex == 2){
                svc_getUserEventsRequest(self.eventPageVal)
            }
            
        }else{
            //加载未登录的页面
            tableView.mj_header.endRefreshing()
            tableView.mj_footer.endRefreshing()
            tableView.mj_footer.isHidden = true
            
        }
    }
    
    // MARK: - SegmentControl

    func mvc_setupSegmentView() {
        segControl.addTarget(self, action: #selector(CPMessageViewController.mvc_segmentControlChangeValue), for: .valueChanged)
        self.view.addSubview(segControl)
    }
    
    func mvc_segmentControlChangeValue() {
        
        if(!self.mvc_isLogin()){
            return
        }
        self.tableView.reloadData()

        if( (self.segControl.selectedSegmentIndex == 0)&&self.notificationsData.isEmpty ){
            self.tableView.allowsSelection = false
            self.mvc_getNotificationsRequest(self.notisPageVal)
        }else if( (self.segControl.selectedSegmentIndex == 1)&&self.issuesData.isEmpty ){
            self.tableView.allowsSelection = true
            self.mvc_getIssuesRequest(self.issuesPageVal)
        }else if( (self.segControl.selectedSegmentIndex == 2)&&self.eventsData != nil ){
            self.svc_getUserEventsRequest(self.eventPageVal)
        }else{
            
        }
    }
    
    
    func mvc_addSwipeGesture() {
        
        let swipeLeft = UISwipeGestureRecognizer.init(target: self, action: #selector(CPMessageViewController.mvc_swipeRight(sengder:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.tableView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer.init(target: self, action: #selector(CPMessageViewController.mvc_swipeLeft(sengder:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.tableView.addGestureRecognizer(swipeRight)
    }
    
    /// 左滑
    func mvc_swipeLeft(sengder:Any) {
        let currentIndex = segControl.selectedSegmentIndex
        var nextIndex = 0
        if  currentIndex == 0{
            nextIndex = segControl.sectionTitles.count-1
        }else{
            nextIndex = currentIndex-1
        }
        segControl.setSelectedSegmentIndex(UInt(nextIndex), animated: true)
        mvc_segmentControlChangeValue()
        tableView.setContentOffset(CGPoint.zero, animated:true)
    }
    
    /// 右滑
    func mvc_swipeRight(sengder:Any) {
        let currentIndex = segControl.selectedSegmentIndex
        var nextIndex:Int = 0
        if  currentIndex == segControl.sectionTitles.count-1{
            nextIndex = 0
        }else{
            nextIndex = currentIndex+1
        }
        segControl.setSelectedSegmentIndex(UInt(nextIndex), animated: true)
        mvc_segmentControlChangeValue()
        tableView.setContentOffset(CGPoint.zero, animated:true)
    }
    
    // MARK: - TableView

    func mvc_setupTableView() {
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.viewBackgroundColor
        self.automaticallyAdjustsScrollViewInsets = false
        
        // 下拉刷新
        header.setTitle("", for: .idle)
        header.setTitle(kHeaderPullTip, for: .pulling)
        header.setTitle(kHeaderPullingTip, for: .refreshing)
        header.setRefreshingTarget(self, refreshingAction: #selector(CPMessageViewController.headerRefresh))
        // 现在的版本要用mj_header
        self.tableView.mj_header = header
        
        // 上拉刷新
        footer.setTitle("", for: .idle)
        footer.setTitle(kFooterLoadTip, for: .pulling)
        footer.setTitle(kFooterLoadNoDataTip, for: .noMoreData)
        footer.setRefreshingTarget(self, refreshingAction: #selector(CPMessageViewController.footerRefresh))
        footer.isRefreshingTitleHidden = true
        self.tableView.mj_footer = footer
        
        self.mvc_addSwipeGesture()
    }
    
    // 顶部刷新
    func headerRefresh(){
        print("下拉刷新")
        if(segControl.selectedSegmentIndex == 0) {
            self.notisPageVal = 1
        }else if(segControl.selectedSegmentIndex == 1){
            self.issuesPageVal = 1
        }else if(segControl.selectedSegmentIndex == 2){
            self.eventPageVal = 1
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
        }else if(segControl.selectedSegmentIndex == 2){
            self.eventPageVal += 1
        }
        mvc_updateNetrokData()
    }

    // MARK: fetch data form request
    
    func mvc_getNotificationsRequest(_ pageVal:Int) {
        
        JSMBHUDBridge.showHud(view: self.view)
        
        Provider.sharedProvider.request( .myNotifications(page:pageVal,perpage:15,all:notiAllPar ,participating:notiPartPar) ) { (result) -> () in
            
            var message = kNoDataFoundTip
            
            if(pageVal == 1) {
                self.tableView.mj_header.endRefreshing()
            }else{
                self.tableView.mj_footer.endRefreshing()
            }
            
            JSMBHUDBridge.hideHud(view: self.view)
            
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

                    JSMBHUDBridge.showError(message, view: self.view)
                }
            case let .failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                JSMBHUDBridge.showError(message, view: self.view)
                
            }
        }
        
    }

    
    func mvc_getIssuesRequest(_ pageVal:Int) {
        
        JSMBHUDBridge.showHud(view: self.view)
        
        Provider.sharedProvider.request(.allIssues( page:pageVal,perpage:10,filter:issueFilterPar,state:issueStatePar,labels:issueLabelsPar,sort:issueSortPar,direction:issueDirectionPar) ) { (result) -> () in
            
            var message = kNoDataFoundTip
            
            if(pageVal == 1) {
                self.tableView.mj_header.endRefreshing()
            }else{
                self.tableView.mj_footer.endRefreshing()
            }
            
            JSMBHUDBridge.hideHud(view: self.view)
            
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
                    JSMBHUDBridge.showError(message, view: self.view)
                }
            case let .failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                JSMBHUDBridge.showError(message, view: self.view)
                
            }
        }
        
    }
    
    func svc_getUserEventsRequest(_ pageVal:Int) {
        
        JSMBHUDBridge.showHud(view: self.view)
        
        Provider.sharedProvider.request(.userEvents(username:ObjUser.loadUserInfo()!.login! ,page:pageVal,perpage:15) ) { (result) -> () in
            
            var message = kNoDataFoundTip
            
            if(pageVal == 1) {
                self.tableView.mj_header.endRefreshing()
            }else{
                self.tableView.mj_footer.endRefreshing()
            }
            
            JSMBHUDBridge.hideHud(view: self.view)
            
            switch result {
            case let .success(response):
                
                do {
                    if let events:[ObjEvent]? = try response.mapArray(ObjEvent){
                        if(pageVal == 1) {
                            self.eventsData.removeAll()
                            self.eventsData = events!
                        }else{
                            self.eventsData = self.eventsData+events!
                        }
                        
                        
                    } else {
                    }
                } catch {
                    JSMBHUDBridge.showError(message, view: self.view)
                }
                self.tableView.reloadData()
                
            case let .failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                JSMBHUDBridge.showError(message, view: self.view)
                
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
        }else if (segControl.selectedSegmentIndex == 1) {
            return self.issuesData.count
        }else if (segControl.selectedSegmentIndex == 2) {
            return self.eventsData.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
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

        }else if(segControl.selectedSegmentIndex == 1){
            
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
        
        var cell:CPEventBaseCell?
        let event = self.eventsData[row]
        let eventType:EventType = EventType(rawValue: (event.type!))!
        
        switch(eventType) {
        case .WatchEvent:
            cellId = "CPEventStarredCellIdentifier"
            cell = tableView .dequeueReusableCell(withIdentifier: cellId) as? CPEventStarredCell
            if cell == nil {
                cell = (CPEventStarredCell.cellFromNibNamed("CPEventStarredCell") as! CPEventStarredCell)
            }
            
        case .CreateEvent:
            cellId = "CPEventCreateCellIdentifier"
            cell = tableView .dequeueReusableCell(withIdentifier: cellId) as? CPEventCreateCell
            if cell == nil {
                cell = (CPEventCreateCell.cellFromNibNamed("CPEventCreateCell") as! CPEventCreateCell)
            }
            
        case .PushEvent:
            cellId = "CPEventPushCellIdentifier"
            cell = tableView .dequeueReusableCell(withIdentifier: cellId) as? CPEventPushCell
            if cell == nil {
                cell = (CPEventPushCell.cellFromNibNamed("CPEventPushCell") as! CPEventPushCell)
            }
            
        default:
            cellId = "CPEventStarredCellIdentifier"
            cell = tableView .dequeueReusableCell(withIdentifier: cellId) as? CPEventStarredCell
            if cell == nil {
                cell = (CPEventStarredCell.cellFromNibNamed("CPEventStarredCell") as! CPEventStarredCell)
            }
            
        }
        
        //handle line in cell
        if row == 0 {
            cell!.topline = true
        }
        if (row == eventsData.count-1) {
            cell!.fullline = true
        }else {
            cell!.fullline = false
        }
        cell!.event = event
        
        return cell!;

    }
    
}
extension CPMessageViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if segControl.selectedSegmentIndex == 0 {
            return 55
        }else if(segControl.selectedSegmentIndex == 1){
            return 75
        }else if(segControl.selectedSegmentIndex == 2){
            let event:ObjEvent = self.eventsData[indexPath.row]
            let eventType:EventType = EventType(rawValue: (event.type!))!
            
            switch(eventType) {
            case .WatchEvent:
                return 45
                
            case .CreateEvent:
                return 65
                
            case .PushEvent:
                
                let height:CGFloat = CGFloat( (event.payload?.commits!.count)! ) * 25.0
                let totalHeight:CGFloat = 65+height
                return totalHeight
                
            default:
                return 0
                
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        
        if segControl.selectedSegmentIndex == 1 {
            if issuesData.isBeyond(index: row) {
                return
            }
            let issue:ObjIssue =  issuesData[row]
            let webView = CPWebViewController()
            webView.hidesBottomBarWhenPushed = true
            webView.url = issue.html_url
            self.navigationController?.pushViewController(webView, animated: true)
        }
    }
    
}

