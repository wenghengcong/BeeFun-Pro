//
//  CPProfileViewController.swift
//  Coderpursue
//
//  Created by wenghengcong on 15/12/30.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

import UIKit
import Foundation
import MJRefresh
import ObjectMapper
import SwiftDate
import MessageUI
import Alamofire

class CPProfileViewController: CPBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileHeaderV: CPProfileHeaderView!

    var isLogin:Bool = false
    var user:ObjUser?
    var settingsArr:[[ObjSettings]] = []
    let cellId = "CPSettingsCellIdentifier"

    var data: NSMutableData = NSMutableData()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        pvc_loadSettingPlistData()
        pvc_customView()
        pvc_setupTableView()
       
        NotificationCenter.default.addObserver(self, selector: #selector(CPProfileViewController.pvc_updateUserinfoData), name: NSNotification.Name(rawValue: kNotificationDidGitLogin), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CPProfileViewController.pvc_updateUserinfoData), name: NSNotification.Name(rawValue: kNotificationDidGitLogOut), object: nil)
        self.leftItem?.isHidden = true
        self.title = "Profile".localized

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pvc_updateUserinfoData()

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: load data
    //登录成功后刷新数据
    func pvc_updateUserinfoData() {
        
        user = UserManager.shared.user
        isLogin = UserManager.shared.isLogin
        profileHeaderV.user = user
        if isLogin{
//            pvc_getUserinfoRequest()
            pvc_getMyinfoRequest()
        }

    }
    
    func pvc_loadSettingPlistData() {
        
        settingsArr = CPGlobalHelper.readPlist("CPProfileList")
        self.tableView.reloadData()

    }
    
    func pvc_isLogin()->Bool{
        if( !(UserManager.shared.needLogin()) ){
            return false
        }
        return true
    }
    
    // MARK: view
    
    func pvc_customView() {
        
        self.view.backgroundColor = UIColor.white
        profileHeaderV.profileActionDelegate = self
    }
    
    
    func pvc_updateViewWithUserData() {
        
        if isLogin {
            profileHeaderV.user = self.user
        }else {
            profileHeaderV.user = nil
        }
        self.tableView.reloadData()
    }
    
    func pvc_setupTableView() {
        
        self.tableView.dataSource=self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.viewBackgroundColor
//        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellId)    //register class by code
        self.tableView.register(UINib(nibName: "CPSettingsCell", bundle: nil), forCellReuseIdentifier: cellId) //regiseter by xib
//        self.tableView.addSingleBorder(UIColor.lineBackgroundColor, at:UIView.ViewBorder.Top)
//        self.tableView.addSingleBorder(UIColor.lineBackgroundColor, at:UIView.ViewBorder.Bottom)
    }
    
    
    // MARK: segue
    
    func pvc_getUserinfoRequest(){
        
        var username = ""
        if(UserManager.shared.isLogin){
            username = UserManager.shared.user!.login!
        }
        
        Provider.sharedProvider.request(.userInfo(username:username) ) { (result) -> () in
            
            var message = kNoDataFoundTip
            
            switch result {
            case let .success(response):
                
                do {
                    if let result:ObjUser = Mapper<ObjUser>().map(JSONObject: try response.mapJSON() ) {
                        ObjUser.saveUserInfo(result)
                        self.user = result
                        self.pvc_updateViewWithUserData()
                    } else {
                        
                    }
                } catch {
                    JSMBHUDBridge.showError(message, view: self.view)
                }
            case let .failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                JSMBHUDBridge.showError(message, view: self.view)
                
            }
        }
        
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if(segue.identifier == SegueProfileAboutView){
            
            let aboutVC = segue.destination as! CPProAboutViewController
            aboutVC.hidesBottomBarWhenPushed = true
            
        }else if(segue.identifier == SegueProfileSettingView){
            let settingsVC = segue.destination as! CPProSettingsViewController
            settingsVC.hidesBottomBarWhenPushed = true
            
        }else if(segue.identifier == SegueProfileFunnyLabView){
            let settingsVC = segue.destination as! CPFunnyLabViewController
            settingsVC.hidesBottomBarWhenPushed = true
        }
        
        
        
    }

}
extension CPProfileViewController : ProfileHeaderActionProtocol {

