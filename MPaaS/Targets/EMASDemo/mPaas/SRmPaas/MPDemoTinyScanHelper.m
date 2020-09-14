//
//  MPDemoTinyScanHelper.m
//  MPTinyAppDemo
//
//  Created by yemingyu on 2019/6/19.
//  Copyright © 2019 alipay. All rights reserved.
//

#import "MPDemoTinyScanHelper.h"
#import <TBScanSDK/TBScanSDK.h>
#import <MPNebulaAdapter/MPNebulaAdapterInterface.h>

@interface MPDemoTinyScanHelper() <TBScanViewControllerDelegate>

@property (nonatomic,strong) TBScanViewController *scanVC;

@end

@implementation MPDemoTinyScanHelper

+ (instancetype)sharedInstance
{
    static MPDemoTinyScanHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MPDemoTinyScanHelper alloc] init];
    });
    return instance;
}

- (void)startScanWithNavVc:(UINavigationController *)navVC
{
    self.scanVC = [[TBScanViewController alloc] initWithAnimationRect:[UIScreen mainScreen].bounds delegate:self];
    self.scanVC.scanType = ScanType_All_Code;
    
    [navVC pushViewController:self.scanVC animated:YES];
}

#pragma mark- delegate

- (void)didFind:(NSArray<TBScanResult*>*)resultArray
{
    if ([resultArray count] > 0) {
        TBScanResult *result = [resultArray objectAtIndex:0];
        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        [dic setObject:@YES forKey:@"success"];
        [dic setObject:result.data forKey:@"code"];
        
        if ([result.resultType isEqualToString:TBScanResultTypeITFCode]
            || [result.resultType isEqualToString:TBScanResultTypeExpressCode]
            || [result.resultType isEqualToString:TBScanResultTypeGoodsBarcode]) {
            [dic setObject:result.data forKey:@"barCode"];
        } else if ([result.resultType isEqualToString:TBScanResultTypeARCode]
                 || [result.resultType isEqualToString:TBScanResultTypeAPXCode]) {
            [dic setObject:result.data forKey:@"apCode"];
        } else {
            [dic setObject:result.data forKey:@"qrCode"];
        }
        [self finish:dic];
    } else {
        [self finish:@{@"error":@11}];
    }
}

- (void)cameraPermissionDenied
{
    [self finish:@{@"error":@11}];
}

- (void)cameraStartFail
{
    [self finish:@{@"error":@11}];
}

- (void)finish:(NSDictionary*)dic
{
    if ([NSThread isMainThread]) {
//        [self.scanVC.navigationController popToViewController:self.scanVC animated:NO];
        [self.scanVC.navigationController popViewControllerAnimated:YES];
        [self doScanFinished:dic];
    } else {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            if (strongSelf != nil)
            {
//                [strongSelf.scanVC.navigationController popToViewController:strongSelf.scanVC animated:NO];
                [strongSelf.scanVC.navigationController popViewControllerAnimated:YES];
                strongSelf.scanVC = nil;
                [strongSelf doScanFinished:dic];
            }
        });
    }
}

- (void)doScanFinished:(NSDictionary *)dict {
    NSString *qrCode = dict[@"code"];
    
    // 调用小程序预览调试接口。 传入二维码内容字符串：
    [MPNebulaAdapterInterface startDebugTinyAppWithUrl:qrCode];
}

@end
