//
//  JSMBHUDBridge.swift
//  Coderpursue
//
//  Created by WengHengcong on 2017/3/18.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit
import MBProgressHUD

class JSMBHUDBridge: NSObject {

    class func showMessage(_ message:String ,view:UIView) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = message
        hud.mode = .text
        hud.hide(animated: true, afterDelay: 1.5)
    }
    
    class func showError(_ error:String ,view:UIView) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = error
        hud.mode = .text
        hud.hide(animated: true, afterDelay: 1.5)
    }
    
}
