//
//  ShareManager.swift
//  Coderpursue
//
//  Created by WengHengcong on 2017/3/10.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

public enum ShareSource:String {
    case defalult = "defalut"
    case app = "app"
    case repository = "repository"
    case user = "user"
}

class ShareContent: NSObject {
    
    var url:String?
    var URL:URL?
    var imageUrl:String?
    var image:UIImage?
    var content:String?
    var title:String?
    
    override init() {
        super.init()
    }
}

class ShareManager: NSObject {
    
    static let shared = ShareManager()

    var sourceType:ShareSource = .defalult
    var shareContent:ShareContent? = ShareContent.init()
    var shareInViewController:UIViewController?
    
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    func registerAppWithPlatforms() {
        
        let platforms = [SSDKPlatformType.typeSinaWeibo.rawValue,
                         SSDKPlatformType.typeWechat.rawValue,
                         SSDKPlatformType.typeQQ.rawValue,
                         SSDKPlatformType.subTypeQZone.rawValue,
                         SSDKPlatformType.typeFacebook.rawValue,
                         SSDKPlatformType.typeTwitter.rawValue,
                         SSDKPlatformType.typeSMS.rawValue,
                         SSDKPlatformType.typeCopy.rawValue,
                         SSDKPlatformType.subTypeWechatTimeline.rawValue,
                         SSDKPlatformType.subTypeQQFriend.rawValue,
                         SSDKPlatformType.subTypeWechatFav.rawValue,
                         //new add
                         SSDKPlatformType.typeYouDaoNote.rawValue,
                         SSDKPlatformType.typeDingTalk.rawValue,
                         SSDKPlatformType.typeLinkedIn.rawValue
                         ]
        
        ShareSDK.registerApp(ShareSDKAppKey, activePlatforms: platforms, onImport: { (platform : SSDKPlatformType) in
            // onImport 里的代码,需要连接社交平台SDK时触发
            switch platform
            {
            case .typeSinaWeibo:
                ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
                break
            case .typeWechat:
                ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                break
            case .typeQQ:
                ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                break
            default:
                break
            }
            
        }) { (platform:SSDKPlatformType , appInfo) -> Void in
            
            switch platform
            {
            case .typeSinaWeibo:
                //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                appInfo?.ssdkSetupSinaWeibo(byAppKey:WeiboSDKAppKey,appSecret : WeiboSDKAppSecret,redirectUri :SocailRedirectURL,authType : SSDKAuthTypeBoth)
                
            case .typeWechat:
                appInfo?.ssdkSetupWeChat(byAppId: WeiXinSDKAppID, appSecret: WeiXinSDKAppSecret)
                
                
            case .typeFacebook:
                //设置Facebook应用信息，其中authType设置为只用SSO形式授权
                appInfo?.ssdkSetupFacebook(byApiKey: FackbookSDKAppID, appSecret: FackbookSDKAppSecret, authType: SSDKAuthTypeBoth)
                
                
            case .typeTwitter:
                //设置Twitter应用信息
                appInfo?.ssdkSetupTwitter(byConsumerKey: TwitterSDKConsumerKey,
                                                      consumerSecret : TwitterSDKConsumerSecret,
                                                      redirectUri : SocailRedirectURL)
                
            case .typeQQ:
                //设置QQ应用信息
                appInfo?.ssdkSetupQQ(byAppId: TencentSDKAppID,
                                           appKey : TencentSDKAppKey,
                                           authType : SSDKAuthTypeBoth)
            case .typeLinkedIn:
                //设置LinkedIn应用信息
                appInfo?.ssdkSetupLinkedIn(byApiKey: LinkedInSDKAppID, secretKey: LinkedInSDKAppSecret, redirectUrl: SocailRedirectURL)
                
            case .typeYouDaoNote:
                //设置YouDaoNote应用信息
                appInfo?.ssdkSetupYouDaoNote(byConsumerKey:YDNoteSDKConsumerKey, consumerSecret: YDNoteSDKConsumerSecret, oauthCallback: SocailRedirectURL)
            case .typeDingTalk:
                appInfo?.ssdkSetupDingTalk(byAppId: DingTalkSDKAppID)
                
            default:
                break
            }
            
        }
    }
    
    func shareDemo() {
        
        // 1.创建分享参数
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: "分享内容",
                                          images : UIImage(named: "shareImg.png"),
                                          url : NSURL(string:"http://mob.com") as URL!,
                                          title : "分享标题",
                                          type : SSDKContentType.image)
        
        //2.进行分享
        ShareSDK.share(SSDKPlatformType.typeSinaWeibo, parameters: shareParames) { (state : SSDKResponseState, nil, entity : SSDKContentEntity?, error :Error?) in
            
            switch state{
                
            case SSDKResponseState.success: print("分享成功")
            case SSDKResponseState.fail:    print("授权失败,错误描述:\(error)")
            case SSDKResponseState.cancel:  print("操作取消")
                
            default:
                break
            }
            
        }
    }
    
    func shareApp() {
        
        sourceType = .app
        
        let shareModel:ShareContent = ShareContent.init()
        shareModel.url = SocailRedirectURL
        shareModel.URL = URL.init(string: shareModel.url!)
        shareModel.content = "Coderpursue，Github第三方客户端，使用最新的Swift语言编写，目前已开源。"
        shareModel.title = "Coderpursue，代码的快乐"
        shareModel.image = UIImage(named: "app_logo_90")
        
        shareContent = shareModel
    }
    
    func shareParamsWithDifferentPlatforms() -> NSMutableDictionary {
        
        shareApp()
        let shareParams:NSMutableDictionary = NSMutableDictionary.init()
        shareParams.ssdkSetupShareParams(byText: shareContent?.content, images: [shareContent?.image], url: shareContent?.URL as URL!, title: shareContent?.title, type:.app)
        return shareParams
    }
    
    func share(source:ShareSource ,content:ShareContent ,view:UIView) {
        
        //1、创建分享参数（必要）
        let shareParams = shareParamsWithDifferentPlatforms()
        //2、分享
        ShareSDK.showShareActionSheet(view, items: nil, shareParams: shareParams) { (responState, platflor, array, contentEntity, error, result:Bool) in
            
        }

    }
}
