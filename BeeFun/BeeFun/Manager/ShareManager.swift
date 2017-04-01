//
//  ShareManager.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/3/10.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit


/// 分享状态的代理
protocol shareResponseProtocol {
    
    func didStateChange(state:SSDKResponseState,platform:SSDKPlatformType,userdata:[AnyHashable:Any]?,content:SSDKContentEntity?,error:Error?,end:Bool)
    func didShareBegin(state:SSDKResponseState,platform:SSDKPlatformType,userdata:[AnyHashable:Any]?,content:SSDKContentEntity?,error:Error?,end:Bool)
    func didShareSuccess(state:SSDKResponseState,platform:SSDKPlatformType,userdata:[AnyHashable:Any]?,content:SSDKContentEntity?,error:Error?,end:Bool)
    func didShareFail(state:SSDKResponseState,platform:SSDKPlatformType,userdata:[AnyHashable:Any]?,content:SSDKContentEntity?,error:Error?,end:Bool)
     func didShareCancel(state:SSDKResponseState,platform:SSDKPlatformType,userdata:[AnyHashable:Any]?,content:SSDKContentEntity?,error:Error?,end:Bool)
}

public enum ShareSource:String {
    case defalult = "defalut"
    case app = "app"
    case repository = "repository"
    case user = "user"
}

class ShareContent: NSObject {
    
    var source:ShareSource = .defalult
    
    /// 分享链接
    var url:String?
    
    /// 分享链接
    var URL:URL?
    
    /// 分享标题
    var title:String?
    
    /// 分享内容
    var content:String?
    
    ///分享图片
    var image:AnyObject?
    
    ///分享图片数组
    var images:[AnyObject]?
    
    ///分享内容类型
    var contentType:SSDKContentType?
    
    override init() {
        super.init()
    }
}

class ShareManager: NSObject {
    
    static let shared = ShareManager()

    var shareContent:ShareContent? = ShareContent.init()
    var shareInViewController:UIViewController?
    var delegate:shareResponseProtocol?
    var showPlatforms = [
        SSDKPlatformType.typeSinaWeibo.rawValue,   //微博
        SSDKPlatformType.typeWechat.rawValue,      //微信
        SSDKPlatformType.typeTwitter.rawValue,     //twitter
        SSDKPlatformType.typeFacebook.rawValue,    //facebook
        //SSDKPlatformType.typeCopy.rawValue,        //copy
        //SSDKPlatformType.typeSMS.rawValue,         //sms
        SSDKPlatformType.typeQQ.rawValue,          //QQ
        SSDKPlatformType.subTypeQZone.rawValue,    //QQ空间
        SSDKPlatformType.subTypeQQFriend.rawValue, //QQ好友
        SSDKPlatformType.subTypeWechatTimeline.rawValue,   //微信朋友圈
        SSDKPlatformType.subTypeWechatFav.rawValue         //微信收藏
        //new add
        //SSDKPlatformType.typeYouDaoNote.rawValue,
        //SSDKPlatformType.typeDingTalk.rawValue,
        //SSDKPlatformType.typeLinkedIn.rawValue
    ]
    
    
    // MARK: - 公共方法
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    // MARK: 注册
    /// 注册
    func register() {
        
        ShareSDK.registerApp(ShareSDKAppKey, activePlatforms: showPlatforms, onImport: { (platform : SSDKPlatformType) in
            // onImport 里的代码,需要连接社交平台SDK时触发
            switch platform
            {
            case .typeSinaWeibo:
                ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
            case .typeWechat:
                ShareSDKConnector.connectWeChat(WXApi.classForCoder())
            case .typeQQ:
                ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
            default:
                break
            }
            
        }) { (platform:SSDKPlatformType , appInfo) -> Void in
            
            switch platform
            {
            case .typeSinaWeibo:
                //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                appInfo?.ssdkSetupSinaWeibo(byAppKey:WeiboSDKAppKey,appSecret : WeiboSDKAppSecret,redirectUri :SocialAppStore,authType : SSDKAuthTypeBoth)
            case .typeWechat:
                appInfo?.ssdkSetupWeChat(byAppId: WeiXinSDKAppID, appSecret: WeiXinSDKAppSecret)
            case .typeFacebook:
                //设置Facebook应用信息，其中authType设置为只用SSO形式授权
                appInfo?.ssdkSetupFacebook(byApiKey: FackbookSDKAppID, appSecret: FackbookSDKAppSecret, authType: SSDKAuthTypeBoth)
            case .typeTwitter:
                //设置Twitter应用信息
                appInfo?.ssdkSetupTwitter(byConsumerKey: TwitterSDKConsumerKey,consumerSecret : TwitterSDKConsumerSecret,redirectUri : SocialAppStore)
            case .typeQQ:
                //设置QQ应用信息
                appInfo?.ssdkSetupQQ(byAppId: TencentSDKAppID,appKey : TencentSDKAppKey,authType : SSDKAuthTypeBoth)
                /*
            case .typeLinkedIn:
                //设置LinkedIn应用信息
                appInfo?.ssdkSetupLinkedIn(byApiKey: LinkedInSDKAppID, secretKey: LinkedInSDKAppSecret, redirectUrl: SocailRedirectURL)
                
            case .typeYouDaoNote:
                //设置YouDaoNote应用信息
                appInfo?.ssdkSetupYouDaoNote(byConsumerKey:YDNoteSDKConsumerKey, consumerSecret: YDNoteSDKConsumerSecret, oauthCallback: SocailRedirectURL)
            case .typeDingTalk:
                appInfo?.ssdkSetupDingTalk(byAppId: DingTalkSDKAppID)
                */
            default:
                break
            }
            
        }
    }
    
