//
//  TBSDKPushMessage.m
//  PushCenterSDK
//
//  Created by wuchen.xj on 2017/5/25.
//  Copyright © 2017年 yidao. All rights reserved.
//

//#import "TBSDKPushCenterError.h"
#import "TBSDKAgooMessageCopy.h"
#import "TBSDKPushUtilsCopy.h"
//#import "TBSDKPushLog.h"

//#import "NWNetworkConfiguration.h"
#import <NetworkCore/NWNetworkConfiguration.h>

//#import <SecurityGuardSDK/Open/OpenSecureSignature/IOpenSecureSignatureComponent.h>
//#import <SecurityGuardSDK/Open/OpenSecureSignature/OpenSecureSignatureDefine.h>
//#import <SecurityGuardSDK/Open/OpenSecurityGuardParamContext.h>
//#import <SecurityGuardSDK/Open/OpenSecurityGuardManager.h>

#import <objc/runtime.h>
#import <objc/message.h>

/**
 * Agoo Message BODY 加密类型
 */
typedef enum {
    kAgooEncryptNone    = 0, // 无加密
    kAgooEncryptDevice  = 1, // 按设备ID加密
    kAgooEncryptUser    = 2  // 按用户ID加密
} AgooEncryptType;



/**
 * Agoo Message 结构
 */
@implementation TBSDKAgooMessageCopy

- (instancetype)initWithId:(NSString *)identifier
               withPackage:(NSString *)package
                  withBody:(NSString *)body
                   withExt:(NSDictionary*)ext
                  withFlag:(unsigned int)flag {
    self = [super init];
    if (self) {
        _identifier = [identifier copy];
        _package = [package copy];
        _body = [body copy];
        _ext = [ext copy];
        _flag = flag;
        _isTesting = [TBSDKAgooMessageCopy isTesting:_flag];
    }
    
    return self;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<TBSDKAgooMessageCopy:%p, i=%@, p=%@, f=%u, t=%d, b=%@>",
            self, _identifier, _package, _flag, _isTesting, _body];
}

//+ (OpenSecurityGuardManager *)securityGuardManager {
//    static OpenSecurityGuardManager *sgm = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sgm = [TBSDKPushUtilsCopy reflectInvokeClass:@"OpenSecurityGuardManager" withSelector:@"getInstance"];
//        if( !sgm ) {
//            PUSH_LOG_ERROR(@"[PushAccsReceiver] SecurityGuardSDK is NOT installed");
//        }
//    });
//
//    return sgm;
//}

