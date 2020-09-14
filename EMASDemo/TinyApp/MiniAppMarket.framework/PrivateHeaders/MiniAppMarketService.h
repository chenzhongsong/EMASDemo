//
//  MiniAppMarketService.h
//  Miniprogram
//
//  Created by 时苒 on 2020/8/4.
//  Copyright © 2020 ShiRaner. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MiniAppMarketService : NSObject

+ (MiniAppMarketService *)shareInstance;

- (NSString *)appkey;
- (NSString *)appSecret;
- (NSString *)getAppVersion;
- (NSString *)MTOPDomain;
- (BOOL)useHTTP;


//- (NSString *)ACCSDomain;
//- (NSDictionary *)IPStrategy;
//- (NSString *)HAServiceID;
//- (NSString *)ChannelID;
//- (NSString *)ZCacheURL;
//- (NSString *)APIDomain;
//- (NSString *)HAOSSBucketName;
//- (NSString *)HAUploadType;
//- (NSString *)HAUniversalHost;
//- (NSString *)HATimestampHost;
//- (NSString *)HARSAPublicKey;
//- (NSString *)HotfixServerURL;
//- (NSString *)RemoteConfigHost;
 


@end

NS_ASSUME_NONNULL_END
