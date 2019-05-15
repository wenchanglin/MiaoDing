//
//  orderDetailViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/27.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "orderDetailViewController.h"
#import "MyOrderDetailTableViewCell.h"
#import "MyOrderDetailListTableViewCell.h"
#import "mineOrderDetailModel.h"
#import "payForView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "OrderAddressTableViewCell.h"
#import "searchWuLiuViewController.h"
//#import "DataSigner.h"
#import "WXApi.h"
#import "PayInfoTableViewCell.h"
#import "waitForPayTableViewCell.h"
@interface orderDetailViewController ()<UITableViewDelegate, UITableViewDataSource, payForViewDelegate>

@end

@implementation orderDetailViewController
{
    UITableView *orderDetailTable;
    NSMutableDictionary *orderDetail;
    NSMutableArray *modelArray;
    payForView *payView;
    UIImageView *imageAlpha;
    BaseDomain *postData;
    NSInteger count;
    mineOrderDetailModel*model;
    BOOL ZFB;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    modelArray = [NSMutableArray array];
    postData = [BaseDomain getInstance:NO];
    [self settabTitle:@"订单详情"];
    ZFB = YES;
    orderDetail = [NSMutableDictionary dictionary];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PaySuccessAction) name:@"PaySuccess" object:nil];
    if (@available(iOS 11.0, *)) {
        orderDetailTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self getDatas];
    [self createTableView];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_order_sn forKey:@"order_sn"];
    [[wclNetTool sharedTools]request:GET urlString:[MoreUrlInterface URL_OrderDetailForOrdersn_String] parameters:params finished:^(id responseObject, NSError *error) {
        //        WCLLog(@"%@",responseObject);
        if ([self checkHttpResponseResultStatus:responseObject]) {
            model = [mineOrderDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            if(model.status==1)
            {
                [self performSelectorInBackground:@selector(thread) withObject:nil];
            }
            
            NSMutableArray*contentArr = [NSMutableArray array];
            for (childOrdersModel*model2 in model.childOrders) {
                if (model2.category_id ==2) {
                    if (model2.sku.count>1) {
                        for (skuModel*model4 in model2.sku) {
                            NSString*string2 =[NSString stringWithFormat:@"%@:%@",model4.type,model4.value];
                            [contentArr addObject:string2];
                        }
                        NSString*string1 = [contentArr componentsJoinedByString:@";"];
                        model2.sizeOrDing=string1;
                    }
                    else
                    {
                        model2.sizeOrDing =@"暂无配件信息";
                    }
                    
                }
                else
                {
                    if (model2.part.count>1) {
                        for (partModel*model3 in model2.part) {
                            NSString*string2 =[NSString stringWithFormat:@"%@:%@",model3.part_name,model3.part_value];
                            [contentArr addObject:string2];
                        }
                        NSString*string1 = [contentArr componentsJoinedByString:@";"];
                        model2.sizeOrDing=string1;
                    }
                    else
                    {
                        model2.sizeOrDing =@"暂无配件信息";
                    }
                }
            }
            [modelArray addObject:model];
        }
        [orderDetailTable reloadData];
        [self createLowView];
        [self createPayView];
    }];
    
}
//获取当前时间戳
- (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:3600];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970];// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}
- (void)thread
{
    for(NSInteger i=model.pay_count_down_time;i>=0;i--)
    {
        count = i;
        // 回调主线程
        [self performSelectorOnMainThread:@selector(mainThread) withObject:nil waitUntilDone:YES];
        sleep(1);
    }
}

- (void)mainThread
{
    
    model.pay_count_down_time =count;
    [orderDetailTable reloadData];
    if (count==0) {
        [self.navigationController popViewControllerAnimated:YES];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:_order_sn forKey:@"order_sn"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"orderDelete" object:nil userInfo:dic];
        
    }
}