+ (TBSDKAgooMessageCopy *)convertFromAccsMessage:(NSDictionary *)dictionay
                                   withError:(NSError **)error {
    
    NSData *data = [dictionay objectForKey:@"resultData"];
    NSLog(@"[TBSDKAgooMessageCopy] parse AGOO message:%@, payload length: %lu", dictionay, data.length);
    
    if (data.length == 0) {
        NSLog(@"[TBSDKAgooMessageCopy] parse AGOO message error: 'resultData' empty");
//        *error = PUSH_ERROR(ECODE_PUSH_ACCS_PAYLOAD_EMPTY, nil);
        return nil;
    }
    
    NSError *jsonError;
    id messageJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
    if (jsonError || !messageJson) {
        NSLog(@"[TBSDKAgooMessageCopy] parse AGOO message error: %@", jsonError);
//        *error = PUSH_ERROR(ECODE_PUSH_ACCS_PAYLOAD_PARSE_ERROR, nil);
        return nil;
        
    }
    
    NSDictionary *messageDict = [TBSDKAgooMessageCopy convert2Dictionary:messageJson];
    if ( !messageDict ) {
        NSLog(@"[TBSDKAgooMessageCopy] parse AGOO message to dictionary failed");
//        *error = PUSH_ERROR(ECODE_PUSH_MESSAGE_PARSE_FAILED, nil);
        return nil;
        
    }
    
    NSString *identifier = [messageDict objectForKey:@"i"];
    NSString *package = [messageDict objectForKey:@"p"];
    NSString *body = [messageDict objectForKey:@"b"];
    NSNumber *flag = [messageDict objectForKey:@"f"];
    if (![identifier isKindOfClass:NSString.class] ||
        ![package isKindOfClass:NSString.class] ||
        ![body isKindOfClass:NSString.class] ||
        ![flag isKindOfClass:NSNumber.class]) {
        NSLog(@"[TBSDKAgooMessageCopy] parse AGOO message DATA TYPE error");
//        *error = PUSH_ERROR(ECODE_PUSH_MESSAGE_DATA_TYPE_ERROR, messageDict);
        return nil;
    }
    
    if (body.length == 0) {
        NSLog(@"[TBSDKAgooMessageCopy] the BODY info in AGOO message is empty");
//        *error = PUSH_ERROR(ECODE_PUSH_MESSAGE_BODY_EMPTY, messageDict);
        return nil;
    }
    
    if (identifier.length == 0) {
        NSLog(@"[TBSDKAgooMessageCopy] the id info in AGOO message is empty");
//        *error = PUSH_ERROR(ECODE_PUSH_MESSAGE_ID_EMPTY, messageDict);
        return nil;
    }
    
    AgooEncryptType encryptType = [TBSDKAgooMessageCopy encryptType:[flag unsignedIntValue]];
    
    if (encryptType != kAgooEncryptNone) {
        NSString *decrypedBody = nil;
        
//        if ( [TBSDKPushCenterConfiguration shareInstance].isUseSecurityGuard ) {
//            decrypedBody = [TBSDKAgooMessageCopy decryptWithSecurityGuard:body withEncryptType:encryptType];
//        }
//        else {
            decrypedBody = [TBSDKAgooMessageCopy decryptWithoutSecurityGuard:body withEncryptType:encryptType];
//        }
        
        if (decrypedBody.length == 0) {
            NSLog(@"[TBSDKAgooMessageCopy] decode body with failed");
//            *error = PUSH_ERROR(ECODE_PUSH_MESSAGE_DECRYPT_FAILED, messageDict);
            return nil;
        }
        
        body = decrypedBody;
    }
    
    NSDictionary *ext = [TBSDKPushUtilsCopy convertJson2Dictionary:[messageDict objectForKey:@"ext"]];
    TBSDKAgooMessageCopy *pushMessage = [[TBSDKAgooMessageCopy alloc] initWithId:identifier
                                                             withPackage:package
                                                                withBody:body
                                                                 withExt:ext
                                                                withFlag:[flag unsignedIntValue]];
    
    NSLog(@"[TBSDKAgooMessageCopy] alert AGOO message:%@", pushMessage);
    
    return pushMessage;
}


//+ (NSString *)decryptWithSecurityGuard:(NSString *)content withEncryptType:(AgooEncryptType)type {
//    // 获取无线保镖
//    OpenSecurityGuardManager *sgm = [TBSDKAgooMessageCopy securityGuardManager];
//    if ( !sgm ) {
//        PUSH_LOG_ERROR(@"[TBSDKAgooMessageCopy] decryptWithSecurityGuard, but SecurityGuardSDK is NOT installed.");
//        return nil;
//    }
//
//    id<IOpenSecureSignatureComponent> comp = [sgm getSecureSignatureComp];
//    if ( !comp ) {
//        PUSH_LOG_ERROR(@"[TBSDKAgooMessageCopy] decryptWithSecurityGuard, but getSecureSignatureComp failed.");
//        return nil;
//    }
//
//    // 获取appkey 与 utdid
//    NWNetworkConfiguration *nc = [NWNetworkConfiguration shareInstance];
//    NSString *appkey = [nc appkey];
//    if (appkey.length == 0) {
//        PUSH_LOG_ERROR(@"[TBSDKAgooMessageCopy] decryptWithSecurityGuard, appkey is nil");
//        return nil;
//    }
//
//    TBSDKPushCenterConfiguration *pc = [TBSDKPushCenterConfiguration shareInstance];
//    NSString *info = type==kAgooEncryptDevice ? [nc utdid] : [pc pushUserToken];
//    if (info.length == 0) {
//        PUSH_LOG_ERROR(@"[TBSDKAgooMessageCopy] decryptWithSecurityGuard, info [type: %d] is nil", (int)type);
//        return nil;
//    }
//
//    // 计算解密key
//    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
//    [param setValue:[NSString stringWithFormat:@"%@%@", appkey, info] forKey:@"input"];
//
//    OpenSecurityGuardParamContext *context = [[OpenSecurityGuardParamContext alloc] init];
//    [context setRequestType:OPEN_ENUM_SIGN_COMMON_HMAC_SHA1];
//    [context setAppKey:appkey];
//    [context setParamDict:param];
//
//    NSString *sign = [comp signRequest:context authCode:nc.authCode];
//    if (sign.length == 0) {
//        PUSH_LOG_ERROR(@"[TBSDKAgooMessageCopy] decryptWithSecurityGuard, generate sign failed");
//        return nil;
//    }
//
//    NSData *signHex = [TBSDKPushUtilsCopy convertHexString:sign];
//    NSData *vecHex = [appkey dataUsingEncoding:NSUTF8StringEncoding];
//
//    return [TBSDKAgooMessageCopy decryptAES128WithContent:content withSign:signHex withVector:vecHex];
//}


