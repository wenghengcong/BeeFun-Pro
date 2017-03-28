//
//  CPRepoDetailController.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/9/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit
import Moya
import Foundation
import MJRefresh
import ObjectMapper
import Kingfisher
import MBProgressHUD


public enum CPReposActionType:String {
    case Watch = "watch"
    case Star = "star"
    case Fork = "fork"
}

class CPRepoDetailController: CPBaseViewController {

    var reposPoseterV: CPReposPosterView = CPReposPosterView.init(frame: CGRect.zero)
    
    var reposInfoV: CPReposInfoView = CPReposInfoView.init(frame: CGRect.zero)
    
    var tableView: UITableView = UITableView.init()
    
    var repos:ObjRepos?
    var reposInfoArr = [[String:String]]()
    
    var user:ObjUser?
    var hasWatchedRepos:Bool = false
    var hasStaredRepos:Bool = false
    
    var actionType:CPReposActionType = .Watch
    
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    
    // MARK: - view cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rvc_customView()
        rvc_userIsLogin()
        rvc_setupTableView()
        rvc_loadAllRequset()
        self.title = repos!.name!
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    // MARK: - view
    
    func rvc_customView(){
        
        self.reposPoseterV.isHidden = true
        self.reposInfoV.isHidden = true
        self.tableView.isHidden = true
        self.view.addSubview(self.reposPoseterV)
        self.view.addSubview(self.reposInfoV)
        self.view.addSubview(self.tableView)
        
        self.rightItemImage = UIImage(named: "nav_share_35")
        self.rightItemSelImage = UIImage(named: "nav_share_35")
        self.rightItem?.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        
        //Layout
        //designBy4_7Inch(80+30)->
        let dynPostH = designBy4_7Inch(110) + 39
        reposPoseterV.frame = CGRect.init(x: 0, y: 64, width: ScreenSize.width, height: dynPostH)
        
        let infoViewT = reposPoseterV.bottom+10
        let dynInfoH = designBy4_7Inch(90)
        
        reposInfoV.frame = CGRect.init(x: 0, y: infoViewT, width: ScreenSize.width, height: dynInfoH)
        
        let tabViewT = reposInfoV.bottom+10
        let tabViewH = ScreenSize.height-tabViewT
        tableView.frame = CGRect.init(x: 0, y: tabViewT, width: ScreenSize.width, height: tabViewH)
    }
    
