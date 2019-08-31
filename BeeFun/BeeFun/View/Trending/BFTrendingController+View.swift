//
//  BFTrendingController+View.swift
//  BeeFun
//
//  Created by WengHengcong on 25/06/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

extension BFTrendingController {
    
    func tvc_initView() {
        tvc_addNaviBarButtonItem()
        tvc_setupSegmentView()
        tvc_setupFilterView()
        tvc_customCarouselView()
    }
    
    // MARK: - 导航栏
    func tvc_addNaviBarButtonItem() {
        self.title = "Explore".localized
        self.leftItem?.isHidden = false
        self.leftItemImage = UIImage(named: "nav_funnel")
        self.leftItemSelImage = UIImage(named: "nav_funnel_sel")
        
        let backView = BFTrendingSearchBar(frame: CGRect(x: 0, y: 0, w: ScreenSize.width-80, h: 31))
        let searchBtn = UIButton(frame: CGRect(x: 8, y: 0, w: ScreenSize.width-80, h: 31))
        searchBtn.setTitle("Search repositories、users...".localized, for: .normal)
        searchBtn.setTitleColor(UIColor.iOS11MidGray, for: .normal)
        searchBtn.titleLabel?.font = UIFont.bfSystemFont(ofSize: 14.0)
        searchBtn.titleLabel?.textAlignment = .left
        searchBtn.backgroundColor = UIColor.white
        searchBtn.layer.cornerRadius = 15.0
        searchBtn.layer.masksToBounds = true
        searchBtn.addTarget(self, action: #selector(tvc_didClickSearchBar), for: .touchUpInside)
        backView.addSubview(searchBtn)
        navigationItem.titleView = backView
    }
    // MARK: - 筛选视图
    func tvc_setupFilterView() {
        
        let firW: CGFloat = 100.0
        let secW: CGFloat = self.view.width-firW
        filterView = CPFilterTableView(frame: CGRect(x: 0, y: 64-filterVHeight-10, width: self.view.width, height: filterVHeight))
        filterView!.backgroundColor = UIColor.bfViewBackgroundColor
        filterView!.filterDelegate = self
        filterView!.coloumn = .two
        filterView!.rowWidths = [firW, secW]
        filterView!.rowHeights = [40.0, 40.0]
        filterView!.filterTypes = ["Language".localized]
        filterView!.filterData = [languageArr!]
        filterView?.filterViewInit()
        self.view.addSubview(filterView!)
    }
    
    // MARK: - 筛选视图
    func tvc_filterViewApper() {
        if !filterView!.filterData.isEmpty {
            filterView!.filterTypes = ["Language".localized]
            filterView!.filterData = [languageArr!]
        }
        view.bringSubview(toFront: filterView!)
        filterView!.frame = CGRect(x: 0, y: uiTopBarHeight, width: self.view.width, height: filterVHeight)
    }
    
    func tvc_filterViewDisapper() {
        leftItem?.isSelected = false
        filterView!.frame = CGRect(x: 0, y: uiTopBarHeight-filterVHeight-10, width: self.view.width, height: filterVHeight)
    }
    
    // MARK: - carouse 内容视图
    func tvc_customCarouselView() {
        let scroolY = 35.0+uiTopBarHeight
        let scroolH = ScreenSize.height-scroolY-3
        
        carouselContent.isHidden = false
        carouselContent.delegate = self
        carouselContent.dataSource = self
        carouselContent.type = .linear
        //        carouselContent.isPagingEnabled = true
        carouselContent.scrollSpeed = 2.5
        carouselContent.decelerationRate = 0.25
        carouselContent.bounceDistance = 0.1
        carouselContent.frame = CGRect(x: 0, y: scroolY, w: ScreenSize.width, h: scroolH)
        //        carouselContent.scrollToItem(at: 0, anim@objc ated: true)
        view.addSubview(carouselContent)
    }
    
    // MARK: - 标签选择视图
    func tvc_setupSegmentView() {
        
        self.automaticallyAdjustsScrollViewInsets = false
        segControl.indexChangeBlock = { index in
            self.segmentControlChange(index: index)
        }
        self.view.addSubview(segControl)
    }

}
