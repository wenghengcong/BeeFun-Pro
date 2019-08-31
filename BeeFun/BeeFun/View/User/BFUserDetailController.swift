//
//  BFUserDetailController.swift
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
import Kingfisher

public enum CPUserActionType: String {
    case Follow = "watch"
    case Repos = "star"
    case Following = "fork"
}

class BFUserDetailController: BFBaseViewController {

    var developerInfoV: CPDeveloperInfoView = CPDeveloperInfoView(frame: CGRect.zero)
    var followBtn: UIButton = UIButton()
    var developer: ObjUser?
    var cellModels: [JSCellModel] = []
    var actionType: CPUserActionType = .Follow
    var followed: Bool = false

    // MARK: - view cycle
    override func viewDidLoad() {
        if let username = developer!.name {
            self.title = username
        } else {
            self.title = developer!.login!
        }
        super.viewDidLoad()
        dvc_customView()
        dvc_setupTableView()
        dvc_getUserinfoRequest()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dvc_checkUserFollowed()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // MARK: - view

    func dvc_customView() {

        self.tableView.isHidden = true
        self.developerInfoV.isHidden = true
        self.followBtn.isHidden = true

        self.rightItemImage = UIImage(named: "nav_share")
        self.rightItemSelImage = UIImage(named: "nav_share")
        self.rightItem?.isHidden = !ShareManager.shared.enable

        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.view.backgroundColor = UIColor.bfViewBackgroundColor

        self.view.addSubview(developerInfoV)
        self.view.addSubview(tableView)
        self.view.addSubview(followBtn)
        developerInfoV.frame = CGRect(x: 0, y: uiTopBarHeight, width: ScreenSize.width, height: 183.0)

        let tabY = developerInfoV.bottom+15.0
        let tabH = ScreenSize.height-tabY
        tableView.frame = CGRect(x: 0, y: tabY, width: ScreenSize.width, height: tabH)

        developerInfoV.userActionDelegate = self

        followBtn.titleLabel?.font = UIFont.bfSystemFont(ofSize: 15.0)
        followBtn.backgroundColor = UIColor.bfRedColor
        followBtn.radius = 3.0
        followBtn.addTarget(self, action: #selector(BFUserDetailController.dvc_followAction), for: UIControlEvents.touchUpInside)

        let followX: CGFloat = 10.0
        let followW = ScreenSize.width-2*followX
        let followH: CGFloat = 40.0
        let followY = ScreenSize.height-followH-57.0
        followBtn.frame = CGRect(x: followX, y: followY, width: followW, height: followH)

        self.dvc_updateFolloweBtn()
    }

    func dvc_setupTableView() {
        refreshHidden = .all
        self.automaticallyAdjustsScrollViewInsets = false
    }

    // MARK: - action

    override func headerRefresh() {
        super.headerRefresh()
    }

    override func footerRefresh() {
        super.footerRefresh()
    }

    func dvc_updateFolloweBtn() {
        if followed {
            followBtn.setTitle("Unfollow".localized, for: UIControlState())
        } else {
            followBtn.setTitle("Follow".localized, for: UIControlState())
        }
    }

    func dvc_updateViewContent() {
        removeReloadView()
        tableView.isHidden = false
        developerInfoV.isHidden = false
        followBtn.isHidden = false
        if developer==nil {
            return
        }
        
        cellModels.removeAll()
        
        if developer!.html_url != nil {
            let homeModel = JSCellModel(["type": "image", "id": "homepage", "key": "Homepage".localized, "icon": "user_home", "discolsure": "true"])
            cellModels.append(homeModel)
        }
        
        if let joinTime: String = developer!.created_at {
            let ind = joinTime.characters.index(joinTime.startIndex, offsetBy: 10)
            let subStr = joinTime.substring(to: ind)
            let join = "Joined on".localized + " "+subStr
            
            let joinModel = JSCellModel(["type": "image", "id": "join", "key": "Join".localized, "icon": "user_time", "value": join, "discolsure": "false"])
            cellModels.append(joinModel)
        }
        
        if let location: String = developer!.location {
            let locModel = JSCellModel(["type": "image", "id": "location", "key": "Location".localized, "icon": "user_loc", "value": location, "discolsure": "false"])
            cellModels.append(locModel)
        }
        
        if let company = developer!.company {
            let companyModel = JSCellModel(["type": "image", "id": "company", "key": "Company".localized, "icon": "user_org", "value": company, "discolsure": "false"])
            cellModels.append(companyModel)
        }
        developerInfoV.developer = developer
        self.tableView.reloadData()
    }

    override func leftItemAction(_ sender: UIButton?) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    override func rightItemAction(_ sender: UIButton?) {

        let shareContent: ShareContent = ShareContent()
        shareContent.contentType = SSDKContentType.webPage
        shareContent.source = .user

        if let name = developer?.name {
            shareContent.title = name
        } else {
            shareContent.title = developer?.login
        }

        shareContent.url = developer?.html_url ?? ""

        if let bio = developer?.bio {
            shareContent.content = "A Talented Developer".localized + ":\((developer?.login)!)\n" + "\(bio).\n" + "\(shareContent.url!)  "+"from BeeFun App".localized+"  "+"Download Here".localized + SocialAppStore
        } else {
            shareContent.content = "A Talented Developer".localized + ":\((developer?.login)!)\n" + "\(shareContent.url!)  "+"from BeeFun App".localized+"  "+"Download Here".localized + SocialAppStore
        }

        if let urlStr = developer?.avatar_url {
            shareContent.image = urlStr as AnyObject?
            ShareManager.shared.share(content: shareContent)
        } else {
            shareContent.image = UIImage(named: "app_logo_90")
            ShareManager.shared.share(content: shareContent)
        }

    }

    @objc func dvc_followAction() {

        let follower = UserManager.shared.login ?? "Unknown User"
        let befollowed = self.title ?? "Unknown User"

        if followBtn.currentTitle == "Follow".localized {
            self.dvc_followUserRequest()
            AnswerManager.logContentView(name: "Follow", type: UserActionType.follow.rawValue, id: follower, attributes: ["follow": follower, "followed": befollowed])
        } else if followBtn.currentTitle == "Unfollow".localized {
            self.dvc_unfolloweUserRequest()
            AnswerManager.logContentView(name: "UnFollow", type: UserActionType.unfollow.rawValue, id: follower, attributes: ["follow": follower, "followed": befollowed])
        }

    }

    // MARK: - request
    /// 是否关注该用户
    func dvc_checkUserFollowed() {
        if let username = developer!.login {
            Provider.sharedProvider.request(.checkUserFollowing(username:username) ) { (result) -> Void in
                var message = kNoDataFoundTip
                switch result {
                case let .success(response):
                    
                    let statusCode = response.statusCode
                    if statusCode == BFStatusCode.noContent.rawValue {
                        self.followed = true
                    } else {
                        self.followed = false
                    }
                    self.dvc_updateFolloweBtn()
                    
                case .failure:
                    message = kNetworkErrorTip
                    JSMBHUDBridge.showError(message, view: self.view)
                }
            }
        }
    }

    func dvc_getUserinfoRequest() {
        if let username = developer!.login {
            let hud = JSMBHUDBridge.showHud(view: self.view)
            Provider.sharedProvider.request(.userInfo(username: username) ) { (result) -> Void in
                hud.hide(animated: true)
                switch result {
                case let .success(response):
                    do {
                        if let result: ObjUser = Mapper<ObjUser>().map(JSONObject: try response.mapJSON() ) {
                            self.developer = result
                            self.dvc_updateViewContent()
                            return
                        } else {
                            
                        }
                    } catch {
                    }
                    self.showReloadView()
                case .failure:
                    self.showReloadView()
                }
            }
        }
    }
    
    override func reconnect() {
        super.reconnect()
        dvc_getUserinfoRequest()
        dvc_checkUserFollowed()
    }

    func dvc_followUserRequest() {
        if let username = developer!.login {
            let hud = JSMBHUDBridge.showHud(view: self.view)
            Provider.sharedProvider.request(.follow(username:username) ) { (result) -> Void in
                hud.hide(animated: true)
                var message = kNoDataFoundTip
                switch result {
                case let .success(response):
                    let statusCode = response.statusCode
                    if statusCode == BFStatusCode.noContent.rawValue {
                        self.followed = true
                        JSMBHUDBridge.showSuccess("Follow Success".localized, view: self.view)
                        
                    }
                    self.dvc_updateFolloweBtn()
                    
                case .failure:
                    message = kNetworkErrorTip
                    JSMBHUDBridge.showError(message, view: self.view)
                    
                }
            }
        }
    }

    func dvc_unfolloweUserRequest() {
        if let username = developer!.login {
            let hud = JSMBHUDBridge.showHud(view: self.view)
            Provider.sharedProvider.request(.unfollow(username:username) ) { (result) -> Void in
                hud.hide(animated: true)
                var message = kNoDataFoundTip
                switch result {
                case let .success(response):
                    
                    let statusCode = response.statusCode
                    if statusCode == BFStatusCode.noContent.rawValue {
                        self.followed = false
                        JSMBHUDBridge.showSuccess("UnFollow Success".localized, view: self.view)
                        
                    }
                    
                    self.dvc_updateFolloweBtn()
                    
                case .failure:
                    message = kNetworkErrorTip
                    JSMBHUDBridge.showError(message, view: self.view)
                    
                }
            }
        }
    }
}

extension BFUserDetailController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            return cellModels.count
        }
        return 0
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

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if section == 0 {
            return nil
        }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 10))
        view.backgroundColor = UIColor.bfViewBackgroundColor

        return view
    }

}

