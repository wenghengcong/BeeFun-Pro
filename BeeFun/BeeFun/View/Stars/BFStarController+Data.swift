//
//  BFStarController+Data.swift
//  BeeFun
//
//  Created by WengHengcong on 26/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper

extension BFStarController {
    
    override func request() {
        super.request()
        svc_requestFetchTags(reloadCurrentPageData: true)
    }
    
    override func reconnect() {
        super.reconnect()
        svc_requestFetchTags(reloadCurrentPageData: true)
    }
    
    // MARK: - 获取Tag数据
    func svc_requestFetchTags(reloadCurrentPageData: Bool) {
        
        let hud = JSMBHUDBridge.showHud(view: view)
        if !UserManager.shared.needLoginAlert() {
            _ = checkCurrentLoginState()
            hud.hide(animated: true)
            return
        }
        
        if let owner = UserManager.shared.login {
            tagFilter.owner = owner
        }
        tagFilter.page = 1
        tagFilter.pageSize = 100000
        tagFilter.sord = "desc"
        tagFilter.sidx = "name"
        
        var dict: [String: Any] = [:]
        do {
            dict = try JSONSerialization.jsonObject(with: try JSONEncoder().encode(tagFilter), options: []) as! [String: Any]
        } catch {
            print("tag filter is error")
        }
        
        BeeFunProvider.sharedProvider.request(BeeFunAPI.getAllTags(filter: dict) ) { (result) in
            hud.hide(animated: true)
            switch result {
            case let .success(response):
                do {
                    if let allTag: GetAllTagResponse = Mapper<GetAllTagResponse>().map(JSONObject: try response.mapJSON()) {
                        if let code = allTag.codeEnum, code == BFStatusCode.bfOk {
                            if let data = allTag.data {
                                DispatchQueue.main.async {
                                    self.handleGetAllTagsRequestResponse(data: data, reloadCurrentPageData: reloadCurrentPageData)
                                }
                                return
                            }
                        }
                    }
                } catch {
                }
                self.showReloadView()
                self.changeNavSegmentControl(index: self.navSegmentView!.selIndex)
            case .failure:
                self.showReloadView()
                self.changeNavSegmentControl(index: self.navSegmentView!.selIndex)
            }
        }
    }
    
    /// 处理网络获取到的tag数据
    func handleGetAllTagsRequestResponse(data: [ObjTag], reloadCurrentPageData: Bool) {
        removeReloadView()
        carouselContent.isHidden = false
        starTags.removeAll()
        if data.count > 0 {
            self.starTags.insert("All", at: 0)
            for tag in data {
                self.starTags.append(tag.name!)
            }
        }
        
        svc_customViewAfterGetTags()
        
        if self.starTags.count > 0 && self.tagBar != nil {
            self.tagBar.sectionTitles = self.starTags
            self.svc_layoutAllTagsButton()
        }
        if reloadCurrentPageData {
            // 重新加载页面数据
            carouselContent.reloadData()
            currentContentView()?.reloadNetworkData(force: true)
        }
    }
    
    /// Get watched repos
    func svc_getWatchedReposRequest(_ pageVal: Int) {
        if !UserManager.shared.isLogin {
            return
        }
        let username = UserManager.shared.login
        
        if DeviceType.isPad {
            watchPerpage = 25
        }
        let hud = JSMBHUDBridge.showHud(view: self.view)
        Provider.sharedProvider.request( .userWatchedRepos( page:pageVal, perpage:watchPerpage, username:username!) ) { (result) -> Void in
            print(result)
            hud.hide(animated: true)
            var message = kNoDataFoundTip
            switch result {
            case let .success(response):
                do {
                    let repos: [ObjRepos] = try response.mapArray(ObjRepos.self)
                    if self.watchPageVal == 1 {
                        self.watchsData.removeAll()
                        self.watchsData = repos
                    } else {
                        self.watchsData += repos
                    }
                    self.watchedTableView.reloadData()
                } catch {
                    JSMBHUDBridge.showError(message, view: self.view)
                }
            case .failure:
                message = kNetworkErrorTip
                JSMBHUDBridge.showError(message, view: self.view)
            }
        }
    }
}
