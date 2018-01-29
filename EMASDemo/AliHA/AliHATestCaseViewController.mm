//
//  AliHATestCaseViewControllerTableViewController.m
//  EMASDemo
//
//  Created by EMAS on 2017/12/26.
//  Copyright © 2017年 EMAS. All rights reserved.
//

#import "AliHATestCaseViewController.h"
#import <AliHACore/AliHA.h>
#import <TRemoteDebugger/TRDManagerService.h>
#import <TRemoteDebugger/TBClientDrivingPushTLogExec.h>

@interface AliHATestCaseViewController ()

@end

@implementation AliHATestCaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"reuseIdentifier"];
    }
    
    switch (indexPath.row) {
            case 0:
        {
            cell.textLabel.text = @"全堆栈Crash";
            cell.textLabel.textColor = [UIColor redColor];
        }
            break;
            case 1:
        {
            cell.textLabel.text = @"Abort";
            cell.textLabel.textColor = [UIColor orangeColor];
        }
            break;
            case 2:
        {
            cell.textLabel.text = @"上报JSError";
            cell.textLabel.textColor = [UIColor blueColor];
        }
            break;
            case 3:
        {
            cell.textLabel.text = @"主动上报tlog";
            cell.textLabel.textColor = [UIColor blueColor];
        }
            break;
            case 4:
        {
            cell.textLabel.text = @"pull task";
            cell.textLabel.textColor = [UIColor blueColor];
        }
            break;
            case 5:
        {
            cell.textLabel.text = @"卡顿";
            cell.textLabel.textColor = [UIColor redColor];
        }
            break;
            case 6:
        {
            cell.textLabel.text = @"upload events";
            cell.textLabel.textColor = [UIColor redColor];
        }
            break;
        default:
            break;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
            
            case 0:
        {
            // full stack crash
            NSMutableArray *array = @[];
            [array addObject:nil];
            break;
        }
            
            case 1:
        {
            // abort
            exit(0);
            break;
        }
            
            case 3:
        {
            // upload tlog
            [TBClientDrivingPushTLogExec uploadTLogAction:@{@"REASON": @"STARTUP_SLOW"}];
            break;
        }
            case 4:
        {
            [kTRDCmdServiceInstance.messageDelegate pullData:kTRDCmdServiceInstance.context.appKey deviceId:kTRDCmdServiceInstance.context.utdid resultsBlock:^(NSError *error, RemoteDebugResponse *response) {
                if (!error && response) {
                    RemoteDebugRequest *request = [[RemoteDebugRequest alloc] init];
                    request.headers = response.headers;
                    request.data = response.data;
                    request.appId = response.appId;
                    request.version = response.version;
                    [kTRDCmdServiceInstance handleRemoteCommand:request];
                }
            }];
            break;
        }
            case 5:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [NSThread sleepForTimeInterval:30];
            });
        }
            break;
            case 6:
        {
            AliHA *haInstance = [AliHA shareInstance];
            if ([haInstance respondsToSelector:NSSelectorFromString(@"scanExistingTraceFiles")]) {
                [haInstance performSelector:NSSelectorFromString(@"scanExistingTraceFiles")];
            }
        }
            break;
        default:
            break;
            
    }
}

@end

