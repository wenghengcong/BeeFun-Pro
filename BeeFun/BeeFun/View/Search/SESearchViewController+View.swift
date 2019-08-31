//
//  SESearchViewController+View.swift
//  BeeFun
//
//  Created by WengHengcong on 07/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit

extension SESearchViewController {

    // MARK: - View
    func svc_setupNavBar() {
        searchBar.placeholder = "Search".localized
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
        if #available(iOS 11.0, *) {
            searchBar.keepBeforeStyle = true
        }
        rightItemImage = UIImage(named: "nav_cancel")
        rightItem?.isHidden = false
    }
    
    func svc_setupHistoryTable() {
        historyTable.frame = CGRect(x: 0, y: 0, w: ScreenSize.width, h: ScreenSize.height)
        historyTable.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        historyTable.delegate = self
        historyTable.dataSource = self
        historyTable.separatorStyle = .singleLine
        if #available(iOS 11, *) {
            historyTable.estimatedRowHeight = 0
            historyTable.estimatedSectionHeaderHeight = 0
            historyTable.estimatedSectionFooterHeight = 0
        }
        view.addSubview(historyTable)
    }
    
}
