//
//  TinyAppViewController.m
//  EMASDemo
//
//  Created by 时苒 on 2020/7/28.
//  Copyright © 2020 EMAS. All rights reserved.
//

#import "TinyAppViewController.h"

 
#import "MiniprogramList.h"

#import <MiniAppMarket/MiniAppMarket.h>

// 调试 小程序 Debug 模式
#import "MPDemoTinyScanHelper.h"

///////////////////////////////////
// 调试 API mtopExtRequest
#import <MtopCore/MtopExtRequest.h>
#import <MtopCore/MtopService.h>
#import "EMASService.h"
#import <MtopSDK/TBSDKConnection.h>
///////////////////////////////////

#import <mPaas/MPaaSInterface.h>

#import "AppDelegate.h"

typedef NS_ENUM(NSUInteger,MtopParamType){
    MtopParamType_Int = 1,
    MtopParamType_Double,
    MtopParamType_Integer,
    MtopParamType_String,
    MtopParamType_Bool
};

static MtopParamType filterType(NSString *typeString) {
    if ([typeString hasPrefix:@"String"]) {
        return MtopParamType_String;
    }else if ([typeString hasPrefix:@"Bool"]) {
        return MtopParamType_Bool;
    }else if ([typeString hasPrefix:@"Int"]){
        return MtopParamType_Int;
    }else if ([typeString hasPrefix:@"Double"]){
        return MtopParamType_Double;
    }else if ([typeString hasPrefix:@"Integer"]){
        return MtopParamType_Integer;
    }
    return 0;
}

static NSString* mtopDescription(MtopExtResponse *response){
   
    NSMutableString *mStr = [NSMutableString stringWithFormat:@"\n\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n请求的网络地址= %@\n\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n\n",response.request.mrequest.request.url];
    
    [mStr appendString:[NSString stringWithFormat:@"\n\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\nHTTP请求Method: %@\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n",response.request.isUseHttpPost?@"POST":@"GET"]];
   
    [mStr appendString:[NSMutableString stringWithFormat:@"\n\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n%@\nHTTP请求头%@\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n\n", response.request.getApiName,  response.requestHeaders]];;
    
    [mStr appendString:[NSString stringWithFormat:@"\n\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n%@\nHTTP响应头%@\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n\n", response.request.getApiName, response.headers]];
    
    if ([response.request.mrequest.responseString length])
    {
        [mStr appendString:[NSString stringWithFormat:@"\n\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n%@\n服务器返回值\n%@\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n\n", response.request.getApiName, response.request.mrequest.responseString]];
    }
    else if (response.request.mrequest.responseData)
    {
        [mStr appendString:[NSString stringWithFormat:@"\n\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n%@\n服务器返回值\n%@\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n\n", response.request.getApiName, [response.request.mrequest.responseData description]]];
    }
    else
    {
        [mStr appendString:[NSString stringWithFormat:@"\n\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n服务器没有返回数据\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n\n"]];
        [mStr appendString:[NSString stringWithFormat:@"\n\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\nmappincCode:%@\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n\n",response.error.mappingCode]];
    }
    
    return mStr;
}

@interface TinyAppViewController ()
  
@property (weak, nonatomic) IBOutlet UITextField *programIdOpen;

@property (weak, nonatomic) IBOutlet UITextField *pageNo;
@property (weak, nonatomic) IBOutlet UITextField *pageSize;

@property (weak, nonatomic) IBOutlet UITextField *programIdOnline;
@property (weak, nonatomic) IBOutlet UITextField *mpassUserIdTF;
// 更新单个离线包
@property (weak, nonatomic) IBOutlet UITextField *equestNebulaAppTF;

@end

@implementation TinyAppViewController

NSString * mpassUserId = @"";

- (void)viewDidLoad {
    [super viewDidLoad];

}

// 设置 白名单测试
- (IBAction)mpassUserIdTest:(id)sender {
    mpassUserId = self.mpassUserIdTF.text;
    MPaaSInterface * mpass = [[MPaaSInterface alloc]init];
    [self alertActionView:@"[mpass userId]" mess:[mpass userId]];
}

// H5 测试
- (IBAction)openH5:(id)sender {
    [MPNebulaAdapterInterface startTinyAppWithId:@"20000069" params:@{@"url":@"https://m.taobao.com",@"enableWK":@"YES"}];
}


// 小程序打开测试 1234567890123456
- (IBAction)openTinyApp:(id)sender {
    [MPNebulaAdapterInterface startTinyAppWithId:self.programIdOpen.text params:nil];
}
 

// 调试 debug
- (IBAction)openTinyAppForDebugMode:(id)sender {
   [[MPDemoTinyScanHelper sharedInstance] startScanWithNavVc:self.navigationController];
}

// 查询小程序列表
- (IBAction)queryList:(id)sender {
    MiniprogramList *tempVC = [[MiniprogramList alloc] init];
    tempVC.pageNo = self.pageNo.text;
    tempVC.pageSize = self.pageSize.text;
    [self.navigationController pushViewController:tempVC animated:YES];
}

