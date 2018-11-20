//
//  PushMessageReceiver.m
//  EMASDemo
//
//  Created by wuchen.xj on 2018/11/15.
//  Copyright © 2018年 EMAS. All rights reserved.
//

#import "PushMessageReceiver.h"

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@implementation PushMessageReceiver

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    
    NSLog(@">>>>>>> [AGOO MESSAGE]: %@", userInfo);
    
    NSString *text = [userInfo description];
    if ( !text ) {
        text = @"消息解析失败!";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"AGOO 消息" message:text delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [alert show];
}

@end
