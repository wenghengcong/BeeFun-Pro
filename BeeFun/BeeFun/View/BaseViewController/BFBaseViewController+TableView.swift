//
//  BFBaseViewController+TableView.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/4/17.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

extension BFBaseViewController: UITableViewDataSource {

    func getBaseTableView() -> UITableView {

        let table = UITableView()
        table.frame = CGRect.zero
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = UIColor.bfViewBackgroundColor
        header = refreshManager.header()
        footer = refreshManager.footer()
        table.mj_header = header
        table.mj_footer = footer
        refreshManager.delegate = self
        if #available(iOS 11, *) {
            table.estimatedRowHeight = 0
            table.estimatedSectionHeaderHeight = 0
            table.estimatedSectionFooterHeight = 0
        }
        return table
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}

extension BFBaseViewController: UITableViewDelegate {

}
