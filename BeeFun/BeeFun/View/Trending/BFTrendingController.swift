//
//  BFTrendingController.swift
//  BeeFun
//
//  Created by wenghengcong on 15/12/30.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

import UIKit
import Moya
import Foundation
import MJRefresh
import HMSegmentedControl
import iCarousel

public enum TrendingViewPageType: String {
    case user
    case repos
}

class BFTrendingController: BFBaseViewController, iCarouselDataSource, iCarouselDelegate {
    
    //view
    var segControl: HMSegmentedControl! = JSHMSegmentedBridge.segmentControl(titles: ["Repositories".localized, "Developers".localized])

    var filterView: CPFilterTableView?
    let filterVHeight: CGFloat = ScreenSize.height-uiTopBarHeight-uiTabBarHeight-35    //filterview height

    // MARK: data
    var requesRepostModel: BFGithubTrendingRequsetModel?
    var requesDeveloperModel: BFGithubTrendingRequsetModel?
    
    var showcasePage: Int = 1
    var reposData: [BFGithubTrengingModel] = []
    var devesData: [BFGithubTrengingModel] = []
    var showcasesData: [ObjShowcase] = []

    var cityArr: [String]?
    var countryArr: [String]?
    var languageArr: [String]?

    // MARK: - request parameters
    var lastSegmentIndex = 0
    var paraSince: String = "daily"
    var paraLanguage: String = "all"
    //carousel
    let tableTag = 5000
    var carouselContent: iCarousel = iCarousel()
    var clickTag: Bool = false

    var currentIndex: Int {
        return carouselContent.currentItemIndex
    }
    
    var displayTableView: UITableView? {
        if let vw = carouselContent.currentItemView {
            if let table = vw.viewWithTag(tableTag) as? UITableView {
                return table
            }
        }
        return nil
    }

    // MARK: - view cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        needLogin = false
        tvc_getDataFromPlist()
        tvc_initView()
        tvc_updateNetrokData()
        reloadViewClosure = { [weak self] (reachable) in
            self?.carouselContent.isHidden = !reachable
        }
        loginViewClosure = { [weak self] (login) in
            self?.carouselContent.isHidden = !login
        }
        
        //只有在首次启动时才弹窗，确保只弹一次窗
        _ = checkCurrentNetworkState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if segControl.selectedSegmentIndex == 0 && reposData.count == 0 {
            tvc_getReposRequest()
        } else if segControl.selectedSegmentIndex == 1 && devesData.count == 0 {
            tvc_getUserRequest()
        } else if segControl.selectedSegmentIndex == 2 && showcasesData.count == 0 {
            tvc_getShowcasesRequest(page: showcasePage)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tvc_filterViewDisapper()
    }

