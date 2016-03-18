//
//  CPRepositoryViewController.swift
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

public enum CPReposActionType:String {
    case Watch = "watch"
    case Star = "star"
    case Fork = "fork"
}

class CPTrendingRepositoryViewController: CPBaseViewController {

    @IBOutlet weak var reposPoseterV: CPReposPosterView!
    
    @IBOutlet weak var reposInfoV: CPReposInfoView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var repos:ObjRepos?
    var reposInfoArr = [[String:String]]()

    var user:ObjUser?
    var hasWatchedRepos:Bool = false
    var hasStaredRepos:Bool = false
    
    var actionType:CPReposActionType = .Watch
    
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        rvc_customView()
        rvc_userIsLogin()
        rvc_setupTableView()
        rvc_loadAllRequset()
        self.navigationController!.navigationBar.topItem?.title = ""
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.title = repos!.name!

    }
    
    func rvc_customView(){
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.view.backgroundColor = UIColor.whiteColor()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func rvc_userIsLogin() {
        
        user = UserInfoHelper.sharedInstance.user
        
        reposPoseterV.reposActionDelegate = self
        
        let uname = repos!.owner!.login!
        let ownerDic:[String:String] = ["img":"octicon_person_25","desc":uname,"discolsure":"true"]
        reposInfoArr.append(ownerDic)
        
    }
    
    func rvc_loadAllRequset(){
        rvc_getReopsRequest()
        rvc_checkWatchedRequset()
        rvc_checkStarredRqeuset()
    }

    func rvc_setupTableView() {
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .None
        self.tableView.backgroundColor = UIColor.viewBackgroundColor()
        self.automaticallyAdjustsScrollViewInsets = false
        // 下拉刷新
        header.setTitle("Pull down to refresh", forState: .Idle)
        header.setTitle("Release to refresh", forState: .Pulling)
        header.setTitle("Loading ...", forState: .Refreshing)
        header.setRefreshingTarget(self, refreshingAction: Selector("headerRefresh"))
        // 现在的版本要用mj_header
//        self.tableView.mj_header = header
    }
    
    // 顶部刷新
    func headerRefresh(){
        print("下拉刷新")
        
    }
    
    func rvc_updateViewContent() {
        
        let objRepo = repos!
        reposPoseterV.repo = objRepo
        reposPoseterV.watched = hasWatchedRepos
        reposPoseterV.stared = hasStaredRepos
        
        reposInfoV.repo = objRepo
        
    }
    
    func rvc_getReopsRequest(){
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let owner = repos!.owner!.login!
        let repoName = repos!.name!
        
        Provider.sharedProvider.request(.UserSomeRepo(owner:owner,repo:repoName) ) { (result) -> () in
            
            var success = true
            var message = "No data to show"
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            
            switch result {
            case let .Success(response):
                
                do {
                    if let result:ObjRepos = Mapper<ObjRepos>().map(try response.mapJSON() ) {
                        self.repos = result
                        self.rvc_updateViewContent()

                    } else {
                        success = false
                    }
                } catch {
                    success = false
                    CPGlobalHelper.sharedInstance.showError(message, view: self.view)
                }
            case let .Failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                success = false
                CPGlobalHelper.sharedInstance.showError(message, view: self.view)
                
            }
        }

        
    }
    
    func rvc_checkWatchedRequset() {
        
        if (!UserInfoHelper.sharedInstance.isLoginIn){
            return
        }
        
        let owner = repos!.owner!.login!
        let repoName = repos!.name!
        
        Provider.sharedProvider.request(.CheckWatched(owner:owner,repo:repoName) ) { (result) -> () in
            
            var success = true
            var message = "No data to show"
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            switch result {
            case let .Success(response):
                
                let statusCode = response.statusCode
                if(statusCode == CPHttpStatusCode.OK.rawValue){
                    self.hasWatchedRepos = true
                }else{
                    self.hasWatchedRepos = false
                }
                self.rvc_updateViewContent()
                
            case let .Failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                success = false
                CPGlobalHelper.sharedInstance.showError(message, view: self.view)
                
            }
        }

    }
    
    func rvc_checkStarredRqeuset() {
        
        if (!UserInfoHelper.sharedInstance.isLoginIn){
            return
        }
        
        let owner = repos!.owner!.login!
        let repoName = repos!.name!
        
        Provider.sharedProvider.request(.CheckStarred(owner:owner,repo:repoName) ) { (result) -> () in
            
            var success = true
            var message = "No data to show"
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            print(result)
            switch result {
            case let .Success(response):
                
                let statusCode = response.statusCode
                if(statusCode == CPHttpStatusCode.NoContent.rawValue){
                    self.hasStaredRepos = true
                }else{
                    self.hasStaredRepos = false
                }
                self.rvc_updateViewContent()
                
            case let .Failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                success = false
                CPGlobalHelper.sharedInstance.showError(message, view: self.view)
                
            }
        }
        
    }

    func rvc_watchRequest() {
        
        let owner = repos!.owner!.login!
        let repoName = repos!.name!
        Provider.sharedProvider.request(.WatchingRepo(owner:owner,repo:repoName,subscribed:"true",ignored:"false") ) { (result) -> () in
            
            var success = true
            var message = "No data to show"
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            print(result)
            switch result {
            case let .Success(response):
                
                let statusCode = response.statusCode
                if(statusCode == CPHttpStatusCode.NoContent.rawValue){
                    self.hasWatchedRepos = true
                    CPGlobalHelper.sharedInstance.showError("Watch Successsful", view: self.view)
                    self.rvc_updateViewContent()
                }else{
                    
                }
                
            case let .Failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                success = false
                CPGlobalHelper.sharedInstance.showError(message, view: self.view)
                
            }
        }
        
    }
    
    func rvc_unwatchRequest() {
        let owner = repos!.owner!.login!
        let repoName = repos!.name!
        
        Provider.sharedProvider.request(.UnWatchingRepo(owner:owner,repo:repoName) ) { (result) -> () in
            
            var success = true
            var message = "No data to show"
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            print(result)
            switch result {
            case let .Success(response):
                
                let statusCode = response.statusCode
                if(statusCode == CPHttpStatusCode.NoContent.rawValue){
                    self.hasWatchedRepos = false
                    CPGlobalHelper.sharedInstance.showError("Unwatch Successsful", view: self.view)
                    self.rvc_updateViewContent()

                }else{
                    
                }
                
            case let .Failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                success = false
                CPGlobalHelper.sharedInstance.showError(message, view: self.view)
                
            }
        }
        
    }
    
    func rvc_starRequest() {
        let owner = repos!.owner!.login!
        let repoName = repos!.name!
        
        Provider.sharedProvider.request(.StarRepo(owner:owner,repo:repoName) ) { (result) -> () in
            
            var success = true
            var message = "No data to show"
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            print(result)
            switch result {
            case let .Success(response):
                
                let statusCode = response.statusCode
                if(statusCode == CPHttpStatusCode.NoContent.rawValue){
                    self.hasStaredRepos = true
                    CPGlobalHelper.sharedInstance.showError("Star Successsful", view: self.view)
                    self.rvc_updateViewContent()
                }else{
                    
                }
                
            case let .Failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                success = false
                CPGlobalHelper.sharedInstance.showError(message, view: self.view)
                
            }
        }
        
    }
    
    func rvc_unstarRequest() {
        let owner = repos!.owner!.login!
        let repoName = repos!.name!
        
        Provider.sharedProvider.request(.UnstarRepo(owner:owner,repo:repoName) ) { (result) -> () in
            
            var success = true
            var message = "No data to show"
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            print(result)
            switch result {
            case let .Success(response):
                
                let statusCode = response.statusCode
                if(statusCode == CPHttpStatusCode.NoContent.rawValue){
                    self.hasStaredRepos = false
                    CPGlobalHelper.sharedInstance.showError("Unstar this repository successsful!", view: self.view)
                    self.rvc_updateViewContent()

                }else{
                    
                }
                
            case let .Failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                success = false
                CPGlobalHelper.sharedInstance.showError(message, view: self.view)
                
            }
        }
        
    }
    
    func rvc_forkRequest() {
        let owner = repos!.owner!.login!
        let repoName = repos!.name!
        
        Provider.sharedProvider.request(.CreateFork(owner:owner,repo:repoName) ) { (result) -> () in
            
            var success = true
            var message = "No data to show"
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            print(result)
            switch result {
            case let .Success(response):
                
                let statusCode = response.statusCode
                if(statusCode == CPHttpStatusCode.Accepted.rawValue){
                    CPGlobalHelper.sharedInstance.showError("Fork this repository successsful!", view: self.view)
                }else{
                }
                
            case let .Failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                success = false
                CPGlobalHelper.sharedInstance.showError(message, view: self.view)
                
            }
        }
        
    }

}


