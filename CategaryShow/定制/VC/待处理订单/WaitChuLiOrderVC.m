//
//  WaitChuLiOrderVC.m
//  CategaryShow
//
//  Created by 文长林 on 2019/1/16.
//  Copyright © 2019年 Mr.huang. All rights reserved.
//

#import "WaitChuLiOrderVC.h"
#import "DiyHeadCell.h"
#import "waitChuLiModel.h"
#import "waitChuLiDetailCell.h"
#import "orderUseGiftCardCell.h"
#import "giftCardExchangeView.h"
#import "payForView.h"
#import "PayResultViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "paySuccessViewController.h"
@interface WaitChuLiOrderVC ()<UITableViewDelegate,UITableViewDataSource,OrderUseAndExchangeGiftCardAndToPayDelegate,payForViewDelegate>
@property(nonatomic,strong)UITableView*waitChuLiTableView;
@property(nonatomic,strong)NSMutableArray*modelArr;
@property(nonatomic,strong)NSString*giftcard_money;
@property(nonatomic,assign)CGFloat lastPayMoney;
@property(nonatomic,strong)payForView *payView;
@property(nonatomic,assign) BOOL useGiftCard;
@end

@implementation WaitChuLiOrderVC
{
    BOOL ZFB;
    UIButton*rightBarBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self settabTitle:@"待处理订单"];
    _modelArr = [NSMutableArray array];
    rightBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightBarBtn setTitle:@"刷新" forState:UIControlStateNormal];
    [rightBarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBarBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
    [rightBarBtn addTarget:self action:@selector(getDatas) forControlEvents:UIControlEventTouchUpInside];
    self.useGiftCard = NO;
    ZFB=YES;
    [self getDatas];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)getDatas{
    NSMutableDictionary*parmse = [NSMutableDictionary dictionary];
    parmse[@"order_sn_s"] = _orderSnString;
    [[wclNetTool sharedTools]request:GET urlString:[MoreUrlInterface URL_BeforeDownOrder_String] parameters:parmse finished:^(id responseObject, NSError *error) {
        if ([self checkHttpResponseResultStatus:responseObject]) {
//            WCLLog(@"%@",responseObject);
            _modelArr = [waitChuLiModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            _giftcard_money = responseObject[@"giftcard_money"];
            if (!_waitChuLiTableView) {
                [self createUI];
            }
            else
            {
                [_waitChuLiTableView reloadData];
            }
            if (!_payView) {
                [self createPayView];
            }else
            {
                [_payView reloadView];
            }
            CGFloat price =0;
            for (waitChuLiModel*model in _modelArr) {
                price +=[model.payable_amount floatValue];
            }
            _payView.price = [NSString stringWithFormat:@"%.2f",price];
        }
    }];
}
-(void)createUI{
    _waitChuLiTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _waitChuLiTableView.delegate=self;
    _waitChuLiTableView.dataSource=self;
    _waitChuLiTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _waitChuLiTableView.tableFooterView=[UIView new];
    [_waitChuLiTableView registerClass:[DiyHeadCell class] forCellReuseIdentifier:@"sncell"];
    [_waitChuLiTableView registerClass:[waitChuLiDetailCell class] forCellReuseIdentifier:@"waitChuLiDetailCell"];
    [_waitChuLiTableView registerClass:[orderUseGiftCardCell class] forCellReuseIdentifier:@"orderUseGiftCardCell"];
    [self.view addSubview:_waitChuLiTableView];
    [_waitChuLiTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(void)createPayView
{
    _payView = [payForView new];
    [_payView setAlpha:0];
    [self.view addSubview:_payView];
    _payView.delegate = self;
    _payView.sd_layout
    .leftEqualToView(self.view)
    .bottomEqualToView(self.view)
    .widthIs(SCREEN_WIDTH)
    .heightIs(526 / 2);
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0||section==2)
    {
        return 1;
    }
    return _modelArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    waitChuLiModel*model = _modelArr[indexPath.row];
    if (indexPath.section==0) {
        DiyHeadCell*cell = [tableView dequeueReusableCellWithIdentifier:@"sncell"];
        cell.firstView.hidden=YES;
        cell.leftLabel.text =model.order_sn;
        cell.endView.backgroundColor = [UIColor colorWithHexString:@"#E8E8E8"];
        return cell;
    }
    else if (indexPath.section==2)
    {
        orderUseGiftCardCell*cell=[tableView dequeueReusableCellWithIdentifier:@"orderUseGiftCardCell"];
        __weak __typeof(cell)weakcCell = cell;
        [cell.switchView setImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
        cell.switchView.selected=NO;
        cell.delegate=self;
        cell.giftCardLabel.text = [NSString stringWithFormat:@"礼品卡余额%@",_giftcard_money];
        CGFloat price =0;
        for (waitChuLiModel*model in _modelArr) {
            price +=[model.payable_amount floatValue];
        }
        cell.heJiLabel.text = [NSString stringWithFormat:@"实付：¥%.2f",price];
        _payView.price = [NSString stringWithFormat:@"%.2f",price];
        [cell setUseGiftCardBlock:^(BOOL isuse) {
            if (isuse) {
                if (price-[_giftcard_money floatValue]>0) {
                    _lastPayMoney =price-[_giftcard_money floatValue];
                }
                else
                {
                    _lastPayMoney =0.00;
                }
            }
            else
            {
                
                _lastPayMoney =price;
            }
            self.useGiftCard = isuse;
            weakcCell.heJiLabel.text = [NSString stringWithFormat:@"实付：¥%.2f",_lastPayMoney];
            _payView.price = [NSString stringWithFormat:@"%.2f",_lastPayMoney];
            [_payView reloadView];
        }];
        cell.selectionStyle=UITableViewCellSeparatorStyleNone;
        return cell;
    }
    else
    {
        waitChuLiDetailCell*cell = [tableView dequeueReusableCellWithIdentifier:@"waitChuLiDetailCell"];
        cell.model=model;
        cell.selectionStyle=UITableViewCellSeparatorStyleNone;
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        return 38;
    }
    else if (indexPath.section==1)
    {
        return 126;
    }
    return 184;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
#pragma mark -OrderUseAndExchangeGiftCardAndToPayDelegate
-(void)exChangeGiftCardwithCell:(orderUseGiftCardCell *)cell
{
    __weak __typeof(self) weakSelf = self;
    [giftCardExchangeView showGiftCardViewWithDoneBlock:^(NSString *card, NSString *code) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:card forKey:@"giftcard_no"];
        [params setObject:code forKey:@"exchange_code"];
        [[wclNetTool sharedTools]request:POST urlString:URL_GetPoper parameters:params finished:^(id responseObject, NSError *error) {
            if ([weakSelf checkHttpResponseResultStatus:responseObject]) {
                [weakSelf alertViewShowOfTime:@"兑换成功" time:1.0];
                [weakSelf getDatas];
            }
        }];
    }];
}
-(void)goToPaywithCell:(orderUseGiftCardCell *)cell
{
    NSMutableArray*arr=[NSMutableArray array];
    for (waitChuLiModel*model in _modelArr) {
        [arr addObject:model.order_sn];
    }
    NSString*appstring = [arr componentsJoinedByString:@","];
    if ([_payView.price isEqualToString:@"0.00"]) {
        NSMutableDictionary*parmes =[NSMutableDictionary dictionary];
        [parmes setObject:appstring forKey:@"order_sn_s"];
        [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_GiftCardToBuy_String] parameters:parmes finished:^(id responseObject, NSError *error) {
            if ([self checkHttpResponseResultStatus:responseObject]) {
                paySuccessViewController*result = [[paySuccessViewController alloc]init];
                result.ordersn=appstring;
                [self.navigationController pushViewController:result animated:YES];
            }
        }];
    }
    else
    {
        _payView.alpha=1;
    }
    
}
#pragma mark - payViewDelegate
- (void)cancelClick
{
    
    _payView.alpha=0;
}
- (void)payClick
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_orderSnString forKey:@"order_sn_s"];
    if (self.useGiftCard) {
        [params setObject:@"1" forKey:@"use_gift_card"];
    } else {
        [params setObject:@"0" forKey:@"use_gift_card"];
    }
    if (ZFB) {
        NSString *appScheme = @"CloudFactory";
        [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_ZhiFuBaoToPayOrder_String] parameters:params finished:^(id responseObject, NSError *error) {
            if ([self checkHttpResponseResultStatus:responseObject]) {
                [[AlipaySDK defaultService]payOrder:responseObject[@"data"] fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    WCLLog(@"reslut = %@",resultDic);
                }];
            }
        }];
    } else {
        [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_WxToPayOrder_String] parameters:params finished:^(id responseObject, NSError *error) {
            if ([self checkHttpResponseResultStatus:responseObject]) {
                NSDictionary *dic = [responseObject objectForKey:@"data"];
                PayReq *request = [[PayReq alloc] init] ;
                request.partnerId = [dic stringForKey:@"partnerid"];
                request.prepayId= [dic stringForKey:@"prepayid"];
                request.package = [dic stringForKey:@"package"];
                request.nonceStr= [dic stringForKey:@"noncestr"];
                request.timeStamp= [[dic objectForKey:@"timestamp"] intValue];
                request.sign= [dic stringForKey:@"sign"];
                [WXApi sendReq:request];
            }
        }];
    }
}
- (void)clickItem:(NSInteger)item
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
@end
