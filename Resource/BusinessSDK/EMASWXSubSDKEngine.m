//
//  ExEMASWXSDKEngine.m
//  EMASDemo
//
//  Created by daoche.jb on 2018/6/28.
//  Copyright © 2018年 EMAS. All rights reserved.
//

#import "EMASWXSubSDKEngine.h"
#import <WeexSDK/WeexSDK.h>
#import "EMASService.h"
#import "EMASWXNavigationImpl.h"
#import <EmasWeexComponents/EmasWeexComponents.h>
#import <EmasWeexComponents/WXNavigationBarModule.h>
#import "WXNavigationBarDefaultImpl.h"
#import <EmasSocial/XCOSocial.h>
#import <EmasWeexComponents/WXScreenModule.h>
#import <WeexPluginLoader/WPLRegister.h>
#import <EmasWeexComponents/WXSysShareModule.h>
#import <EMasXBase/XCOScreenshotDetector.h>
#import "EMASWXScreenModule.h"

@implementation EMASWXSubSDKEngine

+ (void)setup {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self initWXSDKEnviroment];
    });
}

+ (void)initWXSDKEnviroment {
    [super initWXSDKEnviroment];
    
#ifdef DEBUG
    [WXDebugTool setDebug:YES];
    [WXLog setLogLevel:WXLogLevelLog];
    
#else
    [WXDebugTool setDebug:NO];
    [WXLog setLogLevel:WXLogLevelError];
#endif
    [EmasWeexComponents setup];

    [WXSDKEngine registerHandler:[WXNavigationBarDefaultImpl new] withProtocol:@protocol(WXNavigationBarModuleProtocol)];

    [WXSDKEngine registerHandler:[XCOSocial sharedInstance] withProtocol:@protocol(XSocialProtocol)];

    [WPRegister registerPlugins];
}

+ (void)appConfig {
    [super appConfig];
    
    [WXAppConfiguration setAppGroup:@"EMASApp"];
    [WXAppConfiguration setAppName:@"EMASDemo"];
    [WXAppConfiguration setAppVersion:[[EMASService shareInstance] getAppVersion]];

}

+ (void)registerHandler {
    [super registerHandler];
    [self registerHandler:[EMASWXNavigationImpl new] withProtocol:@protocol(WXNavigationProtocol)];
}

+ (void)registerModule {
    [super registerModule];
    [self registerModule:@"navigationBar" withClass:WXNavigationBarModule.class];
    [self registerModule:@"system-share" withClass:[WXSysShareModule class]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //或者用另外的名称覆盖
        [self registerModule:@"screen" withClass:[EMASWXScreenModule class]];
    });
}

@end
