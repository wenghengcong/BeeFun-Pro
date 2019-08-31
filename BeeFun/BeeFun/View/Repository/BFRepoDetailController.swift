//
//  BFRepoDetailController.swift
//  BeeFun
//
//  Created by WengHengcong on 3/9/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit
import Moya
import Foundation
import MJRefresh
import ObjectMapper
import Kingfisher
import Result

public enum CPReposActionType: String {
    case watch
    case star
    case fork
}

enum ReposDetailFrom {
    case search
    case star
    case other
}

class BFRepoDetailController: BFBaseViewController {
    
    var reposPoseterV: CPReposPosterView = CPReposPosterView(frame: CGRect.zero)
    var reposInfoV: CPReposInfoView = CPReposInfoView(frame: CGRect.zero)

    var repoModel: ObjRepos?
    var cellModels: [JSCellModel] = []
    
    var user: ObjUser?
    var actionType: CPReposActionType = .watch

    var from: ReposDetailFrom = .other
    
    // MARK: - view cycle
    override func viewDidLoad() {
        title = repoModel!.name!
        super.viewDidLoad()
        rvc_customView()
        rdc_registerNotification()
        rvc_loadAllRequset()
    }
    
    func rdc_registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(rdc_updateTag(noti:)), name: NSNotification.Name.BeeFun.RepoUpdateTag, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rvc_loadAllRequset()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // MARK: - view
    func rvc_customView() {
        reposPoseterV.isHidden = true
        reposInfoV.isHidden = true
        tableView.isHidden = true

        view.addSubview(reposPoseterV)
        view.addSubview(reposInfoV)
        view.addSubview(tableView)

        rightItemImage = UIImage(named: "nav_share")
        rightItemSelImage = UIImage(named: "nav_share")
        rightItem?.isHidden = !ShareManager.shared.enable
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        //Layout
        //designBy4_7Inch(80+30)->
        let dynPostH = designBy4_7Inch(110) + 39
        reposPoseterV.frame = CGRect(x: 0, y: uiTopBarHeight, width: ScreenSize.width, height: dynPostH)

        let infoViewT = reposPoseterV.bottom+10
        let dynInfoH = designBy4_7Inch(90)

        reposInfoV.frame = CGRect(x: 0, y: infoViewT, width: ScreenSize.width, height: dynInfoH)

        let tabViewT = reposInfoV.bottom+10
        let tabViewH = ScreenSize.height-tabViewT
        tableView.frame = CGRect(x: 0, y: tabViewT, width: ScreenSize.width, height: tabViewH)
        
        user = UserManager.shared.user
        reposPoseterV.reposActionDelegate = self
        
        refreshHidden = .all
        automaticallyAdjustsScrollViewInsets = false
    }

    // MARK: - action

    override func headerRefresh() {
        super.headerRefresh()

    }

    override func footerRefresh() {
        super.footerRefresh()

    }
    
    // 在页面update后需要更新
    @objc func rdc_updateTag(noti: NSNotification) {
        if noti.userInfo != nil {
            if let updatedTags: [String] = noti.userInfo!["star_tags"] as? [String] {
                repoModel?.star_tags = updatedTags
            }
        }
        rdc_updateViewContent()
    }

    func rdc_updateViewContent() {

        if let objRepo = repoModel {
            view.backgroundColor = UIColor.bfViewBackgroundColor
            reposPoseterV.isHidden = false
            reposInfoV.isHidden = false
            tableView.isHidden = false

            reposPoseterV.repo = objRepo
            reposInfoV.repo = objRepo
            if objRepo.html_url != nil {
                rvc_loadReposCellModels()
                tableView.reloadData()
            }
        }
    }
    
    override func reconnect() {
        super.reconnect()
        rvc_loadAllRequset()
    }
    
    func rvc_loadAllRequset() {
        rvc_getReopsRequest()
        rvc_checkWatchedRequset()
        rvc_checkStarredRqeuset()
    }

    /// 导航栏左边按钮
    override func leftItemAction(_ sender: UIButton?) {
        _ = navigationController?.popViewController(animated: true)
    }

