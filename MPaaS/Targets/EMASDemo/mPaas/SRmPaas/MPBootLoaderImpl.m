//
//  MPBootLoaderImpl.m
//  mPaasiOSDemo
//
//  Created by 时苒 on 2020/7/23.
//  Copyright © 2020 ShiRaner. All rights reserved.
//

#import "MPBootLoaderImpl.h"

#import "AppDelegate.h"

@implementation MPBootLoaderImpl

- (UINavigationController *)createNavigationController
{
    return [AppDelegate sharedInstance].navigationController;
}

- (UIWindow *)createWindow
{
    return [AppDelegate sharedInstance].window;
}

@end
