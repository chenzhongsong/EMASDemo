//
//  WVH5APPURLProtocol.m
//  WindVane
//
//  Created by shuxiao on 14-6-17.
//  Copyright (c) 2014年 WindVane 项目组. All rights reserved.
//

#import "EMASWindVaneURLProtocol.h"
#import <WindVaneCore/WindVaneCorePrivate.h>
#import <ZCache/ZCache.h>

@interface EMASWindVaneURLProtocol ()

// 如果取消加载请求后，要向线上的响应中增加的 Header 内容。
@property (nonatomic, copy) NSDictionary<NSString *, NSString *> * externalHeaders;

@end

@implementation EMASWindVaneURLProtocol

/**
 * 加载指定请求，并返回是否可以加载。
 *
 * @param request      要加载的请求。
 * @param successBlock 加载成功的回调。
 * @param failBlock    加载失败的回调。
 *
 * @return 如果可以加载指定请求，则返回 YES；如果不能加载指定请求，则返回 NO，WVURLProtocol 会重新发出线上请求。
 */
- (BOOL)canLoadRequest:(NSURLRequest *)request withSuccess:(WVURLProtocolSuccessBlock)successBlock withFailure:(WVURLProtocolFailureBlock)failBlock {
	// 关闭 PackageApp 功能。
	if ([WVConfigManager commonConfig].packageAppStatus == WVModuleStatusClosed) {
		return NO;
	}

	// 不处理非 http/https 的资源，并兼容无 scheme 的资源。
	WVURLScheme scheme = request.URL.wvSchemeDefine;
	if (scheme != WVURLSchemeNone && scheme != WVURLSchemeHttp && scheme != WVURLSchemeHttps) {
		return NO;
	}

	NSString * urlString = request.URL.absoluteString;
	NSDictionary * header;
	NSError * error;
	NSData * data = [ZCache resourceContentForURL:urlString withHeader:&header error:&error];
	// 增加额外响应 Header。
	WVURLRule * rule = [[WVConfigManager domainConfig] getURLRule:urlString];
	if (rule) {
		NSMutableDictionary * responseHeader = [NSMutableDictionary dictionaryWithDictionary:header];
		[responseHeader wvAddNewEntriesFromDictionary:rule.pkgHeader];
		header = [responseHeader copy];
	}
	_externalHeaders = header;
	if (data) {
		NSHTTPURLResponse * httpResponse = [[NSHTTPURLResponse alloc] initWithURL:request.URL statusCode:200 HTTPVersion:WVHttpVersion1_1 headerFields:header];
        successBlock(httpResponse, data, WVURLProtocolReadFromDiskCache);//][header wvIntegerValue:@"X-ZCache-Type"]);
		return YES;
	} else {
		return NO;
	}
}

@end
