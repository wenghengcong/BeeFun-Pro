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
    
    override init() {
        super.init()
    }
}

class ShareHelper: NSObject,UMSocialUIDelegate {
    
    static let sharedInstance = ShareHelper()
    
    var sourceType:ShareSource = .Defalult
    var shareContent:ShareContent? = ShareContent.init()
    var shareInViewController:UIViewController?
    
    var installedPlatforms:[String] {
        get {
            return checkPlatforms()
        }
    }
    
    func checkPlatforms()->[String]{
        
        var ps:[String] = []
        
        if WXApi.isWXAppInstalled() {
            ps.append(UMShareToWechatSession)
            ps.append(UMShareToWechatFavorite)
            ps.append(UMShareToWechatTimeline)
        }
        
        if QQApiInterface.isQQInstalled() {
            ps.append(UMShareToQQ)
            ps.append(UMShareToQzone)
        }
        
        if WeiboSDK.isWeiboAppInstalled() {
            ps.append(UMShareToSina)
        }
        
        return ps
    }
    
    func configUMSocailPlatforms() {
        
        UMSocialData.setAppKey(UMengAppSecret)
//        UMSocialData.openLog(true)
        
        UMSocialWechatHandler.setWXAppId(WeiXinSDKAppID, appSecret: WeiXinSDKAppSecret, url: SocailRedirectURL)
        UMSocialQQHandler.setQQWithAppId(TencentSDKAppID, appKey: TencentSDKAppKey, url: SocailRedirectURL)
        UMSocialSinaSSOHandler.openNewSinaSSO(withAppKey: WeiboSDKAppKey, secret: WeiboSDKAppSecret, redirectURL: SocailRedirectURL)
        UMSocialFacebookHandler.setFacebookAppID(FackbookSDKAppID, shareFacebookWithURL: SocailRedirectURL)
        
        // TwitterSDK仅在iOS7.0以上有效，在iOS 6.x上自动调用系统内置Twitter授权
        UMSocialTwitterHandler.setTwitterAppKey(TwitterSDKConsumerKey, withSecret: TwitterSDKConsumerSecret)
        UMSocialTwitterHandler.openTwitter()

        
    }
    
