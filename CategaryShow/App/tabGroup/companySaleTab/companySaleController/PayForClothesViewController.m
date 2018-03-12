//
//  PayForClothesViewController.m
//  CategaryShow
//
//  Created by APPLE on 16/10/7.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "PayForClothesViewController.h"
#import "ClothesForPayTableViewCell.h"
#import "ClothesForPayAddressTableViewCell.h"
#import "AddressModel.h"
#import "PriceForAllClothesTableViewCell.h"
#import "priceModel.h"
#import "payForView.h"
#import "ClothesFroPay.h"
#import "addressSetFirstViewViewController.h"
#import "ChangeAddressViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ToBuyCompanyClothes(SecondPlan)ViewController.h"
#import "perentOrderViewController.h"
#import "WXApi.h"
#import "ClothesForPayNoAddressTableViewCell.h"
#import "BuyDesignerClothesViewController.h"
#import "myClothesBagViewController.h"
#import "payConponTableViewCell.h"
#import "paySectionThreeTableViewCell.h"
#import "chooseConponViewController.h"
#import "OrderAddressTableViewCell.h"
#import "DiyClothesDetailViewController.h"
#import "DesignerClothesDetailViewController.h"
#import "giftCardTableViewCell.h"
#import "saleCardViewController.h"
@interface PayForClothesViewController ()<UITableViewDataSource, UITableViewDelegate,payForViewDelegate>

@end

@implementation PayForClothesViewController
{
    UITableView *clothesToPay;
    AddressModel *model;
    NSMutableArray *priceArray;
    payForView *payView;
    BaseDomain *getData;
    BaseDomain *postData;
    NSMutableDictionary *addressDic;
    UILabel *clothesPrice;
    NSInteger flog;
    NSString *orderId;
    UIImageView *imageAlpha;
    NSMutableArray *payPriceAndCon;
    NSString *good_ids;
    
    NSString *couponId;
    NSString *couPonRemark;
    NSString *couponPrice;
    NSString *minCouponPrice;
    NSString *maxPrice;
    NSString *goodName;
    BOOL ZFB;
    
    BOOL choose;
    BOOL canChooseCard;
    NSString *lastMoney;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    getData = [BaseDomain getInstance:NO];
    
    
    if (!model) {
        [self getDatas];
    }
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    postData= [BaseDomain getInstance:NO];
    couPonRemark = @"选择优惠券";
    [self settabTitle:@"确认订单"];
    ZFB = YES;
    choose =YES;
    payPriceAndCon = [NSMutableArray array];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"商品合计" forKey:@"title"];
    [dic setObject:[NSString stringWithFormat:@"￥%@", _allPrice] forKey:@"detail"];
    
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    [dic1 setObject:@"优惠" forKey:@"title"];
    [dic1 setObject:@"-￥0.00" forKey:@"detail"];
    [payPriceAndCon addObject:dic];
    [payPriceAndCon addObject:dic1];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadAddress) name:@"deleteAddress" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadAddressTable:) name:@"AddressChange" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardSuccessAction:) name:@"cardSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccessAction) name:@"PaySuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFlaseAction) name:@"PayFlase" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseCoupon:) name:@"chooseCoupon" object:nil];
    
}
-(void)reloadAddress
{
     [self getDatas];
}
-(void)reloadAddressTable:(NSNotification *)noti
{
    
    //
//    if ([[addressDic stringForKey:@"address"] isEqualToString:@""]) {
//        [self getDatas];
//    } else {
        model = [noti.userInfo objectForKey:@"model"];
        [addressDic setObject:model.detaiArea forKey:@"address"];
        [addressDic setObject:model.city forKey:@"city"];
        [addressDic setObject:model.area forKey:@"area"];
        [addressDic setObject:model.province forKey:@"province"];
        [clothesToPay reloadData];
   // }
    
    
    
}

-(void)payFlaseAction
{
    DiyClothesDetailViewController *toBuy = [[DiyClothesDetailViewController alloc] init];
    
    DesignerClothesDetailViewController *buyDesigner = [[DesignerClothesDetailViewController alloc] init];
    
    myClothesBagViewController *bag = [[myClothesBagViewController alloc] init];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_dateId) {
        [params setObject:_dateId forKey:@"id"];
        [params setObject:good_ids forKey:@"goods_id"];
        [params setObject:goodName forKey:@"goods_name"];
        [params setObject:@"1" forKey:@"click_dingzhi"];
        [params setObject:@"1" forKey:@"click_pay"];
        [self getDateDingZhi:params beginDate:_dingDate ifDing:YES];
    }
    
    
    
    UIViewController *target = nil;
    for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
        if ([controller isKindOfClass:[toBuy class]] || [controller isKindOfClass:[buyDesigner class]]||[controller isKindOfClass:[bag class]]) { //这里判断是否为你想要跳转的页面
            target = controller;
        }
    }
    if (target) {
        [self.navigationController popToViewController:target animated:NO]; //跳转
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"realToOrder" object:nil];
}

