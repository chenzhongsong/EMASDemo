//
//  NotificationService.m
//  pushextension
//
//  Created by wuchen.xj on 2018/7/24.
//  Copyright © 2018年 Taobao.com. All rights reserved.
//

#import "NotificationService.h"
#import "TBNotificationServiceError.h"

#define ICON_KEY            @"icon"

#define SHARED_GROUP_NAME   @"group.com.taobao.taobao4iphone.extension"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

/**
 * 图片下载Session, 全局只有一个即可。
 */
+ (NSURLSession *)thumbnailSession {
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        session = [NSURLSession sessionWithConfiguration:config];
    });
    
    return session;
}


/**
 * 埋点等反馈信息上报专用线程，并发队列。
 */
+ (dispatch_queue_t)feedbackQueue {
    static dispatch_queue_t queue = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.taobao.notificationservice.extension.report", DISPATCH_QUEUE_SERIAL);
    });
    
    return queue;
}


/**
 * 下载小图资源到本地
 */
-(void)download2disk:(NSURL *)url completionHandler: (void (^)(NSURL *localUrl, TBNotificationServiceError *error)) handler {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NotificationService thumbnailSession];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // 图片下载失败
        if ( error ) {
            NSLog(@"[NotificationService] download2disk: error=%@", error.localizedDescription);
            handler(nil, TB_NS_ERROR(NSE_DOWNLOAD_IMAGE_FAILED, error.code, error.localizedDescription));
            return;
        }
        
        
        // 首先检查文件是否已经存在,如果文件已经存在，把原来的同名文件删除
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        
        if ( [fm fileExistsAtPath:path] ) {
            NSError *removeError = nil;
            [fm removeItemAtPath:path error:&removeError];
            
            if ( removeError ) {
                NSLog(@"[NotificationService] download2disk, remove existed failed: %@", removeError.localizedDescription);
                handler(nil, TB_NS_ERROR(NSE_REMOVE_EXISTED_IMAGE_FAILED, removeError.code, removeError.localizedDescription));
                return;
            }
        }
        
        // 将下载下来的临时文件复制到caches文件夹中
        NSError *copyError = nil;
        [fm copyItemAtPath:location.path toPath:path error:&copyError];
        if ( copyError ) {
            NSLog(@"[NotificationService] download2disk, copy image failed: %@", copyError.localizedDescription);
            handler(nil, TB_NS_ERROR(NSE_COPY_IMAGE_FAILED, copyError.code, copyError.localizedDescription));
            return;
        }
        
        handler([NSURL fileURLWithPath:path], nil);
    }];
    
    [task resume];
}

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    NSLog(@"EMASDEMO Notification Service: %@", request.content.userInfo);
    
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    NSDictionary *aps = [request.content.userInfo objectForKey:@"aps"];
    if (!aps || ![aps isKindOfClass:NSDictionary.class]) {
        // do nothing
        self.contentHandler(self.bestAttemptContent);
        return;
    }
    
    // 修改提示音
    NSString *sound = [aps objectForKey:@"sound"];
    if (sound && [sound isKindOfClass:NSString.class] && sound.length > 0) {
        if ( ![sound isEqualToString:@"default"] ) {
            self.bestAttemptContent.sound = [UNNotificationSound soundNamed:@"hongbao.wav"];
        }
        else {
            self.bestAttemptContent.sound = [UNNotificationSound defaultSound];
        }
    }
    
    // 有ICON字段，即显示指定小图
    if ( [self.bestAttemptContent.userInfo objectForKey:ICON_KEY] ) {
        NSLog(@"Notification Service: attach icon.");
        
        NSURL *iconUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"icon_two_selected.png" ofType:nil]];
        
        UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"attachment"
                                                                                              URL:iconUrl
                                                                                          options:nil
                                                                                            error:nil];
        self.bestAttemptContent.attachments = @[attachment];
        self.contentHandler(self.bestAttemptContent);
    }
    
    // 上报埋点
    NSString *messageId = [request.content.userInfo objectForKey:@"m"];
    [self reportMessageArrived:messageId error:nil];
}

- (void)serviceExtensionTimeWillExpire {
    self.contentHandler(self.bestAttemptContent);
}

- (void)reportMessageArrived:(NSString *)messageId error:(TBNotificationServiceError *)error {
    
    __block NSString *t_msgid = [messageId copy];
    __block TBNotificationServiceError *t_error = [error copy];
    
    dispatch_async([NotificationService feedbackQueue], ^(){
        NSLog(@"[NotificationService] reportFeedback: %ld", error.code);
        
        NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:SHARED_GROUP_NAME];
        NSString *appkey = [sharedDefaults objectForKey:@"TB_PUSH_EXTENSION_APPKEY"];
        NSString *agootoken = [sharedDefaults objectForKey:@"TB_PUSH_EXTENSION_AGOO_TOKEN"];
        NSString *reportHost = [sharedDefaults objectForKey:@"TB_PUSH_EXTENSION_AGOO_REPORT_HOST"];
        
        if (reportHost.length == 0) {
            NSLog(@"[NotificationService] the report HOST is empty!");
            return;
        }
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:(appkey.length>0 ? appkey : @"") forKey:@"appkey"];
        [dict setValue:(agootoken.length>0 ? agootoken : @"") forKey:@"tbAppDeviceToken"];
        [dict setValue:(t_msgid.length>0 ? t_msgid : @"") forKey:@"id"];
        [dict setValue:@"4" forKey:@"status"];
        
        if (t_error != nil) {
            [dict setValue:[NSString stringWithFormat:@"%ld", t_error.code] forKey:@"ec"];
            [dict setValue:[NSString stringWithFormat:@"%ld", t_error.subcode] forKey:@"subec"];
        }
        
        NSData *body = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
        
        NSString *url = [NSString stringWithFormat:@"https://%@/apns/", reportHost];
        NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
        [req setHTTPMethod:@"POST"];
        [req setHTTPBody:body];
        
        NSURLSessionDataTask * task = [[NotificationService thumbnailSession] dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if ( error ) {
                NSLog(@"[NotificationService] report error: %@", error);
            }
            
            //NSLog(@"[NotificationService] ACK response: %@", response);
            //NSLog(@"[NotificationService] ACK body: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            
        }];
        [task resume];
    });
}

@end
