//
//  LISDK.h
//
//  Copyright (c) 2015 linkedin. All rights reserved.
//

#ifndef LISDK_h
#define LISDK_h

/**
 file for application to include to interact with LinkedIn SDK for ios.
 
 A typical usage flow might be:
 
 1. use LISDKSessionManager to initialize a linkedin session if it is not already valid.  
 This will ask the user to authorize the application to use his/her linkedin data.
  
 if (! [LISDKSessionManager hasValidSession] ) {
   [LISDKSessionManager createSessionWithAuthorize:[NSArray arrayWithObjects:LISDK_BASIC_PROFILE_PERMISSION, LISDK_EMAILADDRESS_PERMISSION, nil]
                                             state:@"some state"
                            showGoToAppStoreDialog:NO
                                      successBlock:^(NSString *returnState) {
                                      }
                                        errorBlock:^(NSError *error) {
                                        }];
 }
 
 2. use LISDKAPIHelper or LISDKDeeplinkHelper to make API calls or to perform deep link operations
 
 */
#include <linkedin-sdk/LISDKSessionManager.h>
#include <linkedin-sdk/LISDKSession.h>
#include <linkedin-sdk/LISDKAccessToken.h>
#include <linkedin-sdk/LISDKAPIError.h>
#include <linkedin-sdk/LISDKAPIHelper.h>
#include <linkedin-sdk/LISDKAPIResponse.h>
#include <linkedin-sdk/LISDKCallbackHandler.h>
#include <linkedin-sdk/LISDKDeeplinkHelper.h>
#include <linkedin-sdk/LISDKErrorCode.h>
#include <linkedin-sdk/LISDKPermission.h>

#endif
