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
#import "UILabel+YBAttributeTextTapAction.h"
#import "couPonParentViewController.h"
#import "couPonRulerViewController.h"
@interface canUseViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,YBAttributeTapActionDelegate>

@end

@implementation canUseViewController
{
    UITableView *canUse;
    NSMutableArray *modelArray;
    BaseDomain *getData;
    BaseDomain *postData;
    UITextField *CouponNumber;
    UITextField * CouponNumber1;
    UIView * bgNoDingView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    modelArray = [NSMutableArray array];
    getData = [BaseDomain getInstance:NO];
    postData = [BaseDomain getInstance:NO];
    [self settabTitle:@"优惠券"];
    UIButton *buttonRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [buttonRight setImage:[UIImage imageNamed:@"RuleImg"] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    
    [buttonRight addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
   
    [self getDatas];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#EDEDED"]];
    
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)rightClick
{
    couPonRulerViewController *cpRuler = [[couPonRulerViewController alloc] init];
    [self.navigationController pushViewController:cpRuler animated:YES];
}
-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"status"];
    
    [getData getData:URL_Coupon PostParams:params finish:^(BaseDomain *domain, Boolean success) {
       
        if ([self checkHttpResponseResultStatus:domain]) {
            if ([[getData.dataRoot arrayForKey:@"data"] count] == 0) {
                for (UIView *view in [self.view subviews]) {
                    [view removeFromSuperview];
                }
                [self createViewNoDD];
            }
            else
            {
            NSMutableArray *array = [NSMutableArray arrayWithArray:[domain.dataRoot arrayForKey:@"data"]];
            for (NSDictionary *dic in array) {
                couponModel *model = [[couponModel alloc] init];
                model.price = [NSString stringWithFormat:@"%.f", [[dic stringForKey:@"money"] floatValue]];
                model.useType = [dic stringForKey:@"title"];
                model.typeRemark = [dic stringForKey:@"sub_title"];
                model.imageName = @"优惠券卡片";
                model.time = [NSString stringWithFormat:@"有效期:%@至%@",[self dateToString:[dic stringForKey:@"s_time"]], [self dateToString:[dic stringForKey:@"e_time"]]];
                [modelArray addObject:model];
            }
            
            [self createTable];
            }
        }
        
    }];
}
-(void)createViewNoDD    // 创建没有订单界面
{
    UIView *view1 = [[UIView alloc] init];
    view1.userInteractionEnabled = YES;
    [self.view addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(9);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(53);
    }];
    
    UIButton *button1 = [UIButton new];
    [button1 setBackgroundColor:[UIColor blackColor]];
    [button1 setTitle:@"兑换" forState:UIControlStateNormal];
    [button1.layer setCornerRadius:3];
    [button1.layer setMasksToBounds:YES];
    
    [button1.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button1 addTarget:self action:@selector(getConpon) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view1.mas_top).offset(10);
        make.right.mas_equalTo(-12);
        make.width.mas_equalTo(94);
        make.height.mas_equalTo(33);
    }];
    CouponNumber = [[UITextField alloc] init];
    [self.view addSubview:CouponNumber];
    [CouponNumber setFont:[UIFont systemFontOfSize:16]];
    [CouponNumber setPlaceholder:@"请输入兑换码"];
    [CouponNumber setTextAlignment:NSTextAlignmentCenter];
    [CouponNumber.layer setBorderWidth:1];
    [CouponNumber setReturnKeyType:UIReturnKeyDone];
    CouponNumber.delegate = self;
    [CouponNumber.layer setBorderColor:getUIColor(Color_background).CGColor];
    [CouponNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.equalTo(button1.mas_left).offset(-7);
        make.top.equalTo(button1);
        make.height.mas_equalTo(33);
    }];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    bgNoDingView = [[UIView alloc] initWithFrame:CGRectMake(0, 54, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.view addSubview:bgNoDingView];
    
    UIImageView *NoDD = [UIImageView new];
    NoDD.userInteractionEnabled = YES;
    [bgNoDingView addSubview:NoDD];
    NoDD.sd_layout
    .centerXEqualToView(bgNoDingView)
    .topSpaceToView(bgNoDingView, 128)
    .widthIs(211)
    .heightIs(220);
    [NoDD setImage:[UIImage imageNamed:@"EmptyCoupon"]];
    
    UILabel *clickToLookOther = [UILabel new];
    clickToLookOther.font =[UIFont fontWithName:@"PingFangSC-Light" size:12];
    clickToLookOther.textColor = [UIColor colorWithHexString:@"#4F4F4F"];
    clickToLookOther.text = @"没有更多有效券了 | 查看无效券 >>";
    [clickToLookOther yb_addAttributeTapActionWithStrings:@[@"查看无效券 >>"] delegate:self];
    [bgNoDingView addSubview:clickToLookOther];
    
    [clickToLookOther mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(NoDD.mas_bottom).offset(40);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(17);
    }];
    
   
}
-(void)yb_attributeTapReturnString:(NSString *)string range:(NSRange)range index:(NSInteger)index
{
    //WCLLog(@"你点击了我");
    couPonParentViewController * coupon = [[couPonParentViewController alloc]init];
    [self.navigationController pushViewController:coupon animated:YES];
}
-(void)createTable
{
    UIView *view = [[UIView alloc] init];
    view.userInteractionEnabled = YES;
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(9);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(53);
    }];
    
    UIButton *button = [UIButton new];
    [button setBackgroundColor:[UIColor blackColor]];
    [button setTitle:@"兑换" forState:UIControlStateNormal];
    [button.layer setCornerRadius:3];
    [button.layer setMasksToBounds:YES];
    
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button addTarget:self action:@selector(getConpon) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top).offset(10);
        make.right.mas_equalTo(-12);
        make.width.mas_equalTo(94);
        make.height.mas_equalTo(33);
    }];
    CouponNumber = [[UITextField alloc] init];
    [view addSubview:CouponNumber];
    [CouponNumber setFont:[UIFont systemFontOfSize:16]];
    [CouponNumber setPlaceholder:@"请输入兑换码"];
    [CouponNumber setTextAlignment:NSTextAlignmentCenter];
    [CouponNumber.layer setBorderWidth:1];
    [CouponNumber setReturnKeyType:UIReturnKeyDone];
    CouponNumber.delegate = self;
    [CouponNumber.layer setBorderColor:getUIColor(Color_background).CGColor];
    [CouponNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.equalTo(button.mas_left).offset(-7);
        make.top.equalTo(button);
        make.height.mas_equalTo(33);
    }];
    [view setBackgroundColor:[UIColor whiteColor]];
    canUse = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    canUse.delegate = self;
    canUse.dataSource = self;
    canUse.showsVerticalScrollIndicator =NO;
    [canUse setBackgroundColor:[UIColor clearColor]];
    [canUse setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [canUse registerClass:[couponTableViewCell class] forCellReuseIdentifier:@"canUse"];
    [self.view addSubview:canUse];
    [canUse mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_bottom);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo( SCREEN_HEIGHT - 64 - 64);
    }];
}


