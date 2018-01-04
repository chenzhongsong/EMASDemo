//
//  WXResourceRequestHandlerDemoImpl.m
//  WeexDemo
//
//  Created by chenyilong on 24/11/2017.
//  Copyright © 2017 taobao. All rights reserved.
//

#import "WXResourceRequestHandlerDemoImpl.h"
#import <WeexSDK/WeexSDK.h>
//#import <WeexSDK/NSMutableDictionary.h>
#import <WeexSDK/WXAppConfiguration.h>
//#import "NSMutableDictionary.h"
//#import "WXAppConfiguration.h"
//#import <AlicloudHttpDNS/AlicloudHttpDNS.h>
#import <ZCache/ZCache.h>

@interface WXResourceRequestHandlerDemoImpl () <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSMutableURLRequest *request;

@end

@implementation WXResourceRequestHandlerDemoImpl {
    NSURLSession *_session;
    NSMutableDictionary<NSURLSessionDataTask *, id<WXResourceRequestDelegate>> *_delegates;
}

#pragma mark - WXResourceRequestHandler

- (void)sendRequest:(WXResourceRequest *)theRequest withDelegate:(id<WXResourceRequestDelegate>)delegate {
    // 网络请求前，先检查 ZCache，如果命中则直接返回
    NSDictionary *header;
    NSData* zcache = [ZCache resourceContentForURL:theRequest.URL.absoluteString     withHeader:&header error:nil];
    if (zcache && [zcache length] > 0) {
        NSLog(@"🔴类名与方法名：%@（在第%@行），描述：%@", @(__PRETTY_FUNCTION__), @(__LINE__), zcache);
        NSMutableDictionary * newHeader = [NSMutableDictionary dictionaryWithDictionary:header];
        newHeader[@"X-RequestType"] = @"ZCache";
        NSHTTPURLResponse * response = [[NSHTTPURLResponse alloc] initWithURL:theRequest.URL statusCode:200 HTTPVersion:@"1.1" headerFields:[newHeader copy]];
        [delegate request:theRequest didReceiveResponse:(WXResourceResponse *)response];
        [delegate request:theRequest didReceiveData:zcache];
        [delegate requestDidFinishLoading:theRequest];
        return;
    }
    
    self.request = [theRequest mutableCopy];
    if (!_session) {
        NSURLSessionConfiguration *urlSessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        if ([WXAppConfiguration customizeProtocolClasses].count > 0) {
            NSArray *defaultProtocols = urlSessionConfig.protocolClasses;
            urlSessionConfig.protocolClasses = [[WXAppConfiguration customizeProtocolClasses] arrayByAddingObjectsFromArray:defaultProtocols];
        }
        _session = [NSURLSession sessionWithConfiguration:urlSessionConfig
                                                 delegate:self
                                            delegateQueue:[NSOperationQueue mainQueue]];
        _delegates = [NSMutableDictionary new];
    }
    
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:theRequest];
    theRequest.taskIdentifier = task;
    [_delegates setObject:delegate forKey:task];
    [task resume];
}

- (void)cancelRequest:(WXResourceRequest *)request
{
    if ([request.taskIdentifier isKindOfClass:[NSURLSessionTask class]]) {
        NSURLSessionTask *task = (NSURLSessionTask *)request.taskIdentifier;
        [task cancel];
        [_delegates removeObjectForKey:task];
    }
}

#pragma mark - NSURLSessionTaskDelegate & NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    id<WXResourceRequestDelegate> delegate = [_delegates objectForKey:task];
    [delegate request:(WXResourceRequest *)task.originalRequest didSendData:bytesSent totalBytesToBeSent:totalBytesExpectedToSend];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)task
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    id<WXResourceRequestDelegate> delegate = [_delegates objectForKey:task];
    [delegate request:(WXResourceRequest *)task.originalRequest didReceiveResponse:(WXResourceResponse *)response];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)task didReceiveData:(NSData *)data
{
    id<WXResourceRequestDelegate> delegate = [_delegates objectForKey:task];
    [delegate request:(WXResourceRequest *)task.originalRequest didReceiveData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    id<WXResourceRequestDelegate> delegate = [_delegates objectForKey:task];
    if (error) {
        [delegate request:(WXResourceRequest *)task.originalRequest didFailWithError:error];
    }else {
        [delegate requestDidFinishLoading:(WXResourceRequest *)task.originalRequest];
    }
    [_delegates removeObjectForKey:task];
}

#ifdef __IPHONE_10_0
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics
{
    id<WXResourceRequestDelegate> delegate = [_delegates objectForKey:task];
    [delegate request:(WXResourceRequest *)task.originalRequest didFinishCollectingMetrics:metrics];
}
#endif

@end

