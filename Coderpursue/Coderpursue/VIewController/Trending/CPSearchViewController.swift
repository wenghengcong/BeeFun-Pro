//
//  CPSearchViewController.swift
//  Coderpursue
//
//  Created by WengHengcong on 4/6/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

class CPSearchViewController: CPBaseViewController {

    var pageType:TrendingViewPageType = .Repos
    
    lazy var searchBar = UISearchBar(frame: CGRectMake(0, 0, ScreenSize.ScreenWidth-70, 20))
    var tableView = UITableView()
    
    var languageArr:[String]?
    var sortArr:[String]?
    var searchFilterView:CPSearchFilterView?
    
    var paraUser:ParaSearchUser = ParaSearchUser.init()
    var paraRepos:ParaSearchRepos = ParaSearchRepos.init()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        svc_initNavBar()
        svc_initSearchFilterView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func svc_initNavBar() {
        
        searchBar.placeholder = "Search Repository or User"
        searchBar.delegate = self        
        let rightNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.rightBarButtonItem = rightNavBarButton
        
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    func svc_initSearchFilterView() {
        
        if let path = NSBundle.mainBundle().pathForResource("CPLanguage", ofType: "plist") {
            languageArr = NSArray(contentsOfFile: path)! as? [String]
        }
        
        if  pageType == .Repos {
            sortArr = ["Most stars","Fewest stars","Most forks","Fewest forks","Recently updated","Leaest recently updated"]
        }else{
            sortArr = ["Most followers","Fewest followers","Most recently joined","Leaest recently joined","Most repositories ","Fewest repositories"]
        }
        searchFilterView = CPSearchFilterView()
        searchFilterView?.frame = CGRectMake(0, topOffset, self.view.width, 290)
        searchFilterView?.filterPara = ["Language","Sort"]
        searchFilterView?.filterData = [languageArr!,sortArr!]
        searchFilterView?.sfv_customView()
        self.view.addSubview(searchFilterView!)
        
    }
    
    override func leftItemAction(sender: UIButton?) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /*
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

    func searchUser() {
        
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
    
    
    func searchRepos() {

    }

     */
}


extension CPSearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
    }
}

/*
extension CPSearchViewController:CPSearchFilterViewProtcocol {
    
    func didBeginSearch(para: [String : Int]) {
        
    }
    
}

extension CPSearchViewController: UITableViewDataSource {
    
    
}

extension CPSearchViewController: UITabBarDelegate {

}
 */





