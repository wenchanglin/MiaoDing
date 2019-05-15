//
//  MCListViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/1/4.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "MCListViewController.h"
#import "messageListModel.h"
#import "systemMCTableViewCell.h"
@interface MCListViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation MCListViewController
{
    NSMutableArray *modelArray;
    BaseDomain *getData;
    UITableView *MCListTable;
    UILabel *labelCount;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self settabTitle:@"系统通知"];
    modelArray = [NSMutableArray array];
    getData = [BaseDomain getInstance:NO];
    [self.view setBackgroundColor:getUIColor(Color_background)];
    [self getDatas];
    [self createTable];
    labelCount = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    [labelCount setTextAlignment:NSTextAlignmentCenter];
    [labelCount setText:@"暂无通知"];
    [labelCount setFont:[UIFont systemFontOfSize:16]];
    [labelCount setTextColor:getUIColor(Color_active)];
    labelCount.center = self.view.center;
    [self.view addSubview:labelCount];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_mc_Id forKey:@"type"];
    [[wclNetTool sharedTools]request:GET urlString:[MoreUrlInterface URL_NoticationList_String] parameters:params finished:^(id responseObject, NSError *error) {
        if ([self checkHttpResponseResultStatus:responseObject]) {
            NSArray*array = [responseObject arrayForKey:@"data"];
            if ([array count] > 0) {
                [labelCount setHidden:YES];
            } else {
                [labelCount setHidden:NO];
            }
            modelArray = [messageListModel mj_objectArrayWithKeyValuesArray:array];
            [MCListTable reloadData];
        }
    }];
}

-(void)createTable
{
    MCListTable = [[UITableView alloc] initWithFrame:CGRectMake(9, NavHeight, SCREEN_WIDTH - 18, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    if (@available(iOS 11.0, *)) {
       MCListTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    MCListTable.dataSource = self;
    MCListTable.delegate = self;
    MCListTable.showsVerticalScrollIndicator = NO;
    [MCListTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [MCListTable registerClass:[systemMCTableViewCell class] forCellReuseIdentifier:NSStringFromClass([systemMCTableViewCell class])];
    [self.view addSubview:MCListTable];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    messageListModel *model = modelArray[section];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    [label setText:model.create_time];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setTextColor:[UIColor lightGrayColor]];
    return label;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [modelArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat x;
    messageListModel *model = modelArray[indexPath.section];
    Class currentClass = [systemMCTableViewCell class];
    x =  [MCListTable cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
    return x;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    messageListModel *model = modelArray[indexPath.section];
    Class currentClass = [systemMCTableViewCell class];
    systemMCTableViewCell *cell = nil;
    [cell setBackgroundColor:[UIColor whiteColor]];
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
    cell.model = model;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
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
