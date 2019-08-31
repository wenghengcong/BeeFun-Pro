//
//  CPUserListController.swift
//  BeeFun
//
//  Created by wenghengcong on 16/1/30.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit
import Moya
import Foundation
import MJRefresh
import ObjectMapper

/// 用户列表页
class BFUserListController: BFBaseViewController {

    //incoming var
    var dic: [String: String]?
    var username: String?
    var viewType: String?

    // MARK: request parameters
    var userData: [ObjUser] = []
    var userPageVal = 1
    var userPerpageVal = 15

    var typeVal: String = "owner"
    var sortVal: String = "created"
    var directionVal: String = "desc"

    override func viewDidLoad() {
        if viewType == "follower" {
            self.title = "Followers".localized
        } else if viewType == "following" {
            self.title = "Following".localized
        }
        super.viewDidLoad()
        fvc_addNaviBarButtonItem()
        fvc_setupTableView()
        fvc_selectDataSource()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func leftItemAction(_ sender: UIButton?) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    func fvc_addNaviBarButtonItem() {

        /*
        let btnName = UIButton()
        btnName.setImage(UIImage(named: "bubble_consulting_chat-512"), forState: .Normal)
        btnName.frame = CGRectMake(0, 0, 30, 30)
        btnName.addTarget(self, action: Selector("tvc_rightButtonTouch"), forControlEvents: .TouchUpInside)
        
        //.... Set Right/Left Bar Button item
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = btnName
        self.navigationItem.rightBarButtonItem = rightBarButton
        */

    }

    func fvc_rightButtonTouch() {

    }

    func fvc_setupTableView() {

        self.view.addSubview(tableView)
        self.tableView.frame = CGRect(x: 0, y: uiTopBarHeight, width: ScreenSize.width, height: ScreenSize.height-uiTopBarHeight)

        self.automaticallyAdjustsScrollViewInsets = false
    }

    // 顶部刷新
    override func headerRefresh() {
        super.headerRefresh()
        userPageVal = 1
        fvc_selectDataSource()
    }

    // 底部刷新
    override func footerRefresh() {
        super.footerRefresh()

        userPageVal += 1
        fvc_selectDataSource()
    }

    func fvc_updateViewContent() {
        removeReloadView()
        tableView.isHidden = false
        tableView.reloadData()
    }
    // MARK: - fetch data form request
    
    /// 获取对应数据源数据
    func fvc_selectDataSource() {
        if self.viewType == "follower" {
            tvc_getUserFollowerRequest()
        } else if self.viewType == "following" {
            tvc_getUserFollowingRequst()
        }
    }
    
    func tvc_getUserFollowerRequest() {
        let hud = JSMBHUDBridge.showHud(view: self.view)
        Provider.sharedProvider.request(.userFollowers(page:self.userPageVal, perpage:self.userPerpageVal, username:self.username!) ) { (result) -> Void in
            hud.hide(animated: true)
            switch result {
            case let .success(response):
                do {
                 let userResult: [ObjUser] = try response.mapArray(ObjUser.self)
                    if self.userPageVal == 1 {
                        self.userData.removeAll()
                        self.userData = userResult
                    } else {
                        self.userData += userResult
                    }
                    self.fvc_updateViewContent()
                    return
                } catch {
                }
                self.showReloadView()
            case .failure:
                self.showReloadView()
            }
        }

    }

    func tvc_getUserFollowingRequst() {
        let hud = JSMBHUDBridge.showHud(view: self.view)
        Provider.sharedProvider.request(.userFollowing(page:self.userPageVal, perpage:self.userPerpageVal, username:self.username!) ) { (result) -> Void in
            hud.hide(animated: true)
            switch result {
            case let .success(response):
                do {
                    let userResult: [ObjUser] = try response.mapArray(ObjUser.self)
                    if self.userPageVal == 1 {
                        self.userData.removeAll()
                        self.userData = userResult
                    } else {
                        self.userData += userResult
                    }
                    self.fvc_updateViewContent()
                    return
                } catch {
                }
                self.showReloadView()
                self.tableView.isHidden = true

            case .failure:
                self.showReloadView()
                self.tableView.isHidden = true
            }
        }
    }
    
    override func reconnect() {
        super.reconnect()
        fvc_selectDataSource()
    }

}

extension BFUserListController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.userData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let row = indexPath.row

        let cellId = "BFUserTypeSecCellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? BFUserTypeSecCell
        if cell == nil {
            cell = (BFUserTypeSecCell.cellFromNibNamed("BFUserTypeSecCell") as? BFUserTypeSecCell)

        }
        cell?.setBothEndsLines(row, all: userData.count)

        let user = self.userData[row]
        cell!.user = user
        cell!.userNo = row

        return cell!

    }

}

extension BFUserListController {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 71
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = self.userData[indexPath.row]
        JumpManager.shared.jumpUserDetailView(user: user)
    }
}
