/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

#import "WXCrashReporter.h"
#import "WXRecorder.h"

@implementation WXCrashReporter

/**
 * 数据上报额外信息提供。
 */
- (NSDictionary *)crashReporterAdditionalInformation {
    return @{
        // @"wx_currentUrl": [WXRecorder sharedInstance].currentURL.absoluteString ?: @"",
        @"wx_currentUrl": @"http://mobilehubdev.taobao.com/app/feitianyewu-mingzhi/testHa.js",
    };
}

@end