    func rvc_setupTableView() {
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.viewBackgroundColor
        self.automaticallyAdjustsScrollViewInsets = false
        header.setTitle("Pull down to refresh", for: .idle)
        header.setTitle(kHeaderPullTip, for: .pulling)
        header.setTitle(kHeaderPullingTip, for: .refreshing)
        header.setRefreshingTarget(self, refreshingAction: #selector(CPRepoDetailController.headerRefresh))
    }
    
    // MARK: - action
    
    func headerRefresh(){
        print("下拉刷新")
        
    }
    
    func rvc_updateViewContent() {
        
        if let objRepo = self.repos {
            
            self.view.backgroundColor = UIColor.viewBackgroundColor

            self.reposPoseterV.isHidden = false
            self.reposInfoV.isHidden = false
            self.tableView.isHidden = false
            
            reposPoseterV.repo = objRepo
            reposInfoV.repo = objRepo
            if objRepo.html_url != nil {
                if reposInfoArr.count < 2 {
                    let homepage:[String:String] = ["key":"homepage","img":"coticon_repository_25","desc":"Homepage".localized,"discolsure":"true"]
                    reposInfoArr.insert(homepage, at: 0)
                    tableView.reloadData()
                }
            }
            
            JSMBHUDBridge.hideHud(view: self.view)
        }
    }

    
    func rvc_userIsLogin() {
        user = UserManager.shared.user
        reposPoseterV.reposActionDelegate = self
        let uname = repos!.owner!.login!
        let ownerDic:[String:String] = ["key":"owner","img":"octicon_person_25","desc":uname,"discolsure":"true"]
        reposInfoArr.append(ownerDic)
    }
    
    func rvc_loadAllRequset(){
        rvc_getReopsRequest()
        rvc_checkWatchedRequset()
        rvc_checkStarredRqeuset()
    }
    
    
    /// 导航栏左边按钮
    ///
    /// - Parameter sender: <#sender description#>
    override func leftItemAction(_ sender: UIButton?) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func rightItemAction(_ sender: UIButton?) {
        
        let shareContent:ShareContent = ShareContent()
        shareContent.title = repos?.name
        shareContent.contentType = SSDKContentType.image
        shareContent.source = .repository
        
        shareContent.url = repos?.html_url
        if let repoDescription = repos?.cdescription {
            shareContent.content = "Repository".localized+" \((repos?.name)!) : \(repoDescription) "+"\(shareContent.url!)"
        }else{
            shareContent.content = "Repository".localized+" \((repos?.name)!) " + "\(shareContent.url!)"
        }
        
        if let urlStr = repos?.owner?.avatar_url {
            shareContent.image = urlStr as AnyObject?
            ShareManager.shared.share(content: shareContent)
        }else{
            shareContent.image = UIImage(named: "app_logo_90")
            ShareManager.shared.share(content: shareContent)
        }
    }
    
    // MARK: - request
    
    func rvc_getReopsRequest(){
        
        JSMBHUDBridge.showHud(view: self.view)
        self.view.backgroundColor = UIColor.white
        self.tableView.isHidden = true
        
        let owner = repos!.owner!.login!
        let repoName = repos!.name!
        
        Provider.sharedProvider.request(.userSomeRepo(owner:owner,repo:repoName) ) { (result) -> () in
            
            var message = kNoDataFoundTip
            
            switch result {
            case let .success(response):
                
                let statusCode = response.statusCode
                if(statusCode == CPHttpStatusCode.ok.rawValue){
                    do {
                        if let result:ObjRepos = Mapper<ObjRepos>().map(JSONObject: try response.mapJSON() ) {
                            self.repos = result
                            self.rvc_updateViewContent()
                            
                        } else {
                            
                        }
                    } catch {
                        
                        JSMBHUDBridge.showError(message, view: self.view)
                    }
                }else{
                    JSMBHUDBridge.showError(message, view: self.view)
                }
                

            case let .failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description

                JSMBHUDBridge.showError(message, view: self.view)
                
            }
        }

        
    }
    
    func rvc_checkWatchedRequset() {
        
        if (!UserManager.shared.isLogin){
            return
        }
        
        let owner = repos!.owner!.login!
        let repoName = repos!.name!
        
        Provider.sharedProvider.request(.checkWatched(owner:owner,repo:repoName) ) { (result) -> () in
            
            var message = kNoDataFoundTip
            
            JSMBHUDBridge.hideHud(view: self.view)
            switch result {
            case let .success(response):
                
                let statusCode = response.statusCode
                if(statusCode == CPHttpStatusCode.ok.rawValue){
                    self.hasWatchedRepos = true
                }else{
                    self.hasWatchedRepos = false
                }
                self.reposPoseterV.watched = self.hasWatchedRepos
                
            case let .failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                JSMBHUDBridge.showError(message, view: self.view)
                
            }
        }

    }
    
    func rvc_checkStarredRqeuset() {
        
        if (!UserManager.shared.isLogin){
            return
        }
        
        let owner = repos!.owner!.login!
        let repoName = repos!.name!
        
        Provider.sharedProvider.request(.checkStarred(owner:owner,repo:repoName) ) { (result) -> () in
            
            var message = kNoDataFoundTip
            
            JSMBHUDBridge.hideHud(view: self.view)
            print(result)
            switch result {
            case let .success(response):
                
                let statusCode = response.statusCode
                if(statusCode == CPHttpStatusCode.noContent.rawValue){
                    self.hasStaredRepos = true
                }else{
                    self.hasStaredRepos = false
                }
                self.reposPoseterV.stared = self.hasStaredRepos
                
            case let .failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                JSMBHUDBridge.showError(message, view: self.view)
                
            }
        }
        
    }

    func rvc_watchRequest() {
        
        let owner = repos!.owner!.login!
        let repoName = repos!.name!
        Provider.sharedProvider.request(.watchingRepo(owner:owner,repo:repoName,subscribed:"true",ignored:"false") ) { (result) -> () in
            
            var message = kNoDataFoundTip
            
            JSMBHUDBridge.hideHud(view: self.view)
            print(result)
            switch result {
            case let .success(response):
                
                let statusCode = response.statusCode
                if(statusCode == CPHttpStatusCode.noContent.rawValue){
                    self.hasWatchedRepos = true
                    JSMBHUDBridge.showMessage("Watch".localized+kSignEmptySpace+"Success".localized, view: self.view)
                    self.reposPoseterV.watched = self.hasWatchedRepos

                }else{
                    
                }
                
            case let .failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                JSMBHUDBridge.showError(message, view: self.view)
                
            }
        }
        
    }
    
    func rvc_unwatchRequest() {
        let owner = repos!.owner!.login!
        let repoName = repos!.name!
        
        Provider.sharedProvider.request(.unWatchingRepo(owner:owner,repo:repoName) ) { (result) -> () in
            
            var message = kNoDataFoundTip
            
            JSMBHUDBridge.hideHud(view: self.view)
            print(result)
            switch result {
            case let .success(response):
                
                let statusCode = response.statusCode
                if(statusCode == CPHttpStatusCode.noContent.rawValue){
                    self.hasWatchedRepos = false
                    JSMBHUDBridge.showMessage("Unwatch".localized+kSignEmptySpace+"Success".localized, view: self.view)
                    self.reposPoseterV.watched = self.hasWatchedRepos
                }else{
                    
                }
                
            case let .failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                JSMBHUDBridge.showError(message, view: self.view)
                
            }
        }
        
    }
    
    func rvc_starRequest() {
        let owner = repos!.owner!.login!
        let repoName = repos!.name!
        
        Provider.sharedProvider.request(.starRepo(owner:owner,repo:repoName) ) { (result) -> () in
            
            var message = kNoDataFoundTip
            
            JSMBHUDBridge.hideHud(view: self.view)
            print(result)
            switch result {
            case let .success(response):
                
                let statusCode = response.statusCode
                if(statusCode == CPHttpStatusCode.noContent.rawValue){
                    self.hasStaredRepos = true
                    JSMBHUDBridge.showMessage("Star".localized+kSignEmptySpace+"Success".localized, view: self.view)
                    self.reposPoseterV.stared = self.hasStaredRepos
                }else{
                    
                }
                
            case let .failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                JSMBHUDBridge.showError(message, view: self.view)
                
            }
        }
        
    }
    
    func rvc_unstarRequest() {
        let owner = repos!.owner!.login!
        let repoName = repos!.name!
        
        Provider.sharedProvider.request(.unstarRepo(owner:owner,repo:repoName) ) { (result) -> () in
            
            var message = kNoDataFoundTip
            
            JSMBHUDBridge.hideHud(view: self.view)
            print(result)
            switch result {
            case let .success(response):
                
                let statusCode = response.statusCode
                if(statusCode == CPHttpStatusCode.noContent.rawValue){
                    self.hasStaredRepos = false
                    JSMBHUDBridge.showMessage("Unstar".localized+"Success!", view: self.view)
                    self.reposPoseterV.stared = self.hasStaredRepos

                }else{
                    
                }
                
            case let .failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                JSMBHUDBridge.showError(message, view: self.view)
                
            }
        }
        
    }
    
    func rvc_forkRequest() {
        let owner = repos!.owner!.login!
        let repoName = repos!.name!
        
        Provider.sharedProvider.request(.createFork(owner:owner,repo:repoName) ) { (result) -> () in
            
            var message = kNoDataFoundTip
            
            JSMBHUDBridge.hideHud(view: self.view)
            print(result)
            switch result {
            case let .success(response):
                
                let statusCode = response.statusCode
                if(statusCode == CPHttpStatusCode.accepted.rawValue){
                    JSMBHUDBridge.showMessage("Fork".localized+kSignEmptySpace+"Success".localized, view: self.view)
                }else{
                }
                
            case let .failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                JSMBHUDBridge.showError(message, view: self.view)
                
            }
        }
        
    }

}


extension CPRepoDetailController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reposInfoArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        let cellId = "CPDevUserInfoCellIdentifier"