    func pvc_getMyinfoRequest(){

        Provider.sharedProvider.request(.myInfo ) { (result) -> () in

            var success = true
            var message = kNoDataFoundTip

            switch result {
            case let .success(response):

                do {
                    if let result:ObjUser = Mapper<ObjUser>().map(JSONObject:try response.mapJSON() ) {
                        ObjUser.saveUserInfo(result)
                        self.user = result
                        self.isLogin = UserManager.shared.isLogin
                        self.profileHeaderV.user = self.user
                        self.pvc_updateViewWithUserData()
                    } else {
                        success = false
                    }
                } catch {
                    success = false
                    JSMBHUDBridge.showError(message, view: self.view)
                }
            case let .failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                success = false
                JSMBHUDBridge.showError(message, view: self.view)
            }
        }

    }
    
    //登录按钮，点击打开登录页面
    func userLoginAction() {
        if(UserManager.shared.needLogin())
        {
            
        }
    }

    func viewMyReposAction() {
        if ( UserManager.shared.needLogin() ){
            let uname = user!.login
            let dic:[String:String] = ["uname":uname!,"type":"myrepositories"]
            let vc = CPRepoListController()
            vc.hidesBottomBarWhenPushed = true
            vc.dic = dic
            vc.username = dic["uname"]
            vc.viewType = dic["type"]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func viewMyFollowerAction() {
        if ( UserManager.shared.needLogin()  ){
            let uname = user!.login
            let dic:[String:String] = ["uname":uname!,"type":"follower"]
            let vc = CPUserListController()
            vc.hidesBottomBarWhenPushed = true
            vc.dic = dic
            vc.username = dic["uname"]
            vc.viewType = dic["type"]
            self.navigationController?.pushViewController(vc, animated: true)
        }else{

        }
    }
    
    func viewMyFollowingAction() {
        if ( UserManager.shared.needLogin()  ){
            let uname = user!.login
            let dic:[String:String] = ["uname":uname!,"type":"following"]
            let vc = CPUserListController()
            vc.hidesBottomBarWhenPushed = true
            vc.dic = dic
            vc.username = dic["uname"]
            vc.viewType = dic["type"]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension CPProfileViewController : UITableViewDataSource {
	
	    func numberOfSections(in tableView: UITableView) -> Int {
	        return settingsArr.count
	    }
	
	    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            let sectionArr = settingsArr[section]
	        return sectionArr.count
	    }
	
	    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            

            var cell = tableView .dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? CPSettingsCell
            
            if cell == nil {
                cell = (CPSettingsCell.cellFromNibNamed("CPSettingsCell") as! CPSettingsCell)
            }
            let section = (indexPath as NSIndexPath).section
            let row = (indexPath as NSIndexPath).row
            let settings:ObjSettings = settingsArr[section][row]
            cell!.objSettings = settings
            
            //handle line in cell
            if row == 0 {
                cell!.topline = true
            }
            let sectionArr = settingsArr[section]
            if (row == sectionArr.count-1) {
                cell!.fullline = true
            }else {
                cell!.fullline = false
            }
            
            return cell!;
	    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: ScreenSize.width, height: 10))
        view.backgroundColor = UIColor.viewBackgroundColor
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
extension CPProfileViewController : UITableViewDelegate {
	
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = (indexPath as NSIndexPath).section
        let row = (indexPath as NSIndexPath).row
        let settings:ObjSettings = settingsArr[section][row]

        let viewType = settings.itemKey!

        if ( (viewType == "watched")||(viewType == "forked") ){
            
            if (UserManager.shared.needLogin() ){
                let uname = user!.login
                let dic:[String:String] = ["uname":uname!,"type":viewType]
                let vc = CPRepoListController()
                vc.hidesBottomBarWhenPushed = true
                vc.dic = dic
                vc.username = dic["uname"]
                vc.viewType = dic["type"]
                self.navigationController?.pushViewController(vc, animated: true)
            }
        
        }else if(viewType == "feedback"){
            
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
            
        }else if(viewType == "rate"){
            
            AppVersionHelper.shared.rateUs()
            
        }else if(viewType == "share"){
            
            ShareManager.shared.shareApp()
            
        }else if(viewType == "settings"){
            
            self.performSegue(withIdentifier: SegueProfileSettingView, sender: nil)
            
        }else if(viewType == "about"){

            self.performSegue(withIdentifier: SegueProfileAboutView, sender: nil)
            
        }else if(viewType == "funnylab"){
            
            self.performSegue(withIdentifier: SegueProfileFunnyLabView, sender: nil)
            
        }
        
    }
    
}

extension CPProfileViewController : MFMailComposeViewControllerDelegate {

    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["wenghengcong@icloud.com"])
        mailComposerVC.setCcRecipients([""])
        mailComposerVC.setSubject("Suggestions or report bugs")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        
        let sendMailErrorAlert = UIAlertView(title: "Could not send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
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
