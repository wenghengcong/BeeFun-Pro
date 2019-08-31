//
//  MJRefreshManager.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/4/13.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit
import MJRefresh

protocol MJRefreshManagerAction: class {
    func headerRefresh()
    func footerRefresh()
}

class MJRefreshManager: NSObject {

    weak var delegate: MJRefreshManagerAction?

    override init() {
        super.init()
    }

    /// 头部刷新控件
    ///
    /// - Returns: <#return value description#>
    func header() -> MJRefreshNormalHeader {
        let header = MJRefreshNormalHeader()
        header.lastUpdatedTimeLabel.isHidden = true
        header.stateLabel.isHidden = true
//        header.setTitle(kHeaderIdelTIP.localized, for: .idle)
//        header.setTitle(kHeaderPullTip, for: .pulling)
//        header.setTitle(kHeaderPullingTip, for: .refreshing)
        header.setRefreshingTarget(self, refreshingAction:#selector(mj_headerRefresh))
        return header
    }

    /// 头部刷新控件
    ///
    /// - Parameters:
    ///   - target: <#target description#>
    ///   - action: 刷新回调方法
    /// - Returns: <#return value description#>
    func header(_ target: Any!, refreshingAction action: Selector!) -> MJRefreshNormalHeader {
        let header = MJRefreshNormalHeader()
        header.lastUpdatedTimeLabel.isHidden = true
        header.stateLabel.isHidden = true
//        header.setTitle(kHeaderIdelTIP, for: .idle)
//        header.setTitle(kHeaderPullTip, for: .pulling)
//        header.setTitle(kHeaderPullingTip, for: .refreshing)
        header.setRefreshingTarget(target, refreshingAction:action)
        return header
    }

    /// 内部代理方法
   @objc func mj_headerRefresh() {
        if self.delegate != nil {
            self.delegate?.headerRefresh()
        }
    }

    /// 底部加载控件
    ///
    /// - Returns: <#return value description#>
    func footer() -> MJRefreshAutoNormalFooter {
        let footer = MJRefreshAutoNormalFooter()
//        footer.isAutomaticallyHidden = true
//        footer.setTitle(kFooterIdleTip, for: .idle)
//        footer.setTitle(kFooterLoadTip, for: .refreshing)
//        footer.setTitle(kFooterLoadNoDataTip, for: .noMoreData)
        footer.setRefreshingTarget(self, refreshingAction:#selector(mj_footerRefresh))
        footer.stateLabel.isHidden = true
        footer.isRefreshingTitleHidden = true
        return footer
    }

    /// 底部加载控件
    ///
    /// - Parameters:
    ///   - target: <#target description#>
    ///   - action: 加载回调方法
    /// - Returns: <#return value description#>
    func footer(_ target: Any!, refreshingAction action: Selector!) -> MJRefreshAutoNormalFooter {
        let footer = MJRefreshAutoNormalFooter()
//        footer.setTitle(kFooterIdleTip, for: .idle)
//        footer.setTitle(kFooterLoadTip, for: .refreshing)
//        footer.setTitle(kFooterLoadNoDataTip, for: .noMoreData)
        footer.setRefreshingTarget(target, refreshingAction:action)
        footer.stateLabel.isHidden = true
        footer.isRefreshingTitleHidden = true
        return footer
    }

    /// 内部代理方法
   @objc func mj_footerRefresh() {
        if self.delegate != nil {
            self.delegate?.footerRefresh()
        }
    }

}