    // MARK: - action
    override func leftItemAction(_ sender: UIButton?) {
        let btn = sender!
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            tvc_filterViewApper()
        } else {
            tvc_filterViewDisapper()
        }
    }
    
    func segmentControlChange(index: Int) {
        displayTableView?.reloadData()
        //请求
        if index == 0 && reposData.isEmpty {
            tvc_getReposRequest()
        } else if index == 1 && devesData.isEmpty {
            tvc_getUserRequest()
        } else if index == 2 && showcasesData.isEmpty {
            tvc_getShowcasesRequest(page: showcasePage)
        }
        
        //筛选按钮是否显示
        self.leftItem?.isHidden = index == 0 || index == 1 ? false : true
        
        self.clickTag = true
        self.carouselContent.scrollToItem(at: index, animated: true)
    }
    
    @objc func tvc_didClickSearchBar() {
        let searchVC = SESearchViewController()
        searchVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    /// 加载数据
    func tvc_updateNetrokData() {
        
        requesRepostModel = BFGithubTrendingRequsetModel()
        requesDeveloperModel = BFGithubTrendingRequsetModel()
        
        let source = 2
        requesRepostModel?.type = 1
        requesRepostModel?.source = source
        requesRepostModel?.time = BFGihubTrendingTimeEnum.daily
        requesRepostModel?.language = paraLanguage
        requesRepostModel?.page = 1
        requesRepostModel?.perpage = 100
        requesRepostModel?.sort = "up_star_num"
        requesRepostModel?.direction = "desc"
        
        requesDeveloperModel?.type = 2
        requesDeveloperModel?.source = source
        requesDeveloperModel?.time = BFGihubTrendingTimeEnum.daily
        requesDeveloperModel?.language = paraLanguage
        requesDeveloperModel?.page = 1
        requesDeveloperModel?.perpage = 100
        requesDeveloperModel?.sort = "pos"
        requesDeveloperModel?.direction = "asc"
        
        
        if segControl.selectedSegmentIndex == 0 {
            tvc_getReposRequest()
        } else if segControl.selectedSegmentIndex == 1 {
            tvc_getUserRequest()
        } else {
            tvc_getShowcasesRequest(page: showcasePage)
        }
    }
    
    override func reconnect() {
        super.reconnect()
        tvc_updateNetrokData()
    }
    
    override func request() {
        super.request()
        tvc_updateNetrokData()
    }
    
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

// MARK: - iCarousel
extension BFTrendingController {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return segControl.sectionTitles.count
    }
    
    //1. 先获取view
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        var reuseView: UIView
        var reuseTable: UITableView
        if let vw = view {
            reuseView = vw
        } else {
            reuseTable = UITableView()
            reuseTable.frame = CGRect.zero
            reuseTable.dataSource = self
            reuseTable.delegate = self
            reuseTable.separatorStyle = .none
            reuseTable.scrollsToTop = true
            reuseTable.backgroundColor = UIColor.bfViewBackgroundColor
            reuseTable.mj_header = refreshManager.header()
            reuseTable.mj_footer = refreshManager.footer()
            if #available(iOS 11, *) {
                reuseTable.estimatedRowHeight = 0
                reuseTable.estimatedSectionHeaderHeight = 0
                reuseTable.estimatedSectionFooterHeight = 0
            }
            refreshManager.delegate = self
            reuseTable.frame = CGRect(x: 0, y: 0, w: carouselContent.width, h: carouselContent.height)
            reuseTable.tag = tableTag
            reuseView = UIView(frame: CGRect(x: 0, y: 0, w: carouselContent.width, h: carouselContent.height))
            reuseView.addSubview(reuseTable)
        }
        
        return reuseView
    }
    
    //2. index change
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        if carouselContent == carousel {
            // 如果是点击segment控件，则不需要改变tag index
            if !clickTag {
                if !segControl.sectionTitles.isBeyond(index: currentIndex) {
                    segControl.setSelectedSegmentIndex(UInt(currentIndex), animated: true)
                }
            }
            clickTag = false
            displayTableView?.reloadData()
            
            if segControl.selectedSegmentIndex == 0 {
                if reposData.isEmpty {
                    tvc_getReposRequest()
                }
                leftItem?.isHidden = false
            } else if segControl.selectedSegmentIndex == 1 {
                leftItem?.isHidden = false
                if self.devesData.isEmpty {
                    tvc_getUserRequest()
                }
            } else if segControl.selectedSegmentIndex == 2 {
                leftItem?.isHidden = true
                if showcasesData.isEmpty {
                    tvc_getShowcasesRequest(page: showcasePage)
                }
            }
        }
    }
    //可循环滑动
//    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
//        switch option {
//        case .wrap:
//            return 1
//        default:
//            return value
//        }
//    }
}

// MARK: - 筛选视图的回调
extension BFTrendingController : CPFilterTableViewProtocol {
    //filter delegate
    func didSelectValueColoumn(_ row: Int, type: String, value: String) {
        if type == "Since" {
            paraSince = value
        } else if type == "Language" {
            if value == "All" {
                paraLanguage = "all"
            } else {
                paraLanguage = value.replacingOccurrences(of: " ", with: "-").lowercased()
            }
        }
        tvc_filterViewDisapper()
        tvc_updateNetrokData()
        displayTableView?.setContentOffset(CGPoint.zero, animated: true)
    }

