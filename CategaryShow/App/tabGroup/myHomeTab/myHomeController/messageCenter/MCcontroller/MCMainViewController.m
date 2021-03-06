//
//  MCMainViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/1/4.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "MCMainViewController.h"
#import "messageTypeTableViewCell.h"
#import "MCListViewController.h"
#import "mcSaleViewController.h"
#import "mcWuLiuViewController.h"
#import "mcYuYueListViewController.h"
@interface MCMainViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation MCMainViewController
{
    BaseDomain *getData;
    UITableView *messageTypeTable;
    NSMutableArray *modelArray;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self settabTitle:@"系统通知"];
    modelArray = [NSMutableArray array];
    getData = [BaseDomain getInstance:NO];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#EDEDED"]];
    [self createTableMc];
    [self getDatas];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [[wclNetTool sharedTools]request:GET urlString:[MoreUrlInterface URL_NoticationType_String] parameters:params finished:^(id responseObject, NSError *error) {
        if ([self checkHttpResponseResultStatus:responseObject]) {
            modelArray = [messageTypeModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [messageTypeTable reloadData];
        }
    }];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)createTableMc
{
    messageTypeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    if (@available(iOS 11.0, *)) {
        messageTypeTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    messageTypeTable.dataSource = self;
    messageTypeTable.delegate = self;
    [messageTypeTable registerClass:[messageTypeTableViewCell class] forCellReuseIdentifier:@"messageType"];
    [messageTypeTable setBackgroundColor:[UIColor clearColor]];
    messageTypeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    messageTypeTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:messageTypeTable];
}

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [modelArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    messageTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageType" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    messageTypeModel *model = modelArray[indexPath.row];
    cell.model = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    messageTypeModel *model = modelArray[indexPath.row];
    
    if (model.type == 1) {
        MCListViewController *list = [[MCListViewController alloc] init];
        list.mc_Id = [NSString stringWithFormat:@"%@",@(model.type)];
        [self.navigationController pushViewController:list animated:YES];
    } else if (model.type == 2) {
        mcSaleViewController *list = [[mcSaleViewController alloc] init];
        list.mc_Id = [NSString stringWithFormat:@"%@",@(model.type)];
        [self.navigationController pushViewController:list animated:YES];
    } else if (model.type == 3) {
        mcWuLiuViewController *list = [[mcWuLiuViewController alloc] init];
        list.mc_Id = [NSString stringWithFormat:@"%@",@(model.type)];
        [self.navigationController pushViewController:list animated:YES];
    }
    else if (model.type==4)
    {
        mcYuYueListViewController *list = [[mcYuYueListViewController alloc] init];
        list.mc_Id = [NSString stringWithFormat:@"%@",@(model.type)];
        [self.navigationController pushViewController:list animated:YES];
    }
    
    
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
