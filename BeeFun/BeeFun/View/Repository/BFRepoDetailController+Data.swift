//
//  BFRepoDetailController+Data.swift
//  BeeFun
//
//  Created by WengHengcong on 28/05/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper
import Result
import Moya
import SwiftDate

extension BFRepoDetailController {

    override func didAction(place: BFPlaceHolderView) {
        if place == placeEmptyView {
            request()
        } else if place == placeLoginView {
            login()
        } else if place == placeReloadView {
            self.request()
        }
    }
    
    override func request() {
        super.request()
        rvc_loadAllRequset()
    }
    
    // MARK: - Info Models
    func rvc_loadReposCellModels() {
        cellModels.removeAll()
        let homeModel = JSCellModel(["type": "image", "id": "homepage", "key": "Homepage".localized, "icon": "repos_homepage", "disclosure": "true"])
        homeModel.didSelectClosure = { (tableView, indexPath, model) in
            JumpManager.shared.jumpWebView(url: self.repoModel?.html_url)
        }
        cellModels.insert(homeModel, at: 0)
        
        let uname = repoModel!.owner!.login!
        let userModel = JSCellModel(["type": "image", "id": "owner", "key": "Owner".localized, "icon": "repos_me", "value": uname, "disclosure": "true"])
        userModel.didSelectClosure = { (tableView, indexPath, model) in
            if let owner = self.repoModel?.owner {
                JumpManager.shared.jumpUserDetailView(user: owner)
            }
        }
        cellModels.insert(userModel, at: 1)
        
        if from == .star {
            let tags = repoModel?.star_tags?.joined(separator: ",") ?? ""
            let tagsModel = JSCellModel(["type": "image", "id": "tags", "key": "Tags".localized, "icon": "set_tag_black", "value": tags, "disclosure": "true"])
            tagsModel.didSelectClosure = { (tableView, indexPath, model) in
                let vc = BFUpdateTagsController()
                vc.hidesBottomBarWhenPushed = true
                vc.repoModel = self.repoModel
                vc.oriStatTags = self.repoModel?.star_tags
                self.navigationController?.pushViewController(vc, animated: true)
            }
            cellModels.insert(tagsModel, at: 2)
        }
    }
    
    // MARK: - request
    
    func rvc_getReopsRequest() {
        view.backgroundColor = UIColor.white
        tableView.isHidden = true
        
        if let owner = repoModel?.owner?.login, let repoName = repoModel?.name {
            let hud = JSMBHUDBridge.showHud(view: self.view)
            Provider.sharedProvider.request(.userSomeRepo(owner:owner, repo:repoName) ) { (result) -> Void in
                hud.hide(animated: true)
                self.rvc_handleReposResponse(result: result)
            }
        }
    }
    
    func rvc_handleReposResponse( result: Result<Moya.Response, MoyaError> ) {
        
        var message = kNoDataFoundTip
        switch result {
        case let .success(response):
            
            let statusCode = response.statusCode
            if statusCode == BFStatusCode.ok.rawValue {
                do {
                    if let result: ObjRepos = Mapper<ObjRepos>().map(JSONObject: try response.mapJSON() ) {
                        result.star_tags = repoModel?.star_tags
                        result.star_lists = repoModel?.star_lists
                        repoModel = result
                        rdc_updateViewContent()
                    } else {
                        
                    }
                } catch {
                    
                    JSMBHUDBridge.showError(message, view: view)
                }
            } else {
                JSMBHUDBridge.showError(message, view: view)
            }
            
        case .failure:
            message = kNetworkErrorTip
            
            JSMBHUDBridge.showError(message, view: view)
            
        }
        
    }
    
    // MARK: - 各种网络接口
    func rvc_checkWatchedRequset() {
        if !UserManager.shared.isLogin {
            return
        }
        if let owner = repoModel?.owner?.login, let repoName = repoModel?.name {
            Provider.sharedProvider.request(.checkWatched(owner:owner, repo:repoName) ) { (result) -> Void in
                
                var message = kNoDataFoundTip
                
                switch result {
                case let .success(response):
                    self.repoModel?.watched = (response.statusCode == BFStatusCode.ok.rawValue)
                    self.reposPoseterV.watched = self.repoModel?.watched
                case .failure:
                    message = kNetworkErrorTip
                    JSMBHUDBridge.showError(message, view: self.view)
                    
                }
            }
        }
    }
    
    func rvc_checkStarredRqeuset() {
        
        if !UserManager.shared.isLogin {
            return
        }
        
        if let owner = repoModel?.owner?.login, let repoName = repoModel?.name {
            Provider.sharedProvider.request(.checkStarred(owner:owner, repo:repoName) ) { (result) -> Void in
                
                var message = kNoDataFoundTip
                print(result)
                switch result {
                case let .success(response):
                    self.repoModel?.starred = (response.statusCode == BFStatusCode.noContent.rawValue)
                    self.reposPoseterV.stared = self.repoModel?.starred
                case .failure:
                    message = kNetworkErrorTip
                    JSMBHUDBridge.showError(message, view: self.view)
                    
                }
            }
        }
    }
    
    func rvc_watchRequest() {
        
        if !UserManager.shared.isLogin {
            return
        }
        
        if let owner = repoModel?.owner?.login, let repoName = repoModel?.name {
            Provider.sharedProvider.request(.watchingRepo(owner:owner, repo:repoName, subscribed:"true", ignored:"false") ) { (result) -> Void in
                var message = kNoDataFoundTip
                print(result)
                switch result {
                case let .success(response):
                    
                    let statusCode = response.statusCode
                    if statusCode == BFStatusCode.noContent.rawValue {
                        self.repoModel?.watched = true
                        self.reposPoseterV.watched = self.repoModel?.watched
                        JSMBHUDBridge.showSuccess("Watch Success".localized, view: self.view)
                    } else {
                        
                    }
                    
                case .failure:
                    message = kNetworkErrorTip
                    JSMBHUDBridge.showError(message, view: self.view)
                    
                }
            }
        }
    }
    
