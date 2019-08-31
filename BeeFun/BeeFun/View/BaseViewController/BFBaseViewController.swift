//
//  BFBaseViewController.swift
//  BeeFun
//
//  Created by wenghengcong on 15/12/30.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

import UIKit
import MJRefresh

protocol BFViewControllerNetworkProtocol: class {
    func networkSuccssful()
    func networkFailure()
}

class BFBaseViewController: UIViewController, UIGestureRecognizerDelegate {

    typealias PlaceHolderAction = ((Bool) -> Void)

    // MARK: - 视图
    var topOffset: CGFloat = uiTopBarHeight
    
    /// 是否需要登录态
    var needLogin = true

    // MARK: - 各种占位图：网络 > 未登录 > 无数据
    //Reload View
    var needShowReloadView = true
    var placeReloadView: BFPlaceHolderView?
    var reloadTip = "Wake up your connection!".localized {
        didSet {
            
        }
    }
    var reloadImage = "network_error_1" {
        didSet {
            
        }
    }
    var reloadActionTitle = "Try Again".localized {
        didSet {
            
        }
    }
    
    var reloadViewClosure: PlaceHolderAction?
    
    //Empty View
    var needShowEmptyView = true
    var placeEmptyView: BFPlaceHolderView?
    var emptyTip = "Empty now".localized {
        didSet {
            
        }
    }
    var emptyImage = "empty_data" {
        didSet {
            
        }
    }
    var emptyActionTitle = "Go".localized {
        didSet {
            
        }
    }
    var emptyViewClosure: PlaceHolderAction?

    //Login View
    var needShowLoginView = true
    var placeLoginView: BFPlaceHolderView?
    var loginTip = "Please login first".localized {
        didSet {
            
        }
    }
    var loginImage = "github_signin_logo" {
        didSet {
            
        }
    }
    var loginActionTitle = "Sign in".localized {
        didSet {
            
        }
    }
    var loginViewClosure: PlaceHolderAction?
    
     // MARK: - 刷新控件
    var refreshHidden: RefreshHidderType = .all {
        didSet {
            setRefreshHiddenOrShow()
        }
    }
    var refreshManager = MJRefreshManager()

    var header: MJRefreshNormalHeader!
    var footer: MJRefreshAutoNormalFooter!

    lazy var tableView: UITableView = {
        return self.getBaseTableView()
    }()

    // MARK: - 导航栏左右按钮
    var leftItem: UIButton? {
        didSet {
            if let left = leftItem {
                setLeftBarItem(left)
            }

        }
    }

    var rightItem: UIButton? {
        didSet {
            if let right = rightItem {
                setRightBarItem(right)
            }
        }
    }

    var leftItemImage: UIImage? {
        didSet {
            leftItem!.setImage(leftItemImage, for: .normal)
            layoutLeftItem()
        }
    }

    var leftItemSelImage: UIImage? {
        didSet {
            leftItem!.setImage(leftItemSelImage, for: .selected)
            layoutLeftItem()
        }
    }

    var rightItemImage: UIImage? {
        didSet {
            rightItem!.setImage(rightItemImage, for: .normal)
            layoutRightItem()
        }
    }

    var rightItemSelImage: UIImage? {
        didSet {
            rightItem!.setImage(rightItemSelImage, for: .selected)
            layoutRightItem()
        }
    }

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        customView()
        gatherUserActivityInViewDidload()
        registerNoti()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gatherUserActivityInViewWillAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gatherUserActivityInViewWillDisAppear()
    }

}
