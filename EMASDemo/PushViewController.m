//
//  PushViewController.m
//  EMASDemo
//
//  Created by wuchen.xj on 2018/7/17.
//  Copyright © 2018年 EMAS. All rights reserved.
//

#import "PushViewController.h"
#import <AliEMASConfigure/AliEMASConfigure.h>
#import <PushCenterSDK/TBSDKPushCenterConfiguration.h>
#import <PushCenterSDK/TBSDKPushCenterEngine.h>
#include <sys/utsname.h>
#import <objc/runtime.h>

@interface PushViewController ()
@property (weak, nonatomic) IBOutlet UILabel *appKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *appSecretLabel;
@property (weak, nonatomic) IBOutlet UILabel *bundleidLabel;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceModelLabel;
@property (weak, nonatomic) IBOutlet UITextView *deviceidLabel;

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *accsHostLabel;
@property (weak, nonatomic) IBOutlet UILabel *accsChannelLabel;

@property (weak, nonatomic) IBOutlet UITextField *aliasTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *bindSegmentControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *pushSegmentControl;

@property (nonatomic, assign) BOOL binded;
@property (nonatomic, assign) BOOL pushed;
@end

@implementation PushViewController
#pragma mark Temporary Area

#pragma mark - init Method

#pragma mark- View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    AliEMASConfigure *config = [AliEMASConfigure defaultConfigure];
    AliEMASOptions *options = config.options;
    self.appKeyLabel.text = options.appKey;
    self.appSecretLabel.text = options.appSecret;
    self.bundleidLabel.text = options.bundleID;
    self.brandLabel.text = @"iPhone";
    self.deviceModelLabel.text = [self.class currentModel];
    self.deviceidLabel.text = [self getUTDid];
    self.versionLabel.text = [@([[[UIDevice currentDevice] systemVersion] floatValue]) stringValue];
    self.accsHostLabel.text = options.accsOptions.defaultIP;
    self.accsChannelLabel.text = @"offline";
}

#pragma mark- Override Parent Methods

#pragma mark- SubViews Configuration

#pragma mark- Actions

- (IBAction)touchGestureAction:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)bindSegmentAction:(UISegmentedControl *)segmentControl {
    if (segmentControl.selectedSegmentIndex == 0) {
        [self bindUser];
    }
    
    if (segmentControl.selectedSegmentIndex == 1) {
        [self unbindUser];
    }
}

- (IBAction)pushSegmentAction:(UISegmentedControl *)segmentControl {
    
}

#pragma mark- Public Methods

#pragma mark- Delegate，DataSource, Callback Method

#pragma mark- Private Methods

- (void)bindUser {
    NSString *alias = [self.aliasTextField text];
    if (alias.length == 0) {
        [self displayText:@"别名不能为空"];
        
        if (!self.binded) {
            [self.bindSegmentControl setSelectedSegmentIndex:1];
        }
        
        return;
    }
    
    TBSDKPushCenterEngine *pce = [TBSDKPushCenterEngine sharedInstanceWithDefaultConfigure];
    [pce bindUserIntoPushCenterWithAlias:alias userInfo:nil callback:^(NSDictionary *result, NSError *error){
        if (error) {
            [self displayText:[NSString stringWithFormat:@"绑定别名错误:%@", error]];
            if (!self.binded) {
                [self.bindSegmentControl setSelectedSegmentIndex:1];
            } else {
                self.binded = YES;
            }
        }
    }];
}

- (void)unbindUser {
    TBSDKPushCenterEngine *pce = [TBSDKPushCenterEngine sharedInstanceWithDefaultConfigure];
    [pce unbindUserIntoPushCenterWithPushUserInfo:nil callback:^(NSDictionary *result, NSError *error){
        if (error) {
            [self displayText:[NSString stringWithFormat:@"解绑别名发生错误: %@", error]];
            if (self.binded) {
                [self.bindSegmentControl setSelectedSegmentIndex:0];
            }
        } else {
            self.binded = NO;
        }
    }];
}