-(void)getConpon
{
    [CouponNumber resignFirstResponder];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:CouponNumber.text forKey:@"kouling"];
    [postData postData:URL_GetCoupon PostParams:params finish:^(BaseDomain *domain, Boolean success) {
       
        if ([self checkHttpResponseResultStatus:domain]) {
            //[self reloadData];
            for (UIView *view in [self.view subviews]) {
                [view removeFromSuperview];
            }
            [self getDatas];
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
                model.imageName = @"优惠券卡片";
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
    if (section==modelArray.count-1) {
        return 37;
    }
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
    if (section == [modelArray count]-1) {
        UIButton * label1 = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-185)/2, 0, 185, 17)];
        [label1 setTitleColor:[UIColor colorWithHexString:@"#4F4F4F"] forState:UIControlStateNormal];
        label1.titleLabel.font =[UIFont fontWithName:@"PingFangSC-Light" size:12];
        [label1 setTitle:@"没有更多有效券了 | 查看无效券 >>" forState:(UIControlStateNormal)];
        [label1 addTarget:self action:@selector(sf) forControlEvents:UIControlEventTouchUpInside];
        return label1;
    }
    else
        return nil;
}
-(void)sf
{
//    WCLLog(@"你点击了我");
    couPonParentViewController * enter = [[couPonParentViewController alloc]init];
    [self.navigationController pushViewController:enter animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
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
