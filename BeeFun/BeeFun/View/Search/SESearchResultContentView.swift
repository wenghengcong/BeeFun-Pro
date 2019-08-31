//
//  SESearchResultContentView.swift
//  BeeFun
//
//  Created by WengHengcong on 28/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper

protocol SESearchResultContentDelegate: class {
    func contentViewDidScroll(_ conetView: SESearchResultContentView)
    func contentView(_ contentView: SESearchResultContentView, didSelectRowAt indexPath: IndexPath)
}

class SESearchResultContentView: UIView, UITableViewDelegate, UITableViewDataSource, MJRefreshManagerAction {

    var index: Int = 0
    // MARK: - View
    var tableView: UITableView = UITableView()
    let refreshManager = MJRefreshManager()
    
    var reposData: SEResponseRepos = SEResponseRepos()
    var usersData: SEResponseUsers = SEResponseUsers()
    var issueData: SEResponseIssues = SEResponseIssues()
    var codeData: SEResponseCode = SEResponseCode()
    var commitData: SEResponseCommits = SEResponseCommits()
    var wikiData: SEResponseWikis = SEResponseWikis()
    var searchModel: SESearchBaseModel
    var forceRefresh: Bool = false
    weak var delegate: SESearchResultContentDelegate?
    
    override init(frame: CGRect) {
        self.searchModel = SESearchBaseModel()
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, index: Int, searchModel: SESearchBaseModel) {
        self.init(frame: frame)
        self.index = index
        self.searchModel = searchModel
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTableView() {
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
    
    // MARK: - Data
    
    /// 外部加载调用
    func reloadNetworkData() {
        if forceRefresh {
            if searchModel.page == 1 {
                tableView.setContentOffset(CGPoint.zero, animated: true)
            }
            refreshData()
        } else {
            tableView.reloadData()
        }
    }
    
    func headerRefresh() {
        searchModel.page = 1
        tableView.mj_header.endRefreshing()
        refreshData()
    }
    
    func footerRefresh() {
        tableView.mj_footer.endRefreshing()
        searchModel.page += 1
        refreshData()
    }
    
    func refreshData() {
        srvc_searchNow(searchModel: searchModel)
    }
    
}

// MARK: - UITableView
extension SESearchResultContentView {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.delegate != nil {
            self.delegate?.contentViewDidScroll(self)
        }
    }
    
    func srvc_heightForRowAt(type: SESearchType) -> CGFloat {
        switch type {
        case .repo:
            return 85
        case .user:
            return 71
        case .issue:
            return 75
        case .code:
            return 0
        case .commit:
            return 0
        case .wiki:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return srvc_heightForRowAt(type: searchModel.type)
    }
    
    func srvc_numberOfRowsInSection(type: SESearchType) -> Int {
        switch type {
        case .repo:
            return reposData.items?.count ?? 0
        case .user:
            return usersData.items?.count ?? 0
        case .issue:
            return issueData.items?.count ?? 0
        case .code:
            return codeData.items?.count ?? 0
        case .commit:
            return commitData.items?.count ?? 0
        case .wiki:
            return wikiData.items?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return srvc_numberOfRowsInSection(type: searchModel.type)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellId = ""
        let row = indexPath.row
        if searchModel.type == .repo {
            
            cellId = "BFRepositoryTypeThirdCellIdentifier"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? BFRepositoryTypeThirdCell
            if cell == nil {
                cell = (BFRepositoryTypeThirdCell.cellFromNibNamed("BFRepositoryTypeThirdCell") as? BFRepositoryTypeThirdCell)
            }
            
            if reposData.items == nil {
                return cell!
            }
            
            if self.reposData.items!.isBeyond(index: row) {
                return cell!
            }
            cell?.setBothEndsLines(row, all: reposData.items!.count)
            
            let repos = self.reposData.items![row]
            cell!.objRepos = repos
            
            return cell!
            
        } else if searchModel.type == .user {
            
            cellId = "BFUserTypeSecCellIdentifier"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? BFUserTypeSecCell
            if cell == nil {
                cell = (BFUserTypeSecCell.cellFromNibNamed("BFUserTypeSecCell") as? BFUserTypeSecCell)
            }
            
            cell?.setBothEndsLines(row, all: usersData.items!.count)
            let user = self.usersData.items![row]
            cell!.user = user
            cell!.userNo = row
            
            return cell!
        } else if searchModel.type == .issue {
            cellId = "CPMesIssueCellIdentifier"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? CPMesIssueCell
            if cell == nil {
                cell = (CPMesIssueCell.cellFromNibNamed("CPMesIssueCell") as? CPMesIssueCell)
            }
            if issueData.items == nil {
                return cell!
            }
            if self.issueData.items!.isBeyond(index: row) {
                return cell!
            }
            
            cell?.setBothEndsLines(row, all:issueData.items!.count)
            let issue = self.issueData.items![row]
            cell!.issue = issue
            return cell!
        } else if searchModel.type == .code {
            
        } else if searchModel.type == .commit {
            
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //视图重置刷新
        tableView.deselectRow(at: indexPath, animated: true)
        if self.delegate != nil {
            self.delegate?.contentView(self, didSelectRowAt: indexPath)
        }
        
        let row = indexPath.row
        if searchModel.type == .repo {
            if !self.reposData.items!.isBeyond(index: row) {
                let repos = self.reposData.items![row]
                JumpManager.shared.jumpReposDetailView(repos: repos, from: .search)
            }
            
        } else if searchModel.type == .user {
            if !self.usersData.items!.isBeyond(index: row) {
                let user = self.usersData.items![row]
                JumpManager.shared.jumpUserDetailView(user: user)
            }
        } else if searchModel.type == .issue {
            if !self.issueData.items!.isBeyond(index: row) {
                let issue = self.issueData.items![row]
                JumpManager.shared.jumpIssueDetailView(issue: issue)
            }
        } else if searchModel.type == .code {
            
        } else if searchModel.type == .commit {
            
        }
    }
}

extension SESearchResultContentView {
    
    func srvc_searchNow(searchModel: SESearchBaseModel) {
        let hud = JSMBHUDBridge.showHud(view: self)
        SearchProvider.sharedProvider.request(.search(para:searchModel)) { (result) in
            hud.hide(animated: true)
            var message = kNoDataFoundTip
            switch result {
            case let .success(response):
                do {
                    if response.statusCode != 200 {
                        let errStr = try response.mapString()
                        print(errStr)
                        return
                    }
                    switch searchModel.type {
                    case .repo:
                        if let reposResult: SEResponseRepos = Mapper<SEResponseRepos>().map(JSONString: try response.mapString()) {
                            if self.searchModel.page == 1 {
                                self.reposData.items = reposResult.items
                            } else {
                                self.reposData.items! += reposResult.items!
                            }
                            self.reposData.totalCount = reposResult.totalCount
                            self.reposData.incompleteResults = reposResult.incompleteResults
                        }
                    case .user:
                        if let usersResult: SEResponseUsers = Mapper<SEResponseUsers>().map(JSONString: try response.mapString()) {
                            if self.searchModel.page == 1 {
                                self.usersData.items = usersResult.items
                            } else {
                                self.usersData.items! += usersResult.items!
                            }
                            self.usersData.totalCount = usersResult.totalCount
                            self.usersData.incompleteResults = usersResult.incompleteResults
                        }
                    case .issue:
                        if let issueResult: SEResponseIssues = Mapper<SEResponseIssues>().map(JSONString: try response.mapString()) {
                            if self.searchModel.page == 1 {
                                self.issueData.items = issueResult.items
                            } else {
                                self.issueData.items! += issueResult.items!
                            }
                            self.issueData.totalCount = issueResult.totalCount
                            self.issueData.incompleteResults = issueResult.incompleteResults
                        }
                    case .code:
                        if let codeResult: SEResponseCode = Mapper<SEResponseCode>().map(JSONString: try response.mapString()) {
                            if self.searchModel.page == 1 {
                                self.codeData.items = codeResult.items
                            } else {
                                self.codeData.items! += codeResult.items!
                            }
                            self.codeData.totalCount = codeResult.totalCount
                            self.codeData.incompleteResults = codeResult.incompleteResults
                        }
                    default:
                        break
                    }
                    self.tableView.reloadData()
                } catch {
                    JSMBHUDBridge.showError(message, view: self)
                }
            case .failure:
                message = kNetworkErrorTip
                JSMBHUDBridge.showError(message, view: self)
            }
        }
    }
    
}
