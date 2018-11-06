//
//  WVTBCrashReporter.h
//  TBExtension
//
//  Created by lianyu.ysj on 17/5/19.
//  Copyright © 2016年 WindVane. All rights reserved.
//

#import <TBCrashReporter/TBCrashReporterMonitor.h>
#import <Foundation/Foundation.h>

/**
 * 提供 TBCrashReporter 的 WindVane 数据上报功能。
 */
@interface EMASWVCrashReporter : NSObject <CrashReporterMonitorDelegate>

/**
 * 初始化 TBCrashReporter 的 WindVane 数据上报。
 */
+ (void)setup;

@end