        var cell = tableView .dequeueReusableCell(withIdentifier: cellId) as? CPDevUserInfoCell
        if cell == nil {
            cell = (CPDevUserInfoCell.cellFromNibNamed("CPDevUserInfoCell") as! CPDevUserInfoCell)
        }
        
        //handle line in cell
        if row == 1 {
            cell!.topline = true
        }
        
        if (row == reposInfoArr.count-1) {
            cell!.fullline = true
        }else {
            cell!.fullline = false
        }
        cell!.duic_fillData(reposInfoArr[row])
        
        return cell!;
        
    }
    
}
extension CPRepoDetailController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        let dic = reposInfoArr[row]
        let cellKey = dic["key"]

        if cellKey == "homepage" {
            let webView = CPWebViewController()
            webView.url = self.repos?.html_url
            self.navigationController?.pushViewController(webView, animated: true)

        }else if(cellKey == "owner"){
            if let owner = self.repos?.owner {
                let vc = CPUserDetailController()
                vc.hidesBottomBarWhenPushed = true
                vc.developer = owner
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }

        
        if row == 0 {

        }else if(row == 1){
        }

    }
}

extension CPRepoDetailController:ReposActionProtocol {
    
    
    func watchReposAction() {
        actionType = .Watch
        showAlertView()
    }
    
    func starReposAction() {
        actionType = .Star
        showAlertView()
    }
    
    func forkReposAction() {
        actionType = .Fork
        showAlertView()
    }
    
    
    func showAlertView() {
        
        var title = ""
        var message = ""
//        var clickSure: ((UIAlertAction) -> Void) = {
//            (UIAlertAction)->Void in
//        }
        // TODO: localized
        switch(actionType){
        case .Watch:
            if(hasWatchedRepos){
                title = "Unwatching".localized + kSignApostrophe
                message = ""
            }else{
                title = "Watching".localized + kSignApostrophe
                message = kWatchingTip
            }

        case .Star:
            if(hasStaredRepos){
                title = "Unstarring".localized + kSignApostrophe
                message = ""
            }else{
                title = "Starring".localized + kSignApostrophe
                message = kStaringTip
            }

        case .Fork:
            title = "Forking".localized + kSignApostrophe
            message = KForkingTip
        }
        
        let alertController = UIAlertController(title: title, message:message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Sure".localized, style: .default) { (action) in
            
            switch(self.actionType){
            case .Watch:
                if(self.hasWatchedRepos){
                    self.rvc_unwatchRequest()
                }else{
                    self.rvc_watchRequest()
                }
                
            case .Star:
                if(self.hasStaredRepos){
                    self.rvc_unstarRequest()
                }else{
                    self.rvc_starRequest()
                }
                
            case .Fork:
                self.rvc_forkRequest()
            }
            
//            self.rvc_updateViewContent()
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true) {
            // ...
        }
        
    }
    
        
}

