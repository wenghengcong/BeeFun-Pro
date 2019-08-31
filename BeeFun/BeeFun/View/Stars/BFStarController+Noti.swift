//
//  BFStarController+Noti.swift
//  BeeFun
//
//  Created by WengHengcong on 26/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit

extension BFStarController {
    // MARK: - Notification
    func svc_registerNotification() {
        
        //删除tag需要重新加载
        NotificationCenter.default.addObserver(self, selector: #selector(svc_tagChange(noti:)), name: NSNotification.Name.BeeFun.DelTag, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(svc_tagChange(noti:)), name: NSNotification.Name.BeeFun.AddTag, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(svc_tagChange(noti:)), name: NSNotification.Name.BeeFun.UpdateTag, object: nil)

        //update tag需要重新加载
        NotificationCenter.default.addObserver(self, selector: #selector(svc_updateRepoTag(noti:)), name: NSNotification.Name.BeeFun.RepoUpdateTag, object: nil)

        //star repo需要重新加载
        NotificationCenter.default.addObserver(self, selector: #selector(svc_starRepo(noti:)), name: NSNotification.Name.BeeFun.didStarRepo, object: nil)
        //unstar repo需要重新加载
        NotificationCenter.default.addObserver(self, selector: #selector(svc_unstarRepo(noti:)), name: NSNotification.Name.BeeFun.didUnStarRepo, object: nil)
    }
    
    // MARK: - Handle Notification
    override func loginSuccessful() {
        svc_requestFetchTags(reloadCurrentPageData: true)
        svc_updateDataWhenReceiveNotification()
        self.carouselContent.reloadData()
    }
    
    override func logoutSuccessful() {
        starTags = ["All".localized]
        if tagBar != nil {
            tagBar.sectionTitles = starTags
            tagBar.selectedSegmentIndex = 0
            svc_layoutAllTagsButton()
        }
        carouselContent.scrollToItem(at: 0, animated: true)
        carouselContent.reloadData()
        
        watchsData.removeAll()
        watchedTableView.reloadData()
        self.carouselContent.reloadData()
    }
    
    // MARK: - tag delete / addd
    @objc func svc_tagChange(noti: Notification) {
        svc_requestFetchTags(reloadCurrentPageData: false)
        svc_updateDataWhenReceiveNotification()
//        self.carouselContent.reloadData()
    }
    
    @objc func svc_updateRepoTag(noti: Notification) {
        svc_requestFetchTags(reloadCurrentPageData: false)
        svc_updateDataWhenReceiveNotification()
//        self.carouselContent.reloadData()
    }
    
        // MARK: - star / unstar repo action
    @objc func svc_starRepo(noti: Notification) {
        svc_updateDataWhenReceiveNotification()
//        self.carouselContent.reloadData()
    }
    
    @objc func svc_unstarRepo(noti: Notification) {
        svc_updateDataWhenReceiveNotification()
//        self.carouselContent.reloadData()
    }
}
