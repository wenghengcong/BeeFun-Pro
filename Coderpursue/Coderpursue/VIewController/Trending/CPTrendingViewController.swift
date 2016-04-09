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
    
    //view
    var segControl:HMSegmentedControl! = HMSegmentedControl.init(sectionTitles: ["Repositories","Developers","Showcases"])
    var filterView:CPFilterTableView?
    let filterVHeight:CGFloat = 270    //filterview height
    let header = MJRefreshNormalHeader()
    let footer = MJRefreshAutoNormalFooter()

    // MARK: data
    var reposData:[ObjRepos]! = []
    var devesData:[ObjUser]! = []
    var showcasesData:[ObjShowcase]! = []
    
    var cityArr:[String]?
    var countryArr:[String]?
    var languageArr:[String]?
    var sinceArr:[String] = [TrendingSince.Daily.rawValue,TrendingSince.Weekly.rawValue,TrendingSince.Monthly.rawValue]
    
    // MARK: request parameters
    var lastSegmentIndex = 0
    var paraUser:ParaSearchUser = ParaSearchUser.init()
    var paraSince:String = "daily"
    var paraLanguage:String = "all"
    
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
    
    
    // MARK: view cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tvc_getDataFromPlist()
        tvc_setupSegmentView()
        tvc_setupTableView()
        tvc_setupFilterView()
        tvc_addNaviBarButtonItem()
        updateNetrokData()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CPTrendingViewController.tvc_loginSuccessful), name: NotificationGitLoginSuccessful, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CPTrendingViewController.tvc_logoutSuccessful), name: NotificationGitLogOutSuccessful, object: nil)
        self.title = "Explore"

    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func tvc_loginSuccessful() {
        
        if(self.segControl.selectedSegmentIndex == 1){
            tvc_getUserRequest()
        }
    }
    
    func tvc_logoutSuccessful() {
        
        devesData.removeAll()
        tableView.reloadData()
    }
    
    // MARK: view
    
    func tvc_addNaviBarButtonItem() {
        
        self.leftItemImage = UIImage(named: "nav_funnel")
        self.leftItemSelImage = UIImage(named: "nav_funnel_sel")
        
        self.rightItemImage = UIImage(named: "nav_search_35")
        self.rightItemSelImage = UIImage(named: "nav_search_35")
        self.rightItem?.hidden = false
    }
    
    func tvc_setupFilterView(){
        
        let firW:CGFloat = 100.0
        let secW:CGFloat = self.view.width-firW
        filterView = CPFilterTableView(frame: CGRectMake(0, 64-filterVHeight-10, self.view.width, filterVHeight))
        filterView!.backgroundColor = UIColor.viewBackgroundColor()
        filterView!.filterDelegate = self
        filterView!.coloumn = .Two
        filterView!.rowWidths = [firW,secW]
        filterView!.rowHeights = [40.0,40.0]
        filterView!.filterTypes = ["Since"]
        filterView!.filterData = [sinceArr]
        filterView!.filterViewInit()
        self.view.addSubview(filterView!)
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
            
            if( (self.segControl.selectedSegmentIndex == 0) && (self.reposData != nil) ){
                self.leftItem?.hidden = false
                self.tvc_getReposRequest()
            }else if( (self.segControl.selectedSegmentIndex == 1) && (self.devesData != nil) ){
                self.leftItem?.hidden = false
                self.tvc_getUserRequest()
            }else if( (self.segControl.selectedSegmentIndex == 2) && (self.showcasesData != nil) ){
                self.leftItem?.hidden = true
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
        header.setRefreshingTarget(self, refreshingAction: #selector(CPTrendingViewController.headerRefresh))
        // 现在的版本要用mj_header
        self.tableView.mj_header = header
        
        // 上拉刷新
        footer.setTitle("Click or drag up to refresh", forState: .Idle)
        footer.setTitle("Loading more ...", forState: .Pulling)
        footer.setTitle("No more data", forState: .NoMoreData)
        footer.setRefreshingTarget(self, refreshingAction: #selector(CPTrendingViewController.footerRefresh))
        footer.refreshingTitleHidden = true
        self.tableView.mj_footer = footer
    }

    
    // MARK: action
    
    override func leftItemAction(sender: UIButton?) {
        let btn = sender!
        btn.selected = !btn.selected
        if(btn.selected){
            tvc_filterViewApper()
        }else{
            tvc_filterViewDisapper()
        }
    }
    
    override func rightItemAction(sender: UIButton?) {
        
        let searchVC = CPSearchViewController()
        searchVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func tvc_filterViewApper(){
        
        if ((segControl.selectedSegmentIndex == 0) && (lastSegmentIndex != segControl.selectedSegmentIndex) ) {
            filterView!.filterTypes = ["Since"]
            filterView!.filterData = [sinceArr]
        }else if((segControl.selectedSegmentIndex == 1) && (lastSegmentIndex != segControl.selectedSegmentIndex)){
            filterView!.filterTypes = ["Language","Country"]
            filterView!.filterData = [languageArr!,countryArr!]
        }
        
        if(lastSegmentIndex != segControl.selectedSegmentIndex){
            filterView!.resetProperty()
            filterView!.resetAllColoumnsData()
        }

        filterView!.frame = CGRectMake(0, 64, self.view.width, filterVHeight)
        lastSegmentIndex = segControl.selectedSegmentIndex
    }
    
    func tvc_filterViewDisapper(){
        leftItem?.selected = false
        filterView!.frame = CGRectMake(0, 64-filterVHeight-10, self.view.width, filterVHeight)

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
    
    func headerRefresh(){
        if(segControl.selectedSegmentIndex == 0) {

        }else if(segControl.selectedSegmentIndex == 1){
            paraUser.page = 1
        }else{

        }
        updateNetrokData()
    }
    
    func footerRefresh(){
        if(segControl.selectedSegmentIndex == 0) {

        }else if(segControl.selectedSegmentIndex == 1){
            paraUser.page += 1
        }else{
            
        }
        updateNetrokData()
    }
    
    func tvc_isLogin()->Bool{
        if( !(UserInfoHelper.sharedInstance.isLoginIn) ){
            CPGlobalHelper.sharedInstance.showMessage("You Should Login in first!", view: self.view)
            return false
        }
        return true
    }
    
    // MARK: fetch data form plist file
    func tvc_getDataFromPlist() {
        
        if let path = NSBundle.mainBundle().pathForResource("CPCity", ofType: "plist") {
            cityArr = NSArray(contentsOfFile: path)! as? [String]
        }
        
        if let path = NSBundle.mainBundle().pathForResource("CPLanguage", ofType: "plist") {
            languageArr = NSArray(contentsOfFile: path)! as? [String]
        }
        
        if let path = NSBundle.mainBundle().pathForResource("CPCountry", ofType: "plist") {
            countryArr = NSArray(contentsOfFile: path)! as? [String]
        }
    }

    // MARK: fetch data form request
    
    func tvc_getReposRequest() {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        Provider.sharedProvider.request(.TrendingRepos(since:paraSince,language:"all") ) { (result) -> () in
            
            var message = "No data to show"
            
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

                    }
                } catch {
                    CPGlobalHelper.sharedInstance.showError(message, view: self.view)
                }
            case let .Failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                CPGlobalHelper.sharedInstance.showError(message, view: self.view)
                
            }
            
        }
    }
    
    func tvc_getUserRequest() {
        
        if(!tvc_isLogin()){
            
            tableView.mj_header.endRefreshing()
            tableView.mj_footer.endRefreshing()
            tableView.mj_footer.hidden = true
        
            self.tableView.reloadData()
            return
        }
        
        tableView.mj_footer.hidden = false

        resetSearchUserParameters()
        print("search user query:\(paraUser.q)")
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        Provider.sharedProvider.request(.SearchUsers(para:self.paraUser) ) { (result) -> () in
            
            var message = "No data to show"
            
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
                            
                            if(self.devesData != nil){
                                self.devesData.removeAll()
                                self.devesData = userResult.items
                            }

                        }else{
                            self.devesData = self.devesData+userResult.items!
                        }
                        
                        self.tableView.reloadData()
                        
                    } else {
                    }
                } catch {
                    CPGlobalHelper.sharedInstance.showError(message, view: self.view)
                }
            case let .Failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                CPGlobalHelper.sharedInstance.showError(message, view: self.view)
                
            }
        }
        
    }
    
    
    func tvc_getShowcasesRequest() {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        Provider.sharedProvider.request(.TrendingShowcases() ) { (result) -> () in
            
            var message = "No data to show"
            
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
                    }
                } catch {
                    CPGlobalHelper.sharedInstance.showError(message, view: self.view)
                }
            case let .Failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                CPGlobalHelper.sharedInstance.showError(message, view: self.view)
                
            }
        }
        
    }

}

