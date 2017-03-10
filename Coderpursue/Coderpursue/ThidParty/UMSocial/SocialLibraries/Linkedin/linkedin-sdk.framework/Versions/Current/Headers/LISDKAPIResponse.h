//
//  LISDKAPIResponse.h
//
//  Copyright (c) 2015 linkedin. All rights reserved.
//

#ifndef LISDKAPIResponse_h
#define LISDKAPIResponse_h

/**
 Response from an API call
 */
@interface LISDKAPIResponse : NSObject
@property (readonly,nonatomic) NSString *data;
@property (readonly,nonatomic) int statusCode;
@property (readonly,nonatomic) NSDictionary *headers;


- (id)initWithData:(NSString *)data headers:(NSDictionary *)headers statusCode:(int)statusCode;
@end

#endif
