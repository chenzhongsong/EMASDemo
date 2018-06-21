//
//  EMASWeexWrapper.m
//  EMASDemo
//
//  Created by EMAS on 2018/6/14.
//  Copyright © 2018年 EMAS. All rights reserved.
//

#import "EMASWeexWrapper.h"
// --weex头文件
#import <WeexSDK/WXAppConfiguration.h>
#import <WeexSDK/WXSDKEngine.h>
#import <WeexSDK/WXLog.h>
#import <ZCache/ZCache.h>

// --weex默认实现
#import "WXImgLoaderDefaultImpl.h"
#import "WXEventModule.h"
#import "WXResourceRequestHandlerDemoImpl.h"
#import "WXAppMonitorHandler.h"
#import "WXCrashAdapterHandler.h"
#import <TBCrashReporter/TBCrashReporterMonitor.h>

// --crash头文件
#import "WXCrashAdapterHandler.h"
#import "WXCrashReporter.h"

@implementation EMASWeexWrapper

+ (void)initWeexDefaultConfigWithAppGroup:(NSString *)appGroup
                                  appName:(NSString *)appName
                               appVersion:(NSString *)appVersion
{
    // weex初始化部分
    //business configuration
    [WXAppConfiguration setAppGroup:appGroup];
    [WXAppConfiguration setAppName:appName];
    [WXAppConfiguration setAppVersion:appVersion];
    
    //init sdk environment
    [WXSDKEngine initSDKEnvironment];
    
    [WXLog setLogLevel: WXLogLevelAll]; // 打开调试日志
    
    // 数据上报--必选
    [WXSDKEngine registerHandler:[WXAppMonitorHandler new] withProtocol:@protocol(WXAppMonitorProtocol)];
    
    // 图片下载--必选
    [WXSDKEngine registerHandler:[WXImgLoaderDefaultImpl new] withProtocol:@protocol(WXImgLoaderProtocol)];
    
    // zcache--必选
    [WXSDKEngine registerHandler:[WXResourceRequestHandlerDemoImpl new] withProtocol:@protocol(WXResourceRequestHandler)];
    
    // JSError监控--必选
    [WXSDKEngine registerHandler:[WXCrashAdapterHandler new] withProtocol:@protocol(WXJSExceptionProtocol)];
    
    // JSCrash监控--必选
    [[TBCrashReporterMonitor sharedMonitor] registerCrashLogMonitor:[[WXCrashReporter alloc] init]];
    
    // 事件调用--可选
    [WXSDKEngine registerModule:@"haTest" withClass:[WXEventModule class]];
    
    // 事件调用，可选
    [WXSDKEngine registerHandler:[WXEventModule new] withProtocol:@protocol(WXEventModuleProtocol)];
    
//    // ZCache初始化部分
//    [ZCache defaultCommonConfig].packageZipPrefix = zipPrefix;
//    [ZCache setDebugMode:YES]; // 打开调试日志
//    [ZCache setupWithMtop];
}

@end
