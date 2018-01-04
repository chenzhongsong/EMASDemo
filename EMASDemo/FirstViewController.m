//
//  FirstViewController.m
//  EMASDemo
//
//  Created by zhishui.lcq on 2017/12/7.
//  Copyright © 2017年 zhishui.lcq. All rights reserved.
//

#import "FirstViewController.h"
#import <WeexSDK/WXSDKInstance.h>

@interface FirstViewController ()
    
@property (nonatomic, strong) WXSDKInstance *instance;
@property (nonatomic, strong) UIView *weexView;
    
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"First";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _instance = [[WXSDKInstance alloc] init];
    _instance.viewController = self;
    _instance.frame = self.view.frame;
    __weak typeof(self) weakSelf = self;
    _instance.onCreate = ^(UIView *view) {
        [weakSelf.weexView removeFromSuperview];
        weakSelf.weexView = view;
        [weakSelf.view addSubview:weakSelf.weexView];
    };
    _instance.onFailed = ^(NSError *error) {
        //process failure
    };
    _instance.renderFinish = ^ (UIView *view) {
        //process renderFinish
    };
    NSURL *url = [NSURL URLWithString:@"http://mt2.wapa.taobao.com/core/preview/act/msgwin1.js?MultiWindow=true"];
    [_instance renderWithURL:url];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
