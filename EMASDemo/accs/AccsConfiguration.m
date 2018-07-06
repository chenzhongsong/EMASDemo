//
//  AccsConfiguration.m
//  EMASDemo
//
//  Created by wuchen.xj on 2018/6/20.
//  Copyright © 2018年 zhishui.lcq. All rights reserved.
//

#import "AccsConfiguration.h"
#import "EMASService.h"

#define EMAS_DEFAULT_APPKEY         @"10000016";
#define EMAS_DEFAULT_APPSECRET      @"ddc1f5c8b69da5e875a04e3278203fe2"
#define EMAS_DEFAULT_SERVICEID      @"4272_mock"
#define EMAS_DEFAULT_HOST           @"accs.emas-poc.com"
#define EMAS_DEFAULT_IP             @""
#define EMAS_DEFAULT_PORT           80

@implementation AccsConfiguration

+ (instancetype)sharedInstance {
    static AccsConfiguration *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AccsConfiguration alloc] init];
    });
    
    return instance;
}

+ (NSString *)filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    NSString *documentPath = @"";
    if (paths && paths.count > 0) {
        documentPath = [paths objectAtIndex: 0];
    }
    
    return [documentPath stringByAppendingPathComponent:@"emas_accs_config"];
}

- (void)loadfile {
    NSString *path = [AccsConfiguration filePath];
    NSData *fileData = [NSData dataWithContentsOfFile:path];
    
    if (!fileData || [fileData length] == 0) {
        NSLog(@"[FileUtils] NO configuration file, path = %@", path);
        
        _appkey = EMAS_DEFAULT_APPKEY;
        _appsecret = EMAS_DEFAULT_APPSECRET;
        _serviceId = EMAS_DEFAULT_SERVICEID;
        _host = EMAS_DEFAULT_HOST;
        if (EMAS_DEFAULT_IP.length > 0) {
            _ip = EMAS_DEFAULT_IP;
            _port = EMAS_DEFAULT_PORT;
        }
        
        return;
    }
    
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:fileData];
    [self parseDict:dict];
}

- (void)parseDict:(NSDictionary *)dict {
    NSString *appkey = [dict objectForKey:EMAS_CONFIG_KEY_APPEKY];
    if (appkey.length > 0) {
        _appkey = appkey;
    }
    
    NSString *appsecret = [dict objectForKey:EMAS_CONFIG_KEY_APPSECRET];
    if (appsecret.length > 0) {
        _appsecret = appsecret;
    }
    
    NSString *host = [dict objectForKey:EMAS_CONFIG_KEY_HOST];
    if (host.length > 0) {
        _host = host;
    }
    
    NSString *ip = [dict objectForKey:EMAS_CONFIG_KEY_IP];
    if (ip.length > 0) {
        _ip = ip;
    }
    
    NSString *serviceId = [dict objectForKey:EMAS_CONFIG_KEY_SERVICEID];
    if (serviceId.length > 0) {
        _serviceId = serviceId;
    }
    
    NSString *port = [dict objectForKey:EMAS_CONFIG_KEY_PORT];
    if (port.length > 0) {
        _port = [port integerValue];
    }
}

- (void)save {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[_appkey copy] forKey:EMAS_CONFIG_KEY_APPEKY];
    [dict setObject:[_appsecret copy] forKey:EMAS_CONFIG_KEY_APPSECRET];
    [dict setObject:[_host copy] forKey:EMAS_CONFIG_KEY_HOST];
    [dict setObject:[_ip copy] forKey:EMAS_CONFIG_KEY_IP];
    [dict setObject:[_serviceId copy] forKey:EMAS_CONFIG_KEY_SERVICEID];
    [dict setObject:[NSString stringWithFormat:@"%ld", _port] forKey:EMAS_CONFIG_KEY_PORT];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    [data writeToFile:[AccsConfiguration filePath] atomically:YES];
    
}

@end