-(void)createTableView
{
    
    orderDetailTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH ,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-84-74: SCREEN_HEIGHT - 64 - 49) style:UITableViewStyleGrouped];
    orderDetailTable.dataSource = self;
    orderDetailTable.delegate = self;
    [orderDetailTable setBackgroundColor:getUIColor(Color_myOrderBack)];
    orderDetailTable.showsVerticalScrollIndicator = NO;
    orderDetailTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [orderDetailTable registerClass:[MyOrderDetailTableViewCell class] forCellReuseIdentifier:@"orderDetail"];
    [orderDetailTable registerClass:[MyOrderDetailListTableViewCell class] forCellReuseIdentifier:@"orderDetailList"];
    [orderDetailTable registerClass:[OrderAddressTableViewCell class] forCellReuseIdentifier:@"orderDetailAddress"];
    [orderDetailTable registerClass:[PayInfoTableViewCell class] forCellReuseIdentifier:@"payInfo"];
    [self.view addSubview:orderDetailTable];
    
    
    
    
    
}
-(void)createLowView
{
    if (model.status==1) {
        //        if (model.pay_count_down_time  <= 0) {
        //
        //            UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-84-74:SCREEN_HEIGHT-64 - 49, SCREEN_WIDTH, 49)];
        //            [self.view addSubview:deleteButton];
        //            [deleteButton setBackgroundColor:getUIColor(Color_DZClolor)];
        //            [deleteButton setTitle:@"删除订单" forState:UIControlStateNormal];
        //            [deleteButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        //            [deleteButton addTarget:self action:@selector(deleteOrder) forControlEvents:UIControlEventTouchUpInside];
        //
        //        } else {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-74-84:SCREEN_HEIGHT -64- 49, SCREEN_WIDTH, 49)];
        [imageV setImage:[UIImage imageNamed:@"tabBackImage"]];
        [self.view addSubview:imageV];
        [imageV setUserInteractionEnabled:YES];
        UIButton *buttonCancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 2, 49)];
        [imageV addSubview:buttonCancel];
        [buttonCancel setBackgroundColor:getUIColor(Color_DZClolor)];
        [buttonCancel setTitle:@"取消订单" forState:UIControlStateNormal];
        [buttonCancel.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [buttonCancel addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *payButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2, 49)];
        [payButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [imageV addSubview:payButton];
        [payButton setBackgroundColor:[UIColor blackColor]];
        [payButton setTitle:@"付款" forState:UIControlStateNormal];
        [payButton addTarget:self action:@selector(payForClick) forControlEvents:UIControlEventTouchUpInside];
        //        }
    }else if(model.status==2)
    {
        UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-84-74:SCREEN_HEIGHT-64 - 49, SCREEN_WIDTH, 49)];
        [self.view addSubview:deleteButton];
        [deleteButton setBackgroundColor:getUIColor(Color_DZClolor)];
        [deleteButton setTitle:@"提醒发货" forState:UIControlStateNormal];
        [deleteButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [deleteButton addTarget:self action:@selector(worningClick) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (model.status==5)
    {
        UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-84-74:SCREEN_HEIGHT-64 - 49, SCREEN_WIDTH, 49)];
        [self.view addSubview:deleteButton];
        [deleteButton setBackgroundColor:getUIColor(Color_DZClolor)];
        [deleteButton setTitle:@"删除订单" forState:UIControlStateNormal];
        [deleteButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [deleteButton addTarget:self action:@selector(deleteOrder) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (model.status==3)
    {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-74-84:SCREEN_HEIGHT -64- 49, SCREEN_WIDTH, 49)];
        [imageV setImage:[UIImage imageNamed:@"tabBackImage"]];
        [self.view addSubview:imageV];
        [imageV setUserInteractionEnabled:YES];
        UIButton *buttonCancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 2, 49)];
        [imageV addSubview:buttonCancel];
        [buttonCancel setBackgroundColor:getUIColor(Color_DZClolor)];
        [buttonCancel setTitle:@"查看物流" forState:UIControlStateNormal];
        [buttonCancel.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [buttonCancel addTarget:self action:@selector(wuliu) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *payButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2, 49)];
        [payButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [imageV addSubview:payButton];
        [payButton setBackgroundColor:[UIColor blackColor]];
        [payButton setTitle:@"确认收货" forState:UIControlStateNormal];
        [payButton addTarget:self action:@selector(conFirmClick) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)worningClick
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提醒厂家发货发送消息成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
-(void)wuliu{
    searchWuLiuViewController*search = [[searchWuLiuViewController alloc]init];
    search.order_sn =_order_sn;
    [self.navigationController pushViewController:search animated:YES];
    
}
-(void)conFirmClick
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认收货吗" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *album = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:_order_sn forKey:@"order_sn"];
        [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_Confirm_Delivery_String] parameters:params finished:^(id responseObject, NSError *error) {
            if ([self checkHttpResponseResultStatus:responseObject]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"confirm" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:album];
    [alertController addAction:cancel];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

-(void)deleteOrder
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_order_sn forKey:@"order_sn"];
    [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_DeleteOrderForOrdersn_String] parameters:params finished:^(id responseObject, NSError *error) {
        if ([self checkHttpResponseResultStatus:responseObject]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelOrder" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

-(void)cancelOrder
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定取消订单吗" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:_order_sn forKey:@"order_sn"];
        [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_CancleOrderForOrdersn_String] parameters:params finished:^(id responseObject, NSError *error) {
            if ([self checkHttpResponseResultStatus:responseObject]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelOrder" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        
    }
}

-(void)createPayView
{
    
    imageAlpha = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [imageAlpha setImage:[UIImage imageNamed:@"BGALPHA"]];
    [imageAlpha setAlpha:0];
    [self.view addSubview:imageAlpha];
    
    
    payView = [payForView new];
    payView.delegate = self;
    payView.price = [NSString stringWithFormat:@"%.2f",[model.payable_amount floatValue]-[model.ticket_reduce_money floatValue]-[model.giftcard_eq_money floatValue]];
    [payView setAlpha:0];
    [self.view addSubview:payView];
    payView.delegate = self;
    payView.sd_layout
    .leftEqualToView(self.view)
    .bottomEqualToView(self.view)
    .widthIs(SCREEN_WIDTH)
    .heightIs(526 / 2);
}

-(void)payForClick
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [payView setAlpha:1];
    [imageAlpha setAlpha:1];
    [UIView commitAnimations];
}

-(void)cancelClick
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [payView setAlpha:0];
    [imageAlpha setAlpha:0];
    [UIView commitAnimations];
}

-(void)payClick
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_order_sn forKey:@"order_sn_s"];
    if ([model.giftcard_eq_money integerValue]>0) {
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

-(void)PaySuccessAction
{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"turnToOrder" object:nil];
}

