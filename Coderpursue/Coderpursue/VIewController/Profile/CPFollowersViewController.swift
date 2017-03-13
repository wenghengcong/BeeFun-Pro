//
//  CPFollowersViewController.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/30.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit
import Moya
import Foundation
import MJRefresh
import ObjectMapper

class CPFollowersViewController: CPBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    //incoming var
    var dic:[String:String]?
    var username:String?
    var viewType:String?
    
    // MARK: request parameters
    var userData:[ObjUser]! = []
    var userPageVal = 1
    var userPerpageVal = 15
    
    var typeVal:String = "owner"
    var sortVal:String = "created"
    var directionVal:String = "desc"
    
    let header = MJRefreshNormalHeader()
    let footer = MJRefreshAutoNormalFooter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        fvc_addNaviBarButtonItem()
        fvc_setupTableView()
        fvc_selectDataSource()
        if(viewType == "follower"){
            self.title = "Followers".localized
        }else if(viewType == "following"){
            self.title = "Following".localized
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func leftItemAction(_ sender: UIButton?) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func fvc_addNaviBarButtonItem() {
        
        /*
        let btnName = UIButton()
        btnName.setImage(UIImage(named: "bubble_consulting_chat-512"), forState: .Normal)
        btnName.frame = CGRectMake(0, 0, 30, 30)
        btnName.addTarget(self, action: Selector("tvc_rightButtonTouch"), forControlEvents: .TouchUpInside)
        
        //.... Set Right/Left Bar Button item
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = btnName
        self.navigationItem.rightBarButtonItem = rightBarButton
        */


    }
    
    func fvc_rightButtonTouch() {
        
    }
    
    func fvc_setupTableView() {
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.viewBackgroundColor()
        self.automaticallyAdjustsScrollViewInsets = false
        
        // 下拉刷新
        header.setTitle("", for: .idle)
        header.setTitle("Release to refresh", for: .pulling)
        header.setTitle("Loading ...", for: .refreshing)
        header.setRefreshingTarget(self, refreshingAction: #selector(CPFollowersViewController.headerRefresh))
        // 现在的版本要用mj_header
        self.tableView.mj_header = header
        
        // 上拉刷新
        footer.setTitle("", for: .idle)
        footer.setTitle("Loading more ...", for: .pulling)
        footer.setTitle("No more data", for: .noMoreData)
        footer.setRefreshingTarget(self, refreshingAction: #selector(CPFollowersViewController.footerRefresh))
        footer.isRefreshingTitleHidden = true
        self.tableView.mj_footer = footer
    }
    
    // 顶部刷新
    func headerRefresh(){
        userPageVal = 1
        fvc_selectDataSource()
    }
    
    // 底部刷新
    func footerRefresh(){
        userPageVal += 1
        fvc_selectDataSource()
    }

    func fvc_updateViewContent() {
        
        self.tableView.reloadData()
    }
    
    func fvc_selectDataSource() {
        
        if(self.viewType == "follower") {
            tvc_getUserFollowerRequest()
        }else if(self.viewType == "following"){
            tvc_getUserFollowingRequst()
        }
        
    }
    
    // MARK: fetch data form request
    func tvc_getUserFollowerRequest() {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Provider.sharedProvider.request(.userFollowers(page:self.userPageVal,perpage:self.userPerpageVal,username:self.username!) ) { (result) -> () in
            
            var message = kNoMessageTip
            
            if(self.userPageVal == 1) {
                self.tableView.mj_header.endRefreshing()
            }else{
                self.tableView.mj_footer.endRefreshing()
            }
            
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            
            switch result {
            case let .success(response):
                
                do {
                    if let userResult:[ObjUser]? = try response.mapArray(ObjUser.self) {
                        if(self.userPageVal == 1) {
                            self.userData.removeAll()
                            self.userData = userResult
                        }else{
                            self.userData = self.userData+userResult!
                        }
                        
                        self.fvc_updateViewContent()
                        
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
    
    func tvc_getUserFollowingRequst() {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Provider.sharedProvider.request(.userFollowing(page:self.userPageVal,perpage:self.userPerpageVal,username:self.username!) ) { (result) -> () in
            
            var message = kNoMessageTip
            
            if(self.userPageVal == 1) {
                self.tableView.mj_header.endRefreshing()
            }else{
                self.tableView.mj_footer.endRefreshing()
            }
            
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            
            switch result {
            case let .success(response):
                
                do {
                    if let userResult:[ObjUser]? = try response.mapArray(ObjUser.self) {
                        if(self.userPageVal == 1) {
                            self.userData.removeAll()
                            self.userData = userResult
                        }else{
                            self.userData = self.userData+userResult!
                        }
                        
                        self.fvc_updateViewContent()
                        
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

}

extension CPFollowersViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = (indexPath as NSIndexPath).row
        
        let cellId = "CPTrendingDeveloperCellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? CPTrendingDeveloperCell
        if cell == nil {
            cell = (CPTrendingDeveloperCell.cellFromNibNamed("CPTrendingDeveloperCell") as! CPTrendingDeveloperCell)
            
        }
        
        //handle line in cell
        if row == 0 {
            cell!.topline = true
        }
        if (row == userData.count-1) {
            cell!.fullline = true
        }else {
            cell!.fullline = false
        }
        
        let user = self.userData[row]
        cell!.user = user
        cell!.userNo = row
        
        return cell!;
        
    }
    
}

extension CPFollowersViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 71
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    
        let user = self.userData[(indexPath as NSIndexPath).row]
        self.performSegue(withIdentifier: SegueTrendingShowDeveloperDetail, sender: user)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if(segue.identifier == SegueProfileShowDeveloperDetail){
            
            let devVC = segue.destination as! CPTrendingDeveloperViewController
            devVC.hidesBottomBarWhenPushed = true
            
            let dev = sender as? ObjUser
            if(dev != nil){
                devVC.developer = dev
            }
        }
        
        
    }
    
}
