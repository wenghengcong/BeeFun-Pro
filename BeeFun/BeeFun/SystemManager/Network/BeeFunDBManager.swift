//
//  BeeFunDBManager.swift
//  BeeFun
//
//  Created by WengHengcong on 2018/5/14.
//  Copyright © 2018年 JungleSong. All rights reserved.
//

import UIKit
import ObjectMapper

class BeeFunDBManager: NSObject {
    
    static let shared = BeeFunDBManager()
    var lastTimeStampKey = "lastUpdateFromGithub"
    
    func updateServerDB(showTips: Bool, first: Bool) {
        if !UserManager.shared.needLoginAlert() {
            return
        }
        if showTips {
            NotificationCenter.default.post(name: NSNotification.Name.BeeFun.SyncStarRepoStart, object: nil)
        }
        let nowDate = Date().timeStamp
        let lastUpdate = UserDefaults.standard.integer(forKey: lastTimeStampKey)
        if (nowDate - lastUpdate > 1 * 24 * 60 * 60) || first {
            updateRequest(showTips: showTips, first: first, update: true)
        } else {
            updateRequest(showTips: showTips, first: first, update: false)
        }
    }
    
    /// 更新请求
    ///
    /// - Parameter update: 是否更新所有已经在server db存在repo的信息
    func updateRequest(showTips: Bool, first: Bool, update: Bool) {
        
        BeeFunProvider.sharedProvider.request(BeeFunAPI.updateServerDB(first: first, update: update)) { (result) in
            switch result {
            case let .success(response):
                do {
                    if let tagResponse: BeeFunResponseModel = Mapper<BeeFunResponseModel>().map(JSONObject: try response.mapJSON()) {
                        if let code = tagResponse.codeEnum, code == BFStatusCode.bfOk {
                            if showTips {
                                NotificationCenter.default.post(name: NSNotification.Name.BeeFun.SyncStarRepoEnd, object: nil)
                            }
                            if update {
                                //添加成功
                                UserDefaults.standard.set(Date().timeStamp, forKey: self.lastTimeStampKey)
                            }
                        }
                    }
                } catch {
                }
            case .failure:
                break
            }
        }
    }
}
