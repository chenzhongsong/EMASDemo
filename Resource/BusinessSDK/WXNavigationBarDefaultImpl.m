//
//  WXNavigationBarDefaultImpl.h
//  AliWeexExample
//
//  Created by laiyi on 29/12/2016.
//  Copyright © 2016 alibaba.com. All rights reserved.
//

#import "WXNavigationBarDefaultImpl.h"
#import "EMASWXRenderViewController.h"
#import <EmasWeexComponents/WXModuleUtils.h>
#import "UIColor+Hex.h"

#define NAVIGATOR_ICON_HEIGHT 24
#define NAVIGATOR_TITLE_HEIGHT 26

typedef enum {
    BOATBarButtonSystemItemBack = 1,
    BOATBarButtonSystemItemMore,
    BOATBarButtonSystemItemCenter,
    BOATBarButtonSystemItemRight,
    BOATBarButtonItemTypeFlexibleSpace,
    BOATBarButtonItemTypeFixedSpace,
}BOATBarButtonSystemItem;

/**
 * Action Block 的包装。
 */
@interface EMASWeexActionBlockWrapper : NSObject

@property (nonatomic, copy) void (^block)(id sender);

@end

@implementation EMASWeexActionBlockWrapper : NSObject

- (void)callBlock:(id)sender {
    if (_block) {
        _block(sender);
    }
}

@end

@implementation WXNavigationBarDefaultImpl

- (NSError *)show:(WXSDKInstance *)instance options:(NSDictionary *)options {
    UIViewController * parentVC = instance.viewController.parentViewController;
    if (!parentVC) {
        return nil;
    }
    
    BOOL animated = [options[@"animated"] boolValue];
    [parentVC.navigationController setNavigationBarHidden:NO animated:animated];
    
    return nil;
}


- (NSError *)hide:(WXSDKInstance *)instance options:(NSDictionary *)options
{
    UIViewController * parentVC = instance.viewController.parentViewController;
    if (!parentVC) {
        return nil;
    }
    
    BOOL animated = [options[@"animated"] boolValue];
    [parentVC.navigationController setNavigationBarHidden:YES animated:animated];
    
    return nil;
}

- (NSError *)setTitle:(WXSDKInstance *)instance options:(NSDictionary *)options
{
    NSString *title = options[@"title"];
    if ([instance.viewController isKindOfClass:EMASWXRenderViewController.class]) {
        [((EMASWXRenderViewController *)instance.viewController).parentVC.navigationItem setTitle:title];
    }
    
    return nil;
}

- (NSError *)setLeftItem:(WXSDKInstance *)instance options:(NSDictionary *)options clkBlock:(void (^)(int index))clkBlock
{
    if (!instance || ![instance.viewController isKindOfClass:[EMASWXViewController class]]) {
        return [WXModuleUtils errorWithResult:MSG_NOT_SUPPRETED withMessage:@"Invalid ViewController"];
    }
    
    UIViewController * viewController = (UIViewController *)instance.viewController;
    UIViewController * parentVC = [viewController parentViewController];
    
    if (!parentVC) {
        return [WXModuleUtils errorWithResult:MSG_NOT_SUPPRETED withMessage:@"Invalid parent ViewController"];
    }
    
    NSMutableArray *barItems = [NSMutableArray new];
    NSArray *items = [options objectForKey:@"items"];
    if (!items) {
        if (options[@"title"]) {
            items = @[@{@"title":options[@"title"]}];
        }
        if (options[@"icon"]) {
            items = @[@{@"icon":options[@"icon"]}];
        }
    }
    
    int idx = 0;
    for (NSDictionary *item in items) {
        void (^action)(id) = ^(id sender) {
            clkBlock(idx);
        };
        idx++;
        UIBarButtonItem* barItem = [self.class createBarButtonWithOptions:item systemItem:BOATBarButtonSystemItemRight instance:instance action:action];
        [barItems addObject:barItem];
    }
    [parentVC.navigationItem setLeftBarButtonItems:barItems];
    
    
    return nil;
    
}

- (NSError *)setRightItem:(WXSDKInstance *)instance options:(NSDictionary *)options clkBlock:(void (^)(int index))clkBlock
{
    if (!instance || ![instance.viewController isKindOfClass:[EMASWXViewController class]]) {
        return [WXModuleUtils errorWithResult:MSG_NOT_SUPPRETED withMessage:@"Invalid ViewController"];
    }
    
    UIViewController * viewController = (UIViewController *)instance.viewController;
    UIViewController * parentVC = [viewController parentViewController];
    
    if (!parentVC) {
        return [WXModuleUtils errorWithResult:MSG_NOT_SUPPRETED withMessage:@"Invalid parent ViewController"];
    }
    
    NSMutableArray *barItems = [NSMutableArray new];
    NSArray *items = [options objectForKey:@"items"];
    if (!items) {
        if (options[@"title"]) {
            items = @[@{@"title":options[@"title"]}];
        }
        if (options[@"icon"]) {
            items = @[@{@"icon":options[@"icon"]}];
        }
    }
    
    int idx = 0;
    for (NSDictionary *item in items) {
        void (^action)(id) = ^(id sender) {
            clkBlock(idx);
        };
        idx++;
        UIBarButtonItem* barItem = [self.class createBarButtonWithOptions:item systemItem:BOATBarButtonSystemItemRight instance:instance action:action];
        [barItems addObject:barItem];
    }
    [parentVC.navigationItem setRightBarButtonItems:barItems];
    
    
    return nil;
}

