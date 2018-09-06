//
//  EMASWeexContainerService.h
//  EMASWeexDemo
//
//  Created by daoche.jb on 2018/8/23.
//  Copyright © 2018年 EMAS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMASWeexContainerService : NSObject

+ (EMASWeexContainerService *)shareInstance;

- (NSNumber *)tabSize;

- (NSDictionary *)jsSource;

@end
