//
//  LISDKAccessToken.h
//
//  Copyright (c) 2015 linkedin. All rights reserved.
//

#ifndef LISDKAccessToken_h
#define LISDKAccessToken_h

@interface LISDKAccessToken : NSObject

@property (readonly,nonatomic) NSString *accessTokenValue;
@property (readonly,nonatomic) NSDate *expiration;

+(instancetype)LISDKAccessTokenWithValue:(NSString*)value expiresOnMillis:(long long)expiresOnMillis;

/**
 create by passing in a serialized access token obtained by calling serializedString
 */
+(instancetype)LISDKAccessTokenWithSerializedString:(NSString *)serString;

-(NSString *)serializedString;

@end

#endif
