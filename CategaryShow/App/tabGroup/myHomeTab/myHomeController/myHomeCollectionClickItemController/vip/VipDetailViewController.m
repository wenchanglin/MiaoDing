//
//  VipDetailViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/2/16.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "VipDetailViewController.h"
#import "VipGrowModel.h"
#import "FirstSectionTableViewCell.h"
#import "growListTableViewCell.h"
#import "vipRuleViewController.h"
@interface VipDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation VipDetailViewController
{
    BaseDomain *getData;
    NSMutableArray *modelArray;
    UITableView *growTable;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    getData = [BaseDomain getInstance:NO];
    modelArray = [NSMutableArray array];
    UIButton *buttonRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [buttonRight setImage:[UIImage imageNamed:@"RuleImg"] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    
    [buttonRight addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self settabTitle:@"会员俱乐部"];
    [self getDatas];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)rightClick
{
    vipRuleViewController *vipRule = [[vipRuleViewController alloc] init];
    [self.navigationController pushViewController:vipRule animated:YES];
}

-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [getData getData:URL_VipGrow PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            //NSLog(@"%@", domain.dataRoot);
            for (NSDictionary *dic in [domain.dataRoot arrayForKey:@"data"]) {
                VipGrowModel *model = [VipGrowModel new];
                model.time = [self dateToString:[dic stringForKey:@"c_time"]];
                model.name = [dic stringForKey:@"name"];
                model.addCount = [NSString stringWithFormat:@"+%@", [dic stringForKey:@"credit"]];
                [modelArray addObject:model];
            }
            
            [self createTable];
        }
    }];
}


-(void)createTable
{
    growTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    if (@available(iOS 11.0, *)) {
        growTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    growTable.dataSource = self;
    growTable.delegate = self;
    [growTable registerClass:[FirstSectionTableViewCell class] forCellReuseIdentifier:@"firstSection"];
    [growTable registerClass:[growListTableViewCell class] forCellReuseIdentifier:@"growListSection"];
    [self.view addSubview:growTable];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
       return [modelArray count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 8;
    } else {
        return 0.001;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 66;
    } else {
        return 60;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *reCell;
    if (indexPath.section == 0) {
        FirstSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"firstSection" forIndexPath:indexPath];
        
        [cell.vipCount setText:_vipCount];
        reCell = cell;
        
    } else {
        growListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"growListSection" forIndexPath:indexPath];
        cell.model = modelArray[indexPath.row];
        reCell = cell;
    }
    
    [reCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return reCell;
}

-(NSString *)dateToString:(NSString *)dateString
{
    
    NSTimeInterval time=[dateString doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
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
