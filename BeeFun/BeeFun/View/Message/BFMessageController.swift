//
//  BFMessageController.swift
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

class BFMessageController: BFBaseViewController, UIAlertViewDelegate, iCarouselDataSource, iCarouselDelegate, BFViewControllerNetworkProtocol {

    var segControl: HMSegmentedControl! = JSHMSegmentedBridge.segmentControl(titles: ["Event".localized, "Issues".localized, "Notifications".localized])
    
    //carousel
    var carouselContent: iCarousel = iCarousel()
    var clickSegmentControl = false
    
    override func viewDidLoad() {
        self.title = "Message".localized
        super.viewDidLoad()
        mvc_setupSegmentView()
        mvc_customCarouselView()
        self.leftItem?.isHidden = true
        reloadViewClosure = { [weak self] (reachable) in
            self?.carouselContent.isHidden = !reachable
        }
        loginViewClosure = { [weak self] (login) in
            self?.carouselContent.isHidden = !login
        }
        _ = checkCurrentNetworkState()
        _ = checkCurrentLoginState()
        reloadCurrentContentData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // MARK: - Login
    /// 登录成功的通知
    override func loginSuccessful() {
        carouselContent.reloadData()
    }
    /// 注销成功的通知
    override func logoutSuccessful() {
        carouselContent.reloadData()
    }
    
    override func reconnect() {
        super.reconnect()
        reloadCurrentContentData()
    }
    
    override func request() {
        reloadCurrentContentData()
    }

    // MARK: - SegmentControl
    func mvc_setupSegmentView() {
        automaticallyAdjustsScrollViewInsets = false
        segControl.indexChangeBlock = { index in
            self.segmentControlChange(index: index)
        }
        view.addSubview(segControl)
    }
    
    func segmentControlChange(index: Int) {
        if !checkCurrentLoginState() {
            return
        }
        clickSegmentControl = true
        self.carouselContent.scrollToItem(at: index, animated: true)
    }
    
    // MARK: - carouse 内容视图
    func mvc_customCarouselView() {
        let scroolY = 35.0+uiTopBarHeight
        let scroolH = ScreenSize.height-scroolY
        
        carouselContent.isHidden = false
        carouselContent.delegate = self
        carouselContent.dataSource = self
        carouselContent.type = .linear
        //        carouselContent.isPagingEnabled = true
        carouselContent.scrollSpeed = 2.5
        carouselContent.decelerationRate = 0.25
        carouselContent.bounceDistance = 0.1
        carouselContent.frame = CGRect(x: 0, y: scroolY, w: ScreenSize.width, h: scroolH)
        view.addSubview(carouselContent)
        //FIXME: 此处添加后，carouselContent仍然在loginView上面，不知道为什么，通过下面方式解决。
        if let loginView = placeLoginView {
            view.bringSubview(toFront: loginView)
        }
    }
    
}

// MARK: - iCarousel
extension BFMessageController {
    
    func reloadCurrentContentData() {
        if !checkCurrentLoginState() {
            return
        }
        let contentView = self.carouselContent.currentItemView as? BFMessageConentView
        contentView?.reloadNetworkData()
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        //
        if !checkCurrentLoginState() {
            return 0
        }
        return segControl.sectionTitles.count
    }
    
    //1. 先获取view
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let contentView = BFMessageConentView.init(frame: carouselContent.bounds, index: index)
        contentView.delegate = self
        contentView.reloadNetworkData()
        return contentView
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        if !checkCurrentLoginState() {
            return
        }
        if !clickSegmentControl {
            segControl.setSelectedSegmentIndex(UInt(carouselContent.currentItemIndex), animated: true)
        }
        clickSegmentControl = false
        reloadCurrentContentData()
    }
}

extension BFMessageController {
    func networkSuccssful() {
        removeReloadView()
    }
    
    func networkFailure() {
        showReloadView()
    }
}