extension CPTrendingRepositoryViewController : UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        let cellId = "CPDevUserInfoCellIdentifier"

        var cell = tableView .dequeueReusableCellWithIdentifier(cellId) as? CPDevUserInfoCell
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
        cell!.backgroundColor = UIColor.hexStr("#e8e8e8", alpha: 1.0)
        
        return cell!;
        
    }
    
}
extension CPTrendingRepositoryViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let user = self.repos!.owner!
        self.performSegueWithIdentifier(SegueRepositoryToOwner, sender: user)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if(segue.identifier == SegueRepositoryToOwner) {
            let devVC = segue.destinationViewController as! CPTrendingDeveloperViewController
            devVC.hidesBottomBarWhenPushed = true
            
            let user = sender as? ObjUser
            if(user != nil){
                devVC.developer = user
            }
        }

    }
    
}

extension CPTrendingRepositoryViewController:ReposActionProtocol {
    
    
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
        switch(actionType){
        case .Watch:
            if(hasWatchedRepos){
                title = "Unwatching..."
                message = ""
            }else{
                title = "Watching..."
                message = "Watching a Repository registers the user to receive notifications on new discussions."
            }

        case .Star:
            if(hasStaredRepos){
                title = "Unstarring..."
                message = ""
            }else{
                title = "Starring..."
                message = "Repository Starring is a feature that lets users bookmark repositories."
            }

        case .Fork:
            title = "Forking..."
            message = "A fork is a copy of a repository."
        }
        
        let alertController = UIAlertController(title: title, message:message, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Sure", style: .Default) { (action) in
            
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
            
            self.rvc_updateViewContent()

        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
        
    }
    
        
}

