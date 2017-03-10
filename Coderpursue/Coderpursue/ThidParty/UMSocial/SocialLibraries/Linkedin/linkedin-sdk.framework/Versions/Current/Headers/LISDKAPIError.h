//
//  LISDKAPIError.h
//
//  Copyright (c) 2015 linkedin. All rights reserved.
//

/**
 LISDKAPIError - Error sent when a LinkedIn api call returns an error response.
 This class extends NSError to allow easy access to the LISDKAPIResponse object
 */
#ifndef LISDKAPIError_h
#define LISDKAPIError_h

#define LISDKAuthErrorAPIResponse @"LISDKAuthErrorAPIResponse"

@class LISDKAPIResponse;

@interface LISDKAPIError : NSError

/**
 returns the LISDKAPIResponse object associated with the API error
 */
- (LISDKAPIResponse *)errorResponse;

/**
 create LISDKAPIError object with the given LISDKAPIResponse object
 */
+ (id)errorWithApiResponse:(LISDKAPIResponse *)response;

/**
 create LISDKAPIError object with the given NSError object
 */
+ (id)errorWithError:(NSError *)error;

@end

#endif
