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
    
    /// 显示Hud
    class func showHudInWindow() {
        showHud(view: jsKeywindow!)
    }
    
    /// 隐藏Hud
    class func hideHudInWindow() {
        hideHud(view: jsKeywindow!)
    }
    
    
    /// 显示Hud
    class func showHud(view:UIView) {
        MBProgressHUD.showAdded(to: view, animated: true)
    }
    
    /// 隐藏Hud
    class func hideHud(view:UIView) {
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    /// 显示信息
    ///
    /// - Parameter message: <#message description#>
    class func showMessage(_ message:String) {
        showMessage(message, view: jsTopView!)
    }
    
    /// 在window上显示信息
    ///
    /// - Parameter message: <#message description#>
    class func showMessageInWindow(_ message:String){
        showMessage(message, view: jsKeywindow!)
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
    
    /// 在window上显示错误信息
    ///
    /// - Parameter message: <#message description#>
    class func showErrorInWindow(_ message:String){
        showError(message, view: jsKeywindow!)
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
