//
//  LISessionManager.h
//
//  Copyright (c) 2015 linkedin. All rights reserved.
//


#ifndef LISDKSessionManager_h
#define LISDKSessionManager_h

@class LISDKSession;
@class LISDKAuthError;
@class UIApplication;
@class LISDKScope;
@class LISDKAccessToken;
typedef void (^AuthSuccessBlock)(NSString *);
typedef void (^AuthErrorBlock)(NSError *);

/**
 * LISDKSessionManager.
 */
@interface LISDKSessionManager : NSObject


+ (instancetype)sharedInstance;

@property (readonly,nonatomic) LISDKSession *session;

/**
 @brief create a session with user authorization if needed.
        If the user previously authorized this application, the successBlock will be called and
        a valid session created.
        If needed, an authorization screen will be shown to the user.
        This method will bring the user to the LinkedIn flagship app.  The application must
        call application:openURL from their AppDelegate:application:openURL in order for the
        successBlock and errorBlock completion handlers to be properly called.
        By default, sessions are saved in the keychain.
 @param permissions  NSArray of permissions strings.  For valid values see LISDKPermission.h
 @param showGoToAppStoreDialog YES if you want an alert to prompt the user to go to the App Store if the LinkedIn App is not installed. If NO, no alert will be shown and the user will be taken to the App Store directly.
 */
+ (void)createSessionWithAuth:(NSArray *)permissions state:(NSString *)state showGoToAppStoreDialog:(BOOL)showDialog successBlock:(AuthSuccessBlock)successBlock errorBlock:(AuthErrorBlock)erroBlock;

+ (void)createSessionWithAccessToken:(LISDKAccessToken *)accessToken;

/**
 call to clear any open session. Any saved session will also be cleared.
 */
+ (void)clearSession;

/**
 @return YES if session has been properly created.
 */
+ (BOOL)hasValidSession;

/**
 call this from AppDelegate:application:openURL  in order to properly handle the authorization
 sequence
 @return YES if the url was handled
 */
+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

/**
 call this within AppDelegate:application:openURL to determine whether or not to call
 this methods application:openURL method 
 @return YES if the url is one that should be handled by the LinkedIn SDK
*/
+ (BOOL)shouldHandleUrl:(NSURL *)url;

@end

#endif
