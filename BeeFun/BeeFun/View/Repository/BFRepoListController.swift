//
//  BFRepoListController.swift
//  BeeFun
//
//  Created by wenghengcong on 16/1/30.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit
import Moya
import Foundation
import MJRefresh

class BFRepoListController: BFBaseViewController {

    //incoming var
    var dic: [String: String]?
    var username: String?       //用户login，必须有
    var viewType: String?       //有myrepositories，就是用户创建维护仓库，另外，forked表示，fork的仓库

    var reposData: [ObjRepos] = []
    var reposPageVal = 1
    var reposPerpage = 15

    var typeVal: String = "all"
    var sortVal: String = "created"
    var directionVal: String = "desc"

    override func viewDidLoad() {
        self.title = "Repositories".localized
        super.viewDidLoad()
        rvc_addNaviBarButtonItem()
        rvc_setupTableView()
        rvc_selectDataSource()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func leftItemAction(_ sender: UIButton?) {
       _ = self.navigationController?.popViewController(animated: true)
    }

    func rvc_addNaviBarButtonItem() {

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

    func rvc_rightButtonTouch() {

    }

    func rvc_setupTableView() {

        self.view.addSubview(tableView)
        self.tableView.frame = CGRect(x: 0, y: uiTopBarHeight, width: ScreenSize.width, height: ScreenSize.height-uiTopBarHeight)

        self.automaticallyAdjustsScrollViewInsets = false
    }

    // 顶部刷新
    override func headerRefresh() {
        super.headerRefresh()
        reposPageVal = 1
        rvc_selectDataSource()
    }

    // 底部刷新
    override func footerRefresh() {
        super.footerRefresh()

        reposPageVal += 1
        rvc_selectDataSource()
    }

    func rvc_updateViewContent() {
        self.tableView.reloadData()
    }

    // MARK: - request for repos

    override func reconnect() {
        super.reconnect()
        rvc_selectDataSource()
    }
    
    func rvc_selectDataSource() {
        if self.viewType == "myrepositories" {
            rvc_getMyReposRequest()
        } else if self.viewType == "forked" {
            rvc_getForkedReposRequst()
        } else {
            rvc_getMyReposRequest()
        }
    }

    func rvc_getMyReposRequest() {
        if username == nil {
            return
        }
        let hud = JSMBHUDBridge.showHud(view: self.view)
        Provider.sharedProvider.request(.userRepos(username: username! ,page:self.reposPageVal, perpage:self.reposPerpage, type:self.typeVal, sort:self.sortVal, direction:self.directionVal ) ) { (result) -> Void in
            hud.hide(animated: true)
            switch result {
            case let .success(response):
                do {
                    let repos: [ObjRepos] = try response.mapArray(ObjRepos.self)
                    if self.reposPageVal == 1 {
                        self.reposData.removeAll()
                        self.reposData = repos
                    } else {
                        self.reposData += repos
                    }
                    self.rvc_updateViewContent()
                } catch {

                }
            case .failure:
                break

            }

        }

    }

    func rvc_getForkedReposRequst() {

    }
}

extension BFRepoListController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return  self.reposData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let row = indexPath.row
        var cellId = ""
        if self.viewType == "myrepositories" {
            cellId = "BFRepositoryTypeSecCellIdentifier"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? BFRepositoryTypeSecCell
            if cell == nil {
                cell = (BFRepositoryTypeSecCell.cellFromNibNamed("BFRepositoryTypeSecCell") as? BFRepositoryTypeSecCell)
            }
            cell?.setBothEndsLines(row, all:reposData.count)

            let repos = self.reposData[row]
            cell!.objRepos = repos

            return cell!
        }

        cellId = "BFRepositoryTypeThirdCellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? BFRepositoryTypeThirdCell
        if cell == nil {
            cell = (BFRepositoryTypeThirdCell.cellFromNibNamed("BFRepositoryTypeThirdCell") as? BFRepositoryTypeThirdCell)
        }
        cell?.setBothEndsLines(row, all: reposData.count)
        let repos = self.reposData[row]
        cell!.objRepos = repos

        return cell!

    }

}
extension BFRepoListController {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 85
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        let repos = self.reposData[indexPath.row]

        JumpManager.shared.jumpReposDetailView(repos: repos, from: .other)
    }
}
