//
//  WXScreenModule.m
//  Pods
//
//  Created by 齐山 on 17/4/28.
//
//

#import "EMASWXScreenModule.h"
#import <WeexSDK/WXConvert.h>
#import <WeexSDK/WXUtility.h>
#import <WeexPluginLoader/WeexPluginLoader.h>
#import "EMASHostViewController.h"

@interface EMASWXScreenModule()
@property(nonatomic)BOOL captureEnabled;
@property(nonatomic)BOOL alwaysOn;
@property(nonatomic)BOOL isObserver;
@property(nonatomic)CGFloat defaultBrightness;
@property(nonatomic)BOOL isSet;
@property(nonatomic,copy)WXModuleKeepAliveCallback callback;
@end

@implementation EMASWXScreenModule

@synthesize weexInstance;

WX_PlUGIN_EXPORT_MODULE(screen, EMASWXScreenModule)
WX_EXPORT_METHOD(@selector(setCaptureEnabled:callback:))
WX_EXPORT_METHOD(@selector(setAlwaysOn:))
WX_EXPORT_METHOD(@selector(setBrightness:))
WX_EXPORT_METHOD(@selector(setOrientation:callback:))

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setCaptureEnabled:(BOOL)on callback:(WXModuleKeepAliveCallback)callback
{
    self.callback = callback;
    self.captureEnabled = on;
    if(!self.isObserver){
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userDidScreenShort:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
        self.isObserver = YES;
    }
}

-(void)setAlwaysOn:(BOOL)on
{
    [UIApplication sharedApplication].idleTimerDisabled = on;
}

-(void)setBrightness:(CGFloat )brightness
{
    if(!self.isSet){
        self.defaultBrightness = [UIScreen mainScreen].brightness;
        self.isSet = YES;
    }
    if(brightness >1){
        brightness = 1;
    }
    if(brightness < 0){
        brightness = self.defaultBrightness;
    }
    [[UIScreen mainScreen] setBrightness:brightness];
}

- (void)userDidScreenShort:(NSNotification *)notification
{
    if(self.callback){
        if(!self.captureEnabled){
            self.callback(@{},YES);
        }
    }
}
- (void)setOrientation:(NSDictionary *)params callback:(WXModuleCallback)callback {
    UIViewController * parentVC = self.weexInstance.viewController.parentViewController;
    if (!parentVC) {
        return ;
    }
    
    UIViewController *viewController = self.weexInstance.viewController;
    if (!viewController || ![viewController isKindOfClass:[EMASWXRenderViewController class]]) {
        !callback?:callback(@{@"result":@"ViewController not support set orientation"});
        return;
    }
    
    NSString * orientation = [params objectForKey:@"orientation"];
    
    // 将 orientation 转换为 UIInterfaceOrientationMask。
    UIInterfaceOrientationMask mask = 0;
    if ([@"default" isEqualToString:orientation]) {
        mask = 0;
    } else if ([@"portrait" isEqualToString:orientation]) {
        mask = UIInterfaceOrientationMaskPortrait;
    } else if ([orientation hasPrefix:@"landscape"]) {
        if ([@"landscape" isEqualToString:orientation]) {
            mask = UIInterfaceOrientationMaskLandscape;
        } else if ([@"landscapeRight" isEqualToString:orientation]) {
            mask = UIInterfaceOrientationMaskLandscapeRight;
        } else if ([@"landscapeLeft" isEqualToString:orientation]) {
            mask = UIInterfaceOrientationMaskLandscapeLeft;
        }
    } else if ([@"portraitUpsideDown" isEqualToString:orientation]) {
        mask = UIInterfaceOrientationMaskPortraitUpsideDown;
    } else if ([@"auto" isEqualToString:orientation]) {
        mask = UIInterfaceOrientationMaskAll;
    }
    if (mask == 0) {
        !callback?:callback(@{@"result":@"Orientation not supported"});
        return;
    }
    
    // 获取所有支持的方向，便于过滤不支持的值。
    UIInterfaceOrientationMask supportedOrientation = [[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:viewController.view.window];
    if ((supportedOrientation & mask) == 0) {
        !callback?:callback(@{@"result":@"Orientation not supported in current window"});
        return;
    }
    
    ((EMASWXRenderViewController *)viewController).interfaceOrientationMask = mask;
}


@end
