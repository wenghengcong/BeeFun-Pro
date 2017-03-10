//
//  LISDKDeeplinkHelper.h
//
//  Copyright (c) 2015 linkedin. All rights reserved.
//

#ifndef LISDKDeeplinkHelper_h
#define LISDKDeeplinkHelper_h

@class UIApplication;

/**
 This class is used to view member profiles in the LinkedIn native app.
 Calls should only be made once a valid session has been established.
 A typical use might be:
 
 if ([LISDKSessionManager hasValidSession]) {
 [[LISDKDeeplinkHelper sharedInstance] viewOtherProfile:@"x1y2z3abc"
                                              WithState:@"some state"
                                                success:^(NSString *) {
                                                                        // do something on success
                                                                      }
                                                  error:^(NSError *deeplinkError, NSString *) {
                                                                                                // do something with error
                                                                                              }];
 }
 */
typedef void (^DeeplinkSuccessBlock)(NSString *returnedState);
typedef void (^DeeplinkErrorBlock)(NSError *error, NSString *returnedState);

@interface LISDKDeeplinkHelper : NSObject

/**
 access to singleton
 */
+ (instancetype)sharedInstance;


- (void)viewCurrentProfileWithState:(NSString *)state
             showGoToAppStoreDialog:(BOOL)showDialog
                            success:(DeeplinkSuccessBlock)success
                              error:(DeeplinkErrorBlock)error;

- (void)viewOtherProfile:(NSString *)memberId
               withState:(NSString *)state
  showGoToAppStoreDialog:(BOOL)showDialog
                 success:(DeeplinkSuccessBlock)success
                   error:(DeeplinkErrorBlock)error;

+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

+ (BOOL)shouldHandleUrl:(NSURL *)url;

@end

#endif
