//
//  CPTrendingViewController.swift
//  Coderpursue
//
//  Created by wenghengcong on 15/12/30.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

import UIKit
import Moya
import Foundation
import MJRefresh
import ObjectMapper

class CPTrendingViewController: CPBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let segRepos = "Repositoies"
    let segDeves = "Developers"
    let segShows = "Showcases"
    var segControl:HMSegmentedControl! = HMSegmentedControl.init(sectionTitles: ["Repositoies","Developers","Showcases"])
    
    var reposData:[ObjRepos]! = []
    var devesData:[ObjUser]! = []
    var showcasesData:[ObjShowcase]! = []
    
    
    // MARK: request parameters
    
    //search user para
    var paraUser:ParaSearchUser = ParaSearchUser.init()
    
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tvc_checkUserSignIn()
        tvc_addNaviBarButtonItem()
    }
    
    func tvc_addNaviBarButtonItem() {
        
        let btnName = UIButton()
        btnName.setImage(UIImage(named: "bubble_consulting_chat-512"), forState: .Normal)
        btnName.frame = CGRectMake(0, 0, 30, 30)
        btnName.addTarget(self, action: Selector("tvc_rightButtonTouch"), forControlEvents: .TouchUpInside)
        
        //.... Set Right/Left Bar Button item
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = btnName
        self.navigationItem.rightBarButtonItem = rightBarButton
        
    }
    
    func tvc_rightButtonTouch() {
        
    }
    
    func resetSearchUserParameters(){
        
        //test
        /*
        var para:ParaComparison = ParaComparison.init(left: 5, op:ComparisonOperator.Less)
        let s1 = para.combineComparision()
        
        var para2:ParaComparison = ParaComparison.init(left: 5, right: 10, op: ComparisonOperator.Between)
        let s2 = para2.combineComparision()
        
        print("\(s1),\(s2)")
        */
        
        paraUser.q = paraUser.combineQuery()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tvc_checkUserSignIn() {
        
        tvc_setupSegmentView()
        tvc_setupTableView()
        updateNetrokData()
        
    }
    
    func updateNetrokData() {
        
        
        if(segControl.selectedSegmentIndex == 0) {
            tvc_getReposRequest()
        }else if(segControl.selectedSegmentIndex == 1){
            tvc_getUserRequest()
        }else{
            tvc_getShowcasesRequest()
        }
        

    }
    
    func tvc_setupSegmentView() {
        
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
        
        segControl.indexChangeBlock = {
            (index:Int)-> Void in
            
            if( (self.segControl.selectedSegmentIndex == 0)&&self.reposData.isEmpty ){
                self.tvc_getReposRequest()
            }else if( (self.segControl.selectedSegmentIndex == 1)&&self.devesData.isEmpty ){
                self.tvc_getUserRequest()
            }else if( (self.segControl.selectedSegmentIndex == 2)&&self.showcasesData.isEmpty ){
                self.tvc_getShowcasesRequest()
            }else{
                self.tableView.reloadData()
            }
            
        }
        
        segControl.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(64)
            make.height.equalTo(44)
            make.width.equalTo(self.view)
            make.left.equalTo(0)
        }
        
    }
    
    func tvc_setupTableView() {
        
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
        footer.refreshingTitleHidden = true
        self.tableView.mj_footer = footer
    }
    
    // 顶部刷新
    func headerRefresh(){
        print("下拉刷新")
        if(segControl.selectedSegmentIndex == 0) {

        }else if(segControl.selectedSegmentIndex == 1){
            paraUser.page = 1
        }else{

        }
        updateNetrokData()
    }
    
    // 底部刷新
    func footerRefresh(){
        print("上拉刷新")
        if(segControl.selectedSegmentIndex == 0) {

        }else if(segControl.selectedSegmentIndex == 1){
            paraUser.page++
        }else{
            
        }
        updateNetrokData()
    }
    
    // MARK: fetch data form request
    
    func tvc_getReposRequest() {
        
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        Provider.sharedProvider.request(.TrendingRepos(since:"daily",language:"all") ) { (result) -> () in
            
            var success = true
            var message = "Unable to fetch from GitHub"
            
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            
            switch result {
            case let .Success(response):
                
                do {
                    if let repos:[ObjRepos]? = try response.mapArray(ObjRepos){
                        if(self.paraUser.page == 1){
                            self.reposData.removeAll()
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
    
    func tvc_getUserRequest() {
        
        resetSearchUserParameters()
        print("search user query:\(paraUser.q)")
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        Provider.sharedProvider.request(.SearchUsers(para:self.paraUser) ) { (result) -> () in
            
            var success = true
            var message = "Unable to fetch from GitHub"
            
            if(self.paraUser.page == 1) {
                self.tableView.mj_header.endRefreshing()
            }else{
                self.tableView.mj_footer.endRefreshing()
            }
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            
            switch result {
            case let .Success(response):
                
                do {
                    if let userResult:ObjSearchUserResponse = Mapper<ObjSearchUserResponse>().map(try response.mapJSON() ) {
                        if(self.paraUser.page == 1) {
                            self.devesData.removeAll()
                            self.devesData = userResult.items
                        }else{
                            self.devesData = self.devesData+userResult.items!
                        }
                        
                        self.tableView.reloadData()
                        
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
    
    
    func tvc_getShowcasesRequest() {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        Provider.sharedProvider.request(.TrendingShowcases() ) { (result) -> () in
            
            var success = true
            var message = "Unable to fetch from GitHub"
            
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            
            switch result {
            case let .Success(response):
                
                do {
                    if let shows:[ObjShowcase]? = try response.mapArray(ObjShowcase){
                        
                        self.showcasesData.removeAll()
                        self.showcasesData = shows!
                        self.tableView.reloadData()
                        
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

}

extension CPTrendingViewController : UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (segControl.selectedSegmentIndex == 0) {
            
            return  self.reposData.count
        }else if(segControl.selectedSegmentIndex == 1)
        {
            return self.devesData.count
        }
        return self.showcasesData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        var cellId = ""
        
        if segControl.selectedSegmentIndex == 0 {
            
            cellId = "CPTrendingRepoCellIdentifier"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? CPTrendingRepoCell
            if cell == nil {
                cell = (CPTrendingRepoCell.cellFromNibNamed("CPTrendingRepoCell") as! CPTrendingRepoCell)
            }
            
            //handle line in cell
            if row == 0 {
                cell!.topline = true
            }
            if (row == reposData.count-1) {
                cell!.fullline = true
            }else {
                cell!.fullline = false
            }
            
            let repos = self.reposData[row]
            cell!.objRepos = repos
            
            return cell!;
            
        }else if(segControl.selectedSegmentIndex == 1) {
            
            cellId = "CPTrendingDeveloperCellIdentifier"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? CPTrendingDeveloperCell
            if cell == nil {
                cell = (CPTrendingDeveloperCell.cellFromNibNamed("CPTrendingDeveloperCell") as! CPTrendingDeveloperCell)
                
            }
            
            //handle line in cell
            if row == 0 {
                cell!.topline = true
            }
            if (row == devesData.count-1) {
                cell!.fullline = true
            }else {
                cell!.fullline = false
            }
            
            let user = self.devesData[row]
            cell!.user = user
            cell!.userNo = row
            
            return cell!;
        }
        
        cellId = "CPTrendingShowcaseCellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? CPTrendingShowcaseCell
        if cell == nil {
            cell = (CPTrendingShowcaseCell.cellFromNibNamed("CPTrendingShowcaseCell") as! CPTrendingShowcaseCell)
            
        }
        let showcase = self.showcasesData[row]
        cell!.showcase = showcase
        return cell!;
        
    }
    
}

extension CPTrendingViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if segControl.selectedSegmentIndex == 0 {
            
            return 85
            
        }else if(segControl.selectedSegmentIndex == 1){
            
            return 71
        }
        return 135
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        if segControl.selectedSegmentIndex == 0 {
            
            let repos = self.reposData[indexPath.row]
            self.performSegueWithIdentifier(SegueTrendingShowRepositoryDetail, sender: repos)
        }else if(segControl.selectedSegmentIndex == 1){
            
            let dev = self.devesData[indexPath.row]
            self.performSegueWithIdentifier(SegueTrendingShowDeveloperDetail, sender: dev)
        }else {
            
            let showcase = self.showcasesData[indexPath.row]
            self.performSegueWithIdentifier(SegueTrendingShowShowcaseDetail, sender: showcase)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == SegueTrendingShowRepositoryDetail){
            let reposVC = segue.destinationViewController as! CPTrendingRepositoryViewController
            reposVC.hidesBottomBarWhenPushed = true
            
            let repos = sender as? ObjRepos
            if(repos != nil){
                reposVC.repos = repos
            }

        }else if(segue.identifier == SegueTrendingShowDeveloperDetail){
            let devVC = segue.destinationViewController as! CPTrendingDeveloperViewController
            devVC.hidesBottomBarWhenPushed = true
            
            let dev = sender as? ObjUser
            if(dev != nil){
                devVC.developer = dev
            }
            
        }else if(segue.identifier == SegueTrendingShowShowcaseDetail){
            
            let showcaseVC = segue.destinationViewController as! CPTrendingShowcaseViewController
            showcaseVC.hidesBottomBarWhenPushed = true

            let showcase = sender as? ObjShowcase
            if(showcase != nil){
                showcaseVC.showcase = showcase
            }
            
        }
        
    }
    
}


