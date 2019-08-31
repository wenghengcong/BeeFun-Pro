//
//  BFProfileController.swift
//  BeeFun
//
//  Created by wenghengcong on 15/12/30.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

import UIKit
import Foundation
import MJRefresh
import ObjectMapper
import Alamofire
//import SwiftyStoreKit
import MessageUI

class BFProfileController: BFBaseViewController {

    var personCardV: CPPersonCardView = CPPersonCardView()

    var imagePicker = UIImagePickerController()

    var isLogin: Bool = false
    var user: ObjUser?
    var allSettings: [[JSCellModel]] = []
    let cellId = "CPProfileCellIdentifier"

    var data: NSMutableData = NSMutableData()

    // MARK: - view cycle

    override func viewDidLoad() {
        self.title = "Profile".localized
        super.viewDidLoad()
        pvc_loadSettingPlistData()
        pvc_customView()
        pvc_setupTableView()
        pvc_addNavigationbar()

        NotificationCenter.default.addObserver(self, selector: #selector(BFProfileController.pvc_updateUserinfoData), name: NSNotification.Name.BeeFun.DidLogin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BFProfileController.pvc_updateUserinfoData), name: NSNotification.Name.BeeFun.DidLogout, object: nil)
        self.leftItem?.isHidden = true

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pvc_updateUserinfoData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - load data
    //登录成功后刷新数据
    @objc func pvc_updateUserinfoData() {
        isLogin = UserManager.shared.isLogin
        user = UserManager.shared.user
        personCardV.user = user
        if isLogin {
//            pvc_getUserinfoRequest()
            pvc_getMyinfoRequest()
            MobClick.profileSignIn(withPUID: UserManager.shared.login)
        } else {
            MobClick.profileSignOff()
        }
    }
    
    func pvc_isLogin() -> Bool {
        if !UserManager.shared.needLogin() {
            return false
        }
        return true
    }

    // MARK: - view

    /// 不在导航栏有按钮，不方便
    func pvc_addNavigationbar() {
        self.rightItemImage = UIImage(named: "set_settings_white")
        self.rightItemSelImage = UIImage(named: "set_settings_white")
        self.rightItem?.isHidden = false
    }

    func pvc_customView() {

        self.refreshHidden = .all
        self.view.backgroundColor = UIColor.white

        self.view.addSubview(personCardV)
        personCardV.frame = CGRect(x: 0, y: uiTopBarHeight, w: ScreenSize.width, h: 142)
        personCardV.delegate = self
    }

    func pvc_updateViewWithUserData() {

        if isLogin {
            personCardV.user = self.user
        } else {
            personCardV.user = nil
        }
        self.removeReloadView()
        self.tableView.reloadData()
    }

    func pvc_setupTableView() {

        self.view.addSubview(tableView)

        let tabY = personCardV.bottom
        let tabH = ScreenSize.height-tabY-uiTabBarHeight
        self.tableView.frame = CGRect(x: 0, y: personCardV.bottom, w: ScreenSize.width, h: tabH)
        self.tableView.register(UINib(nibName: "JSImageCell", bundle: nil), forCellReuseIdentifier: cellId) //regiseter by xib
    }

    // MARK: - Action
    override func rightItemAction(_ sender: UIButton?) {
        let setVC = BFSettingsViewController()
        setVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(setVC, animated: true)
    }

    // MARK: - segue

    func pvc_getUserinfoRequest() {

        var username = ""
        if UserManager.shared.isLogin {
            username = UserManager.shared.user!.login!
        }

        Provider.sharedProvider.request(.userInfo(username:username) ) { (result) -> Void in

            var message = kNoDataFoundTip

            switch result {
            case let .success(response):

                do {
                    if let result: ObjUser = Mapper<ObjUser>().map(JSONObject: try response.mapJSON() ) {
                        ObjUser.saveUserInfo(result)
                        self.user = result
                        self.pvc_updateViewWithUserData()
                    } else {

                    }
                } catch {
                    JSMBHUDBridge.showError(message, view: self.view)
                }
            case .failure:
                message = kNetworkErrorTip
                JSMBHUDBridge.showError(message, view: self.view)

            }
        }

    }

}

extension BFProfileController: PersonCardViewActionProtocol {
    
    // MARK: - 编辑用户
    func editMyProfileAction() {
        let editVc = BFEditUserController()
        editVc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(editVc, animated: true)
    }

    /// 更换用户背景图
    func userChangeBackgroundImageAction() {
        imagePicker.delegate = self
        imagePicker.navigationBar.isTranslucent = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.navigationBar.barTintColor = UIColor.bfRedColor
        imagePicker.navigationBar.tintColor = UIColor.white
        imagePicker.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white
        ]
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }

    /// 获取用户信息
    func pvc_getMyinfoRequest() {
        Provider.sharedProvider.request(.myInfo ) { (result) -> Void in
            var message = kNoDataFoundTip
            switch result {
            case let .success(response):
                do {
                    if let result: ObjUser = Mapper<ObjUser>().map(JSONObject: try response.mapJSON() ) {
                        ObjUser.saveUserInfo(result)
                        self.user = result
                        self.isLogin = UserManager.shared.isLogin
                        self.personCardV.user = self.user
                        self.pvc_updateViewWithUserData()
                    }
                } catch {
                    JSMBHUDBridge.showError(message, view: self.view)
                }
            case .failure:
                message = kNetworkErrorTip
                JSMBHUDBridge.showError(message, view: self.view)
            }
        }
    }
    
    override func reconnect() {
        super.reconnect()
        pvc_getMyinfoRequest()
    }
    
    override func request() {
        super.request()
        pvc_getMyinfoRequest()
    }
    
    override func didAction(place: BFPlaceHolderView) {
        if place == placeEmptyView {
            request()
        } else if place == placeLoginView {
            login()
        } else if place == placeReloadView {
            self.request()
        }
    }
    
    //登录按钮，点击打开登录页面
    func userLoginAction() {
        OAuthManager.shared.beginOauth()
    }

    // MARK: - 顶部点击跳转：项目、粉丝、关注
    func viewMyReposAction() {
        if UserManager.shared.needLogin() {
            let uname = user!.login
            let dic: [String: String] = ["uname": uname!, "type": "myrepositories"]
            let vc = BFRepoListController()
            vc.hidesBottomBarWhenPushed = true
            vc.dic = dic
            vc.username = dic["uname"]
            vc.viewType = dic["type"]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func viewMyFollowerAction() {
        if UserManager.shared.needLogin() {
            let uname = user!.login
            let dic: [String: String] = ["uname": uname!, "type": "follower"]
            let vc = BFUserListController()
            vc.hidesBottomBarWhenPushed = true
            vc.dic = dic
            vc.username = dic["uname"]
            vc.viewType = dic["type"]
            self.navigationController?.pushViewController(vc, animated: true)
        } else {

        }
    }

    func viewMyFollowingAction() {
        if UserManager.shared.needLogin() {
            let uname = user!.login
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

extension BFProfileController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        /*
        Swift Dictionary named “info”.
        We have to unpack it from there with a key asking for what media information we want.
        We just want the image, so that is what we ask for.  For reference, the available options are:
        
        UIImagePickerControllerMediaType
        UIImagePickerControllerOriginalImage
        UIImagePickerControllerEditedImage
        UIImagePickerControllerCropRect
        UIImagePickerControllerMediaURL
        UIImagePickerControllerReferenceURL
        UIImagePickerControllerMediaMetadata
        
        */
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {

            var imgData: Data?

            if let refreUrl = info[UIImagePickerControllerReferenceURL] {
                if let convertURl = refreUrl as? URL {
                    let refUrl: URL = convertURl
                    let refUrlStr = refUrl.absoluteString.lowercased()
                    let pngRange = refUrlStr.range(of: "png", options: String.CompareOptions.literal, range: refUrlStr.startIndex..<refUrlStr.endIndex, locale: nil)
                    if pngRange != nil {
                        imgData = UIImagePNGRepresentation(pickedImage)
                    }
                    
                    let jpegRange = refUrlStr.range(of: "jpeg", options: String.CompareOptions.literal, range: refUrlStr.startIndex..<refUrlStr.endIndex, locale: nil)
                    if jpegRange != nil {
                        imgData = UIImageJPEGRepresentation(pickedImage, 1.0)
                    }
                    
                    let jpgRange = refUrlStr.range(of: "jpg", options: String.CompareOptions.literal, range: refUrlStr.startIndex..<refUrlStr.endIndex, locale: nil)
                    if jpgRange != nil {
                        imgData = UIImageJPEGRepresentation(pickedImage, 1.0)
                    }
                    
                    UserDefaults.standard.set(imgData, forKey: "userBackgroundImgage")
                    UserDefaults.standard.synchronize()
                    personCardV.avatarImgView.image = pickedImage
                }
            }
        }
        dismiss(animated: true, completion: nil)

    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension BFProfileController {

    func numberOfSections(in tableView: UITableView) -> Int {
        return allSettings.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionArr = allSettings[section]
        return sectionArr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = (indexPath as NSIndexPath).section
        let row = indexPath.row
        let rowOfSettings: JSCellModel = allSettings[section][row]
        let sectionOfSettings = allSettings[section]

        var cell = tableView.dequeueReusableCell(withIdentifier: "JSImageCellIdentifier") as? JSImageCell
        if cell == nil {
            cell = JSCellFactory.cell(type: rowOfSettings.type!) as? JSImageCell
        }
        cell?.model = rowOfSettings
        cell?.bothEndsLine(row, all: sectionOfSettings.count)
        return cell!
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.width, height: 10))
        view.backgroundColor = UIColor.bfViewBackgroundColor
        return view

    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

}
extension BFProfileController {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = (indexPath as NSIndexPath).section
        let row = indexPath.row
        let cellM: JSCellModel = allSettings[section][row]
        if let cellDidSeleted = cellM.didSelectClosure {
            cellDidSeleted(tableView, indexPath, cellM)
        }
    }
}

extension BFProfileController: MFMailComposeViewControllerDelegate {

    func configuredMailComposeViewController() -> MFMailComposeViewController {

        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property

        mailComposerVC.setToRecipients([KMyIcloudEmail])
        mailComposerVC.setCcRecipients([""])
        mailComposerVC.setSubject(KMailSubject)
        mailComposerVC.setMessageBody("", isHTML: false)

        return mailComposerVC
    }

    func showSendMailErrorAlert() {

        let sendMailErrorAlert = UIAlertView(title: KSendEmailErrorTitle, message: KSendEmailErrorContent, delegate: self, cancelButtonTitle: "Sure".localized)
        sendMailErrorAlert.show()
    }

    // MARK: MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)

        /*
         switch(result){
         case MFMailComposeResultCancelled:
         return
         case MFMailComposeResultSent:
         return
         case MFMailComposeResultFailed:
         return
         case MFMailComposeResultSaved:
         return
         default:
         return
         }
         */
    }

}
