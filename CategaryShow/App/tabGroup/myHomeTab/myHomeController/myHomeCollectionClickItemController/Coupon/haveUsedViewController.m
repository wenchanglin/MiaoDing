//
//  haveUsedViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/12/19.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "haveUsedViewController.h"
#import "couponTableViewCell.h"
#import "couponModel.h"
@interface haveUsedViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation haveUsedViewController
{
    UITableView *canUse;
    NSMutableArray *modelArray;
    BaseDomain *getData;
    BaseDomain *postData;
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
    [params setObject:@"2" forKey:@"status"];
    [[wclNetTool sharedTools]request:GET urlString:URL_Coupon parameters:params finished:^(id responseObject, NSError *error) {
        if ([self checkHttpResponseResultStatus:responseObject]) {
            WCLLog(@"%@",responseObject);
            modelArray = [couponModel mj_objectArrayWithKeyValuesArray:responseObject[@"tickets"]];
            if (modelArray.count>0) {
                 [self createTable];
            }
            else
            {
                [canUse removeFromSuperview];
                [self createViewNoDD];
            }
        }
        
    }];

}
-(void)createViewNoDD    // 创建没有优惠券界面
{
    UIImageView *NoDD = [UIImageView new];
    [self.view addSubview:NoDD];
    NoDD.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view, 120)
    .widthIs(211)
    .heightIs(220);
    [NoDD setImage:[UIImage imageNamed:@"EmptyCoupon"]];
    
}
-(void)createTable
{
    canUse = [[UITableView alloc] initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH - 16,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-64-84:SCREEN_HEIGHT - 41 - 64) style:UITableViewStyleGrouped];
    canUse.delegate = self;
    canUse.dataSource = self;
    canUse.showsVerticalScrollIndicator =NO;
    [canUse setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [canUse registerClass:[couponTableViewCell class] forCellReuseIdentifier:@"haveUsed"];
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
    return 87;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [modelArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    couponModel *model = modelArray[indexPath.section];
    couponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"haveUsed" forIndexPath:indexPath];
    cell.model = model;
    cell.backgroundColor = [UIColor clearColor];
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
