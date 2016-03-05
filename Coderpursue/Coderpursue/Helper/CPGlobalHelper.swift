//
//  CPGlobalHelper.swift
//  Coderpursue
//
//  Created by wenghengcong on 16/1/31.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

import UIKit

class CPGlobalHelper {
    
    static let sharedInstance = CPGlobalHelper()

    func showMessage(message:String ,view:UIView) {
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = message
        hud.mode = .Text
        hud.hide(true, afterDelay: 1.5)
    }
    
    func showError(error:String ,view:UIView) {
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = error
        hud.mode = .Text
        hud.hide(true, afterDelay: 1.5)
    }
    
}
