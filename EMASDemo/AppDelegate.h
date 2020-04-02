//
//  AppDelegate.h
//  EMASDemo
//
//  Created by EMAS on 2017/12/7.
//  Copyright © 2017年 EMAS. All rights reserved.
//

#import <UIKit/UIKit.h>
// --ACCS头文件
#import <TBAccsSDK/TBAccsManager.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (copy, nonatomic) NSString *agooDeviceToken;
@property (nonatomic, strong) TBAccsManager *accsManager;
@end

