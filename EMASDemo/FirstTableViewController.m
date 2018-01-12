//
//  FirstTableViewController.m
//  EMASDemo
//
//  Created by zhishui.lcq on 2017/12/8.
//  Copyright © 2017年 zhishui.lcq. All rights reserved.
//

#import "FirstTableViewController.h"
#import "FirstViewController.h"
#import "HFXViewController.h"
#import "WXDemoViewController.h"
#import "DemoDefine.h"
#import "AliHATestCaseViewController.h"
#import "EMASConstantDefine.h"

@interface FirstTableViewController ()

@end

@implementation FirstTableViewController

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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"Weex";
            cell.textLabel.textColor = [UIColor redColor];
        }
        break;
        case 1:
        {
            cell.textLabel.text = @"高可用";
            cell.textLabel.textColor = [UIColor orangeColor];
        }
        break;
        case 2:
        {
            cell.textLabel.text = @"热修复";
            cell.textLabel.textColor = [UIColor blueColor];
        }
        break;
        case 3:
        {
            cell.textLabel.text = @"应用信息";
            cell.textLabel.textColor = [UIColor greenColor];
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
            // 热修复demo
            UIViewController *controller = [self demoController];
            [self.navigationController pushViewController:controller animated:YES];
            
            break;
        }
        case 1:
        {
            // AliHA
            AliHATestCaseViewController *controller = [[AliHATestCaseViewController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        
        case 2:
        {
            // 热修复demo
            HFXViewController *controller = [HFXViewController new];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case 3:
        {
            NSString *content = [NSString stringWithFormat:@"appkey=%@\r\n appsecret=%@\r\n accs域名=%@\r\n mtop域名=%@\r\n ZCachepackageZipPrefix=%@\r\n ossBucketName=%@\r\n 渠道ID=%@\r\n", AppKey,AppSecret, ACCSDomain, MTOPDomain, ZCachepackageZipPrefix, ossBucketName, CHANNELID];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"应用信息"
                                                                message:content
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            break;
        }

        default:
        {
            FirstViewController *controller = [FirstViewController new];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
    }
}

- (UIViewController *)demoController
{
    UIViewController *demo = [[WXDemoViewController alloc] init];
    
//#if DEBUG
    //If you are debugging in device , please change the host to current IP of your computer.
    ((WXDemoViewController *)demo).url = [NSURL URLWithString:HOME_URL];
//#else
//    ((WXDemoViewController *)demo).url = [NSURL URLWithString:BUNDLE_URL];
//#endif
//
//#ifdef UITEST
//    ((WXDemoViewController *)demo).url = [NSURL URLWithString:UITEST_HOME_URL];
//#endif
    
    return demo;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
