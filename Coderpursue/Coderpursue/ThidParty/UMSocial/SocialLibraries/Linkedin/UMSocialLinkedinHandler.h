
//
//  UMSocialLinkedinHandler.h
//  UMSocialSDK
//
//  Created by umeng on 16/8/17.
//  Copyright © 2016年 dongjianxiong. All rights reserved.
//

#import <UMSocialCore/UMSocialCore.h>

/**
 * 领英分享权限枚举
 */
typedef NS_ENUM(NSInteger,UMSocial_Linkedin_Share_Visibility)
{
    UMSocial_Linkedin_Share_Visibility_default,//默认是所有人
    UMSocial_Linkedin_Share_Visibility_anyone,//所有人都能看
    UMSocial_Linkedin_Share_Visibility_connectionsOnly,//只有已添加的联系人可以看
};

/**
 * 领英授权权限枚举
 */
typedef  NS_OPTIONS(NSUInteger, UMSocial_Linkedin_Auth_Permission){
    UMSocial_Linkedin_Auth_Permission_Default               = 0, //默认都支持
    
    UMSocial_Linkedin_Auth_Permission_BasicProfile          = 1 << 0,//获取用户基本信息
    UMSocial_Linkedin_Auth_Permission_EmailAddress          = 1 << 1,//获取邮件地址
    UMSocial_Linkedin_Auth_Permission_Share                 = 1 << 2,//支持分享
    UMSocial_Linkedin_Auth_Permission_CompanyAdmin          = 1 << 3,//

    UMSocial_Linkedin_Auth_Permission_Contactinfo           = 1 << 4,//暂时没用
    UMSocial_Linkedin_Auth_Permission_FullProfile           = 1 << 5,//暂时没用
    
    UMSocial_Linkedin_Auth_Permission_Mask                  = 0xFFFFFFFF,

};

@interface UMSocialLinkedinHandler : UMSocialHandler

+ (UMSocialLinkedinHandler *)defaultManager;

/**
 * 分享可见权限
 */
@property (nonatomic, assign) UMSocial_Linkedin_Share_Visibility linkedin_Share_Visibility;

/**
 * app授权权限
 */
@property (nonatomic, assign) UMSocial_Linkedin_Auth_Permission linkedin_Auth_Permission;

/**
 *  A unique string value of your choice that is hard to guess. Used to prevent CSRF.  参考 https://developer.linkedin.com/docs/oauth2
 */
@property (nonatomic, copy) NSString *state;

@end
