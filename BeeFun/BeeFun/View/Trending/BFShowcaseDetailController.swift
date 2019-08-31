//
//  BFShowcaseDetailController.swift
//  BeeFun
//
//  Created by WengHengcong on 3/10/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit
import Moya
import Foundation
import MJRefresh
import ObjectMapper

class BFShowcaseDetailController: BFBaseViewController {

    var showcaseInfoV: BFShowcaseHeaderView = BFShowcaseHeaderView.loadViewFromNib()

    var showcase: ObjShowcase!

    override func viewDidLoad() {
        self.title = showcase.name
        super.viewDidLoad()
        tsc_setupTableView()
        tsc_updateContentView()
        tsc_getShowcaseRequest()

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

    func tsc_setupTableView() {

        refreshHidden = .all
        
        self.view.addSubview(showcaseInfoV)
        showcaseInfoV.frame = CGRect(x: 0, y: topOffset, w: ScreenSize.width, h: 121)

        self.view.addSubview(tableView)
        let tabY = showcaseInfoV.bottom + 15.0
        let tabH = ScreenSize.height - tabY
        tableView.frame = CGRect(x: 0, y: tabY, w: ScreenSize.width, h: tabH)

        self.automaticallyAdjustsScrollViewInsets = false
    }

    func tsc_updateContentView() {
        showcaseInfoV.showcase = showcase
        self.tableView.reloadData()
    }

    // MARK: - Request
    ///
    func tsc_getShowcaseRequest() {
        if showcase.name == nil {
            return
        }
        let hud = JSMBHUDBridge.showHud(view: self.view)
        TrendingManager.shared.requestForTrendingShowcaseDetail(showcase: showcase.name!) { (repos) in
            DispatchQueue.main.async {
                hud.hide(animated: true)
            }
            if repos.isEmpty {
                return
            }
            self.showcase.repositories?.removeAll()
            self.showcase.repositories = repos
            self.tableView.reloadData()
            //self.tableView.setContentOffset(CGPoint.zero, animated:true)
        }
    }
    
    override func reconnect() {
        super.reconnect()
        tsc_getShowcaseRequest()
    }
}

extension BFShowcaseDetailController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if showcase.repositories == nil {
            return 0
        }

        let reposCount = showcase.repositories!.count
        return reposCount

    }

   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let row = indexPath.row

        let cellId = "BFRepositoryTypeThirdCellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? BFRepositoryTypeThirdCell
        if cell == nil {
            cell = (BFRepositoryTypeThirdCell.cellFromNibNamed("BFRepositoryTypeThirdCell") as? BFRepositoryTypeThirdCell)
        }
        cell?.setBothEndsLines(row, all:self.showcase.repositories!.count)

        let repos = self.showcase.repositories![row]
        cell!.objRepos = repos

        return cell!

    }

}

extension BFShowcaseDetailController {

    // 顶部刷新
    override func headerRefresh() {
        super.headerRefresh()

    }
    override func footerRefresh() {
        super.footerRefresh()

    }

}

extension BFShowcaseDetailController {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 85
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        let repos = self.showcase.repositories![indexPath.row]
        JumpManager.shared.jumpReposDetailView(repos: repos, from: .other)
    }

}
