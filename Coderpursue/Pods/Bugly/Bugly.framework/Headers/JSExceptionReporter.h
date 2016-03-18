//
//  JSCrashReporter.h
//  JSException
//
//  Created by Ben Xu on 15/10/9.
//  Copyright © 2015年 tencent.com. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
@protocol RqdJSSupportProtocol <JSExport>

JSExportAs(reportException,
- (void)reportJSExceptionType:(NSString *)type
                      message:(NSString *)msg
                          url:(NSString *)url
                     filePath:(NSString *)filePath
                        stack:(NSString *)stack
);
/**
 *    @brief JavaScript 主动上报异常接口
 *
 *    @param exp JS捕获到的exception
 */
- (void)reportJSException:(id)exp;

/**
 *    @brief JavaScript 输出日志接口
 *
 *    @param obj 需要打印日志的对象
 */
- (void)log:(id)obj;
@end

@interface JSExceptionReporter : NSObject <RqdJSSupportProtocol>

+ (instancetype)sharedInstance;

/**
 *    @brief 初始化JS异常捕获
 *
 *    @param webview 需要捕获的UIWebView实例
 *    @param inject  是否自动注入Bugly.js
 */
+ (void)startCaptureJSExceptionWithWebView:(UIWebView *)webview
                          injectScript:(BOOL)inject;

/**
 *    @brief 初始化JS异常捕获
 *
 *    @param context JSContext 实例
 */
+ (void)startCaptureJSExceptionWithJSContext:(JSContext *)context;

@end
