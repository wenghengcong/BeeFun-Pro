//
//  BFBaseViewController+Refresh.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/4/17.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit
import MJRefresh

enum RefreshHidderType {
    case none
    case all
    case header
    case footer
}

extension BFBaseViewController : MJRefreshManagerAction {

    @objc func headerRefresh() {
        tableView.mj_header.endRefreshing()
        //        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
        //        }
    }

    @objc func footerRefresh() {
        tableView.mj_footer.endRefreshing()
        //        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
        //        }
    }

    func endHeaderRefreshing() {
        tableView.mj_header.endRefreshing()
    }

    func endFooterRefreshing() {
        tableView.mj_footer.endRefreshing()
    }

    func endRefreshing() {
        endHeaderRefreshing()
        endFooterRefreshing()
    }

    func setRefreshHiddenOrShow() {
        switch refreshHidden {
        case .none:
            self.tableView.mj_footer.isHidden = false
            self.tableView.mj_header.isHidden = false
        case .all:
            self.tableView.mj_footer.isHidden = true
            self.tableView.mj_header.isHidden = true
        case .header:
            self.tableView.mj_footer.isHidden = true
            self.tableView.mj_header.isHidden = false

        case .footer:
            self.tableView.mj_footer.isHidden = false
            self.tableView.mj_header.isHidden = true
        }
    }
}
