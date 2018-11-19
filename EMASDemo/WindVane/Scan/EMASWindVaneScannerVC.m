//
//  EMASWindVaneScannerVC.m
//  EMASDemo
//
//  Created by daoche.jb on 2018/10/11.
//  Copyright © 2018年 EMAS. All rights reserved.
//

#import "EMASWindVaneScannerVC.h"
#import "AppDelegate.h"
#import "UIViewController+EMASWXNaviBar.h"
#import "EMASWindVaneViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface EMASWindVaneScannerVC ()

@property (nonatomic, strong) AVCaptureSession * session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureLayer;
@property (nonatomic, strong) UIView *sanFrameView;

@end

@implementation EMASWindVaneScannerVC

#pragma mark - lifeCircle

- (void)dealloc {
    [_captureLayer removeFromSuperlayer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
#if !(TARGET_IPHONE_SIMULATOR)
    self.session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    if (output && input && device) {
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [_session addInput:input];
        [_session addOutput:output];
        output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    }
    
    _captureLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _captureLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    _captureLayer.frame=self.view.layer.bounds;
#endif
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self setupNaviBar];
    [self.view.layer addSublayer:_captureLayer];
    [_session startRunning];
    
    self.navigationItem.title = @"H5页面演示";
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [_captureLayer removeFromSuperlayer];
    [_session stopRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [_captureLayer removeFromSuperlayer];
    [_session stopRunning];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex: 0];
        [self openURL:metadataObject.stringValue];
    }
}

- (void)openURL:(NSString*)URL
{
    EMASWindVaneViewController * controller = [[EMASWindVaneViewController alloc] init];
    controller.loadUrl = URL;

    [[self navigationController] pushViewController:controller animated:YES];
}


@end

