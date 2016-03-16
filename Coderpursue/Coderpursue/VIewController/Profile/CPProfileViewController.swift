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

class CPProfileViewController: CPBaseViewController,NSURLConnectionDelegate {
    
    @IBOutlet weak var profileBgV: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var pvc_backImgV: UIImageView!
    @IBOutlet weak var pvc_avatarImgV: UIImageView!
    @IBOutlet weak var pvc_nameLabel: UILabel!
    @IBOutlet weak var pvc_emailLabel: UIButton!
    @IBOutlet weak var pvc_loginBtn: UIButton!
    @IBOutlet weak var pvc_editProfileBtn: UIButton!
    
    @IBOutlet weak var reposBgV: UIView!
    @IBOutlet weak var followerBgV: UIView!
    @IBOutlet weak var followingBgV: UIView!
    
    @IBOutlet weak var pvc_numOfReposLabel: UILabel!
    @IBOutlet weak var pvc_numOfFollwerLabel: UILabel!
    @IBOutlet weak var pvc_numOfFollowingLabel: UILabel!
    
    @IBOutlet weak var pvc_reposLabel: UILabel!
    @IBOutlet weak var pvc_followersLabel: UILabel!
    @IBOutlet weak var pvc_followingLabel: UILabel!
    
    
    var isLoingin:Bool = false
    var user:ObjUser?
    var settingsArr:[[ObjSettings]] = []
    let cellId = "CPSettingsCellIdentifier"