- (NSError *)setStyle:(WXSDKInstance *)instance options:(NSDictionary *)options
{
    if (!instance || ![instance.viewController isKindOfClass:[EMASWXViewController class]]) {
        return [WXModuleUtils errorWithResult:MSG_NOT_SUPPRETED withMessage:@"Invalid ViewController"];
    }
    
    UIViewController * viewController = (UIViewController *)instance.viewController;
    UIViewController * parentVC = [viewController parentViewController];
    
    if (!parentVC) {
        return [WXModuleUtils errorWithResult:MSG_NOT_SUPPRETED withMessage:@"Invalid parent ViewController"];
    }
    
    // 导航栏的前景色（文本颜色）
    NSString * colorStr = options[@"color"];
    if (colorStr && [colorStr isKindOfClass:[NSString class]] && colorStr.length > 0) {
        NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor colorWithHexString:colorStr] forKey:NSForegroundColorAttributeName];
        parentVC.navigationController.navigationBar.titleTextAttributes = dict;
        //        instance.viewController.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:colorStr];
    }
    
    // 导航栏的背景色
    NSString * backgroundColor = options[@"backgroundColor"];
    if (backgroundColor && [backgroundColor isKindOfClass:[NSString class]] && backgroundColor.length > 0) {
        parentVC.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:backgroundColor];
    }
    
    return nil;
}

static void * BOATWeexBarButtonActionKey = &BOATWeexBarButtonActionKey;

/**
 * 根据数据创建导航栏按钮。
 */
+ (UIBarButtonItem *)createBarButtonWithOptions:(NSDictionary *)options systemItem:(BOATBarButtonSystemItem)systemItem instance:(WXSDKInstance *)instance action:(void (^)(id))action {
    
    EMASWeexActionBlockWrapper * wrapper = [[EMASWeexActionBlockWrapper alloc] init];
    wrapper.block = action;
    // 显示图标。
    NSString * iconURL = options[@"icon"];
    if (iconURL && [iconURL isKindOfClass:[NSString class]]) {
        WXModuleIcon * icon = [WXModuleUtils loadIcon:iconURL withInstance:instance];
        CGFloat maxHeight = (systemItem == BOATBarButtonSystemItemCenter) ? NAVIGATOR_TITLE_HEIGHT : NAVIGATOR_ICON_HEIGHT;
        if (!icon) {
            return nil;
        } else if (icon.sync) {
            // 同步图标。
            if (icon.type == WXModuleIconTypeImage) {
                UIImage * image = [WXModuleUtils scaleImage:icon.image withMaxHeight:maxHeight];
                UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:wrapper action:@selector(callBlock:)];
                objc_setAssociatedObject(buttonItem, &BOATWeexBarButtonActionKey, wrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                return buttonItem;
            }
        } else {
            // 异步图标。
            if (icon.type == WXModuleIconTypeImage) {
                UIButton * button = [[UIButton alloc] initWithFrame:CGRectZero];
                button.adjustsImageWhenHighlighted = NO;
                [button addTarget:wrapper action:@selector(callBlock:) forControlEvents:UIControlEventTouchUpInside];
                objc_setAssociatedObject(button, &BOATWeexBarButtonActionKey, wrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                __block __weak UIButton * weakButton = button;
                icon.callback = ^(BOOL isSuccess, WXModuleIcon * icon) {
                    if (isSuccess) {
                        UIImage * image = [WXModuleUtils scaleImage:icon.image withMaxHeight:maxHeight];
                        [weakButton setImage:image forState:UIControlStateNormal];
                        // 令图标居中。
                        CGFloat width = image.size.width;
                        CGFloat x = weakButton.frame.origin.x - width / 2;
                        CGFloat y = weakButton.frame.origin.y - image.size.height / 2;
                        weakButton.frame = CGRectMake(x, y, width, image.size.height);
                        [weakButton setNeedsLayout];
                    }
                };
                return [[UIBarButtonItem alloc] initWithCustomView:button];
            }
        }
    }
    
    // 显示文本。
    NSString * title = options[@"title"];
    if (title && [title isKindOfClass:[NSString class]]) {
        UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:wrapper action:@selector(callBlock:)];
        objc_setAssociatedObject(buttonItem, &BOATWeexBarButtonActionKey, wrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return buttonItem;
    }
    
    return nil;
}
@end
