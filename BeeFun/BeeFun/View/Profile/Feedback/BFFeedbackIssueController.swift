//
//  BFFeedbackIssueController.swift
//  BeeFun
//
//  Created by WengHengcong on 2018/7/6.
//  Copyright © 2018年 JungleSong. All rights reserved.
//

import UIKit

class BFFeedbackIssueController: BFBaseViewController {
    
    var issuesData: [ObjIssue] = []

    //issue
    var issueFilterPar: String = "all"
    var issueStatePar: String = "all"
    var issueLabelsPar: String = ""
    var issueSortPar: String = "created"
    var issueDirectionPar: String = "desc"
    var issueCurrentPage: Int = 1
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func leftItemAction(_ sender: UIButton?) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fbi_setupTableView()
        fbi_selectDataSource()
    }
    
    func fbi_setupTableView() {
        
        self.view.addSubview(tableView)
        self.tableView.frame = CGRect(x: 0, y: uiTopBarHeight, width: ScreenSize.width, height: ScreenSize.height-uiTopBarHeight)
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    // 顶部刷新
    override func headerRefresh() {
        super.headerRefresh()
        issueCurrentPage = 1
        fbi_selectDataSource()
    }
    
    // 底部刷新
    override func footerRefresh() {
        super.footerRefresh()
        issueCurrentPage += 1
        fbi_selectDataSource()
    }
    
    func fbi_selectDataSource() {
        var perPage: Int = 15
        if DeviceType.isPad {
            perPage = 25
        }
        
        let dic: [String : Any] = [
                "page": issueCurrentPage,
                "per_page": perPage,
                "filter": issueFilterPar,
                "state": issueStatePar,
                "labels": issueLabelsPar,
                "sort": issueSortPar,
                "direction": issueDirectionPar
            ]
        let hud = JSMBHUDBridge.showHud(view: self.view)
        let owner = BFFeedbackManager.shared.adminLogin
        let repo = BFFeedbackManager.shared.feedbackRepo
        IssueProvider.sharedProvider.request(.repoIssues(owner: owner, repo: repo, para: dic)) { (result) -> Void in
            hud.hide(animated: true)
            switch result {
            case let .success(response):
                do {
                    let issues: [ObjIssue] = try response.mapArray(ObjIssue.self)
                    if self.issueCurrentPage == 1 {
                        self.issuesData.removeAll()
                        self.issuesData = issues
                    } else {
                        self.issuesData += issues
                    }
                    
                    self.tableView.reloadData()
                    return
                } catch {
                }
            case .failure:
                break
            }
        }
    }
    
    // MARK: - UITableViewDatasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.issuesData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        var cellId = "CPMesIssueCellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? CPMesIssueCell
        if cell == nil {
            cell = (CPMesIssueCell.cellFromNibNamed("CPMesIssueCell") as? CPMesIssueCell)
        }
        cell?.setBothEndsLines(row, all: issuesData.count)
        let issue = self.issuesData[row]
        cell!.issue = issue
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        if issuesData.isBeyond(index: row) {
            return
        }
        let issue: ObjIssue =  issuesData[row]
        JumpManager.shared.jumpIssueDetailView(issue: issue)
    }
}
