//
//  TBSDKPushUtilsCopy.m
//  PushCenterSDK
//
//  Created by wuchen.xj on 16/9/27.
//  Copyright © 2016年 yidao. All rights reserved.
//

#import "TBSDKPushUtilsCopy.h"
//#import "TBSDKPushLog.h"

#import <UserNotifications/UserNotifications.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <UIKit/UIKit.h>

#import <objc/runtime.h>
#import <objc/message.h>

@implementation TBSDKPushUtilsCopy

+ (BOOL)deviceSystemIsLargeIOS10 {
    static BOOL __ios10__ = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __ios10__ = [[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0;
    });
    
    return __ios10__;
}

+ (BOOL)deviceSystemIsLargeIOS9 {
    static BOOL _ios9_ = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _ios9_ = [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0;
    });
    
    return _ios9_;
}

+ (BOOL)deviceSystemIsLargeIOS8 {
    static BOOL _ios8_ = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_8_0) {
            _ios8_ = YES;
        }
    });
    
    return _ios8_;
}

+ (BOOL)isNotificationEnabled {
    NSUInteger nt = UIUserNotificationTypeNone;
    
    if([TBSDKPushUtilsCopy deviceSystemIsLargeIOS8])
    {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        nt = setting.types;
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        nt = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
#pragma clang diagnostic pop
    }

    return UIUserNotificationTypeNone != nt;
}

+ (void)isNotificationEnabledWithCompletionHandler:(void (^)(BOOL notificationEnabled))completionHandler {
    if (!completionHandler) {
        return;
    }
    
    if (@available(iOS 10.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            BOOL enableNotification = settings.soundSetting == UNNotificationSettingEnabled
                                    || settings.badgeSetting == UNNotificationSettingEnabled
                                    || settings.alertSetting == UNNotificationSettingEnabled
                                    || settings.notificationCenterSetting == UNNotificationSettingEnabled
                                    || settings.lockScreenSetting == UNNotificationSettingEnabled;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                completionHandler(enableNotification);
            });
        }];
    } else if (@available(iOS 8.0, *)) {
        UIUserNotificationType type = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
        BOOL enableNotification = (type != UIUserNotificationTypeNone);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            completionHandler(enableNotification);
        });
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        BOOL enableNotification = (type != UIRemoteNotificationTypeNone);
#pragma clang diagnostic pop
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            completionHandler(enableNotification);
        });
    }
}

+ (id)reflectInvokeClass:(NSString *)className withSelector:(NSString *)selector {
    id cls = objc_getClass([className UTF8String]);
    if (cls == nil) {
//        PUSH_LOG_ERROR(@"[reflectInvokeClass] find class failed: %@", className);
        return nil;
    }
    
    SEL sel = NSSelectorFromString(selector);
    if ([cls respondsToSelector:sel] == NO) {
//        PUSH_LOG_ERROR(@"[reflectInvokeClass] selector not found: %@.%@", className, selector);
        return nil;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    id obj = [cls performSelector:sel];
    if (obj == nil) {
//        PUSH_LOG_ERROR(@"[reflectInvokeClass] return nil: [%@ %@]", className, selector);
    }
#pragma clang diagnostic pop
    
    return obj;
}

+ (NSUInteger)calcHexStringBytes:(NSString *)text {
    if (text.length == 0) {
        return 0;
    }
    
    unsigned int length = (unsigned int)text.length;
    if ((length&0x1) == 0x1) {
        return 0;
    }
    
    return length/2;
}

+ (NSData *)convertHexString:(NSString *)text {
    if (text.length == 0) {
        return NO;
    }

    char buff[ text.length/2 ];
    
    for (int i=0, j=0; i<text.length-1; i+=2, j++) {
        unsigned int value;
        NSString * hex = [text substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [NSScanner scannerWithString:hex];
        [scanner scanHexInt:&value];
        buff[j] = (char)value;
    }
    
    return [NSData dataWithBytes:buff length:text.length/2];
}

+ (NSData *)md5WithData:(NSData *)data {
    if (data.length == 0) {
        return nil;
    }
    
    unsigned char result[16];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    
    return [[NSData alloc] initWithBytes:result length:sizeof(result)];
}


+ (NSData *)md5WithString:(NSString *)text {
    if (text.length == 0) {
        return nil;
    }
    
    const char *cStr = [text UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [[NSData alloc] initWithBytes:result length:sizeof(result)];
}

+ (NSData *)md5WithBytes:(const char *)data withLength:(NSUInteger)length {
    if (data==NULL || length==0) {
        return nil;
    }
    
    unsigned char result[16];
    CC_MD5(data, (CC_LONG)length, result);
    
    return [[NSData alloc] initWithBytes:result length:sizeof(result)];
}

+ (NSData *)hmacsha1:(NSString *)text key:(NSString *)secret {
    const char *cKey  = [secret cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, secret.length, cData, text.length, cHMAC);
    
    return [NSData dataWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
}


+ (NSString *)decodeBase64URLSafeString:(NSString *)text {
    // '-' -> '+'
    // '_' -> '/'
    // 不足4倍长度，补'='
    NSMutableString * base64Str = [[NSMutableString alloc]initWithString:text];
    base64Str = (NSMutableString * )[base64Str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    base64Str = (NSMutableString * )[base64Str stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
    base64Str = (NSMutableString * )[base64Str stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
    NSInteger mod4 = base64Str.length % 4;
    if(mod4 > 0)
        [base64Str appendString:[@"====" substringToIndex:(4-mod4)]];
    
    return base64Str;
}

+ (NSData *)decryptAES128WithData:(NSData *)data withKey:(NSData *)key withVector:(NSData *)vec {
    if (data.length==0 || key.length==0 || vec.length==0) {
        return nil;
    }
    
    void const *contentBytes = data.bytes;
    NSUInteger dataLength = data.length;
    
    size_t operationSize = dataLength + kCCBlockSizeAES128;
    void *operationBytes = malloc(operationSize);
    memset(operationBytes, 0, operationSize);
    size_t actualOutSize = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          key.bytes,
                                          kCCKeySizeAES128,
                                          vec.bytes,
                                          contentBytes,
                                          dataLength,
                                          operationBytes,
                                          operationSize,
                                          &actualOutSize);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:operationBytes length:actualOutSize];
    }
    
    free(operationBytes);
    return nil;
}

+ (NSDictionary *)convertJson2Dictionary:(NSString *)text {
    if (text.length == 0) {
        return nil;
    }
    
    NSError *error;
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingAllowFragments
                                                           error:&error];
    
    if(error) {
        NSLog(@"convert json '%@' to dictionary failed: %@", text, error.localizedDescription);
        return nil;
        
    }
    
    return dict;
}


+ (UIApplicationState)currentApplicationState {
    __block UIApplicationState state;
    
    if ([NSThread isMainThread]) {
        state = [UIApplication sharedApplication].applicationState;
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), ^(){
            state = [UIApplication sharedApplication].applicationState;
        });
    }
    
    return state;
}

+ (NSString *)hexadecimalStringFromData:(NSData *)data {
  if (![data isKindOfClass:[NSData class]]) {
      return nil;
  }

  NSUInteger dataLength = data.length;
  if (dataLength == 0) {
    return nil;
  }

  const unsigned char *dataBuffer = data.bytes;
  NSMutableString *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
  for (int i = 0; i < dataLength; ++i) {
    [hexString appendFormat:@"%02x", dataBuffer[i]];
  }
    
  return [hexString copy];
}

@end