    var data: NSMutableData = NSMutableData()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        pvc_addButtonTarget()
        pvc_loadSettingPlistData()
        pvc_customView()
        pvc_setupTableView()
       
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pvc_loadUserinfoData", name: NotificationGitLoginSuccessful, object: nil)
//        loginbasein()
    }
    
    func loginbasein(){
        
        let username = "wenghengcong"
        let password = ""
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSASCIIStringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        let authorizationHeaderStr = "Basic \(base64LoginString)"
        
        // create the request
        let url = NSURL(string: "https://api.github.com/user")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        request.setValue(authorizationHeaderStr, forHTTPHeaderField: "Authorization")
        
        // fire off the request
        // make sure your class conforms to NSURLConnectionDelegate
        let urlConnection = NSURLConnection(request: request, delegate: self)
        urlConnection?.start()
    }
    
    //NSURLConnection delegate method
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        print("Failed with error:\(error.localizedDescription)")
    }
    
    //NSURLConnection delegate method
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        //New request so we need to clear the data object
        self.data = NSMutableData()
        let status = (response as! NSHTTPURLResponse).statusCode
        print("status code is \(status)")
    }
    
    //NSURLConnection delegate method
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        //Append incoming data
        self.data.appendData(data)
        let str = String(data: self.data, encoding:NSUTF8StringEncoding)
        print(str)
    }
    
    //NSURLConnection delegate method
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        NSLog("connectionDidFinishLoading");
        let str = String(data: self.data, encoding:NSUTF8StringEncoding)
        print(str)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Profile"  
        pvc_loadUserinfoData()

    }
    // MARK: load data
    func pvc_loadUserinfoData() {
        
        pvc_getUserinfoRequest()
        user = UserInfoHelper.sharedInstance.user
        isLoingin = UserInfoHelper.sharedInstance.isLoginIn
        
        if user != nil {
            print("user\(user!.name)")
            pvc_updateViewWithUserData()
        }
    }
    
    func pvc_loadSettingPlistData() {
        
        settingsArr = CPGlobalHelper.sharedInstance.readPlist("CPProfileList")
        self.tableView.reloadData()

    }
    
    // MARK: view
    
    func pvc_customView() {
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.pvc_avatarImgV.layer.cornerRadius = self.pvc_avatarImgV.width/2
        self.pvc_avatarImgV.layer.masksToBounds = true
        
        self.pvc_nameLabel.textColor = UIColor.whiteColor()
        self.pvc_emailLabel.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.pvc_emailLabel.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        
        self.pvc_loginBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.pvc_loginBtn.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        
        self.pvc_numOfReposLabel.textColor = UIColor.labelTitleTextColor()
        self.pvc_reposLabel.textColor = UIColor.labelSubtitleTextColor()
        
        self.pvc_numOfFollwerLabel.textColor = UIColor.labelTitleTextColor()
        self.pvc_followersLabel.textColor = UIColor.labelSubtitleTextColor()
        
        self.pvc_numOfFollowingLabel.textColor = UIColor.labelTitleTextColor()
        self.pvc_followingLabel.textColor = UIColor.labelSubtitleTextColor()
        
        //add border to sperator three columns
        self.reposBgV.addOnePixelAroundBorder(UIColor.lineBackgroundColor())
        self.reposBgV.userInteractionEnabled = true
        self.followerBgV.addOnePixelAroundBorder(UIColor.lineBackgroundColor())
        self.followerBgV.userInteractionEnabled = true
        self.followingBgV.addOnePixelAroundBorder(UIColor.lineBackgroundColor())
        self.followingBgV.userInteractionEnabled = true
        
        let reposGes = UITapGestureRecognizer(target: self, action: "pvc_reposTapAction:")
        self.reposBgV.addGestureRecognizer(reposGes)
        
        let followGes = UITapGestureRecognizer(target: self, action: "pvc_followTapAction:")
        self.followerBgV.addGestureRecognizer(followGes)
        
        let followingGes = UITapGestureRecognizer(target: self, action: "pvc_followingTapAction:")
        self.followingBgV.addGestureRecognizer(followingGes)
        
        pvc_updateViewWithUserData()
    }
    
    func pvc_reposTapAction(sender: UITapGestureRecognizer) {
        print("pvc_reposTapAction")
        
        if ( isLoingin && (user != nil) ){
            let count = user!.public_repos!
            if(count == 0){
                return
            }
            let uname = user!.login
            let dic:[String:String] = ["uname":uname!,"type":"myrepositories"]
            self.performSegueWithIdentifier(SegueProfileShowRepositoryList, sender: dic)
        }
        
    }
    
    func pvc_followTapAction(sender: UITapGestureRecognizer) {
        print("pvc_followTapAction")
        if ( isLoingin && (user != nil) ){
            
            let count = user!.followers!
            if(count == 0){
                return
            }
            
            let uname = user!.login
            let dic:[String:String] = ["uname":uname!,"type":"follower"]
            self.performSegueWithIdentifier(SegueProfileShowFollowerList, sender: dic)
        }
    }
    
    func pvc_followingTapAction(sender: UITapGestureRecognizer) {
        print("pvc_followintTapAction")
        if ( isLoingin && (user != nil) ){
            let count = user!.following!
            if(count == 0){
                return
            }
            let uname = user!.login
            let dic:[String:String] = ["uname":uname!,"type":"following"]
            self.performSegueWithIdentifier(SegueProfileShowFollowerList, sender: dic)
        }
    }
    
    func pvc_updateViewWithUserData() {
        
        self.pvc_nameLabel.hidden = !isLoingin
        self.pvc_emailLabel.hidden = !isLoingin
        
//        self.pvc_editProfileBtn.hidden = !isLoingin
        self.pvc_editProfileBtn.hidden = true
        self.pvc_loginBtn.hidden = isLoingin
        
        if isLoingin {
            self.pvc_avatarImgV.kf_setImageWithURL( NSURL(string: user!.avatar_url!)!, placeholderImage: nil)
            self.pvc_numOfReposLabel.text = String(format: "%ld", arguments: [(user?.public_repos)!])
            self.pvc_numOfFollowingLabel.text = String(format: "%ld", arguments: [(user?.following)!])
            self.pvc_numOfFollwerLabel.text = String(format: "%ld", arguments: [(user?.followers)!])
            
            self.tableView.reloadData()
        }else {
            
        }
        
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
    
    
    func pvc_addButtonTarget() {
        pvc_editProfileBtn.addTarget(self, action: "pvc_editProfileAction:", forControlEvents: .TouchUpInside)
        pvc_loginBtn.addTarget(self, action: "pvc_loginAction:", forControlEvents: .TouchUpInside)

    }
    
    // MARK:  action
    func pvc_editProfileAction(sender:UIButton!) {
    }
    
    func pvc_loginAction(sender:UIButton) {
        
        pvc_showLoginInWebView()
    }
    
    
    // MARK: segue
    
    func pvc_showLoginInWebView() {
        NetworkHelper.clearCookies()
        
        let loginVC = CPGitLoginViewController()
        let url = String(format: "https://github.com/login/oauth/authorize/?client_id=%@&state=%@&redirect_uri=%@&scope=%@",GithubAppClientId,"junglesong",GithubAppRedirectUrl,"user,user:email,user:follow,public_repo,repo,repo_deployment,repo:status,delete_repo,notifications,gist,read:repo_hook,write:repo_hook,admin:repo_hook,admin:org_hook,read:org,write:org,admin:org,read:public_key,write:public_key,admin:public_key" )
        loginVC.url = url
        loginVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(loginVC, animated: true)
        
    }
    
    
    func pvc_getUserinfoRequest(){
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        var username = ""
        if(UserInfoHelper.sharedInstance.isLoginIn){
            username = UserInfoHelper.sharedInstance.user!.login!
        }
        
        Provider.sharedProvider.request(.UserInfo(username:username) ) { (result) -> () in
            
            var success = true
            var message = "Unable to fetch from GitHub"
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            
            switch result {
            case let .Success(response):
                
                do {
                    if let result:ObjUser = Mapper<ObjUser>().map(try response.mapJSON() ) {
                        ObjUser.saveUserInfo(result)
                        self.user = result
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
        
        let view:UIView = UIView.init(frame: CGRectMake(0, 0, ScreenSize.ScreenWidth, 15))
        view.backgroundColor = UIColor.viewBackgroundColor()
        return view
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
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

        if ( isLoingin && (user != nil) && ( (viewType == "watched")||(viewType == "forked") )){
            let uname = user!.login
            let dic:[String:String] = ["uname":uname!,"type":viewType]
            self.performSegueWithIdentifier(SegueProfileShowRepositoryList, sender: dic)
            
        }else if(viewType == "feedback"){
            
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
            
        }else if(viewType == "rate"){
            
            AppVersionHelper.sharedInstance.rateUs()
            
        }else if(viewType == "settings"){
            
            self.performSegueWithIdentifier(SegueProfileSettingView, sender: nil)
            
        }else if(viewType == "about"){

            self.performSegueWithIdentifier(SegueProfileAboutView, sender: nil)
            
        }
        
    }
    
}

extension CPProfileViewController : MFMailComposeViewControllerDelegate {

    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["wenghengcong@gmail.com"])
        mailComposerVC.setCcRecipients(["735929774@qq.com"])
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