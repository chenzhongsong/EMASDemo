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
#import "MtopCustomCell.h"
#import <TBAccsSDK/TBAccsManager.h>
#import "EMASService.h"


static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
static NSString *LabelIdentifier = @"LabelIdentifier";

@interface MtopVerifyTableViewController () <MtopExtRequestDelegate>

@end

@implementation MtopVerifyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"验证MTOP";
    [self.tableView registerClass:[MtopCustomCell class] forCellReuseIdentifier:TableSampleIdentifier];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:LabelIdentifier];
    
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        cell = (MtopCustomCell *)[tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
        if (cell == nil) {
            cell = (MtopCustomCell *)[[MtopCustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TableSampleIdentifier];
        }
        
        if (indexPath.row == 0) {
             ((MtopCustomCell *)cell).textFiled.placeholder = @"输入网关IP";
        }
        if (indexPath.row == 1) {
            ((MtopCustomCell *)cell).textFiled.placeholder = @"输入网关PORT";
        }
    
    }else if (indexPath.section == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:LabelIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:LabelIdentifier];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"点击验证GET请求";
        }
        
        if (indexPath.row == 1) {
            cell.textLabel.text = @"点击验证POST请求";
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *indexPaht2 = [NSIndexPath indexPathForRow:1 inSection:0];
    
    MtopCustomCell *cell1 = [tableView cellForRowAtIndexPath:indexPath1];
    MtopCustomCell *cell2 = [tableView cellForRowAtIndexPath:indexPaht2];
   
    
    NSString *url = [NSString stringWithFormat:@"%@:%@",cell1.textFiled.text.length ? cell1.textFiled.text :[[EMASService shareInstance] MTOPDomain], cell2.textFiled.text.length ? cell2.textFiled.text:@"80"];
    
    MtopResultViewController *resultVc = [[MtopResultViewController alloc] initWithRowPath:indexPath andUrl:url];
    if (indexPath.row == 0) {
        // GET请求
        NSLog(@"GET");
        [self.navigationController pushViewController:resultVc animated:YES];
    } else {
        // POST请求
        NSLog(@"POST");
        [self.navigationController pushViewController:resultVc animated:YES];
    }
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
