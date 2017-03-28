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
import MBProgressHUD
import HMSegmentedControl

class CPStarsViewController: CPBaseViewController{

    @IBOutlet weak var tableView: UITableView!
    
    var segControl:HMSegmentedControl! = JSHMSegmentedBridge.segmentControl(titles: ["Repositories".localized,"Event".localized])
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(svc_loginSuccessful), name: NSNotification.Name(rawValue: kNotificationDidGitLogin), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(svc_logoutSuccessful), name: NSNotification.Name(rawValue: kNotificationDidGitLogOut), object: nil)
        self.leftItem?.isHidden = true
        self.title = "Stars".localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func svc_loginSuccessful() {
        svc_updateNetrokData()
    }
    
    func svc_logoutSuccessful() {
        
        reposData.removeAll()
        eventsData.removeAll()
        tableView.reloadData()
    }
    
    
    func svc_isLogin()->Bool{
        if( !(UserManager.shared.checkUserLogin()) ){
            reposData.removeAll()
            eventsData.removeAll()
            tableView.reloadData()
            return false
        }
        return true
    }
    
    func svc_updateNetrokData() {
        
        if UserManager.shared.checkUserLogin(){
            
            tableView.mj_footer.isHidden = false

            if segControl.selectedSegmentIndex == 0 {
                svc_getUserReposRequest(self.reposPageVal)
            }else{
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
    
    func svc_setupSegmentView() {
        segControl.addTarget(self, action: #selector(CPStarsViewController.svc_segmentControlChangeValue), for: .valueChanged)
        self.view.addSubview(segControl)
    }
    
    func svc_segmentControlChangeValue() {
        
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
    
    
    func svc_addSwipeGesture() {
        
        let swipeLeft = UISwipeGestureRecognizer.init(target: self, action: #selector(CPStarsViewController.svc_swipeRight(sengder:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.tableView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer.init(target: self, action: #selector(CPStarsViewController.svc_swipeLeft(sengder:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.tableView.addGestureRecognizer(swipeRight)
    }
    
    /// 左滑
    func svc_swipeLeft(sengder:Any) {
        let currentIndex = segControl.selectedSegmentIndex
        var nextIndex = 0
        if  currentIndex == 0{
            nextIndex = segControl.sectionTitles.count-1
        }else{
            nextIndex = currentIndex-1
        }
        segControl.setSelectedSegmentIndex(UInt(nextIndex), animated: true)
        svc_segmentControlChangeValue()
        tableView.setContentOffset(CGPoint.zero, animated:true)
    }
    
    /// 右滑
    func svc_swipeRight(sengder:Any) {
        let currentIndex = segControl.selectedSegmentIndex
        var nextIndex:Int = 0
        if  currentIndex == segControl.sectionTitles.count-1{
            nextIndex = 0
        }else{
            nextIndex = currentIndex+1
        }
        segControl.setSelectedSegmentIndex(UInt(nextIndex), animated: true)
        svc_segmentControlChangeValue()
        tableView.setContentOffset(CGPoint.zero, animated:true)
    }
    
    // MARK: - Tableview
    
    func svc_setupTableView() {
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.viewBackgroundColor
        self.automaticallyAdjustsScrollViewInsets = false
        
        // 下拉刷新
        header.setTitle("", for: .idle)
        header.setTitle(kHeaderPullTip, for: .pulling)
        header.setTitle(kHeaderPullingTip, for: .refreshing)
        header.setRefreshingTarget(self, refreshingAction: #selector(CPStarsViewController.headerRefresh))
        // 现在的版本要用mj_header
        self.tableView.mj_header = header
        
        // 上拉刷新
        footer.setTitle("", for: .idle)
        footer.setTitle(kFooterLoadTip, for: .pulling)
        footer.setTitle(kFooterLoadNoDataTip, for: .noMoreData)
        footer.setRefreshingTarget(self, refreshingAction: #selector(CPStarsViewController.footerRefresh))
        footer.isRefreshingTitleHidden = true
        self.tableView.mj_footer = footer
        
        self.svc_addSwipeGesture()
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
            self.reposPageVal += 1
        }else{
            self.eventPageVal += 1
        }
        svc_updateNetrokData()
    }
    
    
    // MARK: fetch data form request
    
    func svc_getUserReposRequest(_ pageVal:Int) {
        
        print("page:\(pageVal)")
        
        JSMBHUDBridge.showHud(view: self.view)
        
        Provider.sharedProvider.request(.myStarredRepos(page:pageVal,perpage:7,sort: sortVal,direction: directionVal) ) { (result) -> () in

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
                    if let repos:[ObjRepos]? = try response.mapArray(ObjRepos.self){
                        if(pageVal == 1) {
                            self.reposData.removeAll()
                            self.reposData = repos!
                        }else{
                            self.reposData = self.reposData+repos!
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

extension CPStarsViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segControl.selectedSegmentIndex == 0 {
            return  self.reposData.count
        }
        return self.eventsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row

        var cellId = ""
        
        if segControl.selectedSegmentIndex == 0 {
            
            cellId = "CPStarredReposCellIdentifier"
            var cell = tableView .dequeueReusableCell(withIdentifier: cellId) as? CPStarredReposCell
            if cell == nil {
                cell = CPStarredReposCell(style: UITableViewCellStyle.default, reuseIdentifier:cellId)
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
extension CPStarsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let repos = self.reposData[indexPath.row]
        let vc = CPRepoDetailController()
        vc.hidesBottomBarWhenPushed = true
        vc.repos = repos
        self.navigationController?.pushViewController(vc, animated: true)        
    }
}