extension BFUserDetailController {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 10
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        let cellM = cellModels[row]

        if  cellM.identifier == "homepage" {
            JumpManager.shared.jumpWebView(url: self.developer?.html_url)
        }

    }

}

extension BFUserDetailController: UserProfileActionProtocol {

    func viewFollowAction() {
        actionType = .Follow
        segueGotoViewController()
    }

    func viewReposAction() {
        actionType = .Repos
        segueGotoViewController()
    }

    func viewFollowingAction() {
        actionType = .Following
        segueGotoViewController()
    }

    func segueGotoViewController() {

        if !UserManager.shared.isLogin {
            JSMBHUDBridge.showError(kLoginFirstTip, view: self.view)
            return
        }

        switch actionType {
        case .Follow:
            let uname = developer!.login
            let dic: [String: String] = ["uname": uname!, "type": "follower"]
            let vc = BFUserListController()
            vc.hidesBottomBarWhenPushed = true
            vc.dic = dic
            vc.username = dic["uname"]
            vc.viewType = dic["type"]
            self.navigationController?.pushViewController(vc, animated: true)

        case .Repos:

            let uname = developer!.login
            let dic: [String: String] = ["uname": uname!, "type": "myrepositories"]
            let vc = BFRepoListController()
            vc.hidesBottomBarWhenPushed = true
            vc.dic = dic
            vc.username = dic["uname"]
            vc.viewType = dic["type"]
            self.navigationController?.pushViewController(vc, animated: true)

        case .Following:
            let uname = developer!.login
            let dic: [String: String] = ["uname": uname!, "type": "following"]
            let vc = BFUserListController()
            vc.hidesBottomBarWhenPushed = true
            vc.dic = dic
            vc.username = dic["uname"]
            vc.viewType = dic["type"]
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }

}
