//
//  LISDKErrorCode.h
//
//  Copyright (c) 2015 linkedin. All rights reserved.
//

#ifndef LISDKErrorCode_h
#define LISDKErrorCode_h

#define LISDK_ERROR_API_DOMAIN @"LISDKErrorAPIDomain"
#define LISDK_ERROR_AUTH_DOMAIN @"LISDKErrorAuthDomain"
#define LISDK_ERROR_DEEPLINK_DOMAIN @"LISDKErrorDeepLinkDomain"

typedef NS_ENUM(int,LISDKErrorCode) {
    NONE,
    /**
     There is something wrong with the request
     */
    INVALID_REQUEST,
    
    /**
     Unable to complete request due to a network error
     */
    NETWORK_UNAVAILABLE,
    
    /**
     The user cancelled the operation
     */
    USER_CANCELLED,
    
    /**
     Unknown error
     */
    UNKNOWN_ERROR,
    
    /**
     An error occurred within LinkedIn's
     */
    SERVER_ERROR,
    
    /**
     Linkedin App not found on device or the version of the Linkedin App installed does not support the sdk
     */
    LINKEDIN_APP_NOT_FOUND,
        
    /**
     The user is not properly authenticated on this device
     */
    NOT_AUTHENTICATED
};

#endif
