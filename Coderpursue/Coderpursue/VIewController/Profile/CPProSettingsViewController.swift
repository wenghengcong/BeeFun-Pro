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
        self.title = "Settings".localized

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
        self.tableView.backgroundColor = UIColor.viewBackgroundColor
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    
    func psvc_readPlist(){
        settingsArr = CPGlobalHelper.readPlist("CPSettingsList")
    }
    
    func psvc_logoutAction() {
        
        if( !(UserManager.shared.isLogin) ){
            JSMBHUDBridge.showMessage("You didn't login !", view: self.view)
            return
        }
        
        UserManager.shared.deleteUser()
        
        NotificationCenter.default.post(name: Notification.Name(rawValue:kNotificationDidGitLogOut), object:nil)

        _ = self.navigationController?.popViewController(animated: true)
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
        
        let view:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: ScreenSize.width, height: 15))
        view.backgroundColor = UIColor.viewBackgroundColor
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
        
        let section = (indexPath as NSIndexPath).section
        let row = (indexPath as NSIndexPath).row
        let settings:ObjSettings = settingsArr[section][row]
        
        let viewType = settings.itemKey!
        let viewValue = settings.itemValue!
        
        if(viewType == "language"){
            if viewValue == "切换到英语" {
                
                let alertController = UIAlertController(title: "切换到英语?", message:"Tha app shows in English", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
                    // ...
                }
                alertController.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: "确定", style: .default) { (action) in
                    JSLanguage.setEnglish()
                    JSLanguage.synchronize()
                    self.reloadAllResource()
                }
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true) {
                    // ...
                }

            }else if(viewValue == "Change to Chinese"){
                
                let alertController = UIAlertController(title: "Change to Chinese?", message:"App将会显示成中文", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                    // ...
                }
                alertController.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: "Sure", style: .default) { (action) in
                    JSLanguage.setChinese()
                    JSLanguage.synchronize()
                    self.reloadAllResource()
                }
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true) {
                    // ...
                }
                
            }
        }
        
    }
    
}


extension CPProSettingsViewController {

    func reloadAllResource() {
        self.tableView.reloadData()
        self.reloadMainStroyboard()
        self.reloadOtherViewController()
    }
    
    func reloadMainStroyboard() {
        
        let storyboardName = "Main"
        let storyboard = UIStoryboard.init(name: storyboardName, bundle: nil)
        jsKeywindow?.rootViewController = storyboard.instantiateInitialViewController()
    }
    
    func reloadOtherViewController() {
        jsAppDelegate.tabBarController?.reloadAllChildController()
    }
    
}