    func rvc_unwatchRequest() {
        
        if !UserManager.shared.isLogin {
            return
        }
        
        if let owner = repoModel?.owner?.login, let repoName = repoModel?.name {
            Provider.sharedProvider.request(.unWatchingRepo(owner:owner, repo:repoName) ) { (result) -> Void in
                var message = kNoDataFoundTip
                print(result)
                switch result {
                case let .success(response):
                    
                    let statusCode = response.statusCode
                    if statusCode == BFStatusCode.noContent.rawValue {
                        self.repoModel?.watched = false
                        self.reposPoseterV.watched = self.repoModel?.watched
                        JSMBHUDBridge.showSuccess("Unwatch Success".localized, view: self.view)
                    } else {
                        
                    }
                    
                case .failure:
                    message = kNetworkErrorTip
                    JSMBHUDBridge.showError(message, view: self.view)
                    
                }
            }
        }
    }
    
    func rvc_starRequest() {
        if !UserManager.shared.isLogin {
            return
        }
        
        if let owner = repoModel?.owner?.login, let repoName = repoModel?.name {
            Provider.sharedProvider.request(.starRepo(owner:owner, repo:repoName) ) { (result) -> Void in
                var message = kNoDataFoundTip
                print(result)
                switch result {
                case let .success(response):
                    
                    let statusCode = response.statusCode
                    if statusCode == BFStatusCode.noContent.rawValue {
                        self.repoModel?.starred = true
                        self.reposPoseterV.stared = self.repoModel?.starred
                        JSMBHUDBridge.showSuccess("Star Success".localized, view: self.view)
                        //插入
                        if let repo = self.repoModel {
                            self.rvc_addRepoWhenStarRepo(objRepo: repo)
                        }
                    } else {
                        
                    }
                    
                case .failure:
                    message = kNetworkErrorTip
                    JSMBHUDBridge.showError(message, view: self.view)
                    
                }
            }
        }
    }
    
    func rvc_unstarRequest() {
        if !UserManager.shared.isLogin {
            return
        }
        
        if let owner = repoModel?.owner?.login, let repoName = repoModel?.name {
            Provider.sharedProvider.request(.unstarRepo(owner:owner, repo:repoName) ) { (result) -> Void in
                var message = kNoDataFoundTip
                print(result)
                switch result {
                case let .success(response):
                    let statusCode = response.statusCode
                    if statusCode == BFStatusCode.noContent.rawValue {
                        self.repoModel?.starred = false
                        self.reposPoseterV.stared = self.repoModel?.starred
                        JSMBHUDBridge.showSuccess("Unstar Success".localized, view: self.view)
                        if let repoid = self.repoModel?.id {
                            self.rvc_deleteRepoWhenUnStarRepo(repoId: repoid)
                        }
                    } else {
                        
                    }
                    
                case .failure:
                    message = kNetworkErrorTip
                    JSMBHUDBridge.showError(message, view: self.view)
                }
            }
        }
    }
    
    func rvc_forkRequest() {
        if !UserManager.shared.isLogin {
            return
        }
        
        if let owner = repoModel?.owner?.login, let repoName = repoModel?.name {
            Provider.sharedProvider.request(.createFork(owner:owner, repo:repoName) ) { (result) -> Void in
                var message = kNoDataFoundTip
                switch result {
                case let .success(response):
                    
                    let statusCode = response.statusCode
                    if statusCode == BFStatusCode.accepted.rawValue {
                        JSMBHUDBridge.showSuccess("Fork Success".localized, view: self.view)
                    } else {
                    }
                    
                case .failure:
                    message = kNetworkErrorTip
                    JSMBHUDBridge.showError(message, view: self.view)
                    
                }
            }
        }
    }
    
    // MARK: - BeeFun DB 操作
    func rvc_deleteRepoWhenUnStarRepo(repoId: Int) {
        BeeFunProvider.sharedProvider.request(BeeFunAPI.delRepo(repoid: repoId)) { (result) in
            switch result {
            case let .success(response):
                do {
                    if let tagResponse: BeeFunResponseModel = Mapper<BeeFunResponseModel>().map(JSONObject: try response.mapJSON()) {
                        if let code = tagResponse.codeEnum {
                            if code == BFStatusCode.bfOk {
                                NotificationCenter.default.post(name: NSNotification.Name.BeeFun.didUnStarRepo, object: nil)
                            }
                        } else {
                            
                        }
                    }
                } catch {
                }
            case .failure:
               break
            }
        }
    }
    
    func rvc_addRepoWhenStarRepo(objRepo: ObjRepos) {
        let now = DateInRegion()
        objRepo.starred_at = now.toISO()
        BeeFunProvider.sharedProvider.request(BeeFunAPI.addRepo(repo: objRepo)) { (result) in
            switch result {
            case let .success(response):
                do {
                    if let tagResponse: BeeFunResponseModel = Mapper<BeeFunResponseModel>().map(JSONObject: try response.mapJSON()) {
                        if let code = tagResponse.codeEnum {
                            if code == BFStatusCode.bfOk {
                                NotificationCenter.default.post(name: NSNotification.Name.BeeFun.didStarRepo, object: nil)
                            }
                        } else {
                            
                        }
                    }
                } catch {
                }
            case .failure:
               break
            }
        }
    }
    
}
