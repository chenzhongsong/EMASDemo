//
//  DTBootPhase+Category.m
//  mPaasiOSDemo
//
//  Created by 时苒 on 2020/7/23.
//  Copyright © 2020 ShiRaner. All rights reserved.
//

#import "DTBootPhase+Category.h"

#import <NebulaSDK/NBContext.h>
#pragma clang diagnostic push
#pragma clang diagnostic ignore "-Wobjc-protocol-method-implementation"


@implementation DTBootPhase (Category)

+ (DTBootPhase*)setupNavigationController {
    
    return [DTBootPhase phaseWithName:@"setupNavigationController" block:^{
        UINavigationController * navControl = [[[DTFrameworkInterface sharedInstance] bootLoader] createNavigationController];
        DTContextGet().navigationController = navControl;
    }];
}


@end
