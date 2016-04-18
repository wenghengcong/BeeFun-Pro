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
        self.title = "About"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func leftItemAction(sender: UIButton?) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func pavc_setupTableView() {
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .None
        self.tableView.backgroundColor = UIColor.viewBackgroundColor()
        self.automaticallyAdjustsScrollViewInsets = false
    }

    func pavc_customView(){
        introTextV.text = "  Coderpursue is a client for github.It is written in Swift language. Also it is open source project on github.com.  \n  Welcome more people to join this project. You can participate in design or develope work. Also welcome more suggestions and reports of bugs come from you!\n  Thank you!"
    }
    
    func pavc_readPlist(){
        settingsArr = CPGlobalHelper.sharedInstance.readPlist("CPAboutList")
    }
}


extension CPProAboutViewController : UITableViewDataSource {
    
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

extension CPProAboutViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if( !(UserInfoHelper.sharedInstance.isLogin) ){
            CPGlobalHelper.sharedInstance.showMessage("You Should Login first!", view: self.view)
            return
        }
        
        let section = indexPath.section
        let row = indexPath.row
        let settings:ObjSettings = settingsArr[section][row]
        
        let viewType = settings.itemKey!
        
        if(viewType == "openlib"){
            
//            self.performSegueWithIdentifier(SegueTrendingShowRepositoryDetail, sender: nil)

        }else if(viewType == "website"){
//            self.performSegueWithIdentifier(SegueTrendingShowRepositoryDetail, sender: nil)

        }else if(viewType == "coderpursue"){
            
            self.performSegueWithIdentifier(SegueProfileAboutCoderpursue, sender: nil)

        }else if(viewType == "me"){
            self.performSegueWithIdentifier(SegueProfileAboutMe, sender: nil)

        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        let me = ObjUser()
        me.name = "wenghengcong"
        me.login = "wenghengcong"
        
        let coderpursuePrj = ObjRepos()
        coderpursuePrj.owner = me
        coderpursuePrj.name = "Coderpursue"
        
        if (segue.identifier == SegueProfileAboutCoderpursue){
            
            let reposVC = segue.destinationViewController as! CPTrendingRepositoryViewController
            reposVC.hidesBottomBarWhenPushed = true
            
            reposVC.repos = coderpursuePrj
            
        }else if(segue.identifier == SegueProfileAboutMe){
            
            let devVC = segue.destinationViewController as! CPTrendingDeveloperViewController
            devVC.hidesBottomBarWhenPushed = true
            devVC.developer = me
            
        }
        
    }
    
}