-(void)clickItem:(NSInteger)item
{
    switch (item) {
        case 0:
        {
            ZFB = YES;
        }
            break;
        case 1:
        {
            ZFB = NO;
        }
            break;
        default:
            break;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 7;
    }
    return 0.001;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 7;
    }else if(section == 2) {
        return 0.01;
    }else return 7;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 2;
    }else return [modelArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 62;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 65;
        } else
            return 100;
    } else
        return 90*model.childOrders.count+50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *reCell ;
    
    if (indexPath.section == 0) {
        MyOrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderDetail" forIndexPath:indexPath];
        [cell.orderCreateTime setText:[NSString stringWithFormat:@"%@",model.create_time]];
        [cell.orderPayTime setText:@"支付时间:"];
        if (model.status==1) {
            if (model.pay_count_down_time <= 0) {
                [cell.orderStatus setText:@"已取消"];
            } else {
                int min =(int)model.pay_count_down_time;
                [cell.orderStatus setText:[NSString stringWithFormat:@"请在%d分%d秒内完成支付,超时订单自动关闭",min / 60,min%60]];
            }
        }
        else if (model.status==2||model.status==3)
        {
            cell.orderStatus.text = model.pay_time;
        }
        else if (model.status==5)
        {
            [cell.orderStatus setText:@"已取消"];
        }
        reCell = cell;
    }else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            OrderAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderDetailAddress" forIndexPath:indexPath];
            [cell.lineView setHidden:NO];
            [cell.userName setText:model.accept_name];
            [cell.userPhone setText:model.address_phone];
            [cell.userAddress setText:[NSString stringWithFormat:@"%@%@%@%@",model.province,model.city,model.area,model.address]];
            
            reCell = cell;
        } else {
            PayInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payInfo" forIndexPath:indexPath];
            if (model.status==1) {
                if (model.pay_count_down_time<=0) {
                    [cell.payType setText:@" 已取消"];
                } else {
                    [cell.payType setText:@" 待付款"];
                }
            }
            else if (model.status==2||model.status==3)
            {
                cell.payType.text = model.pay_type;
            }
            else if (model.status==5)
            {
                [cell.payType setText:@" 已取消"];
            }
            [cell.couponMoney setText:[NSString stringWithFormat:@"￥%@", model.ticket_reduce_money]];
            [cell.payMoney setText:[NSString stringWithFormat:@"¥%@",  model.payable_amount]];
            reCell = cell;
        }
        
    } else {
        MyOrderDetailListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderDetailList" forIndexPath:indexPath];
        mineOrderDetailModel *model = modelArray[indexPath.row];
        cell.model = model;
        reCell = cell;
        
    }
    
    [reCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return reCell;
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
