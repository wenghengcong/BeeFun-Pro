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

    
    /// 显示信息
    ///
    /// - Parameter message: <#message description#>
    class func showMessage(_ message:String) {
        showMessage(message, view: jsTopView!)
    }
    
    
    /// 显示信息
    ///
    /// - Parameters:
    ///   - message: <#message description#>
    ///   - view: <#view description#>
    class func showMessage(_ message:String ,view:UIView) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = message
        hud.mode = .text
        hud.hide(animated: true, afterDelay: 1.5)
    }
    
    /// 显示错误信息
    ///
    /// - Parameter error: <#error description#>
    class func showError(_ error:String) {
        showError(error, view: jsTopView!)
    }
    
    /// 显示错误信息
    ///
    /// - Parameters:
    ///   - error: <#error description#>
    ///   - view: <#view description#>
    class func showError(_ error:String ,view:UIView) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = error
        hud.mode = .text
        hud.hide(animated: true, afterDelay: 1.5)
    }
    
}
