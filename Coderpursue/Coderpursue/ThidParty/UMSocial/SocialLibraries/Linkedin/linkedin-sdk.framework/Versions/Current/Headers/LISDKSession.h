//
//  LISession.h
//
//  Copyright (c) 2015 linkedin. All rights reserved.
//

#ifndef LISDKSession_h
#define LISDKSession_h

@class LISDKAccessToken;

/**
 class representing a valid LinkedIn session.  A valid session means that the LinkedIn member
 has granted access to the application to use some of his/her LinkedIn data.
*/
@interface LISDKSession : NSObject

@property(nonatomic,strong) LISDKAccessToken *accessToken;

- (BOOL)isValid;
- (NSString *)value;
/*
- (LISDKAccessToken *)getAccessToken;

- (void)setAccessToken:(LISDKAccessToken *)accessToken;
*/
@end

#endif
