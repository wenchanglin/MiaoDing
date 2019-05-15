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
#import "PhotoLiangTiCell.h"
#import "LiangTiSureViewController.h"
#import "LiangTiModel.h"
#import "WaitChuLiOrderVC.h"
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
    NSMutableArray * ltArray;
    NSMutableDictionary *addressDic;
    NSMutableArray*dataArr;
    UILabel *clothesPrice;
    
    NSInteger flog;
    NSString *orderId;
    UIImageView *imageAlpha;
    NSMutableArray *payPriceAndCon;
    NSString *good_ids;
    NSInteger  ticket_num;
    NSString *couponId;
    NSString *couPonRemark;
    NSString *couponPrice;
    NSString *maxCouponPrice;
    NSString *maxPrice;
    NSString *goodName;
    BOOL ZFB;
    LiangTiModel * ltmodel;
    BOOL choose;
    BOOL canChooseCard;
    NSString *lastMoney;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [MobClick beginLogPageView:@"确认订单"];
    
    if (!model) {
        [self getDatas];
        
    }
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"确认订单"];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    postData= [BaseDomain getInstance:NO];
    ltArray = [NSMutableArray array];
    dataArr = [NSMutableArray array];
    couPonRemark = @"选择优惠券";
    [self settabTitle:@"确认订单"];
    ZFB = YES;
    choose =YES;
    _arrayForClothes = [NSMutableArray array];
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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectlt:) name:@"selectlt" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseCoupon:) name:@"chooseCoupon" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadAddress) name:@"reloadAddress" object:nil];
}
-(void)reloadAddress
{
    [dataArr removeAllObjects];
    [self getDatas];
}
-(void)reloadAddressTable:(NSNotification *)noti
{
    [dataArr removeAllObjects];
    [self getDatas];
}
-(void)selectlt:(NSNotification*)noti
{
    [ltArray removeAllObjects];
    ltmodel = [noti.userInfo objectForKey:@"model"];
    [ltArray addObject:ltmodel];
    [clothesToPay reloadData];
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
    [parms setObject:_carId forKey:@"cart_id_s"];
    [[wclNetTool sharedTools]request:GET urlString:[MoreUrlInterface URL_QueRenOrderForShoppingCarID_String] parameters:parms finished:^(id responseObject, NSError *error) {
//        WCLLog(@"%@",responseObject);
       if([self checkHttpResponseResultStatus:responseObject])
       {
           ClothesFroPay *model2 = [ClothesFroPay mj_objectWithKeyValues:responseObject[@"data"]];
           [dataArr addObject:model2];
           _arrayForClothes = [carListModel mj_objectArrayWithKeyValuesArray:model2.car_list];
           _allPrice = ((carListModel*)[_arrayForClothes firstObject]).sell_price;
           if ([[model2.lt_arr stringForKey:@"name"]length]==0) {
               ltArrModel*model4=[ltArrModel new];
               model4.name = @"";
               model4.ID=0;
               model4.height=0;
               model4.weight=0;
               [ltArray addObject:model4];
           }
           else
           {
               ltArrModel*model5 = [ltArrModel mj_objectWithKeyValues:model2.lt_arr];
               [ltArray addObject:model5];
           }
           if (model2.address_list==nil) {
               model = [AddressModel new];
               model.address = @"请添加地址";
               model.phone = @"";
               model.accept_name = @"";
               model.ID = 0;
               model.is_default = 0;
               model.noAddressPic = @"addAddress";
           } else {
               model = [AddressModel new];
               model.address = [NSString stringWithFormat:@"%@%@%@%@", [model2.address_list stringForKey:@"province"],[model2.address_list stringForKey:@"city"],[model2.address_list stringForKey:@"area"],[model2.address_list stringForKey:@"address"]];
               model.phone = [model2.address_list stringForKey:@"phone"];
               model.accept_name = [model2.address_list stringForKey:@"accept_name"];
               model.ID = [[model2.address_list stringForKey:@"id"] integerValue];
               model.is_default = [[model2.address_list stringForKey:@"is_default"] integerValue];
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
    clothesToPay = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-88-77: SCREEN_HEIGHT - 64 - 52) style:UITableViewStyleGrouped];
    clothesToPay.separatorStyle = UITableViewCellSeparatorStyleNone;
    clothesToPay.dataSource = self;
    clothesToPay.delegate = self;
    [clothesToPay registerClass:[PhotoLiangTiCell class] forCellReuseIdentifier:@"photoLiangTi"];
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
    .bottomSpaceToView(self.view,[ShiPeiIphoneXSRMax isIPhoneX]?20:0)
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
    .heightIs([ShiPeiIphoneXSRMax isIPhoneX]?72:50);
    
    UIButton *buyButton = [UIButton new];
    buyButton.qi_eventInterval=3;
    [lowView addSubview:buyButton];
    buyButton.sd_layout
    .rightEqualToView(lowView)
    .topEqualToView(lowView)
    .heightIs(50)
    .widthIs(SCREEN_WIDTH / 3);
    [buyButton addTarget:self action:@selector(DownOrderClick) forControlEvents:UIControlEventTouchUpInside];
    [buyButton setTitle:@"下单" forState:UIControlStateNormal];
    [buyButton setBackgroundColor:getUIColor(Color_myBagToPayButton)];
    [buyButton.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14]];
    
    
    
    UILabel *Heji = [UILabel new];
    [leftView addSubview:Heji];
    Heji.sd_layout.leftSpaceToView(leftView, 10).centerYEqualToView(leftView).widthIs(40).heightIs(20);
    [Heji setFont:[UIFont fontWithName:@"PingFangSC-Light" size:13]];
    [Heji setTextColor:[UIColor colorWithHexString:@"#222222"]];
    [Heji setText:@"合计:"];
    clothesPrice = [UILabel new];
    [leftView addSubview:clothesPrice];
    clothesPrice.sd_layout
    .leftSpaceToView(Heji, 3)
    .rightSpaceToView(leftView, 3)
    .topEqualToView(leftView)
    .bottomEqualToView(leftView);
    
    clothesPrice.textColor= [UIColor colorWithHexString:@"#B10909"];
    [clothesPrice setFont:[UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:16]];
    [clothesPrice setTextAlignment:NSTextAlignmentLeft];
    CGFloat prices =0.0;
    for (carListModel*carlistmodel in _arrayForClothes) {
        prices +=[carlistmodel.sell_price floatValue]*[carlistmodel.goods_num floatValue];
    }
    [clothesPrice setText:[NSString stringWithFormat:@"¥%.2f",prices]];
}
//-(void)chooseGift
//{
//    if (canChooseCard) {
//        if ([couPonRemark isEqualToString:@"选择优惠券"]) {
//            if (choose) {
//                choose = NO;
//                CGFloat price = 0;
//                if (_arrayForClothes.count==1) {
////                    _allPrice = ((ClothesFroPay*)_arrayForClothes[0]).clothesPrice;
////                    payView.price = [NSString stringWithFormat:@"%.2f", [_allPrice floatValue]* [((ClothesFroPay*)_arrayForClothes[0]).clothesCount integerValue]];
////                    [clothesPrice setText:[NSString stringWithFormat:@"¥%.2f", [_allPrice floatValue]* [((ClothesFroPay*)_arrayForClothes[0]).clothesCount integerValue]]];
////
////                    for (ClothesFroPay *clothesMo in _arrayForClothes) {
////                        price = price + ([clothesMo.clothesPrice floatValue]) * [clothesMo.clothesCount integerValue];
////                    }
//                    [payPriceAndCon[0] setObject:[NSString stringWithFormat:@"¥%.2f", price] forKey:@"detail"];
//                    [payPriceAndCon[1] setObject:@"¥0.00" forKey:@"detail"];
//                }
//                else
//                {
//                    payView.price = [NSString stringWithFormat:@"%.2f", [_allPrice floatValue]];
//                    [clothesPrice setText:[NSString stringWithFormat:@"¥%.2f", [_allPrice floatValue]]];
////                    for (ClothesFroPay *clothesMo in _arrayForClothes) {
////                        price = price + ([clothesMo.clothesPrice floatValue]) * [clothesMo.clothesCount integerValue];
////                    }
//                    [payPriceAndCon[0] setObject:[NSString stringWithFormat:@"¥%.2f", price] forKey:@"detail"];
//                    [payPriceAndCon[1] setObject:@"¥0.00" forKey:@"detail"];
//                }
//            } else {
//                choose = YES;
//                CGFloat canUseCard = 0;
//                if (_arrayForClothes.count==1) {
////                    _allPrice = ((ClothesFroPay*)_arrayForClothes[0]).clothesPrice;
////
////                    for (ClothesFroPay *clothesMo in _arrayForClothes) {
////
////                        if (clothesMo.can_use_card == 1) {
////                            canUseCard = canUseCard + [clothesMo.clothesPrice floatValue] * [clothesMo.clothesCount integerValue];
////                        }
////
////                    }
////
//                    if (canUseCard - [lastMoney floatValue] <= 0) {
////                        if (canUseCard == [_allPrice floatValue]* [((ClothesFroPay*)_arrayForClothes[0]).clothesCount integerValue]) {
////                            payView.price = @"0.01";
////                            [clothesPrice setText:@"¥0.01"];
////                        } else if(canUseCard<[_allPrice floatValue]* [((ClothesFroPay*)_arrayForClothes[0]).clothesCount integerValue]) {
////                            payView.price = [NSString stringWithFormat:@"%.2f", canUseCard-[_allPrice floatValue] ];
////                            [clothesPrice setText:[NSString stringWithFormat:@"¥%.2f",canUseCard -[_allPrice floatValue] ]];
////                        }
////                        else
////                        {
////                            payView.price = [NSString stringWithFormat:@"%.2f",[_allPrice floatValue]-canUseCard];
////                            [clothesPrice setText:[NSString stringWithFormat:@"¥%.2f",[_allPrice floatValue]-canUseCard]];
////                        }
//
//                    } else {
////                        payView.price = [NSString stringWithFormat:@"%.2f", [_allPrice floatValue]* [((ClothesFroPay*)_arrayForClothes[0]).clothesCount integerValue] - [lastMoney floatValue]];
////                        [clothesPrice setText:[NSString stringWithFormat:@"¥%.2f", [_allPrice floatValue]* [((ClothesFroPay*)_arrayForClothes[0]).clothesCount integerValue] - [lastMoney floatValue]]];
//                    }
//
//                    CGFloat price = 0;
//                    for (ClothesFroPay *clothesMo in _arrayForClothes) {
////                        price = price + ([clothesMo.clothesPrice floatValue]) * [clothesMo.clothesCount integerValue];
//                    }
//                    [payPriceAndCon[0] setObject:[NSString stringWithFormat:@"¥%.2f", price] forKey:@"detail"];
//                    if (canUseCard>=[lastMoney floatValue]) {
//                        [payPriceAndCon[1] setObject:[NSString stringWithFormat:@"-¥%.2f", [lastMoney floatValue]] forKey:@"detail"];
//
//                    }
//                    else
//                    {
//                        [payPriceAndCon[1] setObject:[NSString stringWithFormat:@"-¥%.2f", canUseCard] forKey:@"detail"];
//                    }
//                }
//                else
//                {
//                    for (ClothesFroPay *clothesMo in _arrayForClothes) {
//
////                        if (clothesMo.can_use_card == 1) {
////                            canUseCard = canUseCard + [clothesMo.clothesPrice floatValue] * [clothesMo.clothesCount integerValue];
////                        }
//
//                    }
//
//                    if (canUseCard - [lastMoney floatValue] <= 0) {
//                        if (canUseCard == [_allPrice floatValue]) {
//                            payView.price = @"0.01";
//                            [clothesPrice setText:@"¥0.01"];
//                        } else if(canUseCard<[_allPrice floatValue]) {
//                            payView.price = [NSString stringWithFormat:@"%.2f", canUseCard-[_allPrice floatValue] ];
//                            [clothesPrice setText:[NSString stringWithFormat:@"¥%.2f",canUseCard -[_allPrice floatValue] ]];
//                        }
//                        else
//                        {
//                            payView.price = [NSString stringWithFormat:@"%.2f",[_allPrice floatValue]-canUseCard];
//                            [clothesPrice setText:[NSString stringWithFormat:@"¥%.2f",[_allPrice floatValue]-canUseCard]];
//                        }
//
//                    } else {
//                        payView.price = [NSString stringWithFormat:@"%.2f", [_allPrice floatValue] - [lastMoney floatValue]];
//                        [clothesPrice setText:[NSString stringWithFormat:@"¥%.2f", [_allPrice floatValue] - [lastMoney floatValue]]];
//                    }
//
//                    CGFloat price = 0;
//                    for (ClothesFroPay *clothesMo in _arrayForClothes) {
////                        price = price + ([clothesMo.clothesPrice floatValue]) * [clothesMo.clothesCount integerValue];
//                    }
//                    [payPriceAndCon[0] setObject:[NSString stringWithFormat:@"¥%.2f", price] forKey:@"detail"];
//                    if (canUseCard>=[lastMoney floatValue]) {
//                        [payPriceAndCon[1] setObject:[NSString stringWithFormat:@"-¥%.2f", [lastMoney floatValue]] forKey:@"detail"];
//
//                    }
//                    else
//                    {
//                        [payPriceAndCon[1] setObject:[NSString stringWithFormat:@"-¥%.2f", canUseCard] forKey:@"detail"];
//                    }
//                }
//
//            }
//            [payView reloadView];
//        } else {
//            [self alertViewShowOfTime:@"礼品卡与优惠券不能同时使用哦" time:1];
//        }
//    } else {
//        [self alertViewShowOfTime:@"该商品不能使用礼品卡" time:1];
//    }
//    [clothesToPay reloadData];
//}
-(void)chooseCoupon:(NSNotification *)noti
{
    
    if ([noti.userInfo integerForKey:@"price"] == 0) {
        ticket_num = 0;
        if (_arrayForClothes.count==1) {
            carListModel*model =_arrayForClothes[0];
            _allPrice = model.sell_price;
            payView.price = [NSString stringWithFormat:@"%.2f", [_allPrice floatValue]* [model.goods_num integerValue]];
            [clothesPrice setText:[NSString stringWithFormat:@"¥%.2f", [_allPrice floatValue]* [model.goods_num integerValue]]];
        }
        else
        {
            payView.price = _allPrice;
            clothesPrice.text = [NSString stringWithFormat:@"¥%.2f",[_allPrice floatValue]];
        }
        [payPriceAndCon[1] setObject:@"-￥0.00" forKey:@"detail"];
        couponPrice = @"0.00";
        couPonRemark = @"选择优惠券";
        couponId = nil;
        
        
    } else {
        couPonRemark = [noti.userInfo stringForKey:@"remark"];
        couponId = [noti.userInfo stringForKey:@"conponid"];
        couponPrice = [noti.userInfo stringForKey:@"price"];
        ticket_num = [couponPrice integerValue];
        maxCouponPrice = [noti.userInfo stringForKey:@"maxPrice"];
        CGFloat price = 0;
        if (_arrayForClothes.count==1) {
            carListModel*model2 =_arrayForClothes[0];
            _allPrice=model2.sell_price;
            for (carListModel *clothesMo in _arrayForClothes) {
                price = price + ([clothesMo.sell_price floatValue]) * [clothesMo.goods_num integerValue];
            }
            if (([_allPrice floatValue]*[model2.goods_num integerValue]) - [couponPrice floatValue] <= 0) {
                payView.price = @"0.01";
                [clothesPrice setText:@"¥0.01"];
            } else {
                payView.price = [NSString stringWithFormat:@"%.2f", ([_allPrice floatValue]*[model2.goods_num integerValue]) - [couponPrice floatValue]];
                
                [clothesPrice setText:[NSString stringWithFormat:@"￥%.2f", ([_allPrice floatValue]*[model2.goods_num integerValue]) - [couponPrice floatValue]]];
            }
            [payPriceAndCon[0] setObject:[NSString stringWithFormat:@"￥%.2f", price] forKey:@"detail"];
            if ([couponPrice floatValue]>([_allPrice floatValue]*[model2.goods_num integerValue])) {
                [payPriceAndCon[1] setObject:[NSString stringWithFormat:@"-￥%.2f",[_allPrice floatValue]*[model2.goods_num integerValue]] forKey:@"detail"];
            }
            else
            {
                [payPriceAndCon[1] setObject:[NSString stringWithFormat:@"-￥%.2f", [couponPrice floatValue]] forKey:@"detail"];
            }
        }
        else
        {
            for (carListModel *clothesMo in _arrayForClothes) {
                price = price + ([clothesMo.sell_price floatValue]) * [clothesMo.goods_num integerValue];
            }
            if ([_allPrice floatValue]<=[couponPrice floatValue]) {
                payView.price = @"0.01";
                [clothesPrice setText:@"¥0.01"];
            } else {
                payView.price = [NSString stringWithFormat:@"%.2f", [_allPrice floatValue]- [couponPrice floatValue]];
                [clothesPrice setText:[NSString stringWithFormat:@"￥%.2f", [_allPrice floatValue] - [couponPrice floatValue]]];
            }
            [payPriceAndCon[0] setObject:[NSString stringWithFormat:@"￥%.2f", price] forKey:@"detail"];
            if ([couponPrice floatValue] > [_allPrice floatValue]) {
                [payPriceAndCon[1] setObject:[NSString stringWithFormat:@"-¥%.2f", [_allPrice floatValue]] forKey:@"detail"];
            } else {
                [payPriceAndCon[1] setObject:[NSString stringWithFormat:@"-¥%.2f", [couponPrice floatValue]] forKey:@"detail"];
            }
        }
        choose = NO;
    }
    
    [payView reloadView];
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
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger re;
    if (section == 0||section==1||section==2) {
        re = 1;
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
        x = 103;
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
    ClothesFroPay*model2 = [dataArr firstObject];
    if (indexPath.section == 0) {
        
        if (model2.address_list==nil) {
            ClothesForPayNoAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noaddress" forIndexPath:indexPath];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.model = model;
            reCell = cell;
        } else {
            OrderAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"clothesToPayAddress" forIndexPath:indexPath];
            [cell.userName setText:model.accept_name];
            [cell.userPhone setText:model.phone];
            [cell.userAddress setText:model.address];
            reCell = cell;
        }
        
        
    }
    else if (indexPath.section==1)
    {
        ltArrModel * modeles = ltArray[indexPath.row];
        PhotoLiangTiCell * cell = [tableView dequeueReusableCellWithIdentifier:@"photoLiangTi" forIndexPath:indexPath];
        cell.models =modeles;
        reCell = cell;
    }
    else if(indexPath.section == 2) {
        payConponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payConpon" forIndexPath:indexPath];
        [cell.chooseCon setText:couPonRemark];
        if ([couPonRemark isEqualToString:@"选择优惠券"]) {
            cell.yhquanImageView.image = [UIImage imageNamed:@"nocouponpic"];
            [cell.chooseCon setTextColor:[UIColor blackColor]];
        } else {
            cell.yhquanImageView.image=[UIImage imageNamed:@"choosecon"];
            cell.chooseCon.text = @"已选1张优惠券";
            [cell.chooseCon setTextColor:[UIColor blackColor]];
        }
        
        if (ticket_num==0) {
            cell.tikerNumLabel.text = @"";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

        }
        else
        {
            cell.tikerNumLabel.text = [NSString stringWithFormat:@"-¥%@",couponPrice];
            cell.accessoryType=UITableViewCellAccessoryNone;

        }
        reCell = cell;
    }
//    else if(indexPath.section==3){
//        giftCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"giftCard" forIndexPath:indexPath];
//        [cell.chooseImage setTitle:[NSString stringWithFormat:@"礼品卡余额（¥%.2f）", [lastMoney floatValue]] forState:UIControlStateNormal];
//        if (choose) {
//
//            [cell.chooseImage setImage:[UIImage imageNamed:@"giftCardChoose"] forState:UIControlStateNormal];
//        } else {
//
//            [cell.chooseImage setImage:[UIImage imageNamed:@"giftCardNoChoose"] forState:UIControlStateNormal];
//        }
//        if (canChooseCard) {
//            [cell.chooseImage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//
//
//        } else {
//            [cell.chooseImage setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//            [cell.chooseImage setImage:[UIImage imageNamed:@"addressNoChoose"] forState:UIControlStateNormal];
//
//        }
//        [cell.chooseImage addTarget:self action:@selector(chooseGift) forControlEvents:UIControlEventTouchUpInside];
//        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//        reCell = cell;
//    }
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



-(void)upClick:(UIButton *)sender
{
    carListModel *coutModel = _arrayForClothes[sender.tag - 100];
    coutModel.goods_num = [NSString stringWithFormat:@"%ld", [coutModel.goods_num integerValue] + 1];
    [self reloadAllView:sender.tag - 100];
    
    
    
}

-(void)cutClick:(UIButton *)sender
{
    
    carListModel *coutModel = _arrayForClothes[sender.tag - 1000];
    if ([coutModel.goods_num integerValue] > 1) {
        coutModel.goods_num = [NSString stringWithFormat:@"%ld", [coutModel.goods_num integerValue] - 1];
        [self reloadAllView:sender.tag - 1000];
    }
    
}

-(void)reloadAllView:(NSInteger)item
{
    
    CGFloat price = 0;
    CGFloat canUseCard = 0;
    for (carListModel *clothesMo in _arrayForClothes ) {
        price = price + ([clothesMo.sell_price floatValue]) * [clothesMo.goods_num integerValue];
    }
    if (price - [couponPrice floatValue] <= 0) {
//        payView.price = @"0.01";
        payView.price = [NSString stringWithFormat:@"%.2f",price];
    } else {
        payView.price = [NSString stringWithFormat:@"%.2f", price - [couponPrice floatValue]];
    }
    _allPrice = [NSString stringWithFormat:@"%.2f", price];
    [payPriceAndCon[0] setObject:[NSString stringWithFormat:@"￥%.2f", price] forKey:@"detail"];
    
    if ([_allPrice floatValue] < [maxCouponPrice floatValue]) {
        [payPriceAndCon[1] setObject:@"-￥0.00" forKey:@"detail"];
        ticket_num =0;
        couPonRemark = @"选择优惠券";
        couponId = nil;
        couponPrice =@"0.00";
    }
    
    if (choose) {
        if ([lastMoney floatValue] > canUseCard) {
            if (price-canUseCard<=0) {
                clothesPrice.text = @"¥0.01";
                payView.price = @"0.01";
            }
            else
            {
                [clothesPrice setText: [NSString stringWithFormat:@"¥%.2f", price - canUseCard]];
                payView.price = [NSString stringWithFormat:@"%.2f", price - canUseCard];
            }
            [payPriceAndCon[1] setObject:[NSString stringWithFormat:@"-¥%.2f",canUseCard] forKey:@"detail"];
            
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
    carListModel *clothesModel = _arrayForClothes[item];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:clothesModel.cart_id forKey:@"cart_id"];
    [params setObject:clothesModel.goods_num forKey:@"buy_num"];
    [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_ChangeCarNum_String] parameters:params finished:^(id responseObject, NSError *error) {
        WCLLog(@"%@",responseObject);
        if ([self checkHttpResponseResultStatus:responseObject]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateNum" object:nil];
        }
    }];
    
}

-(void)DownOrderClick
{
    if (model.address.length > 0) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:_carId forKey:@"cart_id_s"];
        [params setObject:@"" forKey:@"volume_id"];
        [params setObject:@(model.ID) forKey:@"address_id"];
        for (carListModel* paymodel in _arrayForClothes){
            if ([paymodel.category_id intValue]==1||[paymodel.category_id intValue]==3) {
                [params setObject:@(ltmodel.ID) forKey:@"volume_id"];
            }
            else
            {
                if (ltArray.count>0) {
                    [params setObject:@(ltmodel.ID) forKey:@"volume_id"];
                }

            }
        }
        if (couponId) {
            [params setObject:couponId forKey:@"ticket_record_id"];
        }
        [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_OrderForCar_String] parameters:params finished:^(id responseObject, NSError *error) {
            if ([self checkHttpResponseResultStatus:responseObject]) {
                WaitChuLiOrderVC*vc = [[WaitChuLiOrderVC alloc]init];
                vc.orderSnString = [responseObject stringForKey:@"order_sn"];
                [self.navigationController pushViewController:vc animated:YES];
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
        addFirst.addressid = [NSString stringWithFormat:@"%@",@(model.ID)];
        [self.navigationController pushViewController:addFirst animated:YES];
        
    }
    else if (indexPath.section==1)
    {
        LiangTiSureViewController * svc =[[LiangTiSureViewController alloc]init];
        svc.comefromwode = NO;
        [self.navigationController pushViewController:svc animated:YES];
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
                chooseConponViewController *chooseCon = [[chooseConponViewController alloc] init];
                chooseCon.carId = _carId;
                [self.navigationController pushViewController:chooseCon animated:YES];
            
            
        }
        
    }
    else if(indexPath.section==3) {
//        if (canChooseCard) {
//            saleCardViewController *sale = [[saleCardViewController alloc] init];
//            sale.ifPayContrller = YES;
//            [self.navigationController pushViewController:sale animated:YES];
//        } else {
//            [self alertViewShowOfTime:@"该产品不能使用礼品卡哦" time:1];
//        }
        
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
