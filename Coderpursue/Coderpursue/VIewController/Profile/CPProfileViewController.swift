//
//  CPProfileViewController.swift
//  Coderpursue
//
//  Created by wenghengcong on 15/12/30.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

import UIKit
import Moya
import Foundation
import MJRefresh
import ObjectMapper
import SwiftDate
import MessageUI
import Alamofire

class CPProfileViewController: CPBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileHeaderV: CPProfileHeaderView!

    var isLoingin:Bool = false
    var user:ObjUser?
    var settingsArr:[[ObjSettings]] = []
    let cellId = "CPSettingsCellIdentifier"

    var data: NSMutableData = NSMutableData()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pvc_loadSettingPlistData()
        pvc_customView()
        pvc_setupTableView()
       
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CPProfileViewController.pvc_updateUserinfoData), name: NotificationGitLoginSuccessful, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CPProfileViewController.pvc_updateUserinfoData), name: NotificationGitLogOutSuccessful, object: nil)
        self.leftItem?.hidden = true
        self.title = "Profile"

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        pvc_updateUserinfoData()

    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: load data
    func pvc_updateUserinfoData() {
        
        user = UserInfoHelper.sharedInstance.user
        isLoingin = UserInfoHelper.sharedInstance.isLoginIn
        profileHeaderV.user = user
        if isLoingin{
//            pvc_getUserinfoRequest()
            pvc_getMyinfoRequest()
        }

    }
    
    func pvc_loadSettingPlistData() {
        
        settingsArr = CPGlobalHelper.sharedInstance.readPlist("CPProfileList")
        self.tableView.reloadData()

    }
    
    func pvc_isLogin()->Bool{
        if( !(UserInfoHelper.sharedInstance.isLoginIn) ){
            CPGlobalHelper.sharedInstance.showMessage("You Should Login first!", view: self.view)
            return false
        }
        return true
    }
    
    // MARK: view
    
    func pvc_customView() {
        
        self.view.backgroundColor = UIColor.whiteColor()
        profileHeaderV.profileActionDelegate = self
    }
    
    
    func pvc_updateViewWithUserData() {
        
        if isLoingin {
            profileHeaderV.user = self.user
        }else {
            profileHeaderV.user = nil
        }
        self.tableView.reloadData()
    }
    
    func pvc_setupTableView() {
        
        self.tableView.dataSource=self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .None
        self.tableView.backgroundColor = UIColor.viewBackgroundColor()
//        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellId)    //register class by code
        self.tableView.registerNib(UINib(nibName: "CPSettingsCell", bundle: nil), forCellReuseIdentifier: cellId) //regiseter by xib
//        self.tableView.addSingleBorder(UIColor.lineBackgroundColor(), at:UIView.ViewBorder.Top)
//        self.tableView.addSingleBorder(UIColor.lineBackgroundColor(), at:UIView.ViewBorder.Bottom)
    }
    
    
    // MARK: segue
    
    func pvc_getUserinfoRequest(){
        
        var username = ""
        if(UserInfoHelper.sharedInstance.isLoginIn){
            username = UserInfoHelper.sharedInstance.user!.login!
        }
        
        Provider.sharedProvider.request(.UserInfo(username:username) ) { (result) -> () in
            
            var message = "No data to show"
            
            switch result {
            case let .Success(response):
                
                do {
                    if let result:ObjUser = Mapper<ObjUser>().map(try response.mapJSON() ) {
                        ObjUser.saveUserInfo(result)
                        self.user = result
                        self.pvc_updateViewWithUserData()
                    } else {
                        
                    }
                } catch {
                    CPGlobalHelper.sharedInstance.showError(message, view: self.view)
                }
            case let .Failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                CPGlobalHelper.sharedInstance.showError(message, view: self.view)
                
            }
        }
        
        
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if (segue.identifier == SegueProfileShowRepositoryList){
          
            let reposVC = segue.destinationViewController as! CPReposViewController
            reposVC.hidesBottomBarWhenPushed = true
            
            let dic = sender as? [String:String]
            if (dic != nil) {
                reposVC.dic = dic!
                reposVC.username = dic!["uname"]
                reposVC.viewType = dic!["type"]
            }
            
        }else if(segue.identifier == SegueProfileShowFollowerList){
            
            let followVC = segue.destinationViewController as! CPFollowersViewController
            followVC.hidesBottomBarWhenPushed = true
            
            let dic = sender as? [String:String]
            if (dic != nil) {
                followVC.dic = dic!
                followVC.username = dic!["uname"]
                followVC.viewType = dic!["type"]
            }
            
        }else if(segue.identifier == SegueProfileAboutView){
            
            let aboutVC = segue.destinationViewController as! CPProAboutViewController
            aboutVC.hidesBottomBarWhenPushed = true
            
        }else if(segue.identifier == SegueProfileSettingView){
            let settingsVC = segue.destinationViewController as! CPProSettingsViewController
            settingsVC.hidesBottomBarWhenPushed = true
            
        }else if(segue.identifier == SegueProfileFunnyLabView){
            let settingsVC = segue.destinationViewController as! CPFunnyLabViewController
            settingsVC.hidesBottomBarWhenPushed = true
        }
        
        
        
    }

}
extension CPProfileViewController : ProfileHeaderActionProtocol {

    private func pvc_saveAuthorization(auth:String){

        var token = AppToken.sharedInstance
        token.access_token = auth

    }

