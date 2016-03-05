//
//  CPStarsViewController.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/23.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit
import Moya
import PullToBounce
import Foundation
import MJRefresh

class CPStarsViewController: CPBaseViewController{

    @IBOutlet weak var tableView: UITableView!
    
    var segControl:HMSegmentedControl! = HMSegmentedControl.init(sectionTitles: ["Repositories","Event"])
    
    var cellId = "CPStarredReposCell"
    var reposData:[ObjRepos]! = []
    var sortVal:String = "created"
    var directionVal:String = "desc"
    var pageVal = 0
    
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        svc_checkUserSignIn()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func svc_checkUserSignIn() {
        
        svc_setupSegmentView()
        svc_setupTableView()
        
        if UserInfoHelper.sharedInstance.isLoginIn {
            self.tableView.hidden = false
            svc_getUserReposRequest(pageVal)
        }else {
            //加载未登录的页面
            self.tableView.hidden = true
            
            
        }
        
    }
    
    func svc_setupSegmentView() {
        
        self.view.addSubview(segControl)
        segControl.verticalDividerColor = UIColor.lineBackgroundColor()
        segControl.verticalDividerWidth = 1
        segControl.verticalDividerEnabled = true
        segControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe
        segControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
        segControl.selectionIndicatorColor = UIColor.cpRedColor()
        segControl.selectionIndicatorHeight = 2
        segControl.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.labelTitleTextColor(),NSFontAttributeName:UIFont.hugeSizeSystemFont()];
        
        segControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName : UIColor.cpRedColor(),NSFontAttributeName:UIFont.hugeSizeSystemFont()];
        
        segControl.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(64)
            make.height.equalTo(44)
            make.width.equalTo(self.view)
            make.left.equalTo(0)
        }
        
    }
    
    func svc_setupTableView() {
        
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
        self.tableView.mj_header = header
        
        // 上拉刷新
        footer.setTitle("Click or drag up to refresh", forState: .Idle)
        footer.setTitle("Loading more ...", forState: .Pulling)
        footer.setTitle("No more data", forState: .NoMoreData)
        footer.setRefreshingTarget(self, refreshingAction: Selector("footerRefresh"))
        self.tableView.mj_footer = footer
    }
    
    // 顶部刷新
    func headerRefresh(){
        print("下拉刷新")
        pageVal = 0
        svc_getUserReposRequest(pageVal)
    }
    
    // 底部刷新
    func footerRefresh(){
        print("上拉刷新")
        pageVal++
        svc_getUserReposRequest(pageVal)
    }
    
    
    // MARK: fetch data form request
    
    func svc_getUserReposRequest(pageVal:Int) {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        Provider.sharedProvider.request(.MyStarredRepos(page:pageVal,perpage:10,sort: sortVal,direction: directionVal) ) { (result) -> () in

            var success = true
            var message = "Unable to fetch from GitHub"
            
            if(pageVal == 0) {
                self.tableView.mj_header.endRefreshing()
            }else{
                self.tableView.mj_footer.endRefreshing()
            }
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            
            switch result {
            case let .Success(response):
                
                do {
                    if let repos:[ObjRepos]? = try response.mapArray(ObjRepos){
                        if(pageVal == 0) {
                            self.reposData = repos!
                        }else{
                            self.reposData = self.reposData+repos!
                        }
                        
                        self.tableView.reloadData()
                        
                    } else {
                        success = false
                    }
                } catch {
                    success = false
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

extension CPStarsViewController : UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reposData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView .dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as? CPStarredReposCell
        if cell == nil {
            cell = CPStarredReposCell(style: UITableViewCellStyle.Default, reuseIdentifier:cellId)
        }
        let row = indexPath.row
        
        let repos = self.reposData[row]
        cell!.objRepos = repos
        
        //handle line in cell
        if row == 0 {
            cell!.topline = true
        }
        if (row == reposData.count-1) {
            cell!.fullline = true
        }else {
            cell!.fullline = false
        }
        
        return cell!;
    }
    
}
extension CPStarsViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}
