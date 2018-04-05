
//
//  DateForBodyViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/3/1.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "DateForBodyViewController.h"
#import "dateForBodyTableViewCell.h"
#import "bodyDateDetailViewController.h"
@interface DateForBodyViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation DateForBodyViewController
{
    BaseDomain *getDate;
    UITableView *nameTable;
    NSMutableArray *arrayData;
    UIView *bgNoDingView;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self settabTitle:@"量体数据"];
    getDate = [BaseDomain getInstance:NO];
    arrayData = [NSMutableArray array];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self createTable];
    [self createDates];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)createDates
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"page"];
    [getDate postData:URL_GetBodyDate PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            arrayData = [NSMutableArray arrayWithArray:[domain.dataRoot arrayForKey:@"data"]];
            if ([arrayData count] > 0) {
                [self createTable];
            } else {
                [self createViewNoDD];
            }
            
            
            
        }
    }];
}

-(void)createViewNoDD    // 创建没有订单界面
{
    
    
    bgNoDingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [bgNoDingView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bgNoDingView];
    
    UIImageView *NoDD = [UIImageView new];
    [bgNoDingView addSubview:NoDD];
    NoDD.sd_layout
    .centerXEqualToView(bgNoDingView)
    .centerYEqualToView(bgNoDingView)
    .widthIs(448/ 2)
    .heightIs(222);
    [NoDD setImage:[UIImage imageNamed:@"LiangTiEmpty"]];
    
    
    
   
    
    
    
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(void)createTable
{
    nameTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    if (@available(iOS 11.0, *)) {
        nameTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    nameTable.delegate = self;
    nameTable.dataSource = self;
    [nameTable registerClass:[dateForBodyTableViewCell class] forCellReuseIdentifier:@"name"];
    [nameTable setSeparatorColor : getUIColor(Color_myTabIconLineColor)];
    [self.view addSubview:nameTable];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [arrayData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    dateForBodyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"name" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.titleLabel.text = [[arrayData[indexPath.section] objectAtIndex:0] stringForKey:@"name"];
    
    cell.detailLabel.text = [[arrayData[indexPath.section] objectAtIndex:0] stringForKey:@"value"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    bodyDateDetailViewController *bodyDeta = [[bodyDateDetailViewController alloc] init];
    bodyDeta.dateArray = arrayData[indexPath.section];
    [self.navigationController pushViewController:bodyDeta animated:YES];
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