    func didSelectTypeColoumn(_ row: Int, type: String) {

    }
    
    func didTapSinceTime(since: String) {
        paraSince = since
        tvc_filterViewDisapper()
        tvc_updateNetrokData()
        displayTableView?.setContentOffset(CGPoint.zero, animated: true)
    }
}

extension BFTrendingController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if segControl.selectedSegmentIndex == 0 {
            return  self.reposData.count
        } else if segControl.selectedSegmentIndex == 1 {
                return self.devesData.count
        }

        return self.showcasesData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let row = indexPath.row

        var cellId = ""

        if segControl.selectedSegmentIndex == 0 {

            cellId = "BFRepositoryTypeFourCellIdentifier"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? BFRepositoryTypeFourCell
            if cell == nil {
                cell = (BFRepositoryTypeFourCell.cellFromNibNamed("BFRepositoryTypeFourCell") as? BFRepositoryTypeFourCell)
            }

            if self.reposData.isBeyond(index: row) {
                return cell!
            }
            let repos = self.reposData[row]
            cell!.objRepos = repos
            cell?.setBothEndsLines(row, all: reposData.count)
            return cell!

        } else if segControl.selectedSegmentIndex == 1 {

            cellId = "BFUserTypeOneCellIdentifier"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? BFUserTypeOneCell
            if cell == nil {
                cell = (BFUserTypeOneCell.cellFromNibNamed("BFUserTypeOneCell") as? BFUserTypeOneCell)
            }
            if self.devesData.isBeyond(index: row) {
                return cell!
            }
            let user = self.devesData[row]
            cell!.user = user
            cell!.userNo = row
            cell?.setBothEndsLines(row, all: devesData.count)
            return cell!
        }

        cellId = "BFTrendingShowcaseCellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? BFTrendingShowcaseCell
        if cell == nil {
            cell = (BFTrendingShowcaseCell.cellFromNibNamed("BFTrendingShowcaseCell") as? BFTrendingShowcaseCell)

        }
        if self.showcasesData.isBeyond(index: row) {
            return cell!
        }
        let showcase = showcasesData[row]
        cell!.showcase = showcase
        cell?.setBothEndsLines(row, all: showcasesData.count)
        return cell!

    }

}

extension BFTrendingController {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if segControl.selectedSegmentIndex == 0 {

            return 85

        } else if segControl.selectedSegmentIndex == 1 {

            return 71
        }
        return 128
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        tvc_filterViewDisapper()
        if !UserManager.shared.needLoginAlert() {
            return
        }
        
        if segControl.selectedSegmentIndex == 0 {
            let repos = self.reposData[indexPath.row]
            let objRepos = ObjRepos()
            repos.full_name = repos.full_name?.replacing(" ", with: "")
            objRepos.name = repos.full_name
            objRepos.url = repos.repo_url
            JumpManager.shared.jumpReposDetailView(repos: objRepos, from: .other)
        } else if segControl.selectedSegmentIndex == 1 {
            let dev = self.devesData[indexPath.row]
            let objUser = ObjUser()
            objUser.login = dev.login
            JumpManager.shared.jumpUserDetailView(user: objUser)
        } else {
            let showcase = self.showcasesData[indexPath.row]
            let caseVC = BFShowcaseDetailController()
            caseVC.showcase = showcase
            caseVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(caseVC, animated: true)
        }
    }

}

extension BFTrendingController {
    /// 下拉刷新
    override func headerRefresh() {
        self.displayTableView?.mj_header.endRefreshing()
        if segControl.selectedSegmentIndex == 2 {
            showcasePage = 1
        }
        tvc_updateNetrokData()
    }

    /// 上拉加载
    override func footerRefresh() {
        self.displayTableView?.mj_footer.endRefreshing()
        if segControl.selectedSegmentIndex == 2 {
            showcasePage += 1
            tvc_updateNetrokData()
        }
    }
}
