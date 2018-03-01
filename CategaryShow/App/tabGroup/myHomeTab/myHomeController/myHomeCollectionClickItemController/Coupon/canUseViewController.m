//
//  canUseViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/12/19.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "canUseViewController.h"
#import "couponTableViewCell.h"
#import "couponModel.h"
@interface canUseViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@end

@implementation canUseViewController
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
    getData = [BaseDomain getInstance:NO];
    postData = [BaseDomain getInstance:NO];
    // Do any additional setup after loading the view.
    [self getDatas];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
}

-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"status"];
    
    [getData getData:URL_Coupon PostParams:params finish:^(BaseDomain *domain, Boolean success) {
       
        if ([self checkHttpResponseResultStatus:domain]) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:[domain.dataRoot arrayForKey:@"data"]];
            for (NSDictionary *dic in array) {
                couponModel *model = [[couponModel alloc] init];
                model.price = [NSString stringWithFormat:@"%.f", [[dic stringForKey:@"money"] floatValue]];
                model.useType = [dic stringForKey:@"title"];
                model.typeRemark = [dic stringForKey:@"sub_title"];
                model.imageName = @"canUse";
                model.time = [NSString stringWithFormat:@"有效期:%@至%@",[self dateToString:[dic stringForKey:@"s_time"]], [self dateToString:[dic stringForKey:@"e_time"]]];
                [modelArray addObject:model];
            }
            
            [self createTable];
        }
        
    }];
}

-(void)createTable
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH - 16, 60)];
    CouponNumber = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, view.frame.size.width - 100, 40)];
    [view addSubview:CouponNumber];
    [CouponNumber setFont:[UIFont systemFontOfSize:16]];
    [CouponNumber setPlaceholder:@"请输入兑换码"];
    [CouponNumber setTextAlignment:NSTextAlignmentCenter];
    [CouponNumber.layer setBorderWidth:1];
    [CouponNumber setReturnKeyType:UIReturnKeyDone];
    CouponNumber.delegate = self;
    [CouponNumber.layer setBorderColor:getUIColor(Color_background).CGColor];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(view.frame.size.width - 80, 12.5, 70, 35)];
    [button setBackgroundColor:[UIColor blackColor]];
    [button setTitle:@"兑换" forState:UIControlStateNormal];
    [button.layer setCornerRadius:1];
    [button.layer setMasksToBounds:YES];
    
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button addTarget:self action:@selector(getConpon) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    [self.view addSubview:view];
    
    canUse = [[UITableView alloc] initWithFrame:CGRectMake(8, 60, SCREEN_WIDTH - 16, SCREEN_HEIGHT - 41 - 64 - 60) style:UITableViewStyleGrouped];
    canUse.delegate = self;
    canUse.dataSource = self;
    canUse.showsVerticalScrollIndicator =NO;
    [canUse setBackgroundColor:[UIColor whiteColor]];
    [canUse setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [canUse registerClass:[couponTableViewCell class] forCellReuseIdentifier:@"canUse"];
    [self.view addSubview:canUse];
    
}


-(void)getConpon
{
    [CouponNumber resignFirstResponder];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:CouponNumber.text forKey:@"kouling"];
    [postData postData:URL_GetCoupon PostParams:params finish:^(BaseDomain *domain, Boolean success) {
       
        if ([self checkHttpResponseResultStatus:domain]) {
            [self reloadData];
        }
    }];
    
}

-(void)reloadData
{
    [modelArray removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"status"];
    
    [getData getData:URL_Coupon PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:domain]) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:[domain.dataRoot arrayForKey:@"data"]];
            for (NSDictionary *dic in array) {
                couponModel *model = [[couponModel alloc] init];
                model.price = [NSString stringWithFormat:@"%.f", [[dic stringForKey:@"money"] floatValue]];
                model.useType = [dic stringForKey:@"title"];
                model.typeRemark = [dic stringForKey:@"sub_title"];
                model.imageName = @"canUse";
                model.time = [NSString stringWithFormat:@"有效期:%@至%@",[self dateToString:[dic stringForKey:@"s_time"]], [self dateToString:[dic stringForKey:@"e_time"]]];
                [modelArray addObject:model];
            }
            
            [canUse reloadData];
        }
        
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    
    [textField resignFirstResponder];
    
    return YES;
}

-(NSString *)dateToString:(NSString *)dateString
{

    NSTimeInterval time=[dateString doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.001;
    }
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
    couponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"canUse" forIndexPath:indexPath];
    cell.model = model;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LookClothes" object:nil];
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
