//
//  Bugly.h
//  Bugly
//
//  Version: 2.1(5)
//
//  Copyright (c) 2016年 Bugly. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BuglyConfig.h"
#import "BuglyLog.h"

BLY_START_NONNULL

@interface Bugly : NSObject

/**
 *  初始化Bugly,使用默认BuglyConfig
 *
 *  @param appId 注册Bugly分配的应用唯一标识
 */
+ (void)startWithAppId:(NSString * BLY_NULLABLE)appId;

/**
 *  使用指定配置初始化Bugly
 *
 *  @param appId 注册Bugly分配的应用唯一标识
 *  @param config 传入配置的 BuglyConfig
 */
+ (void)startWithAppId:(NSString * BLY_NULLABLE)appId
                config:(BuglyConfig * BLY_NULLABLE)config;

/**
 *  设置用户标识
 *
 *  @param userId 用户标识
 */
+ (void)setUserIdentifier:(NSString *)userId;

/**
 *  更新版本信息
 *
 *  @param version 应用版本信息
 */
+ (void)updateAppVersion:(NSString *)version;

/**
 *  设置关键数据，随崩溃信息上报
 *
 *  @param value
 *  @param key
 */
+ (void)setUserValue:(NSString *)value
              forKey:(NSString *)key;

/**
 *  获取关键数据
 *
 *  @return 关键数据
 */
+ (NSDictionary * BLY_NULLABLE)allUserValues;

/**
 *  设置标签
 *
 *  @param tag 标签ID，可在网站生成
 */
+ (void)setTag:(NSUInteger)tag;

/**
 *  获取当前设置标签
 *
 *  @return 当前标签ID
 */
+ (NSUInteger)currentTag;

/**
 *  获取设备ID
 *
 *  @return 设备ID
 */
+ (NSString *)deviceId;

/**
 *  上报自定义异常
 *
 *  @param exception 异常信息
 */
+ (void)reportException:(NSException *)exception;

/**
 *  上报错误
 *
 *  @param error 错误信息
 */
+ (void)reportError:(NSError *)error;

/**
 *  SDK 版本信息
 *
 *  @return
 */
+ (NSString *)sdkVersion;

BLY_END_NONNULL

@end