    /**
     分享公共方法
     
     - parameter viewController: 当前要分享的页面
     - parameter content:        分享内容（当分享为app是，可传nil）
     - parameter soucre:         分享来源
     */
    func shareContentInView(_ viewController:UIViewController, content:ShareContent ,soucre:ShareSource) {
        
        shareContent = nil
        sourceType = soucre
        
        shareInViewController = viewController
        
        switch sourceType {
        case .Defalult:
            break
        case .App:
           shareApp()
           return
        case .Repository:
            break
        case .User:
            break
        }
        
        if ( (content.shareTitle != nil) || (content.shareContent != nil) ) {
            shareContent = content
            let allPlatforms:[String] = [UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToFacebook]

            UMSocialConfig.hiddenNotInstallPlatforms(allPlatforms)
            UMSocialSnsService.presentSnsIconSheetView(viewController, appKey: UMengAppSecret, shareText: shareContent!.shareContent, shareImage: shareContent!.shareImage, shareToSnsNames: allPlatforms, delegate: self)
        }else{
            //假如传入的内容为空，那么就分享app
            shareApp()
            return
        }
        
    }

    
    func shareApp() {
        
        sourceType = .App
        
        let shareModel:ShareContent = ShareContent.init()
        shareModel.shareUrl = SocailRedirectURL
        shareModel.shareContent = "Coderpursue，Github第三方客户端，使用最新的Swift语言编写，目前已开源。"
        shareModel.shareTitle = "Coderpursue，代码的快乐"
        shareModel.shareImage = UIImage(named: "app_logo_90")
        
        shareContent = shareModel
        
        let allPlatforms:[String] = [UMShareToSina,UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToFacebook]
        
        UMSocialConfig.hiddenNotInstallPlatforms(allPlatforms)
        
        UMSocialSnsService.presentSnsIconSheetView(shareInViewController, appKey: UMengAppSecret, shareText: shareModel.shareContent, shareImage: shareModel.shareImage, shareToSnsNames: allPlatforms, delegate: self)
        
    }
    
    
    /**
     关闭当前页面之后
     @param fromViewControllerType 关闭的页面类型
     
     */
    func didCloseUIViewController(_ fromViewControllerType: UMSViewControllerType) {
        
    }
    /**
     各个页面执行授权完成、分享完成、或者评论完成时的回调函数
     @param response 返回`UMSocialResponseEntity`对象，`UMSocialResponseEntity`里面的viewControllerType属性可以获得页面类型
     */
    func didFinishGetUMSocialData(inViewController response: UMSocialResponseEntity!) {
        
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
    
    func didSelectSocialPlatform(_ platformName: String!, with socialData: UMSocialData!) {
        
        switch sourceType {
            case .Defalult:
                break
            case .App:
                
                if (platformName == UMShareToQQ || platformName == UMShareToQzone) {
                    return
                }else if (platformName == UMShareToFacebook ) {
                    shareContent!.shareTitle = "Happy Coding,Happy Here~"
                    shareContent!.shareContent = "Coderpursue，a Github 3rd client for iOS。It's written in lastest version Swift. https://github.com/wenghengcong/Coderpursue"
                    socialData.title = shareContent!.shareTitle
                    socialData.shareText = shareContent!.shareContent
                    let urlS:UMSocialUrlResource = UMSocialUrlResource()
                    urlS.url = SocailRedirectURL
                    urlS.resourceType = UMSocialUrlResourceTypeWeb
                    socialData.urlResource = urlS
                    
                    return
                }else if(platformName == UMShareToTwitter){
                    shareContent!.shareTitle = "Happy Coding,Happy Here~"
                    shareContent!.shareContent = "Coderpursue，a Github 3rd client for iOS。It's written in lastest version Swift. https://github.com/wenghengcong/Coderpursue"
                    socialData.title = shareContent!.shareTitle
                    socialData.shareText = shareContent!.shareContent
                }else{
                    
            }

            case .Repository:
                break
            case .User:
                break
        }
        
        let extConfig:UMSocialExtConfig = UMSocialExtConfig.init()
        // you have set shareImage, which will be invalid, for you set the urlResource!
        socialData.title = shareContent!.shareTitle
        socialData.shareText = shareContent!.shareContent
        
        if let image =  shareContent!.shareImage {
            socialData.shareImage = image
        }
        socialData.extConfig = extConfig
        
        //为各个平台单独配置分享资源
        if (platformName == UMShareToFacebook) {

            let facebookData:UMSocialFacebookData = UMSocialFacebookData()
            facebookData.url = shareContent!.shareUrl
            facebookData.linkDescription = shareContent!.shareContent
            facebookData.title = shareContent!.shareTitle
            extConfig.facebookData = facebookData
            
        }else if(platformName == UMShareToTwitter){

            let twitterData:UMSocialTwitterData = UMSocialTwitterData()
            extConfig.twitterData = twitterData
        }else if(platformName == UMShareToQzone){

            let qzoneData:UMSocialQzoneData = UMSocialQzoneData()
            extConfig.qzoneData = qzoneData
            qzoneData.url = shareContent!.shareUrl
            qzoneData.title = shareContent!.shareTitle
            qzoneData.shareText = shareContent!.shareContent
            socialData.extConfig = extConfig
            
        }else if(platformName == UMShareToQQ){

            let qqData:UMSocialQQData = UMSocialQQData()
            qqData.url = shareContent!.shareUrl
            qqData.title = shareContent!.shareTitle
            qqData.shareText = shareContent!.shareContent
            extConfig.qqData = qqData
            
        }else if(platformName == UMShareToWechatSession){

            let chatSessionData:UMSocialWechatSessionData = UMSocialWechatSessionData()
            chatSessionData.title = shareContent?.shareTitle
            chatSessionData.wxMessageType = UMSocialWXMessageTypeWeb
            chatSessionData.url = shareContent?.shareUrl
            extConfig.wechatSessionData = chatSessionData
        }else if(platformName == UMShareToWechatTimeline){

            let timeLineData:UMSocialWechatTimelineData = UMSocialWechatTimelineData()
            timeLineData.title = shareContent?.shareTitle
            timeLineData.wxMessageType = UMSocialWXMessageTypeWeb
            timeLineData.url = shareContent?.shareUrl
            extConfig.wechatTimelineData = timeLineData
        }else if(platformName == UMShareToWechatFavorite){

            let favouriteData:UMSocialWechatFavorite = UMSocialWechatFavorite()
            favouriteData.title = shareContent?.shareTitle
            favouriteData.wxMessageType = UMSocialWXMessageTypeWeb
            favouriteData.url = shareContent?.shareUrl
            extConfig.wechatFavoriteData = favouriteData
            
        }else if(platformName == UMShareToSina){

            let sinaData:UMSocialSinaData = UMSocialSinaData()
            sinaData.urlResource.url = shareContent!.shareUrl
            sinaData.urlResource.resourceType = UMSocialUrlResourceTypeWeb
            extConfig.sinaData = sinaData
        }
        
    }
    
}
