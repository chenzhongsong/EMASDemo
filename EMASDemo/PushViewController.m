//
//  PushViewController.m
//  EMASDemo
//
//  Created by wuchen.xj on 2018/7/17.
//  Copyright © 2018年 EMAS. All rights reserved.
//

#import "PushViewController.h"

#import <PushCenterSDK/TBSDKPushCenterConfiguration.h>
#import <PushCenterSDK/TBSDKPushCenterEngine.h>

@interface PushViewController ()

@property (strong, nonatomic) IBOutlet UITextField *tfAlias;
@property (strong, nonatomic) IBOutlet UISegmentedControl *sgAliasSetting;
@property (strong, nonatomic) IBOutlet UITextView *tvLog;

@end

@implementation PushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onAliasSettingChanged:(id)sender {
    if (_sgAliasSetting.selectedSegmentIndex == 0) {
        [self unbindUser];
    }
    else {
        [self bindUser];
    }
}


- (IBAction)onReportMessageArrived:(id)sender {
}

- (void)bindUser {
    NSString *alias = [self.tfAlias text];
    if (alias.length == 0) {
        [self displayText:@">> [ERROR] alias is empty!"];
        return;
    }
    
    TBSDKPushCenterEngine *pce = [TBSDKPushCenterEngine sharedInstanceWithDefaultConfigure];
    [pce bindUserIntoPushCenterWithAlias:alias userInfo:nil callback:^(NSDictionary *result, NSError *error){
        if (error) {
            [self displayText:[NSString stringWithFormat:@">> bind alias error: %@", error]];
        }
        else {
            [self displayText:@">> bind alias successfully"];
        }
    }];
}

- (void)unbindUser {
    TBSDKPushCenterEngine *pce = [TBSDKPushCenterEngine sharedInstanceWithDefaultConfigure];
    [pce unbindUserIntoPushCenterWithPushUserInfo:nil callback:^(NSDictionary *result, NSError *error){
        if (error) {
            [self displayText:[NSString stringWithFormat:@">> unbind alias error: %@", error]];
        }
        else {
            [self displayText:@">> unbind alias successfully"];
        }
    }];
}

- (void)displayText:(NSString*)text {
    if (text.length == 0) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tvLog insertText:text];
        [_tvLog insertText:@"\n"];
    });
    
}

@end
