//
//  DemoWeexViewController.h
//  EMASDemo
//
//  Created by daoche.jb on 2018/6/28.
//  Copyright © 2018年 EMAS. All rights reserved.
//

#import "EMASWXRenderViewController.h"

// 源代码编译异常
// #import <SRWebSocket.h>
// 夕重 修改
#import <SocketRocket/SocketRocket.h>


//宿主容器
@interface EMASHostViewController : UIViewController <EMASWXViewControllerProtocol,SRWebSocketDelegate>

@property (nonatomic, strong) SRWebSocket *hotReloadSocket;
@property (nonatomic, copy) NSString *source;

@property(nonatomic, strong) EMASWXRenderViewController *wxViewController;

- (id)initWithNavigatorURL:(NSURL *)URL;

@end