    private func pvc_requestToken(fromCode code: String) {
        let getTokenPath = "https://github.com/login/oauth/access_token"
        let tokenParams = ["client_id": GithubAppClientId, "client_secret": GithubAppClientSecret, "code": code]
        Alamofire.request(.POST, getTokenPath, parameters: tokenParams)
            .responseString { response in
                if response.result.isSuccess {
                    var token: String?
                    if let value = response.result.value {
                        let resultParams = value.characters.split("&").map(String.init)
                        params_loop: for param in resultParams {
                            let resultsSplit = param.characters.split("=").map(String.init)
                            if resultsSplit.count == 2 {
                                let key = resultsSplit[0].lowercaseString
                                let value = resultsSplit[1]
                                switch key {
                                case "access_token":
                                    token = value
                                    break params_loop
                                default:
                                    break
                                }
                            }
                        }
                    }
                    if let token = token {
                        let authString = "token \(token)"
                        self.pvc_saveAuthorization(authString)
                        self.pvc_getMyinfoRequest()
                    }
                } else {
                    // TODO: Handle the error
                    if let error = response.result.error {
                        NSLog(error.localizedDescription)
                    }
                }
        }
    }

    func pvc_getMyinfoRequest(){

        Provider.sharedProvider.request(.MyInfo ) { (result) -> () in

            var success = true
            var message = "No data to show"

            switch result {
            case let .Success(response):

                do {
                    if let result:ObjUser = Mapper<ObjUser>().map(try response.mapJSON() ) {
                        ObjUser.saveUserInfo(result)
                        self.user = result
                        self.isLoingin = UserInfoHelper.sharedInstance.isLoginIn
                        self.profileHeaderV.user = self.user
                        self.pvc_updateViewWithUserData()
                    } else {
                        success = false
                    }
                } catch {
                    success = false
                    CPGlobalHelper.sharedInstance.showError(message, view: self.view)
                }
            case let .Failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                success = false
                CPGlobalHelper.sharedInstance.showError(message, view: self.view)

            }
        }

    }

    func pvc_showLoginInWebView() {
        (UIApplication.sharedApplication().delegate as! AppDelegate).authCodeDelegate = { code in
            self.pvc_requestToken(fromCode: code)
        }
        let authPath = "https://github.com/login/oauth/authorize?client_id=\(GithubAppClientId)&scope=repo&state=TEST_STATE"
        if let authURL = NSURL(string: authPath) {
            UIApplication.sharedApplication().openURL(authURL)
        }
    }

    func userLoginAction() {
        pvc_showLoginInWebView()
//        self.performSegueWithIdentifier(SegueProfileLoginIn, sender: nil)
    }

    func viewMyReposAction() {
        if ( isLoingin && (user != nil) ){
            let uname = user!.login
            let dic:[String:String] = ["uname":uname!,"type":"myrepositories"]
            self.performSegueWithIdentifier(SegueProfileShowRepositoryList, sender: dic)
        }else{
            CPGlobalHelper.sharedInstance.showMessage("You Should Login first!", view: self.view)

        }

    }
    
    func viewMyFollowerAction() {
        if ( isLoingin && (user != nil) ){
            let uname = user!.login
            let dic:[String:String] = ["uname":uname!,"type":"follower"]
            self.performSegueWithIdentifier(SegueProfileShowFollowerList, sender: dic)
        }else{
            CPGlobalHelper.sharedInstance.showMessage("You Should Login first!", view: self.view)

        }
    }
    
    func viewMyFollowingAction() {
        if ( isLoingin && (user != nil) ){
            let uname = user!.login
            let dic:[String:String] = ["uname":uname!,"type":"following"]
            self.performSegueWithIdentifier(SegueProfileShowFollowerList, sender: dic)
        }else{
            CPGlobalHelper.sharedInstance.showMessage("You Should Login first!", view: self.view)
        }
    }
    
}

extension CPProfileViewController : UITableViewDataSource {
	
	    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
	        return settingsArr.count
	    }
	
	    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            let sectionArr = settingsArr[section]
	        return sectionArr.count
	    }
	
	    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            

            var cell = tableView .dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as? CPSettingsCell
            
            if cell == nil {
                cell = (CPSettingsCell.cellFromNibNamed("CPSettingsCell") as! CPSettingsCell)
            }
            let section = indexPath.section
            let row = indexPath.row
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
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view:UIView = UIView.init(frame: CGRectMake(0, 0, ScreenSize.ScreenWidth, 10))
        view.backgroundColor = UIColor.viewBackgroundColor()
        return view
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
	    
}
extension CPProfileViewController : UITableViewDelegate {
	
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let section = indexPath.section
        let row = indexPath.row
        let settings:ObjSettings = settingsArr[section][row]

        let viewType = settings.itemKey!

        if ( (viewType == "watched")||(viewType == "forked") ){
            
            if (isLoingin && (user != nil) ){
                let uname = user!.login
                let dic:[String:String] = ["uname":uname!,"type":viewType]
                self.performSegueWithIdentifier(SegueProfileShowRepositoryList, sender: dic)
            }else{
                CPGlobalHelper.sharedInstance.showMessage("You Should Login first!", view: self.view)
            }
        
        }else if(viewType == "feedback"){
            
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
            
        }else if(viewType == "rate"){
            
            AppVersionHelper.sharedInstance.rateUs()
            
        }else if(viewType == "share"){
            
            ShareHelper.sharedInstance.shareContentInView(self, content: ShareContent(), soucre: .App)
            
        }else if(viewType == "settings"){
            
            self.performSegueWithIdentifier(SegueProfileSettingView, sender: nil)
            
        }else if(viewType == "about"){

            self.performSegueWithIdentifier(SegueProfileAboutView, sender: nil)
            
        }else if(viewType == "funnylab"){
            
            self.performSegueWithIdentifier(SegueProfileFunnyLabView, sender: nil)
            
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
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        controller.dismissViewControllerAnimated(true, completion: nil)
        
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