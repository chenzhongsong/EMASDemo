//
//  DTFrameworkInterface+EMASDemo.m
//  EMASDemo
//
//  Created by shiran on 2020/08/21. All rights reserved.
//

#import "DTFrameworkInterface+EMASDemo.h"

#import "MPBootLoaderImpl.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation DTFrameworkInterface (EMASDemo)

- (BOOL)shouldLogReportActive
{
    return YES;
}

- (NSTimeInterval)logReportActiveMinInterval
{
    return 0;
}

- (BOOL)shouldLogStartupConsumption
{
    return YES;
}

- (BOOL)shouldAutoactivateBandageKit
{
    return YES;
}

- (BOOL)shouldAutoactivateShareKit
{
    return YES;
}

- (DTNavigationBarBackTextStyle)navigationBarBackTextStyle
{
    return DTNavigationBarBackTextStyleAlipay;
}

// 初始化容器
- (void)application:(UIApplication *)application beforeDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [MPNebulaAdapterInterface initNebula];
    
    /**
    若需要使用 **预置离线包**、**自定义 JSAPI** 和 **Plugin** 等功能
    请将上方代码中的 `initNebula` 替换为下方代码中的
    `initNebulaWith` 接口, 传入对应参数对容器进行初始化。
    说明：initNebula 和 initNebulaWithCustomPresetApplistPath 是两个并列的方法，不要同时调用
    
     - `presetApplistPath`  ：自定义的预置离线包的包信息路径。
    - `appPackagePath`      ：自定义的预置离线包的包路径。
    - `pluginsJsapisPath`   ：自定义 JSAPI 和 Plugin 文件的存储路径。
    */
    
    /**
    NSString *presetApplistPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"MPCustomPresetApps.bundle/h5_json.json"] ofType:nil];
    NSString *appPackagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"MPCustomPresetApps.bundle"] ofType:nil];
    NSString *pluginsJsapisPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Poseidon-UserDefine-Extra-Config.plist"] ofType:nil];
    [MPNebulaAdapterInterface initNebulaWithCustomPresetApplistPath:presetApplistPath customPresetAppPackagePath:appPackagePath customPluginsJsapisPath:pluginsJsapisPath];
    */
    
    
}

// 2. 定制容器
// 如有需要，您可以通过设置 MPNebulaAdapterInterface 的属性值来定制容器配置。
// 必须在 下面的 方法 中设置，否则会被容器默认配置覆盖。

- (void)application:(UIApplication *)application afterDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 定制容器
    [MPNebulaAdapterInterface shareInstance].nebulaVeiwControllerClass = [H5WebViewController class];
    [MPNebulaAdapterInterface shareInstance].nebulaNeedVerify = NO;
    [MPNebulaAdapterInterface shareInstance].nebulaUserAgent = @"mPaaS/Portal";
    
    /**
    属性含义如下：
    名称    含义    备注
    nebulaVeiwControllerClass    H5 页面的基类    默认为 H5WebViewController。若需指定所有 H5 页面的基类，可直接设置此接口。
    注意：基类必须继承自 H5WebViewController。
    
    nebulaWebViewClass      设置 WebView 的基类                  基线版本大于 10.1.60 时，默认为 H5WKWebView。自定义的 WebView 必须继承 H5WKWebView。 基线版本等于 10.1.60 时，不支持自定义。
    
    nebulaUseWKArbitrary    设置是否使用 WKWebView 加载离线包页面    基线版本大于 10.1.60 时，默认为 YES。 基线版本等于 10.1.60 时，默认为 NO。
    
    nebulaUserAgent         设置应用的 UserAgent    设置的 UserAgent 会作为后缀添加到容器默认的 UA 上。
    nebulaNeedVerify        是否验签，默认为 YES     若 配置离线包 时未上传私钥文件，此值需设为 NO，否则离线包加载失败。
    nebulaPublicKeyPath     离线包验签的公钥         与 配置离线包 时上传的私钥对应的公钥。
    nebulaCommonResourceAppList    公共资源包的 appId 列表         -
    errorHtmlPath     当 H5 页面加载失败时展示的 HTML 错误页路径     默认读取 MPNebulaAdapter.bundle/error.html。
    configDelegate    设置自定义开关 delegate                    提供全局修改容器默认开关值的能力。

     */
    
     [MPNebulaAdapterInterface shareInstance].nebulaCommonResourceAppList = @[@"77777777"];
    
    
    // 3. 更新离线包
    // 启动完成后，全量请求所有离线包信息，检查服务端是否有更新包。为了不影响应用启动速度，建议在 (void)application:(UIApplication \*)application afterDidFinishLaunchingWithOptions:(NSDictionary \*)launchOptions 之后调用。
    // 全量更新离线包
       [[MPNebulaAdapterInterface shareInstance] requestAllNebulaApps:^(NSDictionary *data, NSError *error) {
           NSLog(@"\n \n ==== 全量更新离线包 ");
       }];
    
    
  }

// 3. 指定应用启动器
// 在 DTFrameworkInterface 的 category 中重写方法，指定当前应用自己的 bootloader，并隐藏 mPaaS 框架默认的 window 和 launcher 应用。
- (DTBootLoader *)bootLoader {
    static MPBootLoaderImpl *_bootLoader;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _bootLoader = [[MPBootLoaderImpl alloc] init];
    });
    return _bootLoader;
}

- (BOOL)shouldWindowMakeVisable {
    return NO;
}

- (BOOL)shouldShowLauncher {
    return NO;
}

@end

#pragma clang diagnostic pop

