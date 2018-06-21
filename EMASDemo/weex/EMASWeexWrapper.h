//
//  EMASWeexWrapper.h
//  EMASDemo
//
//  Created by EMAS on 2018/6/14.
//  Copyright © 2018年 EMAS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMASWeexWrapper : NSObject

+ (void)initWeexDefaultConfigWithAppGroup:(NSString *)appGroup
                                  appName:(NSString *)appName
                               appVersion:(NSString *)appVersion;


@end
