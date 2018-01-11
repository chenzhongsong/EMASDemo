//
//  AppDelegate.m
//  EMASDemo
//
//  Created by zhishui.lcq on 2017/12/7.
//  Copyright © 2017年 zhishui.lcq. All rights reserved.
//

#import "AppDelegate.h"

// --weex头文件
#import <WeexSDK/WXAppConfiguration.h>
#import <WeexSDK/WXSDKEngine.h>
#import <WeexSDK/WXLog.h>
// --weex头文件
#import <MtopSDK/MtopSDK.h>
#import <MtopCore/MtopService.h>

#import <AliHAAdapter4poc/AliHAAdapter.h>
#import <TRemoteDebugger/TRDManagerService.h>

#import <UT/UTAnalytics.h>
#import <NetworkSDK/NetworkCore/NWNetworkConfiguration.h>
#import <NetworkSDK/NetworkCore/NetworkDemote.h>
#import <NetworkSDK/NetworkCore/NWuserLoger.h>
#import <NetworkSDK/NetworkCore/NWUserPolicy.h>

#import <TBAccsSDK/TBAccsManager.h>
#import <TBCrashReporter/TBCrashReporterMonitor.h>

#import <ZCache/ZCache.h>

#import "WXImgLoaderDefaultImpl.h"
#import "WXEventModule.h"
#import "WXResourceRequestHandlerDemoImpl.h"
#import "WXAppMonitorHandler.h"
#import "WXCrashAdapterHandler.h"
#import "WXCrashReporter.h"
#import <TBCrashReporter/TBCrashReporterMonitor.h>


//-- 配置信息
//#define AppKey @"10000031"
//#define AppSecret @"d4775cd6b8524dd78bbb9de472c51a88"

#define AppKey @"10000040"
#define AppSecret @"c66e5b00ff97809daac7ad60b2eebf20"

#define ACCSDomain @"acs.emas-ha.cn"
#define MTOPDomain @"aserver.emas-ha.cn"
#define CHANNELID @"1001@Test_iOS_1.0.0"

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    // 这两个顺序需要保证下
    [self initHAConfig];
    
    [self initWeexConfig];
    
    return YES;
}

#pragma mark -
#pragma mark SDK初始化

//-- weex
- (void)initWeexConfig
{
    // MTOP初始化部分
    TBSDKConfiguration *config = [TBSDKConfiguration shareInstanceDisableDeviceID:YES];
    config.environment = TBSDKEnvironmentRelease;
    config.safeSecret = NO;
    config.appKey = AppKey;
    config.appSecret = AppSecret;
    config.wapAPIURL = MTOPDomain;//设置全局自定义域名
    config.wapTTID = CHANNELID; //渠道ID
    openSDKSwitchLog(YES); // 打开调试日志
    
    // weex初始化部分
    //business configuration
    [WXAppConfiguration setAppGroup:@"TestApp"];
    [WXAppConfiguration setAppName:@"EMASDemo"];
    [WXAppConfiguration setAppVersion:@"1.0.0"];
    
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
    
    // ZCache初始化部分
    [ZCache defaultCommonConfig].packageZipPrefix = @"http://mobilehubdev.taobao.com/eweex/";
    [ZCache setDebugMode:YES]; // 打开调试日志
    [ZCache setupWithMtop];
}

//-- 高可用
- (void)initHAConfig
{
    // UT初始化部分
    [[UTAnalytics getInstance] turnOffCrashHandler];
    [[UTAnalytics getInstance] turnOnDebug]; // 打开调试日志
    [[UTAnalytics getInstance] setAppKey:AppKey secret:AppSecret];
    
    // 网络库初始化部分
    [NWNetworkConfiguration setEnvironment:release];
    NWNetworkConfiguration *configuration = [NWNetworkConfiguration shareInstance];
    [configuration setIsUseSecurityGuard:NO];
    [configuration setAppkey:AppKey];
    [configuration setAppSecret:AppSecret];
    [configuration setIsEnableAMDC:NO];
    [NetworkDemote shareInstance].canInitWithRequest = NO;
    setNWLogLevel(NET_LOG_DEBUG); // 打开调试日志
    
    // ACCS初始化部分
    void tbAccsSDKSwitchLog(BOOL logCtr);
    tbAccsSDKSwitchLog(YES); // 打开调试日志
    
    TBAccsManager *accsManager = [TBAccsManager accsManagerByHost:ACCSDomain];
    [accsManager setSupportLocalDNS:YES];
    accsManager.slightSslPublicKeySeq = ACCS_PUBKEY_PSEQ_EMAS;
    [accsManager startAccs];
    
    [accsManager bindAppWithAppleToken: nil
                              callBack:^(NSError *error, NSDictionary *resultsDict) {
                                  if (error) {
                                      NSLog(@"\n\n绑定App出错了 %@\n\n", error);
                                  }
                                  else {
                                      NSLog(@"\n\n绑定App成功了\n\n");
                                  }
                              }];
    
    // 高可用初始化部分
    [AliHAAdapter initWithAppKey:AppKey appVersion:@"1.0.0" channel:CHANNELID plugins:nil nick:@"emas-ha"];
    [AliHAAdapter configOSS:@"ha-remote-log"];
}

#pragma mark -
#pragma mark app生命周期

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end

