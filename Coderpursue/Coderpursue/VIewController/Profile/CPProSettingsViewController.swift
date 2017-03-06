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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func leftItemAction(_ sender: UIButton?) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func psvc_customView() {
        logOutBtn.addTarget(self, action: #selector(CPProSettingsViewController.psvc_logoutAction), for: UIControlEvents.touchUpInside)
    }
    
    func psvc_setupTableView() {
        
        self.tableView.dataSource=self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.viewBackgroundColor()
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    
    func psvc_readPlist(){
        settingsArr = CPGlobalHelper.readPlist("CPSettingsList")
    }
    
    func psvc_logoutAction() {
        
        if( !(UserInfoHelper.shared.isLogin) ){
            CPGlobalHelper.showMessage("You didn't login !", view: self.view)
            return
        }
        
        UserInfoHelper.shared.deleteUser()
        
        NotificationCenter.default.post(name: Notification.Name(rawValue:kNotificationDidGitLogOut), object:nil)

        self.navigationController?.popViewController(animated: true)
    }
    
}


extension CPProSettingsViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionArr = settingsArr[section]
        return sectionArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId = "CPSettingsLabelCellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? CPSettingsLabelCell
        if cell == nil {
            cell = (CPSettingsLabelCell.cellFromNibNamed("CPSettingsLabelCell") as! CPSettingsLabelCell)
            
        }
        let section = (indexPath as NSIndexPath).section
        let row = (indexPath as NSIndexPath).row
        let settings:ObjSettings = settingsArr[section][row]
        if(settings.itemKey == "version"){
            settings.itemValue = AppVersionHelper.shared.bundleReleaseVersion()
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
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: ScreenSize.ScreenWidth, height: 15))
        view.backgroundColor = UIColor.viewBackgroundColor()
        return view
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
}

extension CPProSettingsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
}
