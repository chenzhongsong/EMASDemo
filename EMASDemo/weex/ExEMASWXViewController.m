//
//  ExEMASWXViewController.m
//  EMASDemo
//
//  Created by daoche.jb on 2018/6/28.
//  Copyright © 2018年 EMAS. All rights reserved.
//

#import "ExEMASWXViewController.h"
#import <DynamicConfiguration/DynamicConfigurationManager.h>

@interface ExEMASWXViewController () <UIScrollViewDelegate, UIWebViewDelegate>

@property (nonatomic, weak) id<UIScrollViewDelegate> originalDelegate;
@property (nonatomic, strong)  UIActivityIndicatorView *pageLoadingIndicator;

@end

@implementation ExEMASWXViewController

//获取宿主容器的导航控制器。由于当前渲染容器是通过addChildViewController的方式添加到宿主容器中，因此所属的导航控制器应该是通过宿主容器获取。
- (UIViewController *)wxNavigationController {
    if (self.parentVC) {
        return self.parentVC.navigationController;
    }
    return nil;
}

//渲染时需要的URL，供子类定制，默认是初始化传入的url
- (NSURL*)renderURL:(NSString*)url
{
    NSRange range = [url rangeOfString:@"_wx_tpl"];
    if (range.location != NSNotFound) {
        NSString *tmp = [url substringFromIndex:range.location];
        NSUInteger start = [tmp rangeOfString:@"="].location;
        NSUInteger end = [tmp rangeOfString:@"&"].location;
        ++start;
        if (end == NSNotFound) {
            end = [tmp length] - start;
        }
        else {
            end = end - start;
        }
        NSRange subRange;
        subRange.location = start;
        subRange.length = end;
        url = [tmp substringWithRange:subRange];
    }
    return [NSURL URLWithString:url];
}


//获取渲染容器包含的子视图控制器。例如，web对应的component，它会生成webviewController，并通过addChileViewController的方式添加到渲染容器中。
- (NSMutableArray *)wxChildViewControllers {
    return (NSMutableArray *)self.childViewControllers;
}

//在渲染容器中添加特定的子视图控制器。
- (void)wxAddChildViewController:(UIViewController *)viewController {
    [self addChildViewController:viewController];
}

//在渲染容器中移除特定的子视图控制器。
- (void)wxRemoveChildViewController:(UIViewController *)viewController {
    [viewController removeFromParentViewController];
}

//判断宿主容器导航栏是否隐藏
- (BOOL)wxNavbarIsHidden {
    EMASWXViewController *parentVC = (EMASWXViewController *)self.parentVC;
    if (parentVC && parentVC.navigationController.navigationBarHidden) {
        return YES;
    }
    return NO;
}

//自定义页面加载的indicatorView，并显示在view中。
- (void)wxShowPageLoadingIndicator:(UIView *)view {
    [view addSubview:self.pageLoadingIndicator];
    [self.pageLoadingIndicator startAnimating];}

//隐藏indicatorView
- (void)wxHidePageLoadingIndicator {
    [self.pageLoadingIndicator stopAnimating];
    [self.pageLoadingIndicator removeFromSuperview];
}

- (UIActivityIndicatorView *)pageLoadingIndicator {
    if (_pageLoadingIndicator == nil) {
        self.pageLoadingIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 40)/2, (self.view.frame.size.height - 40)/2, 40, 40)];
        [self.pageLoadingIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    }
    return _pageLoadingIndicator;
}


- (void)wxInstanceRenderOnCreate {
    // Weex渲染容器在实渲染中判断当前实例是否可以被复用
}

- (void)wxInstanceRenderOnFail:(NSError *)error {
    // Weex实例渲染失败回调，返回错误信息
}

- (void)wxInstanceRenderOnFinish {
    // Weex实例渲染完成回调
}

- (void)wxJSBundleDownloadOnFinish:(WXResourceResponse *)response request:(WXResourceRequest *)request data:(NSData *)data error:(NSError *)error {
    // JS Bundle下载回调
}

- (BOOL)wxJSBundleCanUseCache:(NSURL *)URL callback:(void (^)(NSString *))callback {
    // JS Bundle是否可以使用本地缓存，例如zcache或本地cache的场景，callback输入参数为完整的JS Bundle，返回后会直接进入模版渲染，不再进行网络请求。
    return NO;
}

@end