    // MARK: share方法
    /// share方法
    ///
    /// - Parameter content: 分享方法
    func share(content:ShareContent) {
        
        print((content.source))
        shareContent = content
        
        //1、创建分享参数（必要）
        let shareParams = shareParamsWithDifferentPlatforms()
        
        //2、分享视图的定制
        SSUIShareActionSheetStyle.setShareActionSheetStyle(.simple)
        
        //3、分享
        ShareSDK.showShareActionSheet(jsTopView!, items: showPlatforms, shareParams: shareParams) { (state, platform, userdata, entity : SSDKContentEntity?, error :Error?, end:Bool) in
            
            if let method = self.delegate?.didStateChange(state: platform: userdata: content: error: end:){
                method(state,platform,userdata,entity,error,end)
                return
            }
            
            switch state{
            case .begin:
                print("开始分享")
                if let method = self.delegate?.didShareBegin(state: platform: userdata: content: error: end:){
                    method(state,platform,userdata,entity,error,end)
                }
            case SSDKResponseState.success:
                print("分享成功")
                JSMBHUDBridge.showMessage("Share Success".localized, view: jsKeywindow!)
                if let method = self.delegate?.didShareSuccess(state: platform: userdata: content: error: end:){
                    method(state,platform,userdata,entity,error,end)
                }
            case SSDKResponseState.fail:
                print("授权失败,错误描述:\(String(describing: error))")
                JSMBHUDBridge.showError("Share Failure".localized, view: jsKeywindow!)
                if let method = self.delegate?.didShareFail(state: platform: userdata: content: error: end:){
                    method(state,platform,userdata,entity,error,end)
                }
            case SSDKResponseState.cancel:
                print("操作取消")
                JSMBHUDBridge.showMessage("Share Cancel".localized, view: jsKeywindow!)
                if let method = self.delegate?.didShareCancel(state: platform: userdata: content: error: end:){
                    method(state,platform,userdata,entity,error,end)
                }
            }
        }
        
    }
    
    // MARK: 分享APP
    /// 分享APP
    func shareApp() {
        
        let shareModel:ShareContent = ShareContent.init()
        shareModel.url = SocialAppStore
        shareModel.URL = URL.init(string: shareModel.url!)
        shareModel.content = "BeeFun，开源的Swift Github第三方客户端。"+ShortSocialAppStore
        shareModel.title = "BeeFun，代码爱好者"
        shareModel.image = UIImage(named: "app_logo_90")
        shareModel.contentType = .app
        shareModel.source = .app
        shareContent = shareModel
        
        share(content: shareContent!)
    }
    
    // MARK: - 分享的参数
    