+ (NSString *)decryptWithoutSecurityGuard:(NSString *)content withEncryptType:(AgooEncryptType)type {
    // 获取appkey 与 utdid
    NWNetworkConfiguration *nc = [NWNetworkConfiguration shareInstance];
    NSString *appkey = [nc appkey];
    NSString *appsecret = [nc appSecret];
    if (appkey.length==0 || appsecret.length==0) {
        NSLog(@"[TBSDKAgooMessageCopy] decryptWithSecurityGuard, appkey or appsecret is nil");
        return nil;
    }
    
//    TBSDKPushCenterConfiguration *pc = [TBSDKPushCenterConfiguration shareInstance];
//    NSString *info = type==kAgooEncryptDevice ? [nc utdid] : [pc pushUserToken];
    NSString *info = [nc utdid];
    if (info.length == 0) {
        NSLog(@"[TBSDKAgooMessageCopy] decryptWithSecurityGuard, info [type: %d] is nil", (int)type);
        return nil;
    }

    // 计算解密key
    NSData *sign = [TBSDKPushUtilsCopy hmacsha1:content key:[NSString stringWithFormat:@"%@%@", appkey, info]];
    if (sign.length == 0) {
        NSLog(@"[TBSDKAgooMessageCopy] decryptWithSecurityGuard, generate sign failed");
        return nil;
    }
    
    NSData *vec = [appkey dataUsingEncoding:NSUTF8StringEncoding];
    return [TBSDKAgooMessageCopy decryptAES128WithContent:content withSign:sign withVector:vec];
}


+ (NSString *)decryptAES128WithContent:(NSString *)content withSign:(NSData *)sign withVector:(NSData *)vec {
    NSData *signMD5 = [TBSDKPushUtilsCopy md5WithData:sign];
    NSData *vecMD5 = [TBSDKPushUtilsCopy md5WithData:vec];
    
    NSData *contentData = [[NSData alloc] initWithBase64EncodedString:[TBSDKPushUtilsCopy decodeBase64URLSafeString:content] options:0];
    NSData *decryptedContent = [TBSDKPushUtilsCopy decryptAES128WithData:contentData withKey:signMD5 withVector:vecMD5];
    if (decryptedContent.length == 0) {
        NSLog(@"[TBSDKAgooMessageCopy] decryptWithSecurityGuard, decryptAES128WithData failed");
        return nil;
    }
    NSString *str = [[NSString alloc] initWithData:decryptedContent encoding:NSUTF8StringEncoding];
    NSLog(@"str:%@",str);
    return [[NSString alloc] initWithData:decryptedContent encoding:NSUTF8StringEncoding];
}

+ (NSDictionary *)convert2Dictionary:(id)object {
    if ([object isKindOfClass:NSArray.class]) {
        NSArray *array = object;
        if (array.count == 0) {
            NSLog(@"[TBSDKAgooMessageCopy] the object.count is 0: %@", object);
            return nil;
        }
        
        NSDictionary *dict = [array objectAtIndex:0];
        if (![dict isKindOfClass:NSDictionary.class]) {
            NSLog(@"[TBSDKAgooMessageCopy] the object item is not Dictionary: @", object);
            return nil;
        }
        
        return dict;
    }
    
    if ([object isKindOfClass:NSDictionary.class]) {
        return object;
    }
    
    return nil;
}


+ (AgooEncryptType)encryptType:(unsigned int)flag {
    unsigned int mask = (flag & 0xF0) >> 4;
    NSLog(@"[TBSDKAgooMessageCopy] parse flag [ %u ] encrypt type [ %u ]", flag, mask);
    
    if (mask == 4) {
        return kAgooEncryptDevice;
    }
    else if (mask == 5) {
        return kAgooEncryptUser;
    }
    
    return kAgooEncryptNone;
}


+ (BOOL)isTesting:(unsigned int)flag {
    unsigned int mask = (flag & 0x1);
    
    return mask==0x1;
}

@end
