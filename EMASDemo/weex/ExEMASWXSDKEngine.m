//
//  ExEMASWXSDKEngine.m
//  EMASDemo
//
//  Created by daoche.jb on 2018/6/28.
//  Copyright © 2018年 EMAS. All rights reserved.
//

#import "ExEMASWXSDKEngine.h"
#import <WeexSDK/WXAppConfiguration.h>
#import "EMASService.h"
#import "WXEventModule.h"

@implementation ExEMASWXSDKEngine

+ (void)setup {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self initWXSDKEnviroment];
    });
}

+ (void)appConfig {
    [super appConfig];
    
    [WXAppConfiguration setAppGroup:@"TestApp"];
    [WXAppConfiguration setAppName:@"EMASDemo"];
    [WXAppConfiguration setAppVersion:[[EMASService shareInstance] getAppVersion]];
}

+ (void)registerHandler {
    [super registerHandler];
    
    // 事件调用，可选
    [WXSDKEngine registerHandler:[WXEventModule new] withProtocol:@protocol(WXEventModuleProtocol)];
}

+ (void)registerModule {
    [super registerModule];
    
    // 事件调用--可选
    [WXSDKEngine registerModule:@"haTest" withClass:[WXEventModule class]];
}

@end
