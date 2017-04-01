//
//  CloudStorageManager.swift
//  Coderpursue
//
//  Created by WengHengcong on 2017/4/1.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit
import AVOSCloud

class CloudStorageManager: NSObject {
    
    class func storageInit(){
        AVOSCloud.setApplicationId(LeanCloudAppID, clientKey: LeanCloudAppKey)
        // TODO: log关闭
        AVOSCloud.setAllLogsEnabled(true)
        
        //获取设置
        getAppRewardSwitch()
    }
    
    
    /// 设置reward的开关
    class func getAppRewardSwitch() {
        let query = AVQuery.init(className:CloudAppSetting)
        query.getObjectInBackground(withId: AppSettingsRewardObjectId) { (avobject, error) in
            UserManager.shared.rewarSwitch = avobject?["switch"] as? Bool
        }
    }
    
}
