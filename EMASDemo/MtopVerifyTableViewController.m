//
//  MtopVerifyTableViewController.m
//  EMASDemo
//
//  Created by zhishui.lcq on 2018/4/9.
//  Copyright © 2018年 zhishui.lcq. All rights reserved.
//

#import "MtopVerifyTableViewController.h"
#import <mtopext/MtopCore/MtopService.h>
#import <mtopext/MtopCore/MtopExtRequest.h>
#import "MtopResultViewController.h"

#import <TBAccsSDK/TBAccsManager.h>
#import "EMASService.h"

@interface MtopVerifyTableViewController () <MtopExtRequestDelegate>

@end

@implementation MtopVerifyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"验证MTOP";
    
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
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TableSampleIdentifier];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"点击验证GET请求";
    }else if(indexPath.row == 1){
        cell.textLabel.text = @"点击验证POST请求";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MtopResultViewController *resultVc = [[MtopResultViewController alloc] init];
    if (indexPath.row == 0) {
        // GET请求
        NSLog(@"GET");
        [self.navigationController pushViewController:resultVc animated:YES];
    } else {
        // POST请求
        NSLog(@"POST");
        [self.navigationController pushViewController:resultVc animated:YES];
    }
//    MtopExtRequest *request = [[MtopExtRequest alloc] initWithApiName:@"com.alibaba.emas.eweex.zcache.gate" apiVersion: @"1.0"];
//    // 添加预加载请求参数。
//    [request addBizParameter:@"0" forKey:@"configType"];
//    [request addBizParameter:@"0" forKey:@"snapshotId"];
//    [request addBizParameter:@"0" forKey:@"snapshotN"];
//    [request addBizParameter:@"a" forKey:@"target"];
//
//    typedef void (^MtopExtRequestSucceed)(MtopExtResponse* response);
//    request.succeedBlock = ^(MtopExtResponse* response){
//        [self showAlert:YES desc:nil];
//    };
//
//    typedef void (^MtopExtRequestFailed)(MtopExtResponse* response);
//    request.failedBlock = ^(MtopExtResponse* response){
//        [self showAlert:NO desc:response.error.code];
//    };
//
//    [[MtopService getInstance] async_call: request delegate: nil];
    
}



- (void)showAlert:(BOOL)isSuccess desc:(NSString *)desc
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:(isSuccess ? @"验证成功" : @"验证失败")
                                                        message:desc
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];
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
