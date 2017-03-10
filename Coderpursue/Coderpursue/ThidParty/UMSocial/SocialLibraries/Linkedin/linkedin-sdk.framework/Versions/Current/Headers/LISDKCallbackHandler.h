//
//  LISDKCallbackHandler.h
//
//  Copyright (c) 2015 linkedin. All rights reserved.
//

#ifndef LISDKCallbackHandler_h
#define LISDKCallbackHandler_h

@class UIApplication;

@interface LISDKCallbackHandler : NSObject

/**
 call this from application:openURL:sourceApplication:annotation: in AppDelegate to check if the callback can be handled by LinkedIn SDK.
 */
+ (BOOL)shouldHandleUrl:(NSURL *)url;

/**
 call this from application:openURL:sourceApplication:annotation: in AppDelegate in order to properly handle the callbacks. This must be called only if shouldHandleUrl: returns YES.
 */
+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

@end

#endif
