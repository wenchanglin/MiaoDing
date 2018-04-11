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
    BaseDomain *getData;
    BaseDomain *postData;
    UITextField *CouponNumber;
    NSMutableArray *canUseModelArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self settabTitle:@"选择优惠券"];
    modelArray = [NSMutableArray array];
    canUseModelArray = [NSMutableArray array];
    getData = [BaseDomain getInstance:NO];
    postData = [BaseDomain getInstance:NO];
    [self getDatas];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
//    [params setObject:_good_ids forKey:@"goods_ids"];
//    
//    [params setObject:_maxPrice forKey:@"max_price"];
    [params setObject:_carId forKey:@"car_ids"];
    [getData getData:URL_ChooseCoupon PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:domain]) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:[[domain.dataRoot objectForKey:@"data"] arrayForKey:@"usable"]];
            
            [array addObjectsFromArray:[[domain.dataRoot objectForKey:@"data"] arrayForKey:@"disable"]];
            
            
            canUseModelArray = [NSMutableArray arrayWithArray:[[domain.dataRoot objectForKey:@"data"] arrayForKey:@"usable"]];
            
            for (NSDictionary *dic in array) {
                couponModel *model = [[couponModel alloc] init];
                model.price = [NSString stringWithFormat:@"%.f",[[dic stringForKey:@"money"] floatValue]];
                model.useType = [dic stringForKey:@"title"];
                model.minPrice = [dic stringForKey:@"min_money"];
                model.typeRemark = [dic stringForKey:@"sub_title"];
                if ([dic integerForKey:@"status"] == 1) {
                    model.imageName = @"canUse";
                } else if ([dic integerForKey:@"status"] == -1) {
                    model.imageName = @"haveOver";
                    
                } else if ([dic integerForKey:@"status"] == 2) {
                    model.imageName = @"haveUsed";
                }
                
                model.conPonId = [dic stringForKey:@"id"];
                model.time = [NSString stringWithFormat:@"有效期:%@至%@",[self dateToString:[dic stringForKey:@"s_time"]], [self dateToString:[dic stringForKey:@"e_time"]]];
                [modelArray addObject:model];
            }
            
            [self createTable];
        }
        
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
    
    
    canUse = [[UITableView alloc] initWithFrame:CGRectMake(8, 60+NavHeight, SCREEN_WIDTH - 16,IsiPhoneX?SCREEN_HEIGHT-88-94:SCREEN_HEIGHT  - 84-49) style:UITableViewStyleGrouped];
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
    [self.view addSubview:canUse];
    
    
    UIButton *buttonBack = [[UIButton alloc] initWithFrame:CGRectMake(0,IsiPhoneX?self.view.frame.size.height-74:self.view.frame.size.height - 49, SCREEN_WIDTH, 49)];
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
    [params setObject:CouponNumber.text forKey:@"kouling"];
    [postData postData:URL_GetCoupon PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:domain]) {
            [self getDatas];
        }
    }];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}
-(void)reloadData
{
    [modelArray removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
//    [params setObject:_good_ids forKey:@"goods_ids"];
//    
//    [params setObject:_maxPrice forKey:@"max_price"];
    [params setObject:_carId forKey:@"car_ids"];
    [getData getData:URL_ChooseCoupon PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:domain]) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:[[domain.dataRoot objectForKey:@"data"] arrayForKey:@"usable"]];
            
            [array addObjectsFromArray:[[domain.dataRoot objectForKey:@"data"] arrayForKey:@"disable"]];
            
            
            canUseModelArray = [NSMutableArray arrayWithArray:[[domain.dataRoot objectForKey:@"data"] arrayForKey:@"usable"]];
            
            for (NSDictionary *dic in array) {
                couponModel *model = [[couponModel alloc] init];
                model.price = [NSString stringWithFormat:@"%.f",[[dic stringForKey:@"money"] floatValue]];
                model.useType = [dic stringForKey:@"title"];
                model.minPrice = [dic stringForKey:@"min_money"];
                model.typeRemark = [dic stringForKey:@"sub_title"];
                if ([dic integerForKey:@"status"] == 1) {
                    model.imageName = @"canUse";
                } else if ([dic integerForKey:@"status"] == -1) {
                    model.imageName = @"haveOver";
                    
                } else if ([dic integerForKey:@"status"] == 2) {
                    model.imageName = @"haveUsed";
                }
                
                model.conPonId = [dic stringForKey:@"id"];
                model.time = [NSString stringWithFormat:@"有效期:%@至%@",[self dateToString:[dic stringForKey:@"s_time"]], [self dateToString:[dic stringForKey:@"e_time"]]];
                [modelArray addObject:model];
            }
            
            [canUse reloadData];
        }
        
    }];
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
    if ([modelArray count] - [canUseModelArray count] > 0) {
        if (section == [canUseModelArray count]) {
            return 40;
        } else return 10;
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([modelArray count] - [canUseModelArray count] > 0) {
        if (section == [canUseModelArray count]) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 20)];
            [label setText:@"以下优惠券不适用此订单"];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setFont:[UIFont systemFontOfSize:14]];
            [label setTextColor:[UIColor grayColor]];
            [view addSubview:label];
            return view;
        } else return nil;
        
    } else return nil;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [modelArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    couponModel *model = modelArray[indexPath.section];
    couponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"canUse" forIndexPath:indexPath];
    cell.model = model;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < [canUseModelArray count]) {
        
        couponModel *model = modelArray[indexPath.section];
        NSMutableDictionary *dicNoti =[ NSMutableDictionary dictionary ];
        [dicNoti setObject:model.conPonId forKey:@"conponid"];
        [dicNoti setObject:[NSString stringWithFormat:@"%@(%@)",model.useType,model.typeRemark] forKey:@"remark"];
        [dicNoti setObject:model.price forKey:@"price"];
        [dicNoti setObject:model.minPrice forKey:@"minPrice"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"chooseCoupon" object:nil userInfo:dicNoti];
        [self.navigationController popViewControllerAnimated:YES];
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
