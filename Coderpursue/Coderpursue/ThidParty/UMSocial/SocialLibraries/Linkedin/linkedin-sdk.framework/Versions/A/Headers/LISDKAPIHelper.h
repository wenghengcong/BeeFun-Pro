//
//  LISDKApiHelper.h
//
//  Copyright (c) 2015 linkedin. All rights reserved.
//

#ifndef LISDKApiHelper_h
#define LISDKApiHelper_h

@class LISDKAPIResponse;
@class LISDKAPIError;


typedef void (^APISuccessBlock)(LISDKAPIResponse *);
typedef void (^APIErrorBlock)(LISDKAPIResponse *, NSError *);

#define LINKEDIN_API_URL @"https://api.linkedin.com/v1"

/**
 This class is used to make API Requests to retrieve LinkedIn data.
 Calls should only be made once a valid session has been established.
 A typical use might be:
 
 if ([LISDKSessionManager hasValidSession]) {
 [[LISDKAPIHelper sharedInstance] getRequest:[NSString stringWithFormat:@"%@/people/~",LINKEDIN_API_URL]
                                success:^(LISDKAPIResponse *response) {
                                   // do something with response
                                }
                                error:^(LISDKAPIError *apiError) {
                                   // do something with error
                                }];
]
 }
 
 */
@interface LISDKAPIHelper : NSObject
/**
 access to singleton
 */
+ (instancetype)sharedInstance;


- (void)getRequest:(NSString *)url
           success:(void(^)(LISDKAPIResponse *))success
             error:(void(^)(LISDKAPIError *))error;

- (void)deleteRequest:(NSString *)url
              success:(void(^)(LISDKAPIResponse *))successCompletion
                error:(void(^)(LISDKAPIError *))errorCompletion;

- (void)putRequest:(NSString *)url
              body:(NSData *)body
           success:(void(^)(LISDKAPIResponse *))successCompletion
             error:(void(^)(LISDKAPIError *))errorCompletion;

- (void)putRequest:(NSString *)url
        stringBody:(NSString *)stringBody
           success:(void(^)(LISDKAPIResponse *))successCompletion
             error:(void(^)(LISDKAPIError *))errorCompletion;

- (void)postRequest:(NSString *)url
               body:(NSData *)body
            success:(void(^)(LISDKAPIResponse *))successCompletion
              error:(void(^)(LISDKAPIError *))errorCompletion;

- (void)postRequest:(NSString *)url
         stringBody:(NSString *)stringBody
            success:(void(^)(LISDKAPIResponse *))successCompletion
              error:(void(^)(LISDKAPIError *))errorCompletion;

// do we want to expose this one?
- (void)apiRequest:(NSString *)url
            method:(NSString *)method
              body:(NSData *)body
           success:(void(^)(LISDKAPIResponse *))successCompletion
             error:(void(^)(LISDKAPIError *))errorCompletion;

/**
 cancel any in process api calls
 */
- (void)cancelCalls;

@end

#endif
