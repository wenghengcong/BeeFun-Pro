//
//  CPTrendingDeveloperViewController.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/10/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit
import Moya
import Foundation
import MJRefresh
import ObjectMapper
import SwiftDate
import Kingfisher


public enum CPUserActionType:String {
    case Follow = "watch"
    case Repos = "star"
    case Following = "fork"
}


class CPTrendingDeveloperViewController: CPBaseViewController {

    @IBOutlet weak var developerInfoV: CPDeveloperInfoView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var followBtn: UIButton!
    
    var developer:ObjUser?
    var devInfoArr = [[String:String]]()
    var userShareImage:UIImage?

    var actionType:CPUserActionType = .Follow
    var followed:Bool = false
    
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    
    // MARK: - view cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dvc_customView()
        dvc_setupTableView()
        dvc_updateViewContent()
        dvc_getUserinfoRequest()
        if let username = developer!.name {
            self.title = username
        }else{
            self.title = developer!.login!
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        dvc_checkUserFollowed()
    }
    
    // MARK: - view
    
    func dvc_customView(){

        self.rightItemImage = UIImage(named: "nav_share_35")
        self.rightItemSelImage = UIImage(named: "nav_share_35")
        self.rightItem?.isHidden = false
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.view.backgroundColor = UIColor.viewBackgroundColor()

        developerInfoV.userActionDelegate = self
        
        if(developer!.login == UserManager.shared.user?.name){
            followBtn.isHidden = true
        }else{
            followBtn.isHidden = false
        }
        followBtn.layer.cornerRadius = 5
        followBtn.layer.masksToBounds = true
        followBtn.addTarget(self, action: #selector(CPTrendingDeveloperViewController.dvc_followAction), for: UIControlEvents.touchUpInside)
        
    }
    
    func dvc_setupTableView() {
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.viewBackgroundColor()
        self.tableView.allowsSelection = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        header.setTitle("Pull down to refresh", for: .idle)
        header.setTitle("Release to refresh", for: .pulling)
        header.setTitle("Loading ...", for: .refreshing)
        header.setRefreshingTarget(self, refreshingAction: #selector(CPTrendingDeveloperViewController.headerRefresh))
        // 现在的版本要用mj_header
//        self.tableView.mj_header = header
        
    }

    // MARK: - action

    func headerRefresh(){
        print("下拉刷新")
    }
    
    func dvc_updateViewContent() {
        
        prefectchShareImage(){
            
        }
        
        if(followed){
            followBtn.setTitle("Unfollow", for: UIControlState())
        }else{
            followBtn.setTitle("Follow", for: UIControlState())
        }
        
        if(developer==nil){
            return
        }
        
        devInfoArr.removeAll()
        
        if let joinTime:String = developer!.created_at {
            let ind = joinTime.characters.index(joinTime.startIndex, offsetBy: 10)
            let subStr = joinTime.substring(to: ind)
            let join = "Joined on "+subStr
            let joinDic:[String:String] = ["img":"octicon_time_25","desc":join,"discolsure":"false"]
            devInfoArr.append(joinDic)
        }
        
        if let location:String = developer!.location {
            let locDic:[String:String] = ["img":"octicon_loc_25","desc":location,"discolsure":"false"]
            devInfoArr.append(locDic)
        }
        
        if let company = developer!.company {
            let companyDic:Dictionary = ["img":"octicon_org_25","desc":company,"discolsure":"false"]
            devInfoArr.append(companyDic)
        }
        
        developerInfoV.developer = developer
        self.tableView.reloadData()
    }
    
    func prefectchShareImage( _ completionHandler: @escaping ()-> Void){
        
        if let urlStr = developer?.avatar_url {
            let url:URL = URL.init(string: urlStr)!
            let downloader = KingfisherManager.shared.downloader
            
            downloader.downloadImage(with: url, options: nil, progressBlock: { (receivedSize, totalSize) in
                
                }, completionHandler: { (image, error, imageURL, originalData) in
                self.userShareImage = image
                completionHandler()
            })
            
        }
        
    }
    
    override func leftItemAction(_ sender: UIButton?) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func rightItemAction(_ sender: UIButton?) {
        
        let shareContent:ShareContent = ShareContent()
        if let name = developer?.name{
            shareContent.shareTitle = name
        }else{
            shareContent.shareTitle = developer?.login
        }
        
        if let bio = developer?.bio {
            shareContent.shareContent = "Developer \((developer?.name)!) " + ":\(bio)."
        }else{
            shareContent.shareContent = "Developer \((developer?.login)!)"
        }
        
        shareContent.shareUrl = developer?.html_url
        
        if userShareImage == nil {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            prefectchShareImage({
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                shareContent.shareImage = self.userShareImage
                ShareHelper.shared.shareContentInView(self, content: shareContent, soucre: ShareSource.Repository)
            })
        }else{
            shareContent.shareImage = self.userShareImage
            ShareHelper.shared.shareContentInView(self, content: shareContent, soucre: ShareSource.Repository)
        }
        
    }

    func dvc_followAction() {
        
        if(followBtn.currentTitle == "Follow"){
            self.dvc_followUserRequest()
        }else if(followBtn.currentTitle == "Unfollow"){
            self.dvc_unfolloweUserRequest()
        }
        
    }
    
    // MARK: - request

    func dvc_checkUserFollowed() {
    
        let username = developer!.login!
        
        Provider.sharedProvider.request(.checkUserFollowing(username:username) ) { (result) -> () in
            
            var message = "No data to show"
            
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            print(result)
            switch result {
            case let .success(response):
                
                let statusCode = response.statusCode
                if(statusCode == CPHttpStatusCode.noContent.rawValue){
                    self.followed = true
                }else{
                    self.followed = false
                }
                self.dvc_updateViewContent()
                
            case let .failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                CPGlobalHelper.showError(message, view: self.view)
                
            }
        }

    }
    
    func dvc_getUserinfoRequest(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let username = developer!.login!

        Provider.sharedProvider.request(.userInfo(username:username) ) { (result) -> () in
            
            var message = "No data to show"
            
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            
            switch result {
            case let .success(response):
                
                do {
                    if let result:ObjUser = Mapper<ObjUser>().map(JSONObject: try response.mapJSON() ) {
                        self.developer = result
                        self.dvc_updateViewContent()
                        
                    } else {

                    }
                } catch {

                    CPGlobalHelper.showError(message, view: self.view)
                }
            case let .failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                CPGlobalHelper.showError(message, view: self.view)
                
            }
        }
        
        
    }
    
    func dvc_followUserRequest(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let username = developer!.login!
        
        Provider.sharedProvider.request(.follow(username:username) ) { (result) -> () in
            
            var message = "No data to show"
            
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            
            switch result {
            case let .success(response):
                
                let statusCode = response.statusCode
                if(statusCode == CPHttpStatusCode.noContent.rawValue){
                    self.followed = true
                    CPGlobalHelper.showError("Follow Successful", view: self.view)

                }
                self.dvc_updateViewContent()
                
            case let .failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                CPGlobalHelper.showError(message, view: self.view)
                
            }
        }
        
        
    }

    
    func dvc_unfolloweUserRequest(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let username = developer!.login!
        
        Provider.sharedProvider.request(.unfollow(username:username) ) { (result) -> () in
            
            var message = "No data to show"
            
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            
            switch result {
            case let .success(response):
                
                let statusCode = response.statusCode
                if(statusCode == CPHttpStatusCode.noContent.rawValue){
                    self.followed = false
                    CPGlobalHelper.showError("Unollow Successful", view: self.view)

                }
                
                self.dvc_updateViewContent()
                
            case let .failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                CPGlobalHelper.showError(message, view: self.view)
                
            }
        }
        
        
    }

    
    
}

extension CPTrendingDeveloperViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return devInfoArr.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = (indexPath as NSIndexPath).row
        
        let cellId = "CPDevUserInfoCellIdentifier"

        if ((indexPath as NSIndexPath).section == 0){
            
            var cell = tableView .dequeueReusableCell(withIdentifier: cellId) as? CPDevUserInfoCell
            if cell == nil {
                cell = (CPDevUserInfoCell.cellFromNibNamed("CPDevUserInfoCell") as! CPDevUserInfoCell)
            }
            
            //handle line in cell
            if row == 1 {
                cell!.topline = true
            }
            
            if (row == devInfoArr.count-1) {
                cell!.fullline = true
            }else {
                cell!.fullline = false
            }
            cell!.duic_fillData(devInfoArr[row])
            
            return cell!;
        }
        
        var cell = tableView .dequeueReusableCell(withIdentifier: cellId) as? CPDevUserInfoCell
        if cell == nil {
            cell = (CPDevUserInfoCell.cellFromNibNamed("CPDevUserInfoCell") as! CPDevUserInfoCell)
        }
        
        //handle line in cell
        if row == 0 {
            cell!.topline = true
        }
        if (row == 1) {
            cell!.fullline = true
        }
        
        return cell!;
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if (section == 0){
            return nil
        }
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 10))
        view.backgroundColor = UIColor.viewBackgroundColor()
 
        return view
    }
    
}