-(void)chooseCoupon:(NSNotification *)noti
{
    if ([[noti.userInfo stringForKey:@"price"] integerValue] == 0) {
        payView.price = _allPrice;
        [clothesPrice setText:_allPrice];
        [payPriceAndCon[1] setObject:@"-￥0.00" forKey:@"detail"];
        couponPrice = @"0.00";
        couPonRemark = @"选择优惠券";
        couponId = nil;
        
        
    } else {
        couPonRemark = [noti.userInfo stringForKey:@"remark"];
        couponId = [noti.userInfo stringForKey:@"conponid"];
        couponPrice = [noti.userInfo stringForKey:@"price"];
        minCouponPrice = [noti.userInfo stringForKey:@"minPrice"];
        CGFloat price = 0;
        for (ClothesFroPay *clothesMo in _arrayForClothes) {
            price = price + ([clothesMo.clothesPrice floatValue]) * [clothesMo.clothesCount integerValue];
        }
        if ([_allPrice floatValue] - [couponPrice floatValue] <= 0) {
            payView.price = @"0.01";
            [clothesPrice setText:@"¥0.01"];
        } else {
            payView.price = [NSString stringWithFormat:@"%.2f", [_allPrice floatValue] - [couponPrice floatValue]];
            [clothesPrice setText:[NSString stringWithFormat:@"￥%.2f", [_allPrice floatValue] - [couponPrice floatValue]]];
        }
        [payPriceAndCon[0] setObject:[NSString stringWithFormat:@"￥%.2f", price] forKey:@"detail"];
        [payPriceAndCon[1] setObject:[NSString stringWithFormat:@"-￥%.2f", [couponPrice floatValue]] forKey:@"detail"];
        choose = NO;
    }
    
    [payView reloadView];
    [clothesToPay reloadData];
    
    
}



-(void)paySuccessAction
{
    DiyClothesDetailViewController *toBuy = [[DiyClothesDetailViewController alloc] init];
    DesignerClothesDetailViewController *buyDesigner = [[DesignerClothesDetailViewController alloc] init];
    myClothesBagViewController *bag = [[myClothesBagViewController alloc] init];
    UIViewController *target = nil;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_dateId) {
        [params setObject:_dateId forKey:@"id"];
        [params setObject:good_ids forKey:@"goods_id"];
        [params setObject:goodName forKey:@"goods_name"];
        [params setObject:@"1" forKey:@"click_dingzhi"];
        [params setObject:@"2" forKey:@"click_pay"];
        [self getDateDingZhi:params beginDate:_dingDate ifDing:YES];
    }
    
    
    
    for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
        if ([controller isKindOfClass:[toBuy class]] || [controller isKindOfClass:[buyDesigner class]]||[controller isKindOfClass:[bag class]]) { //这里判断是否为你想要跳转的页面
            target = controller;
        }
    }
    if (target) {
        [self.navigationController popToViewController:target animated:NO]; //跳转
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"turnToOrder" object:nil];
    
}

