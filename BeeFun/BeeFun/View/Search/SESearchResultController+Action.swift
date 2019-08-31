//
//  SESearchResultController+Action.swift
//  BeeFun
//
//  Created by WengHengcong on 28/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import iCarousel

extension SESearchResultController {

    // MARK: - Action
    
    /// 返回按钮点击
    override func leftItemAction(_ sender: UIButton?) {
        //返回到首页
        srvc_jumpToTrendingPage()
    }
    
    /// 取消按钮点击
    override func rightItemAction(_ sender: UIButton?) {
        srvc_jumpToTrendingPage()
    }
    
    /// 点击后返回到首页
    func srvc_jumpToTrendingPage() {
        srvc_disappearKeyboardAndFilterView()
        //返回到首页
        if  let stackNv = navigationController?.viewControllers {
            for vc in stackNv {
                if vc.isKind(of: BFTrendingController.self) {
                    _ = navigationController?.popToViewController(vc, animated: false)
                }
            }
        }
    }
    
    /// 筛选按钮的点击
    @objc func srvc_filterBtnClick(sender: UIControl) {
        srvc_disappearKeyboardAndFilterView()
        let tag: SESearchResultFilterButtonType = SESearchResultFilterButtonType(rawValue: sender.tag)!
        switch tag {
        case .language:
            srvc_clickLanuageFilterButton(sender: sender)
        case .more:
            break
        default:
            srvc_clickSortFilterButton(sender: sender)
        }
    }
    
    /// 语言筛选，显示语言筛选框
    @objc func srvc_clickLanuageFilterButton(sender: UIControl) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            srvc_dismissSearchKeyboard()
            srvc_showLanguageTableView()
        } else {
            srvc_hideLanguageTableView()
        }
    }
    /// 其他三个排序按钮的点击
    func srvc_clickSortFilterButton(sender: UIControl) {
        currentSearchModel = models![currentIndex]
        currentSearchModel.page = 1
        
        if let btn = sender as? SESearchOrderButton {
            
            for button in filterButtons where button != btn {
                button.selState = .none
            }
            let tag: SESearchResultFilterButtonType = SESearchResultFilterButtonType(rawValue: btn.tag)!
            //sort
            switch tag {
            case .stars:
                currentSearchModel.sort = "stars"
            case .forks:
                currentSearchModel.sort = "forks"
            case .updated:
                currentSearchModel.sort = "updated"
            case .followers:
                currentSearchModel.sort = "followers"
            case .repositories:
                currentSearchModel.sort = "repositories"
            case .joined:
                currentSearchModel.sort = "joined"
            case .comments:
                currentSearchModel.sort = "comments"
            case .created:
                currentSearchModel.sort = "created"
            default:
                break
            }
            //order
            switch btn.selState {
            case .none:
                btn.selState = .up
                currentSearchModel.order = "desc"
            case .up:
                btn.selState = .down
                currentSearchModel.order = "asc"
            case .down:
                btn.selState = .up
                currentSearchModel.order = "desc"
            }
            reloadCarouselData(forceRefresh: true)
        }
    }
    
}

extension SESearchResultController: UISearchBarDelegate {
    
    override func reconnect() {
        super.reconnect()
        searchAgain()
    }
    
    /// 点击搜索按钮
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        srvc_dismissSearchKeyboard()
        searchAgain()
    }
    
    /// 重新搜索
    func searchAgain() {
        searchKey = searchBar.text
        resetAllSearchModel()
        srvc_saveSearchKey()
        //重新加载数据
        currentSearchModel = self.models![currentIndex]
        reloadCarouselData(forceRefresh: true)
    }
    
    /// 保存搜索结果
    func srvc_saveSearchKey() {
        if searchBar.text != nil && searchBar.text!.length > 0 {
            if let values: [String] = BFUserDefaultManager.shared.searchHistory {
                var historyData = values
                if !historyData.contains(searchBar.text!) {
                    //未包含
                    historyData.append(searchBar.text!)
                    BFUserDefaultManager.shared.searchHistory = historyData
                }
            }
        }
    }
}

// MARK: - iCarousel and segment control
extension SESearchResultController {
    // MARK: - Segment control 点击
    func segmentControlChange(index: Int) {
        currentSearchModel = models![currentIndex]
        self.clickTag = true
        self.carouselContent.scrollToItem(at: index, animated: true)
        srvc_resetFilterButtons()
    }
    
    // MARK: - iCarousel
    func numberOfItems(in carousel: iCarousel) -> Int {
        return segControl.sectionTitles.count
    }
    
    //1. 先获取view
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let contentView = SESearchResultContentView(frame: carousel.bounds, index: index, searchModel: currentSearchModel)
        contentView.delegate = self
        reloadCarouselData(forceRefresh: true)
        return contentView
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
            reloadCarouselData(forceRefresh: true)
            srvc_resetFilterButtons()
        }
    }
    
    /// 获取当前内容视图
    ///
    /// - Returns:
    func currentCarouselContentView() -> SESearchResultContentView? {
        let view = carouselContent.currentItemView as? SESearchResultContentView
        return view
    }
    
    /// 重新加载carousel数据
    ///
    /// - Parameter forceRefresh: 是否强制刷新当前页面数据
    func reloadCarouselData(forceRefresh: Bool) {
        currentCarouselContentView()?.searchModel = currentSearchModel
        currentCarouselContentView()?.forceRefresh = forceRefresh
        currentCarouselContentView()?.reloadNetworkData()
    }
}
