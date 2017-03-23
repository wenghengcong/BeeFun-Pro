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
import MBProgressHUD
import HMSegmentedControl

public enum TrendingViewPageType:String {
    
    case user = "user"
    case repos = "repos"
    
}

class CPTrendingViewController: CPBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    //view
    var segControl:HMSegmentedControl! = HMSegmentedControl.init(sectionTitles: ["Repositories".localized,"Developers".localized,"Showcases".localized])
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
    var sinceArr:[String] = [TrendingSince.Daily.rawValue.localized,TrendingSince.Weekly.rawValue.localized,TrendingSince.Monthly.rawValue.localized]
    
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
        tvc_firstCheckLogin()
        
        NotificationCenter.default.addObserver(self, selector: #selector(CPTrendingViewController.tvc_loginSuccessful), name: NSNotification.Name(rawValue: kNotificationDidGitLogin), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CPTrendingViewController.tvc_logoutSuccessful), name: NSNotification.Name(rawValue: kNotificationDidGitLogOut), object: nil)
        self.title = "Explore".localized

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func tvc_firstCheckLogin() {
        
        if (segControl.selectedSegmentIndex != 1){
            tvc_updateNetrokData()
            return
        }
        if UserManager.shared.isLogin {
            tvc_updateNetrokData()
        }else{
            UserManager.shared.showNotLoginTips()
        }
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
        self.rightItem?.isHidden = false
    }
    
    func tvc_setupFilterView(){
        
        let firW:CGFloat = 100.0
        let secW:CGFloat = self.view.width-firW
        filterView = CPFilterTableView(frame: CGRect(x: 0, y: 64-filterVHeight-10, width: self.view.width, height: filterVHeight))
        filterView!.backgroundColor = UIColor.viewBackgroundColor
        filterView!.filterDelegate = self
        filterView!.coloumn = .two
        filterView!.rowWidths = [firW,secW]
        filterView!.rowHeights = [40.0,40.0]
        filterView!.filterTypes = ["Since".localized]
        filterView!.filterData = [sinceArr]
        filterView!.filterViewInit()
        self.view.addSubview(filterView!)
    }
    
    func tvc_setupSegmentView() {
        
        self.view.addSubview(segControl)
        segControl.verticalDividerColor = UIColor.lineBackgroundColor
        segControl.verticalDividerWidth = 1
        segControl.isVerticalDividerEnabled = true
        segControl.selectionStyle = HMSegmentedControlSelectionStyle.fullWidthStripe
        segControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.down
        segControl.selectionIndicatorColor = UIColor.cpRedColor
        segControl.selectionIndicatorHeight = 2
        segControl.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.labelTitleTextColor,NSFontAttributeName:UIFont.hugeSizeSystemFont()];
        
        segControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName : UIColor.cpRedColor,NSFontAttributeName:UIFont.hugeSizeSystemFont()];
        
        segControl.indexChangeBlock = {
            (index:Int)-> Void in
            
            self.filterView?.resetProperty()

            if( (self.segControl.selectedSegmentIndex == 0) && (self.reposData != nil) ){
                self.leftItem?.isHidden = false
                self.tvc_getReposRequest()
            }else if( (self.segControl.selectedSegmentIndex == 1) && (self.devesData != nil) ){
                self.leftItem?.isHidden = false
                self.tvc_getUserRequest()
            }else if( (self.segControl.selectedSegmentIndex == 2) && (self.showcasesData != nil) ){
                self.leftItem?.isHidden = true
                self.tvc_getShowcasesRequest()
            }else{
                self.tableView.reloadData()
            }
            
        }
        
        segControl.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(64)
            make.height.equalTo(44)
            make.width.equalTo(self.view)
            make.left.equalTo(0)
        }
        
    }
    
    func tvc_setupTableView() {
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.viewBackgroundColor
        self.automaticallyAdjustsScrollViewInsets = false
        
        // 下拉刷新
        header.setTitle("", for: .idle)
        header.setTitle(kHeaderPullTip, for: .pulling)
        header.setTitle(kHeaderPullingTip, for: .refreshing)
        header.setRefreshingTarget(self, refreshingAction: #selector(CPTrendingViewController.headerRefresh))
        // 现在的版本要用mj_header
        self.tableView.mj_header = header
        
        // 上拉刷新
        footer.setTitle("", for: .idle)
        footer.setTitle(kFooterLoadTip, for: .pulling)
        footer.setTitle(kFooterLoadNoDataTip, for: .noMoreData)
        footer.setRefreshingTarget(self, refreshingAction: #selector(CPTrendingViewController.footerRefresh))
        footer.isRefreshingTitleHidden = true
        self.tableView.mj_footer = footer
    }

    
    // MARK: action
    
    override func leftItemAction(_ sender: UIButton?) {
        let btn = sender!
        btn.isSelected = !btn.isSelected
        if(btn.isSelected){
            tvc_filterViewApper()
        }else{
            tvc_filterViewDisapper()
        }
    }
    
    // MARK: action 搜索
    override func rightItemAction(_ sender: UIButton?) {
    
        if !tvc_isLogin() {
            return
        }
        self.performSegue(withIdentifier: SegueTrendingSearchView, sender: nil)

    }
    
    func tvc_filterViewApper(){
        
        if ((segControl.selectedSegmentIndex == 0) && (lastSegmentIndex != segControl.selectedSegmentIndex) ) {
            filterView!.filterTypes = ["Since".localized]
            filterView!.filterData = [sinceArr]
        }else if((segControl.selectedSegmentIndex == 1) && (lastSegmentIndex != segControl.selectedSegmentIndex)){
            filterView!.filterTypes = ["Language".localized,"Country".localized]
            filterView!.filterData = [languageArr!,countryArr!]
        }
        
        if(lastSegmentIndex != segControl.selectedSegmentIndex){
            filterView!.resetProperty()
            filterView!.resetAllColoumnsData()
        }

        filterView!.frame = CGRect(x: 0, y: 64, width: self.view.width, height: filterVHeight)
        lastSegmentIndex = segControl.selectedSegmentIndex
    }
    
    func tvc_filterViewDisapper(){
        leftItem?.isSelected = false
        filterView!.frame = CGRect(x: 0, y: 64-filterVHeight-10, width: self.view.width, height: filterVHeight)

    }
    
    /// 加载数据
    func tvc_updateNetrokData() {
        
        if(segControl.selectedSegmentIndex == 0) {
            tvc_getReposRequest()
        }else if(segControl.selectedSegmentIndex == 1){
            tvc_getUserRequest()
        }else{
            tvc_getShowcasesRequest()
        }
        

    }
    
    /// 下拉刷新
    func headerRefresh(){
        if(segControl.selectedSegmentIndex == 0) {

        }else if(segControl.selectedSegmentIndex == 1){
            paraUser.page = 1
        }else{

        }
        tvc_updateNetrokData()
    }
    
    /// 上拉加载
    func footerRefresh(){
        if(segControl.selectedSegmentIndex == 0) {

        }else if(segControl.selectedSegmentIndex == 1){
            paraUser.page += 1
        }else{
            
        }
        tvc_updateNetrokData()
    }
    
    
    /// 判断是否登录
    ///
    /// - Returns: <#return value description#>
    func tvc_isLogin()->Bool{
        if( !(UserManager.shared.checkUserLogin() ) ){
            return false
        }
        return true
    }
    
    // MARK:- 从plist中获取用语filter的数据
    func tvc_getDataFromPlist() {
        
        if let path = Bundle.appBundle.path(forResource: "CPCity", ofType: "plist") {
            cityArr = NSArray(contentsOfFile: path)! as? [String]
        }
        
        if let path = Bundle.appBundle.path(forResource: "CPFilterLanguage", ofType: "plist") {
            languageArr = NSArray(contentsOfFile: path)! as? [String]
        }
        
        if let path = Bundle.appBundle.path(forResource: "CPCountry", ofType: "plist") {
            countryArr = NSArray(contentsOfFile: path)! as? [String]
        }
    }

    // MARK: fetch data form request
    
    func tvc_getReposRequest() {
        
        JSMBHUDBridge.showHud(view: self.view)
        
        Provider.sharedProvider.request(.trendingRepos(since:paraSince,language:"all") ) { (result) -> () in
            
            var message = kNoMessageTip
            
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            JSMBHUDBridge.hideHud(view: self.view)
            
            switch result {
            case let .success(response):
                
                do {
                    if let repos:[ObjRepos]? = try response.mapArray(ObjRepos.self){
                        if repos?.count == 0{
                            return
                        }
                        if(self.paraUser.page == 1){
                            self.reposData.removeAll()
                            self.reposData = repos!
                            self.tableView.reloadData()
                            //self.tableView.setContentOffset(CGPoint.zero, animated:true)
                        }else{
                            self.reposData = self.reposData+repos!
                            self.tableView.reloadData()
                        }
                        
                    } else {

                    }
                } catch {
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
    
    func tvc_getUserRequest() {
        
        if(!tvc_isLogin()){
            
            tableView.mj_header.endRefreshing()
            tableView.mj_footer.endRefreshing()
            tableView.mj_footer.isHidden = true
        
            self.tableView.reloadData()
            return
        }
        
        tableView.mj_footer.isHidden = false

        resetSearchUserParameters()
        print("search user query:\(paraUser.q)")
        
        JSMBHUDBridge.showHud(view: self.view)
        
        Provider.sharedProvider.request(.searchUsers(para:self.paraUser) ) { (result) -> () in
            
            var message = kNoMessageTip
            
            if(self.paraUser.page == 1) {
                self.tableView.mj_header.endRefreshing()
            }else{
                self.tableView.mj_footer.endRefreshing()
            }
            
            JSMBHUDBridge.hideHud(view: self.view)
            
            switch result {
            case let .success(response):
                
                do {
                    if let userResult:ObjSearchUserResponse = Mapper<ObjSearchUserResponse>().map(JSONObject:try response.mapJSON() ) {
                        if(self.paraUser.page == 1) {
                            //在第一页，之前有数据，清空
                            if(self.devesData != nil){
                                self.devesData.removeAll()
                            }
                            self.devesData = userResult.items
                            self.tableView.reloadData()
//                            self.tableView.setContentOffset(uiTopPoint, animated:true)

                        }else{
                            self.devesData = self.devesData+userResult.items!
                            self.tableView.reloadData()
                        }
                        
                        
                    } else {
                    }
                } catch {
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
    
    
    func tvc_getShowcasesRequest() {
        
        JSMBHUDBridge.showHud(view: self.view)
        
        Provider.sharedProvider.request(.trendingShowcases() ) { (result) -> () in
            
            var message = kNoMessageTip
            
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            JSMBHUDBridge.hideHud(view: self.view)
            
            switch result {
            case let .success(response):
                
                do {
                    if let shows:[ObjShowcase]? = try response.mapArray(ObjShowcase.self
                        ){
                        
                        self.showcasesData.removeAll()
                        self.showcasesData = shows!
                        self.tableView.reloadData()
                        
                    } else {
                    }
                } catch {
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

}
// MARK: - 筛选视图的回调

extension CPTrendingViewController : CPFilterTableViewProtocol {
    //filter delegate
    func didSelectValueColoumn(_ row:Int ,type:String ,value:String) {
        
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
            paraUser.page = 1
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
            paraUser.page = 1
            tvc_filterViewDisapper()
            tvc_getUserRequest()
        }
        
    }
    
    func didSelectTypeColoumn(_ row: Int, type: String, value: String) {
        
    }
}

extension CPTrendingViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (segControl.selectedSegmentIndex == 0) {
            
            if (self.reposData != nil){
                return  self.reposData.count
            }
            return 0

        }else if(segControl.selectedSegmentIndex == 1){
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = (indexPath as NSIndexPath).row
        
        var cellId = ""
        
        if segControl.selectedSegmentIndex == 0 {
            
            cellId = "CPTrendingRepoCellIdentifier"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? CPTrendingRepoCell
            if cell == nil {
                cell = (CPTrendingRepoCell.cellFromNibNamed("CPTrendingRepoCell") as! CPTrendingRepoCell)
            }
            
            if self.reposData.isBeyond(index: row) {
                return cell!
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
            var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? CPTrendingDeveloperCell
            if cell == nil {
                cell = (CPTrendingDeveloperCell.cellFromNibNamed("CPTrendingDeveloperCell") as! CPTrendingDeveloperCell)
                
            }
            
            if self.devesData.isBeyond(index: row) {
                return cell!
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
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? CPTrendingShowcaseCell
        if cell == nil {
            cell = (CPTrendingShowcaseCell.cellFromNibNamed("CPTrendingShowcaseCell") as! CPTrendingShowcaseCell)
            
        }
        if self.showcasesData.isBeyond(index: row) {
            return cell!
        }
        
        let showcase = self.showcasesData[row]
        cell!.showcase = showcase
        return cell!;
        
    }
    
}

extension CPTrendingViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if segControl.selectedSegmentIndex == 0 {
            
            return 85
            
        }else if(segControl.selectedSegmentIndex == 1){
            
            return 71
        }
        return 135
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if(!tvc_isLogin()){
            return
        }
        
        if segControl.selectedSegmentIndex == 0 {
            
            let repos = self.reposData[(indexPath as NSIndexPath).row]
            let vc = CPRepositoryViewController()
            vc.repos = repos
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if(segControl.selectedSegmentIndex == 1){
            
            let dev = self.devesData[(indexPath as NSIndexPath).row]
            self.performSegue(withIdentifier: SegueTrendingShowDeveloperDetail, sender: dev)
        }else {
            
            let showcase = self.showcasesData[(indexPath as NSIndexPath).row]
            self.performSegue(withIdentifier: SegueTrendingShowShowcaseDetail, sender: showcase)
        }
    }
    
    // MARK: - Segue跳转
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == SegueTrendingShowDeveloperDetail){
            let devVC = segue.destination as! CPDeveloperViewController
            devVC.hidesBottomBarWhenPushed = true
            
            let dev = sender as? ObjUser
            if(dev != nil){
                devVC.developer = dev
            }
            
        }else if(segue.identifier == SegueTrendingShowShowcaseDetail){
            
            let showcaseVC = segue.destination as! CPTrendingShowcaseViewController
            showcaseVC.hidesBottomBarWhenPushed = true

            let showcase = sender as? ObjShowcase
            if(showcase != nil){
                showcaseVC.showcase = showcase
            }
            
        }else if(segue.identifier == SegueTrendingSearchView){
            
            var pageType:TrendingViewPageType = .repos
            var placeholder = "Search repositories".localized
            
            if segControl.selectedSegmentIndex == 1 {
                pageType = .user
                placeholder = "Search users".localized
            }
            
            let searchVC = segue.destination as! CPSearchViewController
            
            searchVC.hidesBottomBarWhenPushed = true
            searchVC.pageType = pageType
            searchVC.searchPlacehoder = placeholder
        }
        
    }
    
}