-(void)getDatas
{
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms setObject:_carId forKey:@"car_ids"];
    
    [getData getData:URL_GetColthesAndAddress PostParams:parms finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            
            [_arrayForClothes removeAllObjects];
            
            
            addressDic = [NSMutableDictionary dictionaryWithDictionary: [[domain.dataRoot objectForKey:@"data"] dictionaryForKey:@"address_list"]];
            lastMoney = [[domain.dataRoot dictionaryForKey:@"data"] stringForKey:@"gift_card"];
            
            for (NSDictionary *dic in [[domain.dataRoot dictionaryForKey:@"data"] arrayForKey:@"car_list"]) {
                ClothesFroPay *model = [ClothesFroPay new];
                model.clothesImage = [dic stringForKey:@"goods_thumb"];
                model.clotheType = [dic stringForKey:@"goods_type"];
                model.can_use_card = [dic integerForKey:@"can_use_card"];
                model.clothesCount = [dic stringForKey:@"num"];
                model.clothesName = [dic stringForKey:@"goods_name"];
                model.clothesPrice = [dic stringForKey:@"price"];
                model.carId = [dic stringForKey:@"id"];
                model.sizeContent = [dic stringForKey:@"size_content"];
                model.clotheMaxCount = @"100";
                [_arrayForClothes addObject:model];
            }
            
            
            if ([[domain.dataRoot dictionaryForKey:@"data"] integerForKey:@"card_userable"] == 1) {
                choose = YES;
                canChooseCard = YES;
                
                
            } else {
                choose = NO;
                canChooseCard = NO;
            }
            
            if ([[addressDic stringForKey:@"address"] isEqualToString:@""]) {
                
                model = [AddressModel new];
                model.userAddress = @"您还没有收货地址，点击添加";
                model.userPhone = @"";
                model.userName = @"";
                model.addressId = @"";
                model.addressDefault = @"0";
                
                
            } else {
                model = [AddressModel new];
                model.userAddress = [NSString stringWithFormat:@"%@%@%@%@", [addressDic stringForKey:@"province"],[addressDic stringForKey:@"city"],[addressDic stringForKey:@"area"],[addressDic stringForKey:@"address"]];
                model.userPhone = [addressDic stringForKey:@"phone"];
                model.userName = [addressDic stringForKey:@"name"];
                model.addressId = [addressDic stringForKey:@"id"];
                model.addressDefault = [addressDic stringForKey:@"is_default"];
                
                
                
            }
            
            
            for (NSDictionary *dic in [[domain.dataRoot objectForKey:@"data"] arrayForKey:@"car_list"]) {
                if (!good_ids) {
                    good_ids = [dic stringForKey:@"goods_id"];
                    
                    goodName = [dic stringForKey:@"goods_name"];
                    
                } else {
                    good_ids = [NSString stringWithFormat:@"%@,%@",good_ids,[dic stringForKey:@"good_id"]];
                }
                
                
            }
            
            if (clothesToPay) {
                [clothesToPay reloadData];
            } else {
                [self createTableView];
                [self createPayView];
            }
            
        }
    }];
}

-(void)createTableView
{
    if (@available(iOS 11.0, *)) {
        clothesToPay.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    clothesToPay = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 42) style:UITableViewStyleGrouped];
    clothesToPay.separatorStyle = UITableViewCellSeparatorStyleNone;
    clothesToPay.dataSource = self;
    clothesToPay.delegate = self;
    [clothesToPay registerClass:[OrderAddressTableViewCell class] forCellReuseIdentifier:@"clothesToPayAddress"];
    [clothesToPay registerClass:[ClothesForPayTableViewCell class] forCellReuseIdentifier:@"clothesList"];
    [clothesToPay registerClass:[giftCardTableViewCell class] forCellReuseIdentifier:@"giftCard"];
    [clothesToPay registerClass:[ClothesForPayNoAddressTableViewCell class] forCellReuseIdentifier:@"noaddress"];
    [clothesToPay registerClass:[payConponTableViewCell class] forCellReuseIdentifier:@"payConpon"];
    [clothesToPay registerClass:[paySectionThreeTableViewCell class] forCellReuseIdentifier:@"payThree"];
    [self.view addSubview:clothesToPay];
    
    UIView *lowView = [UIView new];
    [self.view addSubview:lowView];
    lowView.sd_layout
    .leftEqualToView(self.view)
    .bottomEqualToView(self.view)
    .heightIs(50)
    .rightEqualToView(self.view);
    [lowView setBackgroundColor:[UIColor whiteColor]];
    
    UIView *lineView = [UIView new];
    [lowView addSubview:lineView];
    lineView.sd_layout
    .leftEqualToView(lineView)
    .rightEqualToView(lineView)
    .topEqualToView(lineView)
    .heightIs(1);
    [lineView setBackgroundColor:getUIColor(Color_myOrderLine)];
    
    
    UIView *leftView = [UILabel new];
    [lowView addSubview:leftView];
    leftView.sd_layout
    .leftEqualToView(lowView)
    .centerYEqualToView(lowView)
    .widthIs(SCREEN_WIDTH / 3 * 2)
    .heightIs(50);
    
    UIButton *buyButton = [UIButton new];
    [lowView addSubview:buyButton];
    buyButton.sd_layout
    .rightEqualToView(lowView)
    .topEqualToView(lowView)
    .bottomEqualToView(lowView)
    .widthIs(SCREEN_WIDTH / 3);
    [buyButton addTarget:self action:@selector(DownOrderClick) forControlEvents:UIControlEventTouchUpInside];
    [buyButton setTitle:@"付款" forState:UIControlStateNormal];
    [buyButton setBackgroundColor:getUIColor(Color_myBagToPayButton)];
    [buyButton.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14]];
    
    
    clothesPrice = [UILabel new];
    [leftView addSubview:clothesPrice];
    
    [clothesPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(buyButton.mas_left).offset(-10);
        make.centerY.equalTo(lowView.mas_centerY);
    }];
    
    clothesPrice.textColor= [UIColor colorWithHexString:@"#222222"];
    [clothesPrice setFont:[UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:16]];
    [clothesPrice setTextAlignment:NSTextAlignmentLeft];
    [clothesPrice setText:[NSString stringWithFormat:@"¥%.2f", [_allPrice floatValue]]];
    UILabel *Heji = [UILabel new];
    [leftView addSubview:Heji];
    [Heji mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(clothesPrice.mas_left);
        make.centerY.equalTo(lowView.mas_centerY);
    }];
    [Heji setFont:[UIFont fontWithName:@"PingFangSC-Light" size:13]];
    [Heji setTextColor:[UIColor colorWithHexString:@"#222222"]];
    [Heji setText:@"合计:"];
    
}

