//
//  EMASService.h
//  EMASDemo
//
//  Created by EMAS on 2018/1/15.
//  Copyright © 2018年 EMAS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMASService : NSObject

+ (EMASService *)shareInstance;

- (NSString *)appkey;
- (NSString *)appSecret;
- (NSString *)getAppVersion;
- (NSString *)ACCSDomain;
- (NSString *)ACCSServiceID;
- (NSString *)MTOPDomain;
- (NSString *)ChannelID;
- (NSString *)packageZipPrefixURL;
- (NSString *)OSSBucketName;
- (NSString *)HAUniversalHost;
- (NSString *)HATimestampHost;

@end