//
//  ShareHelper.swift
//  Coderpursue
//
//  Created by WengHengcong on 4/16/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

public enum ShareSource:String {
    case Defalult = "defalut"
    case App = "app"
    case Repository = "repository"
    case User = "user"
}

class ShareContent: NSObject {
    
    var shareUrl:String?
    var shareImageUrl:String?
    var shareImage:UIImage?
    var shareContent:String?
    var shareTitle:String?
    
    
}

class ShareHelper: NSObject,UMSocialUIDelegate {
    
    static let sharedInstance = ShareHelper()
    
    var sourceType:ShareSource = .Defalult
    var shareContent:ShareContent = ShareContent()
    
    func configUMSocailPlatforms() {
        
        UMSocialData.setAppKey(UMengSocailAppSecret)
        
        UMSocialWechatHandler.setWXAppId(WeiXinSDKAppID, appSecret: WeiXinSDKAppSecret, url: SocailRedirectURL)
        UMSocialQQHandler.setQQWithAppId(TencentSDKAppID, appKey: TencentSDKAppKey, url: SocailRedirectURL)
        UMSocialSinaSSOHandler.openNewSinaSSOWithAppKey(WeiboSDKAppKey, secret: WeiboSDKAppSecret, redirectURL: SocailRedirectURL)
        UMSocialFacebookHandler.setFacebookAppID(FackbookSDKAppID, shareFacebookWithURL: SocailRedirectURL)
        // TwitterSDK仅在iOS7.0以上有效，在iOS 6.x上自动调用系统内置Twitter授权
        if iOSVersion.IOS7Above {
            UMSocialTwitterHandler.setTwitterAppKey(TwitterSDKConsumerKey, withSecret: TwitterSDKConsumerSecret)
        }
        
    }
    
    func shareContent(viewController:UIViewController, content:ShareContent ,soucre:ShareSource) {
        
        sourceType = soucre
        shareContent = content
        
        let allPlatforms:[String] = [UMShareToSina,UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToFacebook,UMShareToTwitter]
        
        UMSocialConfig.hiddenNotInstallPlatforms(allPlatforms)

        UMSocialSnsService.presentSnsIconSheetView(viewController, appKey: UMengSocailAppSecret, shareText: content.shareContent, shareImage: content.shareImage, shareToSnsNames: allPlatforms, delegate: self)
        
    }
    
    func shareApp(viewController:UIViewController) {
        
        sourceType = .App
        
        let shareModel:ShareContent = ShareContent()
        shareModel.shareUrl = SocailRedirectURL
        shareModel.shareContent = "Coderpursue，Github第三方客户端，使用最新的Swift语言编写，目前已开源。"
        shareModel.shareTitle = "Coderpursue代码的快乐"
        shareModel.shareImage = UIImage(named: "app_logo_90")
        
        let allPlatforms:[String] = [UMShareToSina,UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToFacebook,UMShareToTwitter]
        
        UMSocialConfig.hiddenNotInstallPlatforms(allPlatforms)
        
        UMSocialSnsService.presentSnsIconSheetView(viewController, appKey: UMengSocailAppSecret, shareText: shareModel.shareContent, shareImage: shareModel.shareImage, shareToSnsNames: allPlatforms, delegate: self)
        
    }
    
    
    /**
     关闭当前页面之后
     @param fromViewControllerType 关闭的页面类型
     
     */
    func didCloseUIViewController(fromViewControllerType: UMSViewControllerType) {
        
    }
    /**
     各个页面执行授权完成、分享完成、或者评论完成时的回调函数
     @param response 返回`UMSocialResponseEntity`对象，`UMSocialResponseEntity`里面的viewControllerType属性可以获得页面类型
     */
    func didFinishGetUMSocialDataInViewController(response: UMSocialResponseEntity!) {
        
    }
    
