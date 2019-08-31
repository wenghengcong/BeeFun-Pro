//
//  BFStarController.swift
//  BeeFun
//
//  Created by WengHengcong on 26/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import HMSegmentedControl
import iCarousel

class BFStarController: BFBaseViewController, JSSegmentControlProtocol, iCarouselDelegate, iCarouselDataSource {
    // MARK: - View
    var navSegmentView: JSSegmentControl?           //导航栏选择
    //tag选择
    var clickTag: Bool = false
    var tagBar: HMSegmentedControl! = JSHMSegmentedBridge.segmentControl()          //tag栏
    //主内容区域
    var carouselContent: iCarousel = iCarousel()
    var watchedTableView = UITableView()
    //更多
    var moreBtn = UIButton()
    var moreView = UIScrollView()
    var allButtons: [UIButton] = []
    var lastContentIndex: Int = 0
    
    var watchPageVal = 1
    var watchPerpage = 15
    var sortVal: String = "created"
    var directionVal: String = "desc"
    
    var tagFilter: TagFilter = TagFilter()
    
    // MARK: - Data
    var starTags: [String] = []
    var watchsData: [ObjRepos] = []
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        svc_requestFetchTags(reloadCurrentPageData: true)
        svc_customViewBeforeGetTags()
        svc_registerNotification()
        reloadViewClosure = { [weak self] (reachable)  in
            self?.changeNavSegmentControl(index: (self?.navSegmentView!.selIndex)!)
        }
        loginViewClosure = { [weak self] (login) in
            self?.changeNavSegmentControl(index: (self?.navSegmentView!.selIndex)!)
        }
        _ = checkCurrentLoginState()
        _ = checkCurrentNetworkState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        svc_moreViewDisappear()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - fetch data
    // 各种通知过来重新刷新数据：登录后、删除tag、更新tag
    func svc_updateDataWhenReceiveNotification() {
        if checkCurrentLoginState() {
            watchedTableView.mj_footer.isHidden = false
            if navSegmentView?.selIndex == 0 {
                currentContentReloadTagsRepos(force: true)
            } else {
                svc_getWatchedReposRequest(watchPageVal)
            }
        } else {
            //加载未登录的页面
            watchedTableView.mj_footer.isHidden = true
        }
    }
    
    // MARK: - Action
    /// 点击更多按钮
    @objc func svc_clickMoreAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        svc_moreViewAnimation(show: sender.isSelected)
    }
    
    /// 点击更多视图中的某个标签
    @objc func svc_clickTagInMoreView(sender: UIButton) {
        svc_layoutAllTagsButton()
        svc_moreViewAnimation(show: false)
        moreBtn.isSelected = false
        let index = sender.tag
        tagBar.setSelectedSegmentIndex(UInt(index), animated: true)
        carouselContent.scrollToItem(at: index, animated: true)
    }
    
}

// MARK: - Refresh
extension BFStarController {
    
    override func headerRefresh() {
        watchedTableView.mj_header.endRefreshing()
        watchPageVal = 1
        svc_getWatchedReposRequest(watchPageVal)
    }
    
    override func footerRefresh() {
        watchedTableView.mj_footer.endRefreshing()
        watchPageVal += 1
        svc_getWatchedReposRequest(watchPageVal)
    }
}

// MARK: - iCarousel
extension BFStarController {
    
    func currentContentView() -> BFStarContentView? {
        let content = carouselContent.currentItemView as? BFStarContentView
        return content
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return starTags.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var tag: String?
        if !self.starTags.isBeyond(index: index) {
            tag = self.starTags[index]
        }
        var contentView: BFStarContentView
        if tag != nil {
            contentView = BFStarContentView.init(frame: carouselContent.bounds, tag: tag!)
        } else {
            contentView = BFStarContentView.init(frame: carouselContent.bounds)
        }
        carousel.decelerationRate = 0.05
        return contentView
    }
    
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        carousel.decelerationRate = 0.05
        let currentIndex = carousel.currentItemIndex
        // 如果是点击tag控件，则不需要改变tag index
        if !clickTag {
            if !tagBar.sectionTitles.isBeyond(index: currentIndex) {
                tagBar.setSelectedSegmentIndex(UInt(currentIndex), animated: true)
            }
        }
        clickTag = false
        currentContentReloadTagsRepos(force: (abs(lastContentIndex - currentIndex) > 2) )
    }
    
    /// 重新加载tag页面数据
    func currentContentReloadTagsRepos(force: Bool) {
        currentContentView()?.reloadNetworkData(force: force)
    }
}

// MARK: - SegmentControl
extension BFStarController {
    /// 点击头部tags列表动作
    func tagSegmentControlChange(index: Int) {
        self.clickTag = true
        self.carouselContent.scrollToItem(at: index, animated: true)
    }
    
    /// 点击导航栏segment control
    func selectedSegmentContrlol(segment: JSSegmentControl, index: Int) {
        if !checkCurrentLoginState() {
            watchsData.removeAll()
            carouselContent.reloadData()
            watchedTableView.reloadData()
            return
        }
        changeNavSegmentControl(index: index)
        if watchsData.isEmpty {
            svc_getWatchedReposRequest(watchPageVal)
        }
    }
    
    func changeNavSegmentControl(index: Int) {
        let watchViewHidden = index == 0 ? true : false
        watchedTableView.isHidden = watchViewHidden
        tagBar.isHidden = !watchViewHidden
        moreBtn.isHidden = !watchViewHidden
        moreView.isHidden = !watchViewHidden
        carouselContent.isHidden = !watchViewHidden
    }
}

// MARK: - TableViewdatasource
extension BFStarController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchsData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cellId = "BFRepositoryTypeOneCellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? BFRepositoryTypeThirdCell
        if cell == nil {
            cell = (BFRepositoryTypeThirdCell.cellFromNibNamed("BFRepositoryTypeThirdCell") as? BFRepositoryTypeThirdCell)
        }
        cell?.setBothEndsLines(row, all: watchsData.count)
        let repos = self.watchsData[row]
        cell!.objRepos = repos
        return cell!
    }
    
}

// MARK: - Tableview delegate

extension BFStarController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if !self.watchsData.isBeyond(index: indexPath.row) {
            let repos = self.watchsData[indexPath.row]
            JumpManager.shared.jumpReposDetailView(repos: repos, from: .star)
        }
    }
}

extension BFStarController {
    /// 占位图代理
    override func didAction(place: BFPlaceHolderView) {
        if place == placeEmptyView {
            request()
        } else if place == placeLoginView {
            login()
        } else if place == placeReloadView {
            self.request()
        }
    }
    
 
}
