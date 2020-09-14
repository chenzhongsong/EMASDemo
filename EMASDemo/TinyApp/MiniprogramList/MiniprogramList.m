//
//  MiniprogramList.m
//  mPaasiOSDemo
//
//  Created by 时苒 on 2020/8/5.
//  Copyright © 2020 ShiRaner. All rights reserved.
//

#import "MiniprogramList.h"

#import <MiniAppMarket/MiniAppMarket.h>

#import "ListCell.h"

#import <NebulaAppManager/NAMService.h>

@interface MiniprogramList () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

 
// @property (nonatomic, strong) NSArray *heros;
@property (nonatomic, strong) NSDictionary * listData;

@property (nonatomic, strong) NSMutableDictionary * miniprogramIdDictionary;

@end



@implementation MiniprogramList

- (NSDictionary *)listData {
    if (_listData == nil) {
        MiniAppMarketCenter * _center = [MiniAppMarketCenter new];
        _listData = [_center miniProgramlist:self.pageNo pageSize:self.pageSize][@"data"];
    }
    return _listData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    self.listTableView.rowHeight = 100;
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    _miniprogramIdDictionary = [[NSMutableDictionary alloc]init];
    // 通过创建 xib 的形式自定义cell  注册重用的方式为 registerNib
    [self.listTableView registerNib:[UINib nibWithNibName:@"ListCell" bundle:nil] forCellReuseIdentifier:@"ListCellIdentifiter"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) { return self.listData.count; }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (0 == section) { return @"小程序列表"; }
    return @"";
}
    
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (0 == section) {  return @"没有数据了。。。"; }
    return @"";
}

#pragma mark -- 控制状态栏是否显示  返回 YES 代表隐藏状态栏, NO 相反
// - (BOOL)prefersStatusBarHidden { return YES;}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCellIdentifiter" forIndexPath:indexPath];
    NSArray * tempArr = (NSArray*)self.listData;
    NSDictionary * tempDic;
    for (int i = 0; i < tempArr.count; i++) {
        if (i == indexPath.row) {
            tempDic = tempArr[i];
            cell.name.text = [tempDic objectForKey:@"name"];
            cell.descrip.text = [tempDic objectForKey:@"description"];
            cell.miniprogramId.text = [NSString stringWithFormat:@"%@",[tempDic objectForKey:@"miniprogramId"]];
            
            [_miniprogramIdDictionary setObject:[NSString stringWithFormat:@"%@",[tempDic objectForKey:@"miniprogramId"]] forKey:[NSString stringWithFormat:@"%d",i]];
              
            cell.status.text = [NSString stringWithFormat:@"%@",[tempDic objectForKey:@"onlineStatus"]];
            cell.icon.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[tempDic objectForKey:@"icon"]]]];
        }
    }
    
    return cell;
  
}

#pragma mark -- 点击某行单元格的回调
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * tempStr = [_miniprogramIdDictionary objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    MiniAppMarketCenter * _center = [MiniAppMarketCenter new];
    MiniAppMarketInfo *info = [_center miniProgramStatus:tempStr];

    if ([info.onlineStatus isEqualToString:@"2"]) {
  
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"onlineStatus = 2" message:@"该小程序的状态可能是未发布" preferredStyle:UIAlertControllerStyleAlert];
           
           UIAlertAction *conform = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                  NSLog(@"点击了确认按钮");
           }];
           
           UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
               NSLog(@"点击了取消按钮");
           }];
        
           [alert addAction:conform];
           [alert addAction:cancel];
           [self presentViewController:alert animated:YES completion:nil];
   
    } else {
     
//        NSDictionary * allinfo = [[NSDictionary alloc]init];
//        NSArray * att = [NSArray arrayWithObject:tempStr];
//        allinfo = [NAMServiceGet() allAppsForAppId:att];
//        NSLog(@"\n ====================== allInfo %@",allinfo);

        [NAMServiceGet() clearAllAppInfo:tempStr];
        [MPNebulaAdapterInterface startTinyAppWithId:tempStr params:nil];
    }

}


@end
