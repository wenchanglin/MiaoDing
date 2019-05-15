//
//  haveOverduedViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/12/19.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "haveOverduedViewController.h"
#import "couponTableViewCell.h"
#import "couponModel.h"
@interface haveOverduedViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation haveOverduedViewController
{
    UITableView *canUse;
    NSMutableArray *modelArray;
    UITextField *CouponNumber;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    modelArray = [NSMutableArray array];
    [self getDatas];
    
}

-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"3" forKey:@"status"];
    [[wclNetTool sharedTools]request:GET urlString:URL_Coupon parameters:params finished:^(id responseObject, NSError *error) {
        if([self checkHttpResponseResultStatus:responseObject])
        {
            modelArray = [couponModel mj_objectArrayWithKeyValuesArray:responseObject[@"tickets"]];
            [self createTable];
        }
    }];
}

-(void)createTable
{
    canUse = [[UITableView alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH - 24,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-74-84:SCREEN_HEIGHT - 41 - 64) style:UITableViewStyleGrouped];
    canUse.delegate = self;
    canUse.dataSource = self;
    canUse.showsVerticalScrollIndicator =NO;
    [canUse setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [canUse registerClass:[couponTableViewCell class] forCellReuseIdentifier:@"haveOver"];
    [self.view addSubview:canUse];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94;//87;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [modelArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    couponModel *model = modelArray[indexPath.section];
    couponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"haveOver" forIndexPath:indexPath];
    cell.model = model;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
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
