//
//  MPaaSInterface+EMASDemo.m
//  EMASDemo
//
//  Created by shiran on 2020/08/21. All rights reserved.
//

#import "MPaaSInterface+EMASDemo.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation MPaaSInterface (EMASDemo)

- (BOOL)enableSettingService
{
    return NO;
}

- (NSString *)userId
{
    return @"rock445566";
}

@end

#pragma clang diagnostic pop