extension CPTrendingViewController : CPFilterTableViewProtocol {
    //filter delegate
    func didSelectValueColoumn(row:Int ,type:String ,value:String) {
        
        if segControl.selectedSegmentIndex == 0 {
            if type == "Since" {
                paraSince = value
            }else if(type == "Language"){
                if value == "All" {
                    paraLanguage = "all"
                }else{
                    paraLanguage = value
                }
            }
            tvc_filterViewDisapper()
            tvc_getReposRequest()
            
        }else if(segControl.selectedSegmentIndex == 1){
            if(value != "All"){
                if(type == "Language"){
                    paraUser.languagePara = value
                }else if(type == "City"){
                    paraUser.locationPara = value
                }else if(type == "Country"){
                    paraUser.locationPara = value
                }
            }else{
                paraUser.languagePara = nil
                paraUser.locationPara = nil
            }
            tvc_filterViewDisapper()
            tvc_getUserRequest()
        }
        
    }
    
    func didSelectTypeColoumn(row: Int, type: String, value: String) {
        
    }
}

extension CPTrendingViewController : UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (segControl.selectedSegmentIndex == 0) {
            
            if (self.reposData != nil){
                return  self.reposData.count
            }
            return 0

        }else if(segControl.selectedSegmentIndex == 1)
        {
            if (self.devesData != nil){
                return self.devesData.count
            }
            return 0
        }
        
        if (self.showcasesData != nil){
            return self.showcasesData.count
        }
        
        return 0
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
        if(!tvc_isLogin()){
            return
        }
        
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


