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

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    [self initWeexConfig];
    
    [self initNetworkConfig];
    
    [self initMTOPConfig];
    
    [self initACCSConfig];
    
    [self initHAConfig];
    
    [self initZcacheConfig];
    
    
    return YES;
}

#pragma mark -
#pragma mark SDK初始化

//-- weex
- (void)initWeexConfig
{
    //business configuration
    [WXAppConfiguration setAppGroup:@"AliApp"];
    [WXAppConfiguration setAppName:@"EMASDemo"];
    [WXAppConfiguration setAppVersion:@"1.0.0"];
    
    //init sdk environment
    [WXSDKEngine initSDKEnvironment];
    
    //set the log level
    [WXLog setLogLevel: WXLogLevelAll];
    
    //-- 扩展功能
    [WXSDKEngine registerHandler:[WXAppMonitorHandler new] withProtocol:@protocol(WXAppMonitorProtocol)];
    [WXSDKEngine registerHandler:[WXImgLoaderDefaultImpl new] withProtocol:@protocol(WXImgLoaderProtocol)];
    [WXSDKEngine registerHandler:[WXEventModule new] withProtocol:@protocol(WXEventModuleProtocol)];
    [WXSDKEngine registerHandler:[WXResourceRequestHandlerDemoImpl new] withProtocol:@protocol(WXResourceRequestHandler)];
    [WXSDKEngine registerHandler:[WXCrashAdapterHandler new] withProtocol:@protocol(WXJSExceptionProtocol)];
    [WXSDKEngine registerModule:@"haTest" withClass:[WXEventModule class]];
    
    // -- 监控
    [[TBCrashReporterMonitor sharedMonitor] registerCrashLogMonitor:[[WXCrashReporter alloc] init]];
}

//-- 高可用
- (void)initHAConfig
{
    [[UTAnalytics getInstance] turnOffCrashHandler];
    [[UTAnalytics getInstance] turnOnDebug];
    [[UTAnalytics getInstance] setAppKey:AppKey secret:AppSecret];
    [AliHAAdapter initWithAppKey:AppKey appVersion:@"1.0.0" channel:nil plugins:nil nick:nil];
}

//-- mtop
- (void)initMTOPConfig
{
    TBSDKConfiguration *config = [TBSDKConfiguration shareInstanceDisableDeviceID:YES];
    config.environment = TBSDKEnvironmentRelease;
    config.safeSecret = NO;
    config.appKey = AppKey;
    config.appSecret = AppSecret;
    config.wapAPIURL = @"aserver.emas-ha.cn";//设置全局自定义域名
    config.wapTTID = @"1001@Test_iOS_1.0.0"; //渠道ID
    
    openSDKSwitchLog(YES);
    
    /*
     MtopExtRequest* request = [[MtopExtRequest alloc] initWithApiName:@"com.alibaba.emas.eweex.zcache.gate" apiVersion:@"1.0"];
     [request addBizParameter:@"5" forKey:@"configType"];
     [request addBizParameter:@"0" forKey:@"snapshotId"];
     [request addBizParameter:@"0" forKey:@"snapshotN"];
     [request addBizParameter:@"a" forKey:@"target"];
     [request disableHttps];
     [[MtopService getInstance] async_call:request delegate:nil];
     */
}

//-- 网络库
- (void)initNetworkConfig
{
    [NWNetworkConfiguration setEnvironment:release];
    NWNetworkConfiguration *configuration = [NWNetworkConfiguration shareInstance];
    [configuration setIsUseSecurityGuard:NO];
    [configuration setAppkey:AppKey];
    [configuration setAppSecret:AppSecret];
    [NWNetworkConfiguration shareInstance].isEnableAMDC = NO;
    [NetworkDemote shareInstance].canInitWithRequest = NO;
    
    setNWLogLevel(NET_LOG_DEBUG);
}

//-- accs
- (void)initACCSConfig
{
    // 先声明日志开关函数
    void tbAccsSDKSwitchLog(BOOL logCtr);
    // 打开日志
    tbAccsSDKSwitchLog(YES);
    
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
                                      
                                      [self accs_bindService];
                                  }
                              }];
}

- (void)accs_bindService
{
    TBAccsManager *accsManager = [TBAccsManager accsManagerByHost:ACCSDomain];
    [accsManager bindServiceWithServiceId: @"demo_service"
                                 callBack:^(NSError *error, NSDictionary *resultsDict) {
                                     if (error){
                                         NSLog(@"绑定Service出错了");
                                     }
                                     else{
                                         NSLog(@"绑定Service成功了");
                                         
                                         [self accs_sendData];
                                     }
                                 }
                        receviceDataBlock:^(NSError *error, NSDictionary *resultsDict){
                            if (error){
                                NSLog(@"接收 Accs 数据出错 %@", error.description);
                            }
                            else{
                                NSLog(@"接收 Accs 数据成功 %@", resultsDict[@"jsonString"]);
                            }
                        }];
}

- (void)accs_sendData
{
    NSData *data = [@"Hello, this is iOS EMASDemo" dataUsingEncoding:NSUTF8StringEncoding];
    TBAccsManager *accsManager = [TBAccsManager accsManagerByHost:ACCSDomain];
    [accsManager sendRequestWithData: data
                           serviceId: @"demo_service"
                              userId: nil
                              routID:nil
                     otherParameters: nil
                            callBack:^(NSError *error, NSDictionary *resultsDict)
     {
         if (error)
         {
             NSLog(@"发送数据失败sendRequest: %@", error);
         }
         else
         {
             NSLog(@"发送数据成功sendRequest");
         }
     }];
}

//-- zache
- (void)initZcacheConfig
{
    // 设置为 EMAS 环境的预加载下载地址。
    [ZCache defaultCommonConfig].packageZipPrefix = @"http://mobilehubdev.taobao.com/eweex/";
    
    [ZCache setDebugMode:YES];
    
    [ZCache setupWithMtop];
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

// 测试环境抛开证书校验
@implementation NSURLRequest(DataController)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}

@end

