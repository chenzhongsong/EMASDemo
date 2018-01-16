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

#import "WXAppMonitorHandler.h"
#import <UT/AppMonitorTable.h>

#define SPM     @"spm"
#define SCHEME  @"scheme"

#define FSCALLJSTOTALNUM   @"fsCallJsTotalNum"
#define FSCALLNATIVETOTALNUM @"fsCallNativeTotalNum"
#define FSREQUESTNUM @"fsRequestNum"
#define MAXDEEPVIEWLAYER @"maxDeepViewLayer"
#define USESCROLLER @"useScroller"
#define CELLEXCEEDNUM @"cellExceedNum"
#define TIMERINVOKECOUNT @"timerInvokeCount"
#define AVGFPS @"avgFps"
#define MAXIMPROVEMEMORY @"maxImproveMemory"
#define BACKIMPROVEMEMORY @"backImproveMemory"
#define PUSHIMPROVEMEMORY @"pushImproveMemory"

@implementation WXAppMonitorHandler

- (void)commitAppMonitorArgs:(NSDictionary *)args {
    
    NSString* customMonitorInfo = [args objectForKey:WXCUSTOMMONITORINFO]?:@"";
    NSString* jslibVersion = [args objectForKey:JSLIBVERSION];
    NSString* wxSDKVersion = [args objectForKey:WXSDKVERSION];
    NSURL * pageNameURL = [NSURL URLWithString:[args objectForKey:PAGENAME]];
    NSString* pageName = [WXAppMonitorHandler handlePageName:pageNameURL];
    NSString* spm = [[WXAppMonitorHandler parseURLParams:pageNameURL.query] objectForKey:@"spm"]?:@"";
    NSString* scheme = pageNameURL.scheme?:@"";
    NSString* requestType = [args objectForKey:WXREQUESTTYPE]?:@"";
    NSString* connectionType = [args objectForKey:WXCONNECTIONTYPE]?:@"";
    NSString* networkType = [args objectForKey:NETWORKTYPE]?:@"unknown";
    NSString* cacheTpye = @"";
    
    id json = [NSJSONSerialization JSONObjectWithData:[customMonitorInfo dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    if (json && [json isKindOfClass:[NSDictionary class]]) {
        cacheTpye = [json objectForKey:@"cacheType"] ?: @"none";
    }
    
    CGFloat jsLibSize = [[args objectForKey:JSLIBSIZE] floatValue]/1024;
    CGFloat JSLibInitTime = [[args objectForKey:JSLIBINITTIME] floatValue];
    CGFloat sdkInitTime = [[args objectForKey:SDKINITTIME] floatValue];
    CGFloat sdkInitInvokeTime = [[args objectForKey:SDKINITINVOKETIME] floatValue];
    CGFloat jsTemplateSize = [[args objectForKey:JSTEMPLATESIZE] floatValue]/1024;
    CGFloat networkTime = [[args objectForKey:NETWORKTIME] floatValue];
    
    CGFloat callCreateInstanceTime = [[args objectForKey:CALLCREATEINSTANCETIME] floatValue];
    CGFloat communicateTotalTime = [[args objectForKey:COMMUNICATETOTALTIME] floatValue];
    CGFloat fsRenderTime = [[args objectForKey:FSRENDERTIME] floatValue];
    NSUInteger componentCount = [[args objectForKey:COMPONENTCOUNT] integerValue];
    
    AppMonitorTable * table = [AppMonitorTable monitorForScheme:@"weex" tableName:@"load"];
    
    // step2: register cols and rows； 列认为是一些可枚举的条件。行认为是在这些条件组合下的均值（必须是float类型）。
    // 设置为不聚合，row的值不会在客户端做累加，直接上报原始数据
    [table registerTableWithRows:@[
                                   JSLIBSIZE,
                                   JSLIBINITTIME,
                                   SDKINITTIME,
                                   SDKINITINVOKETIME,
                                   JSTEMPLATESIZE,
                                   NETWORKTIME,
                                   FSRENDERTIME,
                                   CALLCREATEINSTANCETIME,
                                   COMMUNICATETOTALTIME,
                                   COMPONENTCOUNT,
                                   FSCALLJSTOTALNUM,
                                   FSCALLNATIVETOTALNUM,
                                   FSREQUESTNUM,
                                   MAXDEEPVIEWLAYER,
                                   USESCROLLER,
                                   CELLEXCEEDNUM,
                                   TIMERINVOKECOUNT,
                                   AVGFPS,
                                   MAXIMPROVEMEMORY,
                                   BACKIMPROVEMEMORY,
                                   PUSHIMPROVEMEMORY
                                   ]
                         columns:@[JSLIBVERSION,
                                   WXSDKVERSION,
                                   PAGENAME,
                                   SPM,
                                   SCHEME,
                                   WXREQUESTTYPE,
                                   WXCONNECTIONTYPE,
                                   NETWORKTYPE,
                                   CACHETYPE
                                   ]
                       aggregate:YES];
    
    // step3: add Constraint; 约束是对于 行（指标）来说的
    [table addConstraintWithName:JSLIBSIZE min:0 max:2000 defaultValue:0];
    [table addConstraintWithName:JSTEMPLATESIZE min:0 max:2000 defaultValue:0];
    [table addConstraintWithName:NETWORKTIME min:-1 max:1500000 defaultValue:0];
    [table addConstraintWithName:FSRENDERTIME min:-1 max:500000 defaultValue:0];
    [table addConstraintWithName:CALLCREATEINSTANCETIME min:0 max:100000 defaultValue:0];
    [table addConstraintWithName:COMMUNICATETOTALTIME min:0 max:500000 defaultValue:0];
    
    [table addConstraintWithName:FSREQUESTNUM min:-1 max:20000 defaultValue:0];
    [table addConstraintWithName:USESCROLLER min:0 max:10000 defaultValue:0];
    [table addConstraintWithName:AVGFPS min:-1 max:600000 defaultValue:0];
    [table addConstraintWithName:MAXIMPROVEMEMORY min:-1 max:60000 defaultValue:0];
    [table addConstraintWithName:BACKIMPROVEMEMORY min:-1 max:60000 defaultValue:0];
    [table addConstraintWithName:PUSHIMPROVEMEMORY min:-1 max:60000 defaultValue:0];
    [table addConstraintWithName:MAXDEEPVIEWLAYER min:-1 max:60000 defaultValue:0];
    [table addConstraintWithName:COMPONENTCOUNT min:-1 max:60000 defaultValue:0];
    [table addConstraintWithName:FSCALLJSTOTALNUM min:-1 max:60000 defaultValue:0];
    [table addConstraintWithName:CELLEXCEEDNUM min:-1 max:600000 defaultValue:0];
    [table addConstraintWithName:TIMERINVOKECOUNT min:-1 max:60000 defaultValue:0];
    [table addConstraintWithName:FSCALLNATIVETOTALNUM min:-1 max:600000 defaultValue:0];
    [table addConstraintWithName:SDKINITINVOKETIME min:0 max:60000 defaultValue:0];
    [table addConstraintWithName:SDKINITTIME min:0 max:60000 defaultValue:0];
    [table addConstraintWithName:JSLIBINITTIME min:0 max:60000 defaultValue:0];
    
    // step4: update table
    [table updateTableForColumns:@{
                                   JSLIBVERSION:jslibVersion,
                                   WXSDKVERSION:wxSDKVersion,
                                   PAGENAME:pageName,
                                   SPM: spm,
                                   SCHEME: scheme,
                                   WXREQUESTTYPE:requestType,
                                   WXCONNECTIONTYPE:connectionType,
                                   NETWORKTYPE:networkType,
                                   CACHETYPE:cacheTpye
                                   }
                            rows:@{
                                   JSLIBSIZE:@(jsLibSize),
                                   JSLIBINITTIME:@(JSLibInitTime),
                                   SDKINITTIME:@(sdkInitTime),
                                   SDKINITINVOKETIME:@(sdkInitInvokeTime),
                                   JSTEMPLATESIZE:@(jsTemplateSize),
                                   NETWORKTIME:@(networkTime),
                                   FSRENDERTIME:@(fsRenderTime),
                                   CALLCREATEINSTANCETIME:@(callCreateInstanceTime),
                                   COMMUNICATETOTALTIME:@(communicateTotalTime),
                                   COMPONENTCOUNT:@(componentCount),
                                   FSCALLJSTOTALNUM:@(0),
                                   FSCALLNATIVETOTALNUM:@(0),
                                   FSREQUESTNUM:@(0),
                                   MAXDEEPVIEWLAYER:@(0),
                                   USESCROLLER:@(0),
                                   CELLEXCEEDNUM:@(0),
                                   TIMERINVOKECOUNT:@(0),
                                   AVGFPS:@(0),
                                   MAXIMPROVEMEMORY:@(0),
                                   BACKIMPROVEMEMORY:@(0),
                                   PUSHIMPROVEMEMORY:@(0)
                                   }
     ];
}

- (void) commitAppMonitorAlarm:(NSString *)pageName monitorPoint:(NSString *)monitorPoint success:(BOOL)success errorCode:(NSString *)errorCode errorMsg:(NSString *)errorMsg arg:(NSString *)arg {
    
    
}

+ (NSString *)handlePageName:(NSURL*)oldPageNameURL
{
    NSString * newPageName = @"";
    NSMutableDictionary * params = [self parseURLParams:[oldPageNameURL query]];
    NSString * spm = nil;
    if (params[@"spm"]) {
        spm = [NSString stringWithFormat:@"?spm=%@",params[@"spm"]];
    }
    // newPageName = host + path + ? spm = spmValue
    newPageName = [NSString stringWithFormat:@"%@%@%@", oldPageNameURL.host?:@"", oldPageNameURL.path?:@"", spm?:@""];
    
    return newPageName;
}

+ (NSMutableDictionary*)parseURLParams:(NSString*)queryValue
{
    if (!queryValue) {
        return nil;
    }
    
    NSArray * pairs = [queryValue componentsSeparatedByString:@"&"];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    for (NSString * pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        if (kv.count == 2) {
            NSString * val = [[kv objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if (val) {
                [params setObject:val forKey:[kv objectAtIndex:0]];
            }
        }
    }
    
    return params;
}

+ (void)monitorWithNetWorkResponse:(WXResourceResponse*)response instance:(WXSDKInstance*)instance response:(WXResourceRequest*)request data:(NSData*)data error:(NSError*)error
{
    if (!instance) return;
    
    NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse*)response;
    if (!instance.userInfo) {
        instance.userInfo = [NSMutableDictionary new];
    }
    
    if (httpResponse.allHeaderFields[@"X-RequestType"]) {
        instance.userInfo[@"weex_bundlejs_requestType"] = @"ZCache";
        instance.userInfo[@"weex_bundlejs_connectionType"] = @"ZCache";
    } else {
        if (!instance.userInfo[@"weex_bundlejs_requestType"]) {
            instance.userInfo[@"weex_bundlejs_requestType"] = @"network";
        }
        if (!instance.userInfo[@"weex_bundlejs_connectionType"]) {
            NSString *connectionType = @"";
            if (httpResponse.allHeaderFields[@"protocolType"]) {
                connectionType = httpResponse.allHeaderFields[@"protocolType"];
            } else {
                connectionType = request.URL.scheme;
            }
            instance.userInfo[@"weex_bundlejs_connectionType"] = connectionType;
        }
    }
}

@end