-(void)cardSuccessAction:(NSNotification *)noti
{
    lastMoney = [noti.userInfo stringForKey:@"gift_card"];
    CGFloat canUseCard = 0;
    for (ClothesFroPay *clothesMo in _arrayForClothes) {
        
        if (clothesMo.can_use_card == 1) {
            canUseCard = canUseCard + [clothesMo.clothesPrice floatValue] * [clothesMo.clothesCount integerValue];
        }
        
    }
    
    if (canUseCard - [lastMoney floatValue] <= 0) {
        
        if (canUseCard - [_allPrice floatValue] == 0) {
            payView.price = @"¥0.01";
            [clothesPrice setText:@"¥0.01"];
        } else {
            payView.price = [NSString stringWithFormat:@"%.2f", [_allPrice floatValue] - canUseCard ];
            [clothesPrice setText:[NSString stringWithFormat:@"¥%.2f", [_allPrice floatValue] - canUseCard ]];
        }
        
        
    } else {
        payView.price = [NSString stringWithFormat:@"%.2f", [_allPrice floatValue] - [lastMoney floatValue]];
        [clothesPrice setText:[NSString stringWithFormat:@"¥%.2f", [_allPrice floatValue] - [lastMoney floatValue]]];
    }
    
    CGFloat price = 0;
    for (ClothesFroPay *clothesMo in _arrayForClothes) {
        price = price + ([clothesMo.clothesPrice floatValue]) * [clothesMo.clothesCount integerValue];
    }
    [payPriceAndCon[0] setObject:[NSString stringWithFormat:@"¥%.2f", price] forKey:@"detail"];
    if (canUseCard > [lastMoney floatValue]) {
        [payPriceAndCon[1] setObject:[NSString stringWithFormat:@"-¥%.2f", [lastMoney floatValue]] forKey:@"detail"];
    } else {
        [payPriceAndCon[1] setObject:[NSString stringWithFormat:@"-¥%.2f", canUseCard] forKey:@"detail"];
    }
    [clothesToPay reloadData];
}


