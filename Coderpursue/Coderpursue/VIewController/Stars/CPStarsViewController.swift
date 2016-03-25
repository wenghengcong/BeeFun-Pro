//
//  CPStarsViewController.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/23.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit
import Moya
import Foundation
import MJRefresh

class CPStarsViewController: CPBaseViewController{

    @IBOutlet weak var tableView: UITableView!
    
    var segControl:HMSegmentedControl! = HMSegmentedControl.init(sectionTitles: ["Repositories","Event"])
    
    var reposData:[ObjRepos]! = []
    var eventsData:[ObjEvent]! = []
    var sortVal:String = "created"
    var directionVal:String = "desc"
    var reposPageVal = 1
    var eventPageVal = 1
    
    let header = MJRefreshNormalHeader()
    let footer = MJRefreshAutoNormalFooter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        svc_setupSegmentView()
        svc_setupTableView()
        svc_updateNetrokData()
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Stars"
    }
    
    func svc_isLogin()->Bool{
        if( !(UserInfoHelper.sharedInstance.isLoginIn) ){
            CPGlobalHelper.sharedInstance.showMessage("You Should Login in first!", view: self.view)
            reposData.removeAll()
            eventsData.removeAll()
            tableView.reloadData()
            return false
        }
        return true
    }
    
    func svc_updateNetrokData() {
        
        if svc_isLogin(){
            
            tableView.mj_footer.hidden = false

            if segControl.selectedSegmentIndex == 0 {
                svc_getUserReposRequest(self.reposPageVal)
            }else{
                svc_getUserEventsRequest(self.eventPageVal)
            }
            
        }else{
            //加载未登录的页面
            tableView.mj_header.endRefreshing()
            tableView.mj_footer.endRefreshing()
            tableView.mj_footer.hidden = true

        }
    }
    
    func svc_setupSegmentView() {
        
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
            
            if(!self.svc_isLogin()){
                return
            }
            
            if( (self.segControl.selectedSegmentIndex == 0) && self.reposData != nil){
                self.svc_getUserReposRequest(self.reposPageVal)
            }else if( (self.segControl.selectedSegmentIndex == 1)&&self.eventsData != nil ){
                self.svc_getUserEventsRequest(self.eventPageVal)
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
    
    func svc_setupTableView() {
        
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
        if segControl.selectedSegmentIndex == 0 {
            self.reposPageVal = 1
        }else{
            self.eventPageVal = 1
        }
        svc_updateNetrokData()
    }
    
    // 底部刷新
    func footerRefresh(){
        print("上拉刷新")
        if segControl.selectedSegmentIndex == 0 {
            self.reposPageVal++
        }else{
            self.eventPageVal++
        }
        svc_updateNetrokData()
    }
    
    
    // MARK: fetch data form request
    
    func svc_getUserReposRequest(pageVal:Int) {
        
        print("page:\(pageVal)")
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        Provider.sharedProvider.request(.MyStarredRepos(page:pageVal,perpage:7,sort: sortVal,direction: directionVal) ) { (result) -> () in

            var success = true
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
                    if let repos:[ObjRepos]? = try response.mapArray(ObjRepos){
                        if(pageVal == 1) {
                            self.reposData.removeAll()
                            self.reposData = repos!
                        }else{
                            self.reposData = self.reposData+repos!
                        }
                        
                        self.tableView.reloadData()
                        
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
    
    func svc_getUserEventsRequest(pageVal:Int) {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        Provider.sharedProvider.request(.UserEvents(username:ObjUser.loadUserInfo()!.login! ,page:pageVal,perpage:15) ) { (result) -> () in
            
            var success = true
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
                    if let events:[ObjEvent]? = try response.mapArray(ObjEvent){
                        if(pageVal == 1) {
                            self.eventsData.removeAll()
                            self.eventsData = events!
                        }else{
                            self.eventsData = self.eventsData+events!
                        }
                        
                        
                    } else {
                        success = false
                    }
                } catch {
                    success = false
                    CPGlobalHelper.sharedInstance.showError(message, view: self.view)
                }
                self.tableView.reloadData()

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

extension CPStarsViewController : UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segControl.selectedSegmentIndex == 0 {
            return  self.reposData.count
        }
        return self.eventsData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = indexPath.row

        var cellId = ""
        
        if segControl.selectedSegmentIndex == 0 {
            
            cellId = "CPStarredReposCellIdentifier"
            var cell = tableView .dequeueReusableCellWithIdentifier(cellId) as? CPStarredReposCell
            if cell == nil {
                cell = CPStarredReposCell(style: UITableViewCellStyle.Default, reuseIdentifier:cellId)
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
        
        var cell:CPEventBaseCell?
        let event = self.eventsData[row]
        let eventType:EventType = EventType(rawValue: (event.type!))!
        
        switch(eventType) {
        case .WatchEvent:
            cellId = "CPEventStarredCellIdentifier"
            cell = tableView .dequeueReusableCellWithIdentifier(cellId) as? CPEventStarredCell
            if cell == nil {
                cell = (CPEventStarredCell.cellFromNibNamed("CPEventStarredCell") as! CPEventStarredCell)
            }
            
        case .CreateEvent:
            cellId = "CPEventCreateCellIdentifier"
            cell = tableView .dequeueReusableCellWithIdentifier(cellId) as? CPEventCreateCell
            if cell == nil {
                cell = (CPEventCreateCell.cellFromNibNamed("CPEventCreateCell") as! CPEventCreateCell)
            }
            
        case .PushEvent:
            cellId = "CPEventPushCellIdentifier"
            cell = tableView .dequeueReusableCellWithIdentifier(cellId) as? CPEventPushCell
            if cell == nil {
                cell = (CPEventPushCell.cellFromNibNamed("CPEventPushCell") as! CPEventPushCell)
            }
            
        default:
            cellId = "CPEventStarredCellIdentifier"
            cell = tableView .dequeueReusableCellWithIdentifier(cellId) as? CPEventStarredCell
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
extension CPStarsViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if segControl.selectedSegmentIndex == 0 {
            
            return 85
            
        }else{
            
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
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let repos = self.reposData[indexPath.row]
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
