//
//  mcYuYueListViewController.m
//  CategaryShow
//
//  Created by 文长林 on 2019/4/30.
//  Copyright © 2019 Mr.huang. All rights reserved.
//

#import "mcYuYueListViewController.h"
#import "messageListModel.h"
#import "mcYuYueListTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

#define kMasonryCell @"mcYuYueListViewController"
@interface mcYuYueListViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation mcYuYueListViewController
{
    NSMutableArray *modelArray;
    UITableView *MCListTable;
    UILabel *labelCount;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self settabTitle:@"预约订单"];
    modelArray = [NSMutableArray array];
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
    [MCListTable registerClass:[mcYuYueListTableViewCell class] forCellReuseIdentifier:kMasonryCell];
    [self.view addSubview:MCListTable];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    messageListModel *model = modelArray[section];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    [label setText:model.create_time];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:14]];
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
    // 计算缓存cell的高度
    return [MCListTable fd_heightForCellWithIdentifier:kMasonryCell cacheByIndexPath:indexPath configuration:^(id cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    mcYuYueListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kMasonryCell];
    [cell setBackgroundColor:[UIColor whiteColor]];
    [self configureCell:cell atIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
#pragma mark - 给cell赋值
- (void)configureCell:(mcYuYueListTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.model = modelArray[indexPath.row];
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