-(void)createPayView
{
    
    imageAlpha = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [imageAlpha setImage:[UIImage imageNamed:@"BGALPHA"]];
    [imageAlpha setAlpha:0];
    [self.view addSubview:imageAlpha];
    
    payView = [payForView new];
    payView.price = _allPrice;
    [payView setAlpha:0];
    [self.view addSubview:payView];
    payView.delegate = self;
    payView.sd_layout
    .leftEqualToView(self.view)
    .bottomEqualToView(self.view)
    .widthIs(SCREEN_WIDTH)
    .heightIs(526 / 2);
    
    if (canChooseCard) {
        CGFloat canUseCard = 0;
        for (ClothesFroPay *clothesMo in _arrayForClothes) {
            
            if (clothesMo.can_use_card == 1) {
                canUseCard = canUseCard + [clothesMo.clothesPrice floatValue] * [clothesMo.clothesCount integerValue];
            }
            
        }
        
        if (canUseCard - [lastMoney floatValue] <= 0) {
            
            if (canUseCard - [_allPrice floatValue] == 0) {
                payView.price = @"¥0.01";
                [clothesPrice setText:@"¥0.01"];
            } else {
                payView.price = [NSString stringWithFormat:@"%.2f", [_allPrice floatValue] - canUseCard ];
                [clothesPrice setText:[NSString stringWithFormat:@"¥%.2f", [_allPrice floatValue] - canUseCard ]];
            }
            
            
        } else {
            payView.price = [NSString stringWithFormat:@"%.2f", [_allPrice floatValue] - [lastMoney floatValue]];
            [clothesPrice setText:[NSString stringWithFormat:@"¥%.2f", [_allPrice floatValue] - [lastMoney floatValue]]];
        }
        
        CGFloat price = 0;
        for (ClothesFroPay *clothesMo in _arrayForClothes) {
            price = price + ([clothesMo.clothesPrice floatValue]) * [clothesMo.clothesCount integerValue];
        }
        [payPriceAndCon[0] setObject:[NSString stringWithFormat:@"¥%.2f", price] forKey:@"detail"];
        if (canUseCard > [lastMoney floatValue]) {
            [payPriceAndCon[1] setObject:[NSString stringWithFormat:@"-¥%.2f", [lastMoney floatValue]] forKey:@"detail"];
        } else {
            [payPriceAndCon[1] setObject:[NSString stringWithFormat:@"-¥%.2f", canUseCard] forKey:@"detail"];
        }
        
    }
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger re;
    if (section == 0) {
        re = 1;
    }else if (section == 1) {
        re = 1;
    }
    else if (section==2)
    {
        re =1;
    }
    else if(section == 3) {
        re = [_arrayForClothes count];
    } else {
        re = 2;
    }
    return re;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat x;
    if (indexPath.section == 0) {
        
        if ([[addressDic stringForKey:@"address"] isEqualToString:@""]) {
            x = 53;
        } else {
            x = 83;
        }
    }else if (indexPath.section == 1) {
        x = 53;
    } else if(indexPath.section == 2) {
        x = 53;
    }
    else if (indexPath.section==3)
    {
        x=99;
    }
    else {
        x = 44;
    }
    
    return x;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==4) {
        return 3;
    }
    return 9;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *reCell;
    
    if (indexPath.section == 0) {
        
        if ([[addressDic stringForKey:@"address"] isEqualToString:@""]) {
            ClothesForPayNoAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noaddress" forIndexPath:indexPath];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.model = model;
            reCell = cell;
        } else {
            OrderAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"clothesToPayAddress" forIndexPath:indexPath];
            [cell.userName setText:model.userName];
            [cell.userPhone setText:model.userPhone];
            [cell.userAddress setText:model.userAddress];
            reCell = cell;
        }
        
        
    } else if(indexPath.section == 1) {
        payConponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payConpon" forIndexPath:indexPath];
        [cell.chooseCon setText:couPonRemark];
        if ([couPonRemark isEqualToString:@"选择优惠券"]) {
            [cell.chooseCon setTextColor:[UIColor blackColor]];
            
        } else {
            [cell.chooseCon setTextColor:[UIColor redColor]];
        }
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        reCell = cell;
    }
    else if(indexPath.section==2){
        giftCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"giftCard" forIndexPath:indexPath];
        [cell.lastMoney setText:[NSString stringWithFormat:@"礼品卡余额（¥%.2f）", [lastMoney floatValue]]];
        if (choose) {
            
            
            [cell.chooseImage setImage:[UIImage imageNamed:@"giftCardChoose"] forState:UIControlStateNormal];
        } else {
            
            [cell.chooseImage setImage:[UIImage imageNamed:@"giftCardNoChoose"] forState:UIControlStateNormal];
        }
        if (canChooseCard) {
            [cell.lastMoney setTextColor:[UIColor blackColor]];
            
            
        } else {
            [cell.lastMoney setTextColor:[UIColor lightGrayColor]];
            [cell.chooseImage setImage:[UIImage imageNamed:@"addressNoChoose"] forState:UIControlStateNormal];
            
        }
        [cell.chooseImage addTarget:self action:@selector(chooseGift) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        reCell = cell;
    }
    else if(indexPath.section == 3) {
        ClothesForPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"clothesList" forIndexPath:indexPath];
        cell.model = [_arrayForClothes objectAtIndex:indexPath.row];
        [cell.upButton addTarget:self action:@selector(upClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.upButton setTag:100 + indexPath.row];
        [cell.cutButton addTarget:self action:@selector(cutClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.cutButton setTag:1000 + indexPath.row];
        reCell = cell;
    } else {
        paySectionThreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payThree" forIndexPath:indexPath];
        [cell.titlePay setText:[payPriceAndCon[indexPath.row] stringForKey:@"title"]];
        [cell.detailPay setText:[payPriceAndCon[indexPath.row] stringForKey:@"detail"]];
        reCell = cell;
    }
    [reCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return reCell;
}

-(void)chooseGift
{
    if (canChooseCard) {
        if ([couPonRemark isEqualToString:@"选择优惠券"]) {
            if (choose) {
                choose = NO;
                
                payView.price = [NSString stringWithFormat:@"%.2f", [_allPrice floatValue]];
                [clothesPrice setText:[NSString stringWithFormat:@"¥%.2f", [_allPrice floatValue]]];
                CGFloat price = 0;
                for (ClothesFroPay *clothesMo in _arrayForClothes) {
                    price = price + ([clothesMo.clothesPrice floatValue]) * [clothesMo.clothesCount integerValue];
                }
                [payPriceAndCon[0] setObject:[NSString stringWithFormat:@"¥%.2f", price] forKey:@"detail"];
                [payPriceAndCon[1] setObject:@"¥0.00" forKey:@"detail"];
            } else {
                choose = YES;
                
                CGFloat canUseCard = 0;
                for (ClothesFroPay *clothesMo in _arrayForClothes) {
                    
                    if (clothesMo.can_use_card == 1) {
                        canUseCard = canUseCard + [clothesMo.clothesPrice floatValue] * [clothesMo.clothesCount integerValue];
                    }
                    
                }
                
                if (canUseCard - [lastMoney floatValue] <= 0) {
                    
                    if (canUseCard == [_allPrice floatValue]) {
                        payView.price = @"¥0.01";
                        [clothesPrice setText:@"¥0.01"];
                    } else {
                        payView.price = [NSString stringWithFormat:@"%.2f", [_allPrice floatValue] - canUseCard ];
                        [clothesPrice setText:[NSString stringWithFormat:@"¥%.2f", [_allPrice floatValue] - canUseCard ]];
                    }
                    
                    
                } else {
                    payView.price = [NSString stringWithFormat:@"%.2f", [_allPrice floatValue] - [lastMoney floatValue]];
                    [clothesPrice setText:[NSString stringWithFormat:@"¥%.2f", [_allPrice floatValue] - [lastMoney floatValue]]];
                }
                
                CGFloat price = 0;
                for (ClothesFroPay *clothesMo in _arrayForClothes) {
                    price = price + ([clothesMo.clothesPrice floatValue]) * [clothesMo.clothesCount integerValue];
                }
                [payPriceAndCon[0] setObject:[NSString stringWithFormat:@"¥%.2f", price] forKey:@"detail"];
                [payPriceAndCon[1] setObject:[NSString stringWithFormat:@"-¥%.2f", canUseCard] forKey:@"detail"];
                
                
            }
            [payView reloadView];
        } else {
            [self alertViewShowOfTime:@"礼品卡与优惠券不能同时使用哦" time:1];
        }
    } else {
        [self alertViewShowOfTime:@"该商品不能使用礼品卡" time:1];
    }
    
    
    
    
    
    [clothesToPay reloadData];
}

-(void)upClick:(UIButton *)sender
{
    ClothesFroPay *coutModel = _arrayForClothes[sender.tag - 100];
    
    
    coutModel.clothesCount = [NSString stringWithFormat:@"%ld", [coutModel.clothesCount integerValue] + 1];
    [self reloadAllView:sender.tag - 100];
    
    
    
}

-(void)cutClick:(UIButton *)sender
{
    
    ClothesFroPay *coutModel = _arrayForClothes[sender.tag - 1000];
    if ([coutModel.clothesCount integerValue] > 1) {
        coutModel.clothesCount = [NSString stringWithFormat:@"%ld", [coutModel.clothesCount integerValue] - 1];
        [self reloadAllView:sender.tag - 1000];
    }
    
}

-(void)reloadAllView:(NSInteger)item
{
    
    CGFloat price = 0;
    CGFloat canUseCard = 0;
    for (ClothesFroPay *clothesMo in _arrayForClothes) {
        price = price + ([clothesMo.clothesPrice floatValue]) * [clothesMo.clothesCount integerValue];
        if (clothesMo.can_use_card == 1) {
            canUseCard = canUseCard + [clothesMo.clothesPrice floatValue] * [clothesMo.clothesCount integerValue];
        }
        
    }
    if (price - [couponPrice floatValue] <= 0) {
        payView.price = @"0.01";
    } else {
        payView.price = [NSString stringWithFormat:@"%.2f", price - [couponPrice floatValue]];
    }
    
    
    
    _allPrice = [NSString stringWithFormat:@"%.2f", price];
    
    
    [payPriceAndCon[0] setObject:[NSString stringWithFormat:@"￥%.2f", price] forKey:@"detail"];
    
    if ([_allPrice floatValue] < [minCouponPrice floatValue]) {
        [payPriceAndCon[1] setObject:@"-￥0.00" forKey:@"detail"];
        couponPrice = @"0.00";
        couPonRemark = @"选择优惠券";
        couponId = nil;
    }
    
    if (choose) {
        if ([lastMoney floatValue] > canUseCard) {
            [clothesPrice setText: [NSString stringWithFormat:@"¥%.2f", price - canUseCard]];
            [payPriceAndCon[1] setObject:[NSString stringWithFormat:@"-¥%.2f",canUseCard] forKey:@"detail"];
            payView.price = [NSString stringWithFormat:@"%.2f", price - canUseCard];
        } else {
            [clothesPrice setText: [NSString stringWithFormat:@"¥%.2f", price - [lastMoney floatValue]]];
            [payPriceAndCon[1] setObject:[NSString stringWithFormat:@"-¥%.2f",[lastMoney floatValue]] forKey:@"detail"];
            payView.price = [NSString stringWithFormat:@"%.2f", price - [lastMoney floatValue]];
        }
        
    } else {
        if (price - [couponPrice floatValue] < 0) {
            [clothesPrice setText: @"¥0.01"];
        } else {
            [clothesPrice setText:[NSString stringWithFormat:@"¥%.2f", price - [couponPrice floatValue]]];
        }
    }
    [payView reloadView];
    [clothesToPay reloadData];
    
    ClothesFroPay *clothesCount = _arrayForClothes[item];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:clothesCount.carId forKey:@"car_id"];
    [params setObject:clothesCount.clothesCount forKey:@"num"];
    [postData postData:URL_UpdateClothesCarNum PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
    }];
    
}