    /// 分享的内容平台化定制
    ///
    /// - Returns: <#return value description#>
    func shareParamsWithDifferentPlatforms() -> NSMutableDictionary {
        
        //处理好ShareContet中的属性
        handleShareContet()
        
        var text = shareContent?.content
        let image = shareContent?.image
        let images = shareContent?.images

        let sURL = shareContent?.URL
        let title = shareContent?.title
        let contentType:SSDKContentType = (shareContent?.contentType)!
        
        let shareParams:NSMutableDictionary = NSMutableDictionary.init()
        shareParams.ssdkSetupShareParams(byText: text, images: images, url: sURL, title: title, type:.auto)
        
        
        //微信
        shareParams.ssdkSetupWeChatParams(byText: text, title: title, url: sURL, thumbImage: nil, image: image, musicFileURL: nil, extInfo: nil, fileData: nil, emoticonData: nil, sourceFileExtension: nil, sourceFileData: nil, type: contentType, forPlatformSubType: .subTypeWechatSession)
        
        shareParams.ssdkSetupWeChatParams(byText: text, title: title, url: sURL, thumbImage: nil, image: image, musicFileURL: nil, extInfo: nil, fileData: nil, emoticonData: nil, sourceFileExtension: nil, sourceFileData: nil, type: contentType, forPlatformSubType: .subTypeWechatFav)

        shareParams.ssdkSetupWeChatParams(byText: text, title: title, url: sURL, thumbImage: nil, image: image, musicFileURL: nil, extInfo: nil, fileData: nil, emoticonData: nil, sourceFileExtension: nil, sourceFileData: nil, type: contentType, forPlatformSubType: .subTypeWechatTimeline)

        //QQ
        //只支持Text、Image、WebPage、Audio、Video
        //shareParams.ssdkSetupQQParams(byText: text, title: title, url: sURL, audioFlash: nil, videoFlash: nil, thumbImage: image, images: images, type: .auto, forPlatformSubType: .subTypeQQFriend)
        
        //Qzone
       //shareParams.ssdkSetupQQParams(byText: text, title: title, url: sURL, audioFlash: nil, videoFlash: nil, thumbImage: image, images: images, type: .auto, forPlatformSubType: .subTypeQZone)
        
        //微博
        // TODO: 经纬度
        //Text、Image、WebPage
        
        if shareContent?.source == .app {
            shareParams.ssdkSetupSinaWeiboShareParams(byText: text, title: title, image: images, url: sURL, latitude: 0.0, longitude: 0.0, objectID: nil, type: .auto)
        }else{
            shareParams.ssdkSetupSinaWeiboShareParams(byText: text, title: title, image: images, url: sURL, latitude: 0.0, longitude: 0.0, objectID: nil, type: .auto)
        }
        
        
        //英文
        // TODO: 经纬度
        if shareContent?.source == .app {
            //Twitter
            //Text、Image
            //Twitter支持140字符！！！
            let en_content = "BeeFun，an opensource swift github 3rd client for iOS."+ShortSocialAppStore
            let en_title = "BeeFun，Just Coding"
            
            shareParams.ssdkSetupTwitterParams(byText: en_content, images: images, latitude: 0.0, longitude: 0.0, type: .auto)

            
            //Facebook
            shareParams.ssdkSetupFacebookParams(byText: en_content, image: image, url: sURL, urlTitle: en_title, urlName: nil, attachementUrl: nil, type: .webPage)
        }else{
            
            if (text?.characters.count)! >= 140 {
                let index = text?.index((text?.startIndex)!, offsetBy: 140)
                text = text?.substring(to: index!)
                shareParams.ssdkSetupTwitterParams(byText: text, images: images, latitude: 0.0, longitude: 0.0, type: .auto)
            }
            
            shareParams.ssdkSetupFacebookParams(byText: text, image: image, url: sURL, urlTitle: title, urlName: nil, attachementUrl: nil, type: .auto)
        }
        
        return shareParams
    }
    
    
    /// 处理分享内容ShareContet的属性
    private func handleShareContet() {
        
        if shareContent == nil {
            return
        }
        
        //1.处理图片
        //先处理是否有本地的UIImage
        if shareContent?.image != nil && shareContent?.images == nil {
            shareContent?.images = [(shareContent?.image)!]
        }
        
        if shareContent?.image == nil && shareContent?.images == nil {
            shareContent?.image = UIImage(named: "app_logo_90")
            shareContent?.images = [(shareContent?.image)!]
        }
        
        //2.处理URL
        if shareContent?.url != nil && shareContent?.URL == nil {
            shareContent?.URL = URL.init(string: (shareContent?.url)!)
        }
        
        //3.title/content
        if shareContent?.title == nil {
            shareContent?.title = "BeeFun 代码爱好者"
        }
        
        if shareContent?.content == nil {
            shareContent?.content = "BeeFun，开源的Swift Github第三方客户端。"+ShortSocialAppStore
        }
        
        if shareContent?.contentType == nil {
            shareContent?.contentType = .auto
        }
        
    }
}
