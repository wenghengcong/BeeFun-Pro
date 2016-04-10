//
//  CPProSettingsViewController.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/16/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

class CPProSettingsViewController: CPBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logOutBtn: UIButton!
    
    var settingsArr:[[ObjSettings]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        psvc_setupTableView()
        psvc_customView()
        psvc_readPlist()
        self.title = "Settings"

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func leftItemAction(sender: UIButton?) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func psvc_customView() {
        logOutBtn.addTarget(self, action: #selector(CPProSettingsViewController.psvc_logoutAction), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func psvc_setupTableView() {
        
        self.tableView.dataSource=self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .None
        self.tableView.backgroundColor = UIColor.viewBackgroundColor()
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    
    func psvc_readPlist(){
        settingsArr = CPGlobalHelper.sharedInstance.readPlist("CPSettingsList")
    }
    
    func psvc_logoutAction() {
        
        if( !(UserInfoHelper.sharedInstance.isLoginIn) ){
            CPGlobalHelper.sharedInstance.showMessage("You didn't login !", view: self.view)
            return
        }
        
        UserInfoHelper.sharedInstance.deleteUser()
        
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationGitLogOutSuccessful, object:nil)

        self.navigationController?.popViewControllerAnimated(true)
    }
    
}


extension CPProSettingsViewController : UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return settingsArr.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionArr = settingsArr[section]
        return sectionArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellId = "CPSettingsLabelCellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? CPSettingsLabelCell
        if cell == nil {
            cell = (CPSettingsLabelCell.cellFromNibNamed("CPSettingsLabelCell") as! CPSettingsLabelCell)
            
        }
        let section = indexPath.section
        let row = indexPath.row
        let settings:ObjSettings = settingsArr[section][row]
        if(settings.itemKey == "version"){
            settings.itemValue = AppVersionHelper.sharedInstance.bundleReleaseVersion()
        }
        
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

extension CPProSettingsViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
    }
    
}