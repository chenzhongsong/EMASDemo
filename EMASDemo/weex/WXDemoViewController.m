//
//  DemoWeexViewController.m
//  EMASDemo
//
//  Created by daoche.jb on 2018/6/28.
//  Copyright © 2018年 EMAS. All rights reserved.
//

#import "WXDemoViewController.h"
#import <objc/message.h>
#import <WeexSDK/WXDebugTool.h>
#import "UIViewController+WXDemoNaviBar.h"
#import <DynamicConfiguration/DynamicConfigurationManager.h>
#import "ExEMASWXViewController.h"

@interface WXDemoViewController()

@property (nonatomic, copy) NSString *resourceUrlString;

@end

@implementation WXDemoViewController

- (void)dealloc {
    if (self.wxViewController) {
        [self.wxViewController removeFromParentViewController];
    }
}

- (id)initWithNavigatorURL:(NSURL *)URL {
    self = [super init];
    if (self) {
        self.resourceUrlString = URL.absoluteString;
        NSString * urlString = [[DynamicConfigurationManager sharedInstance] redirectUrl:[URL absoluteString]];

        self.wxViewController = [[ExEMASWXViewController alloc] initWithNavigatorURL:[NSURL URLWithString:urlString] withCustomOptions:@{@"bundleUrl":urlString} withInitData:nil withViewController:self];
        //渲染容器的外部代理。
        self.wxViewController.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNaviBar];
    [self setupRightBarItem];
    
    //务必设置这个属性，它与导航栏隐藏属性相关。
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //在宿主容器中添加渲染容器和视图。
    [self.view addSubview:self.wxViewController.view];
    [self addChildViewController:self.wxViewController];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRefreshInstance:) name:@"RefreshInstance" object:nil];
}

# pragma mark WXViewController Delegate

//内存报警时销毁非当前实例, 是否销毁通过配置下发。
- (void)wxDidReceiveMemoryWarning {
    id weex_memory_warning_destroy = @"1";
    if (weex_memory_warning_destroy && [@"1" isEqualToString:weex_memory_warning_destroy]) {
        if (self.wxViewController.isViewLoaded && [self.view window] == nil ) {
            [self.wxViewController.instance destroyInstance];
            self.wxViewController.instance = nil;
        }
    }
}

- (void)wxFinishCreateInstance {
    //Weex Instance创建成功
}

- (void)wxFailCreateInstance:(NSError *)error {
    //Weex Instance创建失败
    if ([error.localizedDescription containsString:@"404"]) {
        [[DynamicConfigurationManager sharedInstance] deleteConfigurationForGoalUrl:self.resourceUrlString];
    }
}

- (void)wxFinishRenderInstance {
    //Weex Instance渲染完成
}

#pragma mark - UIBarButtonItems

- (void)setupRightBarItem
{
    if ([WXDebugTool isDebug]){
        [self loadRefreshCtl];
    }
}

- (void)loadRefreshCtl {
    UIBarButtonItem *refreshButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reload"] style:UIBarButtonItemStylePlain target:self.wxViewController action:@selector(refreshWeex)];
    refreshButtonItem.accessibilityHint = @"click to reload curent page";
    self.navigationItem.rightBarButtonItem = refreshButtonItem;
}

#pragma mark - websocket
- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    if ([@"refresh" isEqualToString:message]) {
        [self.wxViewController refreshWeex];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    
}

#pragma mark - notification
- (void)notificationRefreshInstance:(NSNotification *)notification {
    [self.wxViewController refreshWeex];
}

@end


