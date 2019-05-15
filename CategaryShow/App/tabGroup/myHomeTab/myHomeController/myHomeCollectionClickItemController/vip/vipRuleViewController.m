//
//  vipRuleViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/2/16.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "vipRuleViewController.h"
#import "ruleDetailViewController.h"
@interface vipRuleViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation vipRuleViewController
{
    NSMutableArray *listArray;
    }
- (void)viewDidLoad {
    [super viewDidLoad];
    [self settabTitle:@"会员制度"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    listArray = [NSMutableArray array];
    [self getDatas];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_MineUserHelp_String] parameters:params finished:^(id responseObject, NSError *error) {
        if ([self checkHttpResponseResultStatus:responseObject]) {
            listArray = [NSMutableArray arrayWithArray:[responseObject arrayForKey:@"data"]];
            [self createTable];
        }
    }];
}

-(void)createTable{
    
    UITableView *tableRule = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    if (@available(iOS 11.0, *)) {
        tableRule.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    tableRule.delegate = self;
    tableRule.dataSource = self;
    [tableRule setBackgroundColor:getUIColor(Color_background)];
    [tableRule registerClass:[UITableViewCell class] forCellReuseIdentifier:@"list"];
    [self.view addSubview:tableRule];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"list" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.textLabel setText:[listArray[indexPath.row] stringForKey:@"name"]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ruleDetailViewController *ruleDetail = [[ruleDetailViewController alloc] init];
    ruleDetail.ruleDic = listArray[indexPath.row];
    [self.navigationController pushViewController:ruleDetail animated:YES];
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
