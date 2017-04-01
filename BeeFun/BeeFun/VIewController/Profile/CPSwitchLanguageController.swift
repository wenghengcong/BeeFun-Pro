//
//  CPSwitchLanguageController.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/3/19.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

class CPSwitchLanguageController: CPBaseViewController {

    var settingsArr:[[ObjSettings]] = []

    
}

extension CPSwitchLanguageController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tableView .dequeueReusableCell(withIdentifier: "", for: indexPath) as? CPSettingsCell
        
        if cell == nil {
            cell = (CPSettingsCell.cellFromNibNamed("CPSettingsCell") as! CPSettingsCell)
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
    
}
extension CPSwitchLanguageController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
