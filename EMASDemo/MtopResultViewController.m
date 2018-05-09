//
//  MtopResultViewController.m
//  EMASDemo
//
//  Created by jiangpan on 2018/5/2.
//  Copyright © 2018年 zhishui.lcq. All rights reserved.
//

#import "MtopResultViewController.h"
#import <mtopext/MtopCore/MtopExtRequest.h>
#import <mtopext/MtopCore/MtopExtResponse.h>
#import <mtopext/MtopCore/MtopService.h>
#import <MtopSDK/TBSDKConnection.h>

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

@interface MtopResultViewController ()
@property (strong,nonatomic) NSIndexPath *indexPath;
@property (strong,nonatomic) UITextView *requestText;
//@property (strong,nonatomic) UITextView *responseText;

@end

@implementation MtopResultViewController

- (instancetype)initWithRowPath:(NSIndexPath *)indexPath {
    self = [super init];
    if (self) {
        _indexPath = indexPath;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self sendMtopRequest:self.indexPath];
    
}

- (void)setupUI {
    
    _requestText = [[UITextView alloc] init];
    [_requestText setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:_requestText];
    [_requestText setTranslatesAutoresizingMaskIntoConstraints:NO];// 为防止自动布局冲突设置为NO
    NSLayoutConstraint *requestTextConstraint1 = [NSLayoutConstraint constraintWithItem:_requestText
                                                                              attribute:NSLayoutAttributeTop
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeTop
                                                                             multiplier:1.0
                                                                               constant:0];

    NSLayoutConstraint *requestTextConstraint2 = [NSLayoutConstraint constraintWithItem:_requestText
                                                                              attribute:NSLayoutAttributeLeft
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeLeft
                                                                             multiplier:1.0
                                                                               constant:0];

    NSLayoutConstraint *requestTextConstraint3 = [NSLayoutConstraint constraintWithItem:_requestText
                                                                              attribute:NSLayoutAttributeRight
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeRight
                                                                             multiplier:1.0
                                                                               constant:0];


    NSLayoutConstraint *requestTextConstraint4 = [NSLayoutConstraint constraintWithItem:_requestText
                                                                              attribute:NSLayoutAttributeBottom
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeBottom
                                                                             multiplier:1.0
                                                                               constant:0];

    [self.view addConstraints:@[requestTextConstraint1,requestTextConstraint2,requestTextConstraint3,requestTextConstraint4]];
    
}

- (void)sendMtopRequest:(NSIndexPath *)indexPath {
    MtopExtRequest* request = [[MtopExtRequest alloc] initWithApiName: @"mtop.bizmock.test.simpleparam" apiVersion: @"2.0"];
    [request addBizParameter:[NSNumber numberWithBool:true] forKey:@"testBool"];
    [request addBizParameter:[NSNumber numberWithInteger:2] forKey:@"testInteger"];
    [request addBizParameter:[NSNumber numberWithBool:false]  forKey:@"testBoolean"];
    [request addBizParameter:[NSDecimalNumber numberWithDouble:1.1] forKey:@"testDoub"];
    [request addBizParameter:@"test" forKey:@"testStr"];
    [request addBizParameter:[NSNumber numberWithInt:1] forKey:@"testInt"];
    [request addBizParameter:[NSDecimalNumber numberWithDouble:1.2] forKey:@"testDouble"];
    TBSDKConfiguration *config = [TBSDKConfiguration shareInstance];
    config.latitude = 30.26;
    config.longitude = 120.19;
    request.protocolType = MtopProtocolTypeEmas;
    if (indexPath.row == 1) {
       // Post请求
        [request useHttpPost];
    }
    
    request.succeedBlock = ^(MtopExtResponse *response) {
        // 成功回调
        self.requestText.text = mtopDescription(response);
        
    };
    
    request.failedBlock = ^(MtopExtResponse *response) {
        // 失败回调
        self.requestText.text = mtopDescription(response);
    };
    
    [[MtopService getInstance] async_call:request delegate:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