// 查询小程序状态
- (IBAction)queryStatus:(id)sender {
    MiniAppMarketCenter * _center = [MiniAppMarketCenter new];
    MiniAppMarketInfo *info = [_center miniProgramStatus:self.programIdOnline.text];
    [self alertActionView:@" MiniAppMarketInfo " mess:[NSString stringWithFormat:@"info.onlineStatus : %@",info.onlineStatus]];
}

// 查询单个离线包 并预安装离线包
- (IBAction)requestNebulaAppsWithParams:(id)sender {
    
    NSDictionary * dic = @{self.equestNebulaAppTF.text:@""};
     NSLog(@"\n \n =============== dic %@",dic);
    // 单个应用请求
    // 9.9.9 前: 请求成功后Wifi下自动下载离线包,非Wifi只下载auto_install为YES的离线包
    // 9.9.9及之后: 可针对每个应用配置下载时机, 通过服务端配置, 默认WIFI下载
    [[MPNebulaAdapterInterface shareInstance] requestNebulaAppsWithParams:dic finish:^(NSDictionary *data, NSError *error) {
        
        NSLog(@"\n \n =============== error %@",error);
        
        // 解析 data 获取 MPNAApp
        MPNAApp * tempMPNAApp = data[@"data"][0];
        // 1234567890123457_9.1.2.0_isp:0_cha:4_type:1
        
        if (tempMPNAApp) {
            // 批量下载指定的离线包 params 指定要下载的 appId 和版本号, 从包管理池中读取并下载
            [[MPNebulaAdapterInterface shareInstance] downLoadNebulaAppsWithParams:@{tempMPNAApp.app_id:tempMPNAApp.version}];
            
            [[MPNebulaAdapterInterface shareInstance] installNebulaApp:tempMPNAApp process:^(NAMAppInstallStep step, id info) {
                
                // 安装过程回调, 过程包含: 异步下载离线包->解压离线包
                if (NAMAppInstallStepUnzipFinish == step) {
                    NSLog(@"\n \n =============== 下载离线包到解压离线包一切顺利");
                }
            } finish:^(NAMApp *app, NSError *error) {
                NSLog(@"\n \n =============== 安装完成");
                [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
            }];
            
        } else {
            NSLog(@"\n \n =============== tempMPNAApp %@",tempMPNAApp);
            return;
        }

    }];
}

- (void)updateUI {
    [self alertActionView:@"小程序安装完成" mess:@"您可以打开加载小程序"];
}

// 预加载 测试
- (IBAction)PreloadingApp:(id)sender {
    [[MPNebulaAdapterInterface shareInstance] startH5ViewControllerWithNebulaApp:@{@"appId":self.equestNebulaAppTF.text}];
}


// 查询扩展信息
- (IBAction)extendedInformation:(id)sender {
   
    NAMAppDataSource * sourceInfo = [NAMServiceGet() findAppDataSource:self.equestNebulaAppTF.text version:@"*"];
    NSLog(@"\n ====================== sourceInfo.app.extend_info %@",sourceInfo.app.extend_info[@"launchParams"]);
    [self alertActionView:@"扩展信息" mess:[NSString stringWithFormat:@"%@",sourceInfo.app.extend_info[@"launchParams"]]];
    
}

- (void)alertActionView:(NSString *)title mess:(NSString *)msaaage {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msaaage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *conform = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了确认按钮");
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消按钮");
    }];
    [alert addAction:conform];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];

}

- (IBAction)mtopExtRequest:(id)sender {
    
        NSMutableDictionary * requestData = [NSMutableDictionary dictionaryWithCapacity:10];
        [requestData setObject:@"47.103.190.71:32480" forKey:@"Domain"];
        [requestData setObject:@"emas.max.mock.check/1.0" forKey:@"API"];
        NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:2];
        NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithCapacity:2];
        [dictM setObject:@"Bool" forKey:@"paramType"];
        [dictM setObject:@"testBool" forKey:@"paramName"];
        [dictM setObject:@"true" forKey:@"paramValue"];
        [dataArray addObject:dictM];
        [requestData setObject:dataArray forKey:@"Data"];
        [requestData setObject:@"GET请求" forKey:@"Mtheod"];
        
        NSLog(@"\n ==== %@",requestData);
        
        [self sendMtopRequest:requestData];
}

