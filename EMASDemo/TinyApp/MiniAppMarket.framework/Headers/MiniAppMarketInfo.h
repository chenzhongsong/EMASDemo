//
//  MiniAppMarketInfo.h
//  Miniprogram
//
//  Created by 时苒 on 2020/7/28.
//  Copyright © 2020 ShiRaner. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MiniAppMarketInfo : NSObject

@property (copy, nonatomic) NSString *miniprogramId;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *icon;
@property (copy, nonatomic) NSString *describe;
@property (copy, nonatomic) NSString *onlineStatus;

+ (MiniAppMarketInfo *)sharedIPListObject;

- (instancetype)initWithDic:(NSDictionary *)dic;





@end

NS_ASSUME_NONNULL_END
