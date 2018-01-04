//
//  TestClass.m
//  AlicloudHotFixTestApp
//
//  Created by junmo on 2017/9/18.
//  Copyright © 2017年 junmo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HFXTestClass.h"

@implementation HFXTestClass

typedef void (^BlockType)(NSString *);

- (NSString *)output {
    NSLog(@"[TestClass] origin output.");
    return @"[TestClass] origin output.";
}

@end