-(void)DownOrderClick
{
    if ([[addressDic allValues] count] > 0) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:_carId forKey:@"car_ids"];
        [params setObject:[addressDic stringForKey:@"name"] forKey:@"name"];
        [params setObject:[addressDic stringForKey:@"phone"] forKey:@"phone"];
        [params setObject:[addressDic stringForKey:@"province"] forKey:@"province"];
        [params setObject:[addressDic stringForKey:@"city"] forKey:@"city"];
        [params setObject:[addressDic stringForKey:@"area"] forKey:@"area"];
        [params setObject:[addressDic stringForKey:@"address"] forKey:@"address"];
        [params setObject:[addressDic stringForKey:@"id"] forKey:@"address_id"];
        if (couponId) {
            [params setObject:couponId forKey:@"ticket_id"];
        }
        if (choose) {
            [params setObject:@"1" forKey:@"reduce_card"];
        } else {
            [params setObject:@"0" forKey:@"reduce_card"];
        }
        [postData postData:URL_CreateOrder PostParams:params finish:^(BaseDomain *domain, Boolean success) {
            
            if (domain.result == 1 || domain.result == -3) {
                if (domain.result == 1) {
                    orderId = [[domain.dataRoot objectForKey:@"data"] stringForKey:@"order_id"];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"downOrderSuccess" object:nil];
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.5];
                [payView setAlpha:1];
                [imageAlpha setAlpha:1];
                [UIView commitAnimations];
                
            }
            
        }];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有输入地址" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"马上添加", nil];
        [alert show];
    }
    
    
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        ChangeAddressViewController *addFirst = [[ChangeAddressViewController alloc] init];
        [self.navigationController pushViewController:addFirst animated:YES];
    }
}

