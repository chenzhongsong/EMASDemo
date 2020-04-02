//
//  TBSDKPushUtilsCopy.h
//  PushCenterSDK
//
//  Created by wuchen.xj on 16/9/27.
//  Copyright © 2016年 yidao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TBSDKPushUtilsCopy : NSObject

+ (BOOL)deviceSystemIsLargeIOS10;

+ (BOOL)deviceSystemIsLargeIOS9;

+ (BOOL)deviceSystemIsLargeIOS8;

+ (BOOL)isNotificationEnabled;

+ (void)isNotificationEnabledWithCompletionHandler:(void (^)(BOOL notificationEnabled))completionHandler;

+ (id)reflectInvokeClass:(NSString *)className withSelector:(NSString *)selector;

+ (NSData *)convertHexString:(NSString *)text;

+ (NSData *)md5WithData:(NSData *)data;

+ (NSData *)md5WithString:(NSString *)text;

+ (NSData *)md5WithBytes:(const char *)data withLength:(NSUInteger)length;

+ (NSData *)hmacsha1:(NSString *)text key:(NSString *)secret;

+ (NSString *)decodeBase64URLSafeString:(NSString *)text;

+ (NSData *)decryptAES128WithData:(NSData *)data withKey:(NSData *)key withVector:(NSData *)vec;

+ (NSDictionary *)convertJson2Dictionary:(NSString *)text;

+ (UIApplicationState)currentApplicationState;

+ (NSString *)hexadecimalStringFromData:(NSData *)data;

@end
