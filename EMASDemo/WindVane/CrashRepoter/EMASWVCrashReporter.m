//
//  WVTBCrashReporter.m
//  TBExtension
//
//  Created by lianyu.ysj on 17/5/19.
//  Copyright © 2016年 WindVane. All rights reserved.
//

#import "EMASWVCrashReporter.h"
#import <WindVaneBasic/WindVaneBasic.h>

@implementation EMASWVCrashReporter

/**
 * 初始化 TBCrashReporter 的 WindVane 数据上报。
 */
+ (void)setup {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		Class crashReporterMonitorCls = NSClassFromString(@"TBCrashReporterMonitor");
		if (crashReporterMonitorCls) {
			TBCrashReporterMonitor * sharedMonitor = [crashReporterMonitorCls wvInvoke:@selector(sharedMonitor)];
			[sharedMonitor registerCrashLogMonitor:[[self alloc] init]];
			WVLogInfo(WVModuleTBExt, @"Setup TBCrashReporter");
		}
	});
}

/**
 * 数据上报额外信息提供。
 */
- (NSDictionary *)crashReporterAdditionalInformation {
	return [WVWebViewRecorder currentWebViewInfo];
}

@end