    /**
     点击分享列表页面，之后的回调方法，你可以通过判断不同的分享平台，来设置分享内容。
     例如：
     
     -(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
     {
     if (platformName == UMShareToSina) {
     socialData.shareText = @"分享到新浪微博的文字内容";
     }
     else{
     socialData.shareText = @"分享到其他平台的文字内容";
     }
     }
     
     @param platformName 点击分享平台
     
     @prarm socialData   分享内容
     */
    func didSelectSocialPlatform(platformName: String!, withSocialData socialData: UMSocialData!) {
        
        let urlSources:UMSocialUrlResource = UMSocialUrlResource()

        switch sourceType {
            case .Defalult:
                urlSources.resourceType = UMSocialUrlResourceTypeDefault
            case .App:
                urlSources.resourceType = UMSocialUrlResourceTypeWeb
                urlSources.url = SocailRedirectURL
            case .Repository:
                urlSources.resourceType = UMSocialUrlResourceTypeWeb
                urlSources.url = SocailRedirectURL
            case .User:
                urlSources.resourceType = UMSocialUrlResourceTypeWeb
                urlSources.url = SocailRedirectURL
            
        }
        
        let extConfig:UMSocialExtConfig = UMSocialExtConfig()

        if (platformName == UMShareToFacebook) {
            socialData.title = "Happy Coding,Happy Here~"
            socialData.shareText = "Coderpursue，a Github 3rd client for iOS。It's written in lastest version Swift. https://github.com/wenghengcong/Coderpursue";
            socialData.urlResource = urlSources
            let facebookData:UMSocialFacebookData = UMSocialFacebookData()
            extConfig.facebookData = facebookData
            socialData.extConfig = extConfig
            
        }else if(platformName == UMShareToTwitter){
            socialData.title = "Happy Coding,Happy Here~"
            socialData.shareText = "Coderpursue，a Github 3rd client for iOS。It's written in lastest version Swift. https://github.com/wenghengcong/Coderpursue";
            socialData.urlResource = urlSources
            let twitterData:UMSocialTwitterData = UMSocialTwitterData()
            extConfig.twitterData = twitterData
            socialData.extConfig = extConfig
        }else if(platformName == UMShareToQzone){
            socialData.title = "Happy Coding,Happy Here~"
            socialData.shareText = "Coderpursue，a Github 3rd client for iOS。It's written in lastest version Swift. https://github.com/wenghengcong/Coderpursue";
            socialData.urlResource = urlSources
            let qzoneData:UMSocialQzoneData = UMSocialQzoneData()
            extConfig.qzoneData = qzoneData
            socialData.extConfig = extConfig
        }else if(platformName == UMShareToQQ){
            socialData.title = "Happy Coding,Happy Here~"
            socialData.shareText = "Coderpursue，a Github 3rd client for iOS。It's written in lastest version Swift. https://github.com/wenghengcong/Coderpursue";
            socialData.urlResource = urlSources
            let qqData:UMSocialQQData = UMSocialQQData()
            extConfig.qqData = qqData
            socialData.extConfig = extConfig
        }else if(platformName == UMShareToWechatSession){
            socialData.title = "Happy Coding,Happy Here~"
            socialData.shareText = "Coderpursue，a Github 3rd client for iOS。It's written in lastest version Swift. https://github.com/wenghengcong/Coderpursue";
            socialData.urlResource = urlSources
            let chatSessionData:UMSocialWechatSessionData = UMSocialWechatSessionData()
            extConfig.wechatSessionData = chatSessionData
            socialData.extConfig = extConfig
        }else if(platformName == UMShareToWechatTimeline){
            socialData.title = "Happy Coding,Happy Here~"
            socialData.shareText = "Coderpursue，a Github 3rd client for iOS。It's written in lastest version Swift. https://github.com/wenghengcong/Coderpursue";
            socialData.urlResource = urlSources
            let timeLineData:UMSocialWechatTimelineData = UMSocialWechatTimelineData()
            extConfig.wechatTimelineData = timeLineData
            socialData.extConfig = extConfig
        }else if(platformName == UMShareToWechatFavorite){
            socialData.title = "Happy Coding,Happy Here~"
            socialData.shareText = "Coderpursue，a Github 3rd client for iOS。It's written in lastest version Swift. https://github.com/wenghengcong/Coderpursue";
            socialData.urlResource = urlSources
            let favouriteData:UMSocialWechatFavorite = UMSocialWechatFavorite()
            extConfig.wechatFavoriteData = favouriteData
            socialData.extConfig = extConfig
        }else if(platformName == UMShareToSina){
            socialData.title = "Happy Coding,Happy Here~"
            socialData.shareText = "Coderpursue，a Github 3rd client for iOS。It's written in lastest version Swift. https://github.com/wenghengcong/Coderpursue";
            socialData.urlResource = urlSources
            let sinaData:UMSocialSinaData = UMSocialSinaData()
            extConfig.sinaData = sinaData
            socialData.extConfig = extConfig
        }
    
    }
    
}