-(void)cancelClick
{
    DiyClothesDetailViewController *toBuy = [[DiyClothesDetailViewController alloc] init];
    
    DesignerClothesDetailViewController *buyDesigner = [[DesignerClothesDetailViewController alloc] init];
    
    myClothesBagViewController *bag = [[myClothesBagViewController alloc] init];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_dateId) {
        [params setObject:_dateId forKey:@"id"];
        [params setObject:good_ids forKey:@"goods_id"];
        [params setObject:goodName forKey:@"goods_name"];
        [params setObject:@"1" forKey:@"click_dingzhi"];
        [params setObject:@"0" forKey:@"click_pay"];
        [self getDateDingZhi:params beginDate:_dingDate ifDing:YES];
    }
    
    
    
    UIViewController *target = nil;
    for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
        if ([controller isKindOfClass:[toBuy class]] || [controller isKindOfClass:[buyDesigner class]]||[controller isKindOfClass:[bag class]]) { //这里判断是否为你想要跳转的页面
            target = controller;
            break;
        }
    }
    if (target) {
        [self.navigationController popToViewController:target animated:NO]; //跳转
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"realToOrder" object:nil];
    
}

-(void)payClick
{
    if (ZFB) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:orderId forKey:@"order_id"];
        [params setObject:@"1" forKey:@"pay_type"];
        if (choose) {
            [params setObject:@"1" forKey:@"reduce_card"];
        } else {
            [params setObject:@"0" forKey:@"reduce_card"];
        }
        NSString *appScheme = @"CloudFactory";
        [postData postData:URL_APAY PostParams:params finish:^(BaseDomain *domain, Boolean success) {
            if ([domain.dataRoot integerForKey:@"code"] == 1) {
                NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
                [userd setObject:[domain.dataRoot stringForKey:@"pay_code"] forKey:@"payId"];
                [[AlipaySDK defaultService] payOrder:[domain.dataRoot stringForKey:@"data"] fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);
                }];
            }
            
            
        }];
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:orderId forKey:@"order_id"];
        [params setObject:@"2" forKey:@"pay_type"];
        if (choose) {
            [params setObject:@"1" forKey:@"reduce_card"];
        } else {
            [params setObject:@"0" forKey:@"reduce_card"];
        }
        [postData postData:URL_WXPAY PostParams:params finish:^(BaseDomain *domain, Boolean success) {
            if ([self checkHttpResponseResultStatus:domain]) {
                
                NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
                [userd setObject:[domain.dataRoot stringForKey:@"pay_code"] forKey:@"payId"];
                NSDictionary *dic = [domain.dataRoot objectForKey:@"data"];
                PayReq *request = [[PayReq alloc] init] ;
                request.partnerId = [dic stringForKey:@"partnerid"];
                request.prepayId= [dic stringForKey:@"prepayid"];
                request.package = @"Sign=WXPay";
                request.nonceStr= [dic stringForKey:@"noncestr"];
                request.timeStamp= [[dic objectForKey:@"timestamp"] intValue];
                request.sign= [dic stringForKey:@"sign"];
                [WXApi sendReq:request];
            }
        }];
    }
}

