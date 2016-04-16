//
//  ShareHelper.swift
//  Coderpursue
//
//  Created by WengHengcong on 4/16/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

class ShareContent: NSObject {
    
    var shareUrl:String?
    var shareImageUrl:String?
    var shareImage:UIImage?
    var shareContent:String?
    var shareTitle:String?
    
    
}

class ShareHelper: NSObject {
    
    static let sharedInstance = ShareHelper()
    
    func configShareSDKPlatforms() {
        UMSocialData.setAppKey(UMengSocailAppSecret)
    }
    
}
