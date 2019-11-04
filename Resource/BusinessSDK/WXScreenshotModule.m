//
//  WXScreenshotModule.m
//  EmasWeexComponents
//
//  Created by  cijian on 19/03/2018.
//

#import "WXScreenshotModule.h"
#import <WeexPluginLoader/WeexPluginLoader.h>
#import <EmasXBase/XCOScreenshotDetector.h>
#import <WeexSDK/WeexSDK.h>

@implementation WXScreenshotModule

WX_PlUGIN_EXPORT_MODULE(xscreenshot, WXScreenshotModule)
WX_EXPORT_METHOD(@selector(startListen:))
WX_EXPORT_METHOD(@selector(endListen))

- (void)startListen:(WXKeepAliveCallback) callback {
    [[XCOScreenshotDetector sharedInstance] registerCallBack:^(UIImage *screenshot) {
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;

        NSData * binaryImageData = UIImagePNGRepresentation(screenshot);
        [binaryImageData writeToFile:[basePath stringByAppendingPathComponent:@"screenshot.PNG"] atomically:YES];
        NSString *path = [[NSString alloc] initWithFormat:@"file://%@", [basePath stringByAppendingPathComponent:@"screenshot.PNG"]];
        callback(@{@"url": path}, YES);
    }];
}

- (void)endListen {
    [[XCOScreenshotDetector sharedInstance] cleanCallBack];
}
@end