- (void)displayText:(NSString*)text {
    if (text.length == 0) {
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:text preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:ok];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark- Getter Setter

#pragma mark- Helper Method
- (NSString *)getUTDid {
    id UTDevice$Class = objc_getClass("UTDevice");
    if ((UTDevice$Class == nil) || ![UTDevice$Class respondsToSelector: @selector(utdid)]) {
        return @"";
    }
    
    NSString *utdid = [UTDevice$Class performSelector: @selector(utdid)];
    return utdid;
}

+ (NSString *)currentModel{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *phoneModel = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([phoneModel isEqualToString:@"iPhone3,1"]||
        [phoneModel isEqualToString:@"iPhone3,2"]||
        [phoneModel isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([phoneModel isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([phoneModel isEqualToString:@"iPhone5,1"]||
        [phoneModel isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([phoneModel isEqualToString:@"iPhone5,3"]||
        [phoneModel isEqualToString:@"iPhone5,4"]) return @"iPhone 5C";
    if ([phoneModel isEqualToString:@"iPhone6,1"]||
        [phoneModel isEqualToString:@"iPhone6,2"]) return @"iPhone 5S";
    if ([phoneModel isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([phoneModel isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([phoneModel isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([phoneModel isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([phoneModel isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([phoneModel isEqualToString:@"iPhone9,1"]||
        [phoneModel isEqualToString:@"iPhone9,3"]) return @"iPhone 7";
    if ([phoneModel isEqualToString:@"iPhone9,2"]||
        [phoneModel isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus";
    if ([phoneModel isEqualToString:@"iPhone10,1"]||
        [phoneModel isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    if ([phoneModel isEqualToString:@"iPhone10,2"]||
        [phoneModel isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    if ([phoneModel isEqualToString:@"iPhone10,3"]||
        [phoneModel isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    if ([phoneModel isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    if ([phoneModel isEqualToString:@"iPhone11,4"]||
        [phoneModel isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
    if ([phoneModel isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    
    if ([phoneModel isEqualToString:@"iPad1,1"]) return @"iPad";
    if ([phoneModel isEqualToString:@"iPad2,1"] ||
        [phoneModel isEqualToString:@"iPad2,2"] ||
        [phoneModel isEqualToString:@"iPad2,3"] ||
        [phoneModel isEqualToString:@"iPad2,4"]) return @"iPad 2";
    if ([phoneModel isEqualToString:@"iPad3,1"] ||
        [phoneModel isEqualToString:@"iPad3,2"] ||
        [phoneModel isEqualToString:@"iPad3,3"]) return @"iPad 3";
    if ([phoneModel isEqualToString:@"iPad3,4"] ||
        [phoneModel isEqualToString:@"iPad3,5"] ||
        [phoneModel isEqualToString:@"iPad3,6"]) return @"iPad 4";
    if ([phoneModel isEqualToString:@"iPad4,1"] ||
        [phoneModel isEqualToString:@"iPad4,2"] ||
        [phoneModel isEqualToString:@"iPad4,3"]) return @"iPad Air";
    if ([phoneModel isEqualToString:@"iPad5,3"] ||
        [phoneModel isEqualToString:@"iPad5,4"]) return @"iPad Air 2";
    if ([phoneModel isEqualToString:@"iPad6,3"] ||
        [phoneModel isEqualToString:@"iPad6,4"]) return @"iPad Pro 9.7-inch";
    if ([phoneModel isEqualToString:@"iPad6,7"] ||
        [phoneModel isEqualToString:@"iPad6,8"]) return @"iPad Pro 12.9-inch";
    if ([phoneModel isEqualToString:@"iPad6,11"] ||
        [phoneModel isEqualToString:@"iPad6,12"]) return @"iPad 5";
    if ([phoneModel isEqualToString:@"iPad7,1"] ||
        [phoneModel isEqualToString:@"iPad7,2"]) return @"iPad Pro 12.9-inch 2";
    if ([phoneModel isEqualToString:@"iPad7,3"] ||
        [phoneModel isEqualToString:@"iPad7,4"]) return @"iPad Pro 10.5-inch";
    
    if ([phoneModel isEqualToString:@"iPad2,5"] ||
        [phoneModel isEqualToString:@"iPad2,6"] ||
        [phoneModel isEqualToString:@"iPad2,7"]) return @"iPad mini";
    if ([phoneModel isEqualToString:@"iPad4,4"] ||
        [phoneModel isEqualToString:@"iPad4,5"] ||
        [phoneModel isEqualToString:@"iPad4,6"]) return @"iPad mini 2";
    if ([phoneModel isEqualToString:@"iPad4,7"] ||
        [phoneModel isEqualToString:@"iPad4,8"] ||
        [phoneModel isEqualToString:@"iPad4,9"]) return @"iPad mini 3";
    if ([phoneModel isEqualToString:@"iPad5,1"] ||
        [phoneModel isEqualToString:@"iPad5,2"]) return @"iPad mini 4";
    
    if ([phoneModel isEqualToString:@"iPod1,1"]) return @"iTouch";
    if ([phoneModel isEqualToString:@"iPod2,1"]) return @"iTouch2";
    if ([phoneModel isEqualToString:@"iPod3,1"]) return @"iTouch3";
    if ([phoneModel isEqualToString:@"iPod4,1"]) return @"iTouch4";
    if ([phoneModel isEqualToString:@"iPod5,1"]) return @"iTouch5";
    if ([phoneModel isEqualToString:@"iPod7,1"]) return @"iTouch6";
    
    if ([phoneModel isEqualToString:@"i386"] || [phoneModel isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    
    return @"Unknown";
}


@end
