//
//  BFMessageConentView.swift
//  BeeFun
//
//  Created by WengHengcong on 13/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import YYText

class BFMessageConentView: UIView, UITableViewDelegate, UITableViewDataSource, MJRefreshManagerAction {

    var index: Int = 0

    // MARK: - View
    var tableView: UITableView = UITableView()
    let refreshManager = MJRefreshManager()

    // MARK: - Data
    var notificationsData: [ObjNotification] = []
    var issuesData: [ObjIssue] = []
    var eventsData: [ObjEvent] = []
    
    // MARK: request parameters
    //notification
    var notiAllPar: String = "false"
    var notiPartPar: String = "false"
    var notiCurrentPage = 1
    
    //issue
    var issueFilterPar: String = "all"
    var issueStatePar: String = "all"
    var issueLabelsPar: String = ""
    var issueSortPar: String = "created"
    var issueDirectionPar: String = "desc"
    var issueCurrentPage: Int = 1
    
    /// Event
    var eventRequestLoding = false
    var eventCurrentPage = 1
    
    var layouts: [BFEventLayout] = []
    weak var delegate: BFViewControllerNetworkProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, index: Int) {
        self.init(frame: frame)
        self.index = index
        isUserInteractionEnabled = true
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTableView() {
        tableView.isUserInteractionEnabled = true
        tableView.frame = self.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        refreshManager.delegate = self
        tableView.mj_header = refreshManager.header()
        tableView.mj_footer = refreshManager.footer()
        tableView.backgroundColor = UIColor.bfViewBackgroundColor
        if #available(iOS 11, *) {
            tableView.estimatedRowHeight = 0
            tableView.estimatedSectionHeaderHeight = 0
            tableView.estimatedSectionFooterHeight = 0
        }
        self.addSubview(tableView)
    }
    
    func headerRefresh() {
        tableView.mj_header.endRefreshing()
        if self.index == 0 {
            if eventRequestLoding {    //正在加载中不需要再次
                return
            }
           eventCurrentPage = 1
        } else if self.index == 1 {
            issueCurrentPage = 1
        } else if self.index == 2 {
            notiCurrentPage = 1
        }
        refreshData()
    }
    
    func footerRefresh() {
        tableView.mj_footer.endRefreshing()
        if self.index == 0 {
            if eventRequestLoding {    //正在加载中不需要再次
                return
            }
            eventCurrentPage += 1
        } else if self.index == 1 {
            issueCurrentPage += 1
        } else if self.index == 2 {
            notiCurrentPage += 1
        }
        refreshData()
    }
    
    func refreshData() {
        if UserManager.shared.isLogin {//已登录
            tableView.mj_footer.isHidden = false
            if self.index == 0 {
                mc_getUserEventsRequest(eventCurrentPage)
            } else if self.index == 1 {
                mc_getIssuesRequest(issueCurrentPage)
            } else if self.index == 2 {
                mc_getNotificationsRequest(notiCurrentPage)
            }
        } else {
            tableView.mj_footer.isHidden = true
        }
    }
    
    /// 外界加载用
    func reloadNetworkData() {
        if UserManager.shared.isLogin {//已登录
            tableView.mj_footer.isHidden = false
            if self.index == 0 && eventsData.count == 0 {
                mc_getUserEventsRequest(eventCurrentPage)
            } else if self.index == 1 && issuesData.count == 0 {
                mc_getIssuesRequest(issueCurrentPage)
            } else if self.index == 2 && notificationsData.count == 0 {
                mc_getNotificationsRequest(notiCurrentPage)
            } else {
                if BFNetworkManager.shared.isReachable {
                    self.delegate?.networkSuccssful()
                } else {
                    self.delegate?.networkFailure()
                }
            }
        } else {
            //加载未登录的页面
            tableView.mj_footer.isHidden = true
        }
    }
    
    func reloadTableData() {
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDatasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.index == 0 {
            return self.eventsData.count
        } else if self.index == 1 {
            return self.issuesData.count
        } else if self.index == 2 {
            return self.notificationsData.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        var cellId = ""
        if self.index == 2 {
            cellId = "CPMesNotificationCellIdentifier"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? CPMesNotificationCell
            if cell == nil {
                cell = (CPMesNotificationCell.cellFromNibNamed("CPMesNotificationCell") as? CPMesNotificationCell)
            }
            cell?.setBothEndsLines(row, all: notificationsData.count)
            let noti = self.notificationsData[row]
            cell?.noti = noti
            
            return cell!
        } else if self.index == 1 {
            cellId = "CPMesIssueCellIdentifier"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? CPMesIssueCell
            if cell == nil {
                cell = (CPMesIssueCell.cellFromNibNamed("CPMesIssueCell") as? CPMesIssueCell)
            }
            cell?.setBothEndsLines(row, all: issuesData.count)
            let issue = self.issuesData[row]
            cell!.issue = issue
            return cell!
        }
        
        var cell: BFEventCell?
        cellId = "BFEventCell"
        cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? BFEventCell
        if cell == nil {
            cell = BFEventCell.init(style: .default, reuseIdentifier: cellId)
        }
        if indexPath.row < self.layouts.count {
            let layout = self.layouts[indexPath.row]
            cell?.setLayout(layout: layout)
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.index == 0 {
            if indexPath.row < self.layouts.count {
                let layout = self.layouts[indexPath.row]
                return layout.totalHeight
            }
            return 0
        } else if self.index == 1 {
            return 75
        } else if self.index == 2 {
            return 55
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row

        if self.index == 1 {
            if issuesData.isBeyond(index: row) {
                return
            }
            let issue: ObjIssue =  issuesData[row]
            JumpManager.shared.jumpIssueDetailView(issue: issue)
        }
    }
}

extension BFMessageConentView {
    
    // MARK: - fetch data form request
    
    /// 获取通知
    func mc_getNotificationsRequest(_ pageVal: Int) {
        var perPage: Int = 15
        if DeviceType.isPad {
            perPage = 25
        }
        let hud = JSMBHUDBridge.showHud(view: self)
        Provider.sharedProvider.request( .myNotifications(page:pageVal, perpage:perPage, all:notiAllPar, participating:notiPartPar) ) { (result) -> Void in
            hud.hide(animated: true)
            switch result {
            case let .success(response):
                do {
                    self.delegate?.networkSuccssful()
                    let notis: [ObjNotification] = try response.mapArray(ObjNotification.self)
                    if pageVal == 1 {
                        self.notificationsData.removeAll()
                        self.notificationsData = notis
                    } else {
                        self.notificationsData += notis
                    }
                    self.tableView.reloadData()
                    return
                } catch {
                    self.delegate?.networkFailure()
                }
            case .failure:
                self.delegate?.networkFailure()
            }
        }
    }
    
    ///获取Issue
    func mc_getIssuesRequest(_ pageVal: Int) {
        var perPage: Int = 15
        if DeviceType.isPad {
            perPage = 25
        }
        
        let hud = JSMBHUDBridge.showHud(view: self)
        IssueProvider.sharedProvider.request(.allIssues( page:pageVal, perpage:perPage, filter:issueFilterPar, state:issueStatePar, labels:issueLabelsPar, sort:issueSortPar, direction:issueDirectionPar) ) { (result) -> Void in
            hud.hide(animated: true)
            switch result {
            case let .success(response):
                do {
                    self.delegate?.networkSuccssful()
                    let issues: [ObjIssue] = try response.mapArray(ObjIssue.self)
                    if pageVal == 1 {
                        self.issuesData.removeAll()
                        self.issuesData = issues
                    } else {
                        self.issuesData += issues
                    }
                    
                    self.tableView.reloadData()
                    return
                } catch {
                    self.delegate?.networkFailure()
                }
            case .failure:
                self.delegate?.networkFailure()
            }
        }
        
    }
    
    ///获取event
    func mc_getUserEventsRequest(_ pageVal: Int) {
        if eventRequestLoding {  //正在加载的不请求
            return
        }
        var perPage: Int = 15
        if DeviceType.isPad {
            perPage = 25
        }
        let hud = JSMBHUDBridge.showHud(view: self)
        eventRequestLoding = true
        EventProvider.sharedProvider.request(.userReceivedEvents(username:UserManager.shared.login!, page:pageVal, perpage:perPage)) { (result) -> Void in
            self.eventRequestLoding = false
            hud.hide(animated: true)
            switch result {
            case let .success(response):
                do {
                    self.delegate?.networkSuccssful()
                    let events: [ObjEvent] = try response.mapArray(ObjEvent.self)
                    
                    var indexPaths: [IndexPath] = []
                    if pageVal == 1 {
                        self.eventsData.removeAll()
                        self.eventsData = events
                        self.layouts.removeAll()
                    } else {
                        for i in 0..<events.count {
                            let indexPath = IndexPath(row: i+self.eventsData.count, section: 0)
                            indexPaths.append(indexPath)
                        }
                        self.eventsData += events
                    }
                    for event in self.eventsData {
                        let layout = BFEventLayout(event: event)
                        self.layouts.append(layout)
                    }

                    DispatchQueue.main.async {
                        if pageVal == 1 {
                            self.tableView.reloadData()
                        } else {
                            self.tableView.beginUpdates()
                            self.tableView.insertRows(at: indexPaths, with: UITableViewRowAnimation.bottom)
                            self.tableView.endUpdates()
                        }
//                            self.p_screenshotImage()
                    }
                } catch {
                    self.delegate?.networkFailure()
                }
            case .failure:
                self.delegate?.networkFailure()
            }
        }
    }
    
    /// 截全屏
    func p_screenshotImage() {
        if UIScreen.main.responds(to: #selector(NSDecimalNumberBehaviors.scale) ) {
            UIGraphicsBeginImageContextWithOptions(self.window!.bounds.size, false, UIScreen.main.scale)
        } else {
            UIGraphicsBeginImageContext(self.window!.bounds.size)
        }
        self.window?.layer.render(in: UIGraphicsGetCurrentContext()!)
//        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        //                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
}
