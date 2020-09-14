//
//  MiniAppMarketCenter.h
//  Miniprogram
//
//  Created by 时苒 on 2020/7/28.
//  Copyright © 2020 ShiRaner. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MiniAppMarketInfo;

NS_ASSUME_NONNULL_BEGIN

typedef void (^completeBlock)(void);

@interface MiniAppMarketCenter : NSObject

+ (instancetype)shareInstance;


/*! 同步接口
 * @brief 获取小程序列表
 * @details 分页返回已上线的小程序列表, 按创建时间倒序
 * @param pageNo 页码, 1 开始 , 默认为 1
 * @param pageSize 每页 size, 默认为1000
*/
- (NSDictionary *)miniProgramlist:(NSString * )pageNo pageSize:(NSString * )pageSize;

/*! 同步接口
 * @brief 查询小程序状态
 * @details 查询单个小程序的状态
 * @param programId 小程序id , 对应 mpaas h5Id,  16位数字
*/
- (MiniAppMarketInfo *)miniProgramStatus:(NSString * )programId;

 
/*! 异步接口
 * @brief 获取小程序列表
 * @details 分页返回已上线的小程序列表, 按创建时间倒序
 * @param pageNo 页码, 1 开始 , 默认为 1
 * @param pageSize 每页 size, 默认为1000
 * @param dic ：NSDictionary
*/
- (void)asyncMiniProgramlist:(NSString * )pageNo
                    pageSize:(NSString * )pageSize
                   withData:(void(^)(id dic))dic;

/*! 异步接口
 * @brief 查询小程序状态
 * @details 查询单个小程序的状态
 * @param programId 小程序id , 对应 mpaas h5Id,  16位数字
 * @param info ：MiniAppMarketInfo
*/
- (void)asyncMiniProgramStatus:(NSString * )programId
                     withData:(void(^)(id info))info;


@end

 
NS_ASSUME_NONNULL_END