-(void)clickItem:(NSInteger)item
{
    switch (item) {
        case 0:
            ZFB = YES;
            break;
        case 1:
            ZFB = NO;
            break;
        default:
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ChangeAddressViewController *addFirst = [[ChangeAddressViewController alloc] init];
        [self.navigationController pushViewController:addFirst animated:YES];
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            if (choose) {
                [self alertViewShowOfTime:@"礼品卡与优惠券不能同时使用哦" time:1];
            } else {
                chooseConponViewController *chooseCon = [[chooseConponViewController alloc] init];
                chooseCon.good_ids = good_ids;
                chooseCon.carId = _carId;
                NSMutableArray *array = [NSMutableArray array];
                for (ClothesFroPay *modelClothes in _arrayForClothes) {
                    [array addObject:[NSString stringWithFormat:@"%.2f",[modelClothes.clothesPrice floatValue] * [modelClothes.clothesCount floatValue]]];
                }
                CGFloat maxValue = [[array valueForKeyPath:@"@max.floatValue"] floatValue];
                chooseCon.maxPrice = [NSString stringWithFormat:@"%.2f", maxValue];
                [self.navigationController pushViewController:chooseCon animated:YES];
            }
            
        } else {
            if (canChooseCard) {
                saleCardViewController *sale = [[saleCardViewController alloc] init];
                sale.ifPayContrller = YES;
                [self.navigationController pushViewController:sale animated:YES];
            } else {
                [self alertViewShowOfTime:@"该产品不能使用礼品卡哦" time:1];
            }
            
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
