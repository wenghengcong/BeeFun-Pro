//
//  JSScrollContentView.swift
//  BeeFun
//
//  Created by WengHengcong on 23/05/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import MJRefresh
import iCarousel

@objc protocol JSScrollContentProtocol: class {
    
    @objc optional func scrollContentViewDidScroll(scrollContent: JSScrollContentView, displayTableView: UITableView)
    @objc optional func scrollContentViewRefresh(scrollContent: JSScrollContentView)
    @objc optional func scrollContentViewLoadMore(scrollContent: JSScrollContentView)
    @objc optional func scrollContentViewDidSeletedTagBarItem(scrollContent: JSScrollContentView, tagBar: JSTagBar, item: JSTagItem, index: Int)
    @objc optional func scrollContentViewDidSeletedTagBarMore(scrollContent: JSScrollContentView, tagBar: JSTagBar)
}

class JSScrollContentView: UIView, JSTagBarTouchProtocol, iCarouselDataSource, iCarouselDelegate {
    
    var controller: BFBaseViewController?
    
    var titles: [String]? {
        didSet {
            tagBar?.titles = titles!
        }
    }
    
    var carousel: iCarousel = iCarousel()
    
    var tagBar: JSTagBar?
    
    var selIndex: Int = 0 {
        didSet {
            tagBar?.currentIndex = selIndex
            //滑动scroll content
            
        }
    }
    
    var displayTableView: UITableView?
    
    private let tagBarHeight: CGFloat = 40
    
    var delegat: JSScrollContentProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(frame: CGRect, titles: [String], controller: BFBaseViewController) {
        self.init(frame: frame)
        self.controller = controller
        self.titles = titles
        customSubViews()
    }
    
    deinit {
    }
    
    func customSubViews() {
        customTagBar()
        customContentView()
    }
    
    func customTagBar() {
        tagBar = JSTagBar()
        tagBar?.frame = CGRect(x: 0, y: 0, width: self.width, height: tagBarHeight)
        tagBar?.delegate = self
        if titles != nil {
            tagBar?.titles = titles!
        }
        tagBar?.currentIndex = 0
        self.addSubview(tagBar!)
    }
    
    func customContentView() {
        
        assert(titles != nil, "scroll content view titles can't be nil")
        assert(!(titles!.isEmpty), "scroll content view titles can't be empty")

        carousel.delegate = self
        carousel.dataSource = self
        carousel.type = .coverFlow
        carousel.frame = CGRect(x: 0, y: tagBarHeight, w: self.width, h: self.height-tagBarHeight)
        addSubview(carousel)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - carousel
    func numberOfItems(in carousel: iCarousel) -> Int {
        if self.titles != nil {
            return self.titles!.count
        }
        return 0
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let table = UITableView()
        table.frame = CGRect(x: 0, y: 0, w: self.width, h: self.height-tagBarHeight)
        table.dataSource = controller
        table.delegate = controller
        table.separatorStyle = .none
        table.backgroundColor = UIColor.bfViewBackgroundColor
        //滑动
        table.mj_header = jsc_header()
        table.mj_footer = jsc_footer()
//        displayTableView = table
        if #available(iOS 11, *) {
            table.estimatedRowHeight = 0
            table.estimatedSectionHeaderHeight = 0
            table.estimatedSectionFooterHeight = 0
        }
        return table
    }
    
    // MARK: - TagBar touch
    
    func touchIetm(item: JSTagItem, index: Int) {
        if tagBar != nil {
            self.delegat?.scrollContentViewDidSeletedTagBarItem?(scrollContent: self, tagBar: tagBar!, item: item, index: index)
        }
    }
    
    func touchMore(more: UIButton, expend: Bool) {
        if tagBar != nil {
            self.delegat?.scrollContentViewDidSeletedTagBarMore?(scrollContent: self, tagBar: tagBar!)
        }
    }
    
    // MARK: - Refresh
    
    func jsc_header() -> MJRefreshNormalHeader {
        let header = MJRefreshNormalHeader()
        header.lastUpdatedTimeLabel.isHidden = true
        header.stateLabel.isHidden = true
        header.setRefreshingTarget(self, refreshingAction:#selector(jsc_headerRefresh))
        return header
    }
    
    func jsc_footer() -> MJRefreshAutoNormalFooter {
        let footer = MJRefreshAutoNormalFooter()
        footer.setRefreshingTarget(self, refreshingAction:#selector(jsc_footerRefresh))
        footer.stateLabel.isHidden = true
        footer.isRefreshingTitleHidden = true
        return footer
    }
    
    @objc func jsc_headerRefresh() {
        displayTableView?.mj_header.endRefreshing()
        self.delegat?.scrollContentViewRefresh?(scrollContent: self)
    }
    
    @objc func jsc_footerRefresh() {
        displayTableView?.mj_footer.endRefreshing()
        self.delegat?.scrollContentViewLoadMore?(scrollContent: self)
    }
}
