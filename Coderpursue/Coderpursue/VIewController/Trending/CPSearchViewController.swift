//
//  CPSearchViewController.swift
//  Coderpursue
//
//  Created by WengHengcong on 4/6/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

class CPSearchViewController: CPBaseViewController {

    lazy var searchBar = UISearchBar(frame: CGRectMake(0, 0, ScreenSize.ScreenWidth-70, 20))

    var languageArr:[String]?
    var sortArr:[String]?
    var searchFilterView:CPSearchFilterView?

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
        
        sortArr = ["Most stars","Fewest stars","Most forks","Fewest forks","Recently updated","Leaest recently updated"]
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

}


extension CPSearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
    }
    
}