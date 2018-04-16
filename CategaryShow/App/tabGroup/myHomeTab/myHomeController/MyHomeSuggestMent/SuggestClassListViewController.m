//
//  SuggestClassListViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/11/28.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "SuggestClassListViewController.h"
#import "SuggestDetailViewController.h"
@interface SuggestClassListViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation SuggestClassListViewController
{
    UITableView *helpTable;
    NSMutableArray *helpList;
    BaseDomain *getData;
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self settabTitle:@"帮助列表"];
    helpList = [NSMutableArray array];
    getData = [BaseDomain getInstance:NO];
     [self.view setBackgroundColor:getUIColor(Color_background)];
    if (@available(iOS 11.0, *)) {
        helpTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self createHelpTable];
    [self getDatas];
}

-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_classId forKey:@"classify_id"];
    [getData getData:URL_HelpList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            helpList = [NSMutableArray arrayWithArray:[domain.dataRoot arrayForKey:@"data"]];
            [helpTable reloadData];
        }
    }];
}

-(void)createHelpTable
{
    helpTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH,IsiPhoneX?SCREEN_HEIGHT-88-74:SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    helpTable.delegate = self;
    helpTable.dataSource = self;
    [helpTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"helpList"];
    
    [self.view addSubview:helpTable];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [helpList count];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"helpList" forIndexPath:indexPath];
    [cell.textLabel setText:[[helpList objectAtIndex:indexPath.row] stringForKey:@"name"]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    [cell.textLabel setTextColor:getUIColor(Color_suggestLargeTitle)];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SuggestDetailViewController *suggestDetail = [[SuggestDetailViewController alloc] init];
    suggestDetail.detailId = [helpList[indexPath.row] stringForKey:@"id"];
    [self.navigationController pushViewController:suggestDetail animated:YES];
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