extension CPTrendingDeveloperViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0){
            return 0
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //repos_url
    }
    
}

extension CPTrendingDeveloperViewController:UserProfileActionProtocol {
    
    
    func viewFollowAction() {
        actionType = .Follow
        segueGotoViewController()
    }
    
    func viewReposAction() {
        actionType = .Repos
        segueGotoViewController()
    }
    
    func viewFollowingAction() {
        actionType = .Following
        segueGotoViewController()
    }
    
    
    func segueGotoViewController() {
        
        if (!UserManager.shared.isLogin){
            CPGlobalHelper.showError("Please login first", view: self.view)
            return
        }
        
        switch(actionType){
        case .Follow:
            let uname = developer!.login
            let dic:[String:String] = ["uname":uname!,"type":"follower"]
            self.performSegue(withIdentifier: SegueUserToFollower, sender: dic)
            
        case .Repos:
            
            let uname = developer!.login
            let dic:[String:String] = ["uname":uname!,"type":"myrepositories"]
            self.performSegue(withIdentifier: SegueUserToRepository, sender: dic)

        case .Following:
            let uname = developer!.login
            let dic:[String:String] = ["uname":uname!,"type":"following"]
            self.performSegue(withIdentifier: SegueUserToFollowing, sender: dic)

        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == SegueUserToRepository){
            
            let reposVC = segue.destination as! CPReposViewController
            reposVC.hidesBottomBarWhenPushed = true
            
            let dic = sender as? [String:String]
            if (dic != nil) {
                reposVC.dic = dic!
                reposVC.username = dic!["uname"]
                reposVC.viewType = dic!["type"]
            }
            
        }else if(segue.identifier == SegueUserToFollowing){
            
            let followVC = segue.destination as! CPFollowersViewController
            followVC.hidesBottomBarWhenPushed = true
            
            let dic = sender as? [String:String]
            if (dic != nil) {
                followVC.dic = dic!
                followVC.username = dic!["uname"]
                followVC.viewType = dic!["type"]
            }
            
        }else if(segue.identifier == SegueUserToFollower){
            
            let followVC = segue.destination as! CPFollowersViewController
            followVC.hidesBottomBarWhenPushed = true
            
            let dic = sender as? [String:String]
            if (dic != nil) {
                followVC.dic = dic!
                followVC.username = dic!["uname"]
                followVC.viewType = dic!["type"]
            }
            
        }
    }

    
    
}



