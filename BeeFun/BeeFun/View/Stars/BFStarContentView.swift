//
//  BFStarContentView.swift
//  BeeFun
//
//  Created by WengHengcong on 26/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper

class BFStarContentView: UIView, UITableViewDelegate, UITableViewDataSource, MJRefreshManagerAction {

    //Reload View
    let reloadViewTag = 19999
    // 重试提醒
    var reloadTip = "Wake up your connection!".localized
    // 重试提醒的图片
    var reloadImage = "network_error_1"
    //重试加载按钮的title
    var reloadActionTitle = "Try Again".localized
    
    //Reload View
    let emptyViewTag = 19998
    // 无数据提醒
    var emptyTip = "Empty now,star repositories and tag it".localized
    // 无数据提醒的图片
    var emptyImage = "empty_data"
    // 无数据按钮的title
    var emptyActionTitle = "Explore more".localized
    /// 是否显示空白视图
    var showEmpty = false
    
    // MARK: - View
    var tableView: UITableView = UITableView()
    let refreshManager = MJRefreshManager()
    
    // MARK: - Data
    
    /// 当前页面所对应的tag
    var tagTitle: String?
    var starReposData: [ObjRepos] = []
    
    var reposPageVal = 1
    var reposPerpage = 15
    var sortVal: String = "created"
    var directionVal: String = "desc"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }
    
    convenience init(frame: CGRect, tag: String) {
        self.init(frame: frame)
        self.tagTitle = tag
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        tableView.frame = self.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        refreshManager.delegate = self
        tableView.mj_header = refreshManager.header()
        tableView.mj_footer = refreshManager.footer()
        tableView.backgroundColor = UIColor.white
        if #available(iOS 11, *) {
            tableView.estimatedRowHeight = 0
            tableView.estimatedSectionHeaderHeight = 0
            tableView.estimatedSectionFooterHeight = 0
        }
        addSubview(tableView)
    }
    
    /// 当前页面是否已经拉取到数据
    func hasData() -> Bool {
        return starReposData.count > 0
    }
    
    /// 重新加载本页面数据
    ///
    /// - Parameter force: 是否需要强制去请求去拿网络数据
    func reloadNetworkData(force: Bool) {
        if UserManager.shared.isLogin {//已登录
            tableView.mj_footer.isHidden = false
            if force {
                requestFirstPage()
            } else {
                if !hasData() {
                    requestFirstPage()
                }
            }
        } else {
            clearAllData()
            //加载未登录的页面
            tableView.mj_footer.isHidden = true
        }
    }
    
    private func clearAllData() {
        starReposData.removeAll()
        tableView.reloadData()
    }
    
   private func requestFirstPage() {
        reposPageVal = 1
        svc_getStaredReposRequest(reposPageVal)
    }
    
   private func requestNextPage() {
        reposPageVal += 1
        svc_getStaredReposRequest(reposPageVal)
    }
}

// MARK: - Refresh
extension BFStarContentView {
    
    func headerRefresh() {
        tableView.mj_header.endRefreshing()
        requestFirstPage()
    }
    
    func footerRefresh() {
        tableView.mj_footer.endRefreshing()
        requestNextPage()
    }
}

// MARK: - empty and network error
extension BFStarContentView: BFPlaceHolderViewDelegate {
    
    func showReloadView() {
        removeReloadView()
        tableView.isHidden = true
        let placeReloadView = BFPlaceHolderView(frame: self.frame, tip: reloadTip, image: reloadImage, actionTitle: reloadActionTitle)
        placeReloadView.placeHolderActionDelegate = self
        placeReloadView.tag = reloadViewTag
        insertSubview(placeReloadView, at: 0)
        self.bringSubview(toFront: placeReloadView)
    }
    
    func removeReloadView() {
        if let reloadView = viewWithTag(reloadViewTag) {
            reloadView.removeFromSuperview()
        }
        tableView.isHidden = false
    }
    
    func didAction(place: BFPlaceHolderView) {
        self.reloadNetworkData(force: true)
    }
    
}

extension BFStarContentView {
    
    /// Get stared repos
    @objc private func svc_getStaredReposRequest(_ pageVal: Int) {
        if DeviceType.isPad {
            reposPerpage = 25
        }
        if tagTitle == nil || tagTitle?.length == 0 {
            return
        }
        let hud = JSMBHUDBridge.showHud(view: self)
        BeeFunProvider.sharedProvider.request(BeeFunAPI.repos(tag: tagTitle!, language: "all", page: pageVal, perpage: reposPerpage, sort: "starred_at", direction: "desc")) { (result) in
            self.showEmpty = false
            hud.hide(animated: true)
            switch result {
            case let .success(response):
                do {
                    if let allRepos: GetReposResponse = Mapper<GetReposResponse>().map(JSONObject: try response.mapJSON()) {
                        if let code = allRepos.codeEnum, code == BFStatusCode.bfOk {
                            if let data = allRepos.data {
                                DispatchQueue.main.async {
                                    self.hanldeStaredRepoResponse(repos: data)
                                }
                            }
                        }
                    }
                } catch {
                    self.showReloadView()
                }
            case .failure:
                self.showReloadView()
            }
        }
    }
    
    private func hanldeStaredRepoResponse(repos: [ObjRepos]) {
        removeReloadView()
        if reposPageVal == 1 {
            self.starReposData.removeAll()
            self.starReposData = repos
        } else {
            self.starReposData += repos
        }
        if starReposData.count == 0 {
            showEmpty = true
        } else {
            showEmpty = false
        }
        tableView.reloadData()
    }
}

// MARK: - TableViewdatasource
extension BFStarContentView: BFEmptyDataCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showEmpty ? 1 : starReposData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        if !showEmpty {
            let cellId = "BFRepositoryTypeOneCellIdentifier"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? BFRepositoryTypeOneCell
            if cell == nil {
                cell = (BFRepositoryTypeOneCell.cellFromNibNamed("BFRepositoryTypeOneCell") as? BFRepositoryTypeOneCell)
            }
            if !starReposData.isBeyond(index: row) {
                cell?.setBothEndsLines(row, all: starReposData.count)
                let repos = starReposData[row]
                cell!.objRepos = repos
            }
            return cell!
        } else {
            let cellId = "BFEmptyStarDataCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? BFEmptyDataCell
            if cell == nil {
                cell = BFEmptyDataCell(style: .default, reuseIdentifier: cellId)
                cell?.display(tip: emptyTip, imageName: emptyImage, actionTitle: emptyActionTitle)
            }
            cell?.delegate = self
            
            return cell!
        }
    }
    
    func didClickEmptyAction(cell: BFEmptyDataCell) {
        BFTabbarManager.shared.goto(index: 0)
    }
}

// MARK: - Tableview delegate

extension BFStarContentView {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if showEmpty {
            return height
        }
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if showEmpty {
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        if !starReposData.isBeyond(index: row) {
            let repos = starReposData[row]
            JumpManager.shared.jumpReposDetailView(repos: repos, from: .star)
        }
    }
}
