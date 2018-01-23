//
//  EMASService.m
//  EMASDemo
//
//  Created by zhishui.lcq on 2018/1/15.
//  Copyright © 2018年 zhishui.lcq. All rights reserved.
//

#import "EMASService.h"

@implementation EMASService
{
    NSDictionary *services;
}

+ (EMASService *)shareInstance {
    static EMASService *g_instance = nil;
    static  dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        g_instance = [[EMASService alloc] init];
    });
    return g_instance;
}

- (id)init
{
    if (self = [super init])
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EMASService-Info" ofType:@"plist"];
        services = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return self;
}

- (NSString *)appkey
{
    return [services objectForKey:@"AppKey"];
}

- (NSString *)appSecret
{
    return [services objectForKey:@"AppSecret"];
}

- (NSString *)getAppVersion
{
    NSDictionary *appinfo = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [appinfo objectForKey:@"CFBundleShortVersionString"];
    if (!version) {
        version = @"10.0.0";
    }
    return version;
}

- (NSString *)ACCSDomain
{
    return [services objectForKey:@"ACCSDomain"];
}

- (NSString *)MTOPDomain
{
    return [services objectForKey:@"MTOPDomain"];
}

- (NSString *)ChannelID
{
    return [services objectForKey:@"ChannelID"];
}

- (NSString *)packageZipPrefixURL
{
    return [services objectForKey:@"packageZipPrefixURL"];
}

- (NSString *)OSSBucketName
{
    return [services objectForKey:@"OSSBucketName"];
}

- (NSString *)HAUniversalHost
{
    return [services objectForKey:@"HAUniversalHost"];
}

- (NSString *)HATimestampHost
{
    return [services objectForKey:@"HATimestampHost"];
}

@end
