//
//  chooseConponViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/12/19.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "chooseConponViewController.h"
#import "couponTableViewCell.h"
#import "couponModel.h"
@interface chooseConponViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>

@end

@implementation chooseConponViewController
{
    UITableView *canUse;
    NSMutableArray *modelArray;
    UITextField *CouponNumber;
    NSMutableArray *canUseModelArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self settabTitle:@"选择优惠券"];
    modelArray = [NSMutableArray array];
    canUseModelArray = [NSMutableArray array];
    [self getDatas];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)getDatas
{
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms setObject:_carId forKey:@"cart_id_s"];
    [[wclNetTool sharedTools]request:GET urlString:[MoreUrlInterface URL_GetYouHuiQuanFromCarid_String] parameters:parms finished:^(id responseObject, NSError *error) {
//        WCLLog(@"%@",responseObject);
        canUseModelArray = [couponModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"valid_tickets"]];
        modelArray = [couponModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"invalid_tickets"]];
        [self createTable];
    }];
}

-(void)createTable
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(8, NavHeight, SCREEN_WIDTH - 16, 60)];
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
    
    
    canUse = [[UITableView alloc] initWithFrame:CGRectMake(8, 60+NavHeight, SCREEN_WIDTH - 16,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-88-94:SCREEN_HEIGHT  - 84-49) style:UITableViewStyleGrouped];
    if (@available(iOS 11.0, *)) {
        canUse.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    canUse.delegate = self;
    canUse.dataSource = self;
    canUse.showsVerticalScrollIndicator =NO;
    [canUse setBackgroundColor:[UIColor whiteColor]];
    [canUse setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [canUse registerClass:[couponTableViewCell class] forCellReuseIdentifier:@"canUse"];
    [canUse registerClass:[couponTableViewCell class] forCellReuseIdentifier:@"NoUse"];

    [self.view addSubview:canUse];
    
    
    UIButton *buttonBack = [[UIButton alloc] initWithFrame:CGRectMake(0,[ShiPeiIphoneXSRMax isIPhoneX]?self.view.frame.size.height-74:self.view.frame.size.height - 49, SCREEN_WIDTH, 49)];
    [buttonBack setBackgroundColor:[UIColor blackColor]];
    [buttonBack setTitle:@"不使用优惠券" forState:UIControlStateNormal];
    [buttonBack.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [buttonBack addTarget:self action:@selector(ConponbuttonBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonBack];
    
}

-(void)ConponbuttonBack
{
    NSMutableDictionary *dicNoti = [NSMutableDictionary dictionary];
    [dicNoti setObject:@"0" forKey:@"price"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"chooseCoupon" object:nil userInfo:dicNoti];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getConpon
{
    [CouponNumber resignFirstResponder];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:CouponNumber.text forKey:@"exchange_code"];
    [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_ExchangeCouPon_String] parameters:params finished:^(id responseObject, NSError *error) {
        //        WCLLog(@"%@",responseObject);
        if ([self checkHttpResponseResultStatus:responseObject]) {
            [self getDatas];
        }
    }];
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return canUseModelArray.count>0?canUseModelArray.count:0;
    }
    else
    {
        return modelArray.count>0?modelArray.count:0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return 10;
    }
    else
    {
        return 40;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 87;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 20)];
        [label setText:@"以下优惠券不适用此订单"];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:14]];
        [label setTextColor:[UIColor grayColor]];
        [view addSubview:label];
        return view;
    } else return nil;
}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        couponModel *model = canUseModelArray[indexPath.row];
        couponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"canUse" forIndexPath:indexPath];
        cell.model = model;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    else
    {
        
        couponModel *model = modelArray[indexPath.row];
        couponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoUse" forIndexPath:indexPath];
        cell.model = model;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor clearColor];
        return cell;

    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (canUseModelArray.count>0) {
            couponModel *model = canUseModelArray[indexPath.row];
            NSMutableDictionary *dicNoti =[ NSMutableDictionary dictionary ];
                    [dicNoti setObject:@(model.ID) forKey:@"conponid"];
                    [dicNoti setObject:model.re_marks forKey:@"remark"];
                    [dicNoti setObject:model.money forKey:@"price"];
                    [dicNoti setObject:model.full_money forKey:@"maxPrice"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"chooseCoupon" object:nil userInfo:dicNoti];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
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
