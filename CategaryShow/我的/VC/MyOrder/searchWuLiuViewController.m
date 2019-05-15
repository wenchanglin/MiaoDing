//
//  searchWuLiuViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/11/24.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "searchWuLiuViewController.h"
#import "wuLiuModel.h"
#import "WLTableViewCell.h"
#import "WLheaderTableViewCell.h"
@interface searchWuLiuViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation searchWuLiuViewController
{
    BaseDomain *getData;
    UITableView *wuLiuTable;
    NSMutableArray *wuLiuArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self settabTitle:@"物流详情"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    getData = [BaseDomain getInstance:NO];
    wuLiuArray = [NSMutableArray array];
    [self getDatas];
    [self createTableForWuLiu];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"order_sn"]=_order_sn;
    [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_CheckSfExpress_String] parameters:params finished:^(id responseObject, NSError *error) {
        if ([self checkHttpResponseResultStatus:responseObject]) {
            WCLLog(@"%@",responseObject);
            for (NSDictionary *dic in [responseObject arrayForKey:@"data"]) {
                wuLiuModel *model = [wuLiuModel new];
                model.time = [dic stringForKey:@"time"];
                model.context = [dic stringForKey:@"context"];
                [wuLiuArray addObject:model];
            }
            
            [wuLiuTable reloadData];
        }
    }];
    
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)createTableForWuLiu
{
    wuLiuTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-88:SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    wuLiuTable.delegate = self;
    wuLiuTable.dataSource = self;
    [wuLiuTable registerClass:[WLheaderTableViewCell class] forCellReuseIdentifier:NSStringFromClass([WLheaderTableViewCell class])];
    [wuLiuTable registerClass:[WLTableViewCell class] forCellReuseIdentifier:NSStringFromClass([WLTableViewCell class])];
    [self.view addSubview:wuLiuTable];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else return [wuLiuArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat re;
    if (indexPath.section == 0) {
        re = 63;
    } else {
        wuLiuModel *model= wuLiuArray[indexPath.row];
        Class currentClass = [WLTableViewCell class];
        re =  [wuLiuTable cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
    }
    return  re;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 8;
    } else return 0.001;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *reCell;
    if (indexPath.section == 0) {
        Class currentClass = [WLheaderTableViewCell class];
        WLheaderTableViewCell *cell = nil;
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
        //        [cell.wlName setText:[NSString stringWithFormat:@"物流公司: %@", _ems_com_name]];
        //        [cell.wlNum setText:[NSString stringWithFormat:@"物流单号: %@", _ems_no]];
        reCell = cell;
    } else {
        wuLiuModel *model = wuLiuArray[indexPath.row];
        Class currentClass = [WLTableViewCell class];
        WLTableViewCell *cell = nil;
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
        cell.model = model;
        
        if (indexPath.row == [wuLiuArray count] - 1) {
            [cell.downLine setHidden:YES];
        } else {
            [cell.downLine setHidden:NO];
        }
        
        if (indexPath.row == 0) {
            [cell.topLine setHidden:YES];
        } else {
            [cell.topLine setHidden:NO];
        }
        reCell = cell;
    }
    [reCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return reCell;
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
