//
//  BFMonitor+Handle.swift
//  BeeFun
//
//  Created by WengHengcong on 2018/1/25.
//  Copyright © 2018年 LuCi. All rights reserved.
//

extension BFMonitor {
    
    /// 登陆成功
    @objc func userLogin(noti: NSNotification) {
        BeeFunDBManager.shared.updateServerDB(showTips: true, first: true)
        AnswerManager.logLogin(method: "Github", success: true, attributes: [:])
    }
    
    /// 登出成功
    @objc func userLogout(noti: NSNotification) {

    }
    
    @objc func syncStar() {
        JSMBHUDBridge.showText("Sync start".localized)
    }
    
    @objc func syncEnd() {
        JSMBHUDBridge.showText("Sync end".localized)
    }
}
