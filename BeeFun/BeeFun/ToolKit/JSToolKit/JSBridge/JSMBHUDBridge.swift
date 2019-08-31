//
//  MBProgressHud+JS.swift
//  BeeFun
//
//  Created by WengHengcong on 10/10/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import MBProgressHUD

class JSMBHUDBridge {
    
    static let MBHudHideDelay: TimeInterval = 1.35
    
    class func mbProgressHud(message: String?, view: UIView?) -> MBProgressHUD {
        var hud: MBProgressHUD? = nil
        if view == nil {
            hud = MBProgressHUD.showAdded(to: BFTabbarManager.jsKeywindow!, animated: true)
        } else {
            hud = MBProgressHUD.showAdded(to: view!, animated: true)
        }
        if message != nil {
            hud?.label.text = message
        }
        hud?.minShowTime = 0.25
        hud?.label.font = UIFont.bfSystemFont(ofSize: 15.0)
        hud?.removeFromSuperViewOnHide = true
        hud?.isUserInteractionEnabled = false
        return hud!
    }
    
    // MARK: - Show Indeterminate Hud
    class func showHud(view: UIView) -> MBProgressHUD {
        let hud = mbProgressHud(message: nil, view: view)
        return hud
    }
    
    class func showHud() -> MBProgressHUD {
        let hud = mbProgressHud(message: nil, view: BFTabbarManager.jsKeywindow)

        return hud
    }
    
    // MARK: - Show Text
    class func showText(_ message: String) {
        showText(message, time: MBHudHideDelay)
    }
    
    class func showText(_ message: String, time: TimeInterval) {
        showText(message, view: BFTabbarManager.jsKeywindow!, time: time)
    }
    
    class func showText(_ message: String, view: UIView) {
        showText(message, view: view, time: MBHudHideDelay)
    }
    
    class func showText(_ message: String, view: UIView, time: TimeInterval) {
        DispatchQueue.main.async {
            let hud = mbProgressHud(message: message, view: view)
            hud.mode = .text
            hud.hide(animated: true, afterDelay: time)
        }
    }
    
    // MARK: - Show Custom View
    
    class func showImage(_ message: String, icon: String, view: UIView) {
        showImage(message, icon: icon, view: view, time: MBHudHideDelay)
    }
    
    class func showImage(_ message: String, icon: String, time: TimeInterval) {
        showImage(message, icon: icon, view: BFTabbarManager.jsKeywindow!, time: MBHudHideDelay)
    }
    
    class func showImage(_ message: String, icon: String, view: UIView, time: TimeInterval) {
        DispatchQueue.main.async {
            let hud = mbProgressHud(message: message, view: view)
            hud.customView = UIImageView(image: UIImage(named: icon))
            hud.mode = .customView
            hud.minShowTime = 0.35
            hud.hide(animated: true, afterDelay: time)
        }
    }
    
    // MARK: - Hide
    class func hideHud(view: UIView) {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    
    class func hideHud(hud: MBProgressHUD) {
        DispatchQueue.main.async {
            hud.hide(animated: true)
        }
    }
    
    /// 隐藏当前页面所有的hud
    class func hideAllHudInView(view: UIView) {
        DispatchQueue.main.async {
            MBProgressHUD.hideAllHUDs(for: view, animated: true)
        }
    }
}

extension JSMBHUDBridge {
    // MARK: - 各种类型的弹窗
    // MARK: Info
    
    class func showInfo(_ message: String, view: UIView) {
        showInfo(message, view: view, time: MBHudHideDelay)
    }
    
    class func showInfo(_ message: String) {
        showInfo(message, time: MBHudHideDelay)
    }

    class func showInfo(_ message: String, view: UIView, time: TimeInterval) {
        showImage(message, icon: "jsmb_info", view: view, time: time)
    }
    
    class func showInfo(_ message: String, time: TimeInterval) {
        showImage(message, icon: "jsmb_info", time: time)
    }
    
    // MARK: Error
    class func showError(_ message: String, view: UIView) {
        showError(message, view: view, time: MBHudHideDelay)
    }
    
    class func showError(_ message: String) {
        showInfo(message, time: MBHudHideDelay)
    }
    
    class func showError(_ message: String, view: UIView, time: TimeInterval) {
        showImage(message, icon: "jsmb_error", view: view, time: time)
    }
    
    class func showError(_ message: String, time: TimeInterval) {
        showImage(message, icon: "jsmb_error", time: time)
    }
    
    // MARK: Success
    class func showSuccess(_ message: String) {
        showSuccess(message, time: MBHudHideDelay)
    }
    
    class func showSuccess(_ message: String, view: UIView) {
        showSuccess(message, view: view, time: MBHudHideDelay)
    }

    class func showSuccess(_ message: String, view: UIView, time: TimeInterval) {
        showImage(message, icon: "jsmb_success", view: view, time: time)
    }
    
    class func showSuccess(_ message: String, time: TimeInterval) {
        showImage(message, icon: "jsmb_success", time: time)
    }
    
    // MARK: Warn
    class func showWarn(_ message: String, view: UIView) {
        showWarn(message, view: view, time: MBHudHideDelay)
    }
    
    class func showWarn(_ message: String) {
        showWarn(message, time: MBHudHideDelay)
    }
    class func showWarn(_ message: String, view: UIView, time: TimeInterval) {
        showImage(message, icon: "", view: view, time: time)
    }
    
    class func showWarn(_ message: String, time: TimeInterval) {
        showImage(message, icon: "", time: time)
    }
    
}