    override func rightItemAction(_ sender: UIButton?) {

        let shareContent: ShareContent = ShareContent()
        shareContent.title = repoModel?.name
        shareContent.contentType = SSDKContentType.webPage
        shareContent.source = .repository

        shareContent.url = repoModel?.html_url ?? ""
        if let repoDescription = repoModel?.cdescription {
            shareContent.content = "It's A Wonderful Repository from github! Hurry UP!".localized+": \((repoModel?.name)!)\n \(repoDescription) "+"\(shareContent.url!)\n" + "from BeeFun App".localized+"  "+"Download Here".localized + SocialAppStore
        } else {
            shareContent.content = "It's A Wonderful Repository from github! Hurry UP!".localized+": \((repoModel?.name)!)\n" + "\(shareContent.url!)\n" + "from BeeFun App".localized+"  "+"Download Here".localized + SocialAppStore
        }

        if let urlStr = repoModel?.owner?.avatar_url {
            shareContent.image = urlStr as AnyObject?
            ShareManager.shared.share(content: shareContent)
        } else {
            shareContent.image = UIImage(named: "app_logo_90")
            ShareManager.shared.share(content: shareContent)
        }
    }
}

extension BFRepoDetailController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cellModel = cellModels[row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "BFUserTypeThirdCellIdentifier") as? JSImageCell
        if cell == nil {
            cell = JSCellFactory.cell(type: cellModel.type!) as? JSImageCell
        }
        cell?.model = cellModel
        cell?.bothEndsLine(row, all: cellModels.count)
        return cell!
    }

}
extension BFRepoDetailController {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 44
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        let cellM = cellModels[row]
        if let cellDidSeleted = cellM.didSelectClosure {
            cellDidSeleted(tableView, indexPath, cellM)
        }
    }
}

extension BFRepoDetailController:ReposActionProtocol {

    func watchReposAction() {
        actionType = .watch
        showAlertView()
    }

    func starReposAction() {
        actionType = .star
        showAlertView()
    }

    func forkReposAction() {
        actionType = .fork
        showAlertView()
    }

    func showAlertView() {
        var title = ""
//        var clickSure: ((UIAlertAction) -> Void) = {
//            (UIAlertAction)->Void in
//        }
        switch actionType {
        case .watch:
            if repoModel!.watched! {
                title = "Unwatch?".localized
            } else {
                title = "Watch?".localized
            }
        case .star:
            if repoModel!.starred! {
                //移除
                title = "Unstar?".localized
            } else {
                title = "Star?".localized
//                message = kStaringTip
            }

        case .fork:
            title = "Fork?".localized
        }

        let alertController = UIAlertController(title: title, message:nil, preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel) { (_) in
            // ...
        }
        alertController.addAction(cancelAction)

        let repoName = repoModel?.name ?? "Unknown Repos"
        let user = UserManager.shared.login ?? "Unknown User"

        let OKAction = UIAlertAction(title: "Sure".localized, style: .default) { (_) in

            switch self.actionType {
            case .watch:
                if self.repoModel!.watched! {
                    self.rvc_unwatchRequest()
                    AnswerManager.logContentView(name: "UnWatch", type: UserActionType.unwatch.rawValue, id: repoName, attributes: ["user": user, "repos": repoName])
                } else {
                    self.rvc_watchRequest()
                    AnswerManager.logContentView(name: "Watch", type: UserActionType.watch.rawValue, id: repoName, attributes: ["user": user, "repos": repoName])
                }

            case .star:
                if self.repoModel!.starred! {
                    self.rvc_unstarRequest()
                    AnswerManager.logContentView(name: "UnStar", type: UserActionType.unstar.rawValue, id: repoName, attributes: ["user": user, "repos": repoName])
                } else {
                    self.rvc_starRequest()
                    AnswerManager.logContentView(name: "Star", type: UserActionType.star.rawValue, id: repoName, attributes: ["user": user, "repos": repoName])

                }

            case .fork:
                self.rvc_forkRequest()
                AnswerManager.logContentView(name: "Fork", type: UserActionType.fork.rawValue, id: repoName, attributes: ["user": user, "repos": repoName])
            }

//            rvc_updateViewContent()
        }
        alertController.addAction(OKAction)

        present(alertController, animated: true) {
            // ...
        }
    }
}
