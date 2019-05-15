//
//  mcWuLiuViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/1/5.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "mcWuLiuViewController.h"
#import "messageListModel.h"
#import "wuLiuMcTableViewCell.h"
#import "searchWuLiuViewController.h"
@interface mcWuLiuViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation mcWuLiuViewController

{
    NSMutableArray *modelArray;
    BaseDomain *getData;
    UITableView *MCListTable;
    UILabel *labelCount;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self settabTitle:@"物流通知"];
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
//        WCLLog(@"%@",responseObject);
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
    MCListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    if (@available(iOS 11.0, *)) {
        MCListTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    MCListTable.dataSource = self;
    MCListTable.delegate = self;
    [MCListTable registerClass:[wuLiuMcTableViewCell class] forCellReuseIdentifier:@"mcListWuliu"];
    [MCListTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [modelArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 156;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    messageListModel *model = modelArray[indexPath.section];
    wuLiuMcTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mcListWuliu" forIndexPath:indexPath];
    cell.model = model;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    messageListModel *model = modelArray[indexPath.section];
    searchWuLiuViewController *search = [[searchWuLiuViewController alloc] init];
    search.order_sn=model.re_marks;
    [self.navigationController pushViewController:search animated:YES];
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