- (void)sendMtopRequest:(NSDictionary *)requestData {
    
    NSString *domain = [requestData objectForKey:@"Domain"];
    NSString *origianlApiMsg = [requestData objectForKey:@"API"];
    NSArray *apiMsg = [origianlApiMsg componentsSeparatedByString:@"/"];
    
    NSString *apiName = @"";
    NSString *apiVersion = @"";
    
    if ([apiMsg isKindOfClass:[NSArray class]] && apiMsg.count == 2) {
        apiName = [apiMsg objectAtIndex:0];
        apiVersion = [apiMsg objectAtIndex:1];
    }
    
    MtopExtRequest* request = [[MtopExtRequest alloc] initWithApiName: apiName apiVersion: apiVersion];
    [request setCustomHost:domain];
    //  [request setValue:@"application/json;charset=UTF-8" forKey:@"Content-Type"];
    //:@"application/json;charset=UTF-8" forKey:@"Content-Type"
    
    // 添加授权加签
    // [request addHttpHeader:@"c:app:E04C733181004F43A7ABC8676909DF93" forKey:@"x-emas-gw-auth-ticket"];
    
    
    TBSDKConfiguration *config = [TBSDKConfiguration shareInstance];
    config.latitude = 30.26;
    config.longitude = 120.19;
    
    request.protocolType = MtopProtocolTypeEmas;
    
    [[EMASService shareInstance] useHTTP] ? [request disableHttps] : [request useHttps];
    
    //    [config setApplicationRequestHeader:@"text/xml;charset=UTF-8" forKey:@"Content-Type"];
    NSString *httpHeaderStr  = [config getApplicationRequestHeader:@"Content-Type"];
    if ([(NSString *)[requestData objectForKey:@"Mtheod"] hasPrefix:@"POST"]) {
        [request useHttpPost];
    } else {
        // 默认GET请求
    }
    
    NSArray *paramArray = [requestData objectForKey:@"Data"];
        if ([paramArray isKindOfClass:[NSArray class]] && paramArray.count > 0) {
            for (NSDictionary *dict in paramArray) {
                NSString *paramName = [dict objectForKey:@"paramName"];
                NSString *paramType = [dict objectForKey:@"paramType"];
                NSString *paramValue = [dict objectForKey:@"paramValue"];
                
                MtopParamType type = filterType(paramType);
                switch (type) {
                    case MtopParamType_Int:{
                        [request addBizParameter:[NSNumber numberWithInt:paramValue.intValue] forKey:paramName];
                    }
                        
                        break;
                        
                    case MtopParamType_Bool:{
                        [request addBizParameter:paramValue.boolValue?@"true":@"false" forKey:paramName];
                    }
                        
                        break;
                        
                    case MtopParamType_Double:{
                        [request addBizParameter:[NSDecimalNumber numberWithDouble:paramValue.doubleValue] forKey:paramName];
                    }
                        
                        break;
                    
                    case MtopParamType_String:{
                        [request addBizParameter:paramValue forKey:paramName];
                    }
                        
                        break;
                        
                    case MtopParamType_Integer:{
                        [request addBizParameter:[NSNumber numberWithInteger:paramValue.integerValue] forKey:paramName];
                    }
                        break;
                }
            }
        }
        
        
    //    [request addBizParameter:[NSNumber numberWithBool:true] forKey:@"testBool"];
    //    [request addBizParameter:[NSNumber numberWithInteger:2] forKey:@"testInteger"];
    //    [request addBizParameter:[NSNumber numberWithBool:false]  forKey:@"testBoolean"];
    //    [request addBizParameter:[NSDecimalNumber numberWithDouble:1.1] forKey:@"testDoub"];
    //    [request addBizParameter:@"test" forKey:@"testStr"];
    //    [request addBizParameter:[NSNumber numberWithInt:1] forKey:@"testInt"];
    //    [request addBizParameter:[NSDecimalNumber numberWithDouble:1.2] forKey:@"testDouble"];
        
    __weak __typeof(request)weakRequest = request;
    request.succeedBlock = ^(MtopExtResponse *response) {
        __strong __typeof(weakRequest) strongRequest = weakRequest;
        // 成功回调
        // self.requestText.text = mtopDescription(response);
        NSLog(@"\n ==== %@",mtopDescription(response));
        
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ////            [strongRequest addBizParameter:@"true" forKey:@"testTrue"];
        //            [[MtopService getInstance] async_call:strongRequest delegate:nil];
        //        });
                
        //        [[MtopService getInstance] async_call:strongRequest delegate:nil];
                
            
    };
    
    request.failedBlock = ^(MtopExtResponse *response) {
            
        __strong __typeof(weakRequest) strongRequest = weakRequest;
        // 失败回调
        // self.requestText.text = mtopDescription(response);
        NSLog(@"\n ==== %@",mtopDescription(response));
        NSLog(@"Error error: %@", response.error);
            
    //        [strongRequest addBizParameter:@"true" forKey:@"testTrue"];
    //        [[MtopService getInstance] async_call:strongRequest delegate:nil];
        };

        [[MtopService getInstance] async_call:request delegate:nil];
        
    
    
    
}

/**
mtop开始请求回调
@param request mtop请求对象
 
- (void)started:(MtopExtRequest *)request {
    NSLog(@"start mtop request..");
}

 
mtop请求成功回调
@param response mtop响应对象
 

- (void)succeed:(MtopExtResponse *)response {
    NSDictionary *responseDict = response.json;
    // 获取响应的业务data
    NSDictionary *bizResponseData = [response.json objectForKey:@"data"];
}

 
mtop请求失败回调
@param response mtop响应对象
 
- (void)failed:(MtopExtResponse *)response {

    // 获取响应错误ERROR
    Error *error = response.error;
    //  获取错误码 & 错误信息
    NSString *errorCode = error.code;
    NSString *errorMsg = error.msg ;
    NSString *errorMappingCode = error.mappingCode;

}
 */

@end
