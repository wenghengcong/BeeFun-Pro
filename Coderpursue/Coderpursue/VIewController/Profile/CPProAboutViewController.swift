//
//  CPProAboutViewController.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/16/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

class CPProAboutViewController: CPBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var introTextV: UITextView!
    
    
    var settingsArr:[[ObjSettings]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        pavc_readPlist()
        pavc_setupTableView()
        pavc_customView()
        self.title = "About".localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func leftItemAction(_ sender: UIButton?) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func pavc_setupTableView() {
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.viewBackgroundColor
        self.automaticallyAdjustsScrollViewInsets = false
    }

    func pavc_customView(){
        introTextV.text = "  Coderpursue is a client for github.It is written in Swift language. Also it is open source project on github.com.  \n  Welcome more people to join this project. You can participate in design or development work. Also welcome more suggestions and reports of bugs come from everyone!\n  Thank you!".localized
        introTextV.isEditable = false
    }
    
    func pavc_readPlist(){
        settingsArr = CPGlobalHelper.readPlist("CPAboutList")
    }
}


extension CPProAboutViewController : UITableViewDataSource {
    
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

extension CPProAboutViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if( !(UserManager.shared.needLogin()) ){
            return
        }
        
        let section = (indexPath as NSIndexPath).section
        let row = indexPath.row
        let settings:ObjSettings = settingsArr[section][row]
        
        let viewType = settings.itemKey!
        
        let me = ObjUser()
        me.name = "wenghengcong"
        me.login = "wenghengcong"
        
        if(viewType == "openlib"){
            
//            self.performSegueWithIdentifier(SegueTrendingShowRepositoryDetail, sender: nil)

        }else if(viewType == "website"){
//            self.performSegueWithIdentifier(SegueTrendingShowRepositoryDetail, sender: nil)

        }else if(viewType == "coderpursue"){
            
            let coderpursuePrj = ObjRepos()
            coderpursuePrj.owner = me
            coderpursuePrj.name = "Coderpursue"
            let vc = CPRepoDetailController()
            vc.hidesBottomBarWhenPushed = true
            vc.repos = coderpursuePrj
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if(viewType == "me"){

            let vc = CPUserDetailController()
            vc.hidesBottomBarWhenPushed = true
            vc.developer = me
            self.navigationController?.pushViewController(vc, animated: true)

        }
    }

    
}

