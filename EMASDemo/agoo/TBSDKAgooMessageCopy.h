//
//  TBSDKPushMessage.h
//  PushCenterSDK
//
//  Created by wuchen.xj on 2017/5/25.
//  Copyright © 2017年 yidao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface TBSDKAgooMessageCopy : NSObject

@property (nonatomic, strong, readonly) NSString        *identifier;
@property (nonatomic, strong, readonly) NSString        *package;
@property (nonatomic, strong, readonly) NSString        *body;
@property (nonatomic, strong, readonly) NSDictionary    *ext;
@property (nonatomic, assign, readonly) unsigned int    flag;
@property (nonatomic, assign, readonly) BOOL            isTesting;

- (instancetype)initWithId:(NSString *)identifier
               withPackage:(NSString *)package
                  withBody:(NSString *)body
                   withExt:(NSDictionary*)ext
                  withFlag:(unsigned int)flag;


+ (TBSDKAgooMessageCopy *)convertFromAccsMessage:(NSDictionary *)dictionay
                                   withError:(NSError **)error;



@end
