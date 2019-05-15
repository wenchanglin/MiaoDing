//
//  myOrderViewController.m
//  CategaryShow
//
//  Created by APPLE on 16/8/31.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width
#import "myOrderViewController.h"
#import "cashTransactionSuccessTableViewCell.h"
#import "orderModel.h"
#import "waitForPayTableViewCell.h"
#import "waitForSendTableViewCell.h"
#import "orderDetailViewController.h"
#import "orderDetailForHavePayedViewController.h"
#import "orderDetailHaveSendViewController.h"
#import "HaveDoneTableViewCell.h"
#import "HaveDoneViewController.h"
#import "paySuccessViewController.h"
#import "NextPayForClothesVC.h"
#import "searchWuLiuViewController.h"
@interface myOrderViewController ()<UITableViewDataSource, UITableViewDelegate,waitForPayDelegate,waitForSendClickItemDelegate,orderCompelDelegate>

@end

@implementation myOrderViewController
{
    UIView *bgNoDingView;   //没有订单界面底层
    UITableView *haveDingTable;  //有订单的table
    NSMutableArray *modelArray;
    NSMutableArray *dataArray;
    BOOL canceled;
    NSInteger page;
    UIAlertView *deleteAlert;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:getUIColor(Color_myOrderBack)];
    modelArray = [NSMutableArray array];
    dataArray = [NSMutableArray array];
    page=1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"PaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"confirm" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"orderDelete" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"cancelOrder" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"realToOrder" object:nil];
    
    [self getDatas];
}

-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"0" forKey:@"order_status"];
    [params setObject:@"1" forKey:@"page"];
    [[wclNetTool sharedTools]request:GET urlString:[MoreUrlInterface URL_OrderList_String] parameters:params finished:^(id responseObject, NSError *error) {
        if ([self checkHttpResponseResultStatus:responseObject]) {
            WCLLog(@"%@",responseObject);
            if ([responseObject[@"data"]count]>0) {
                modelArray = [orderModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                for (orderModel*model in modelArray) {
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
                }
                [self createHaveOrderView];
            }
            else
            {
                [self createViewNoDD];
            }
        }
    }];
}

-(void)reloadTable
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"0" forKey:@"order_status"];
    [params setObject:@"1" forKey:@"page"];
    [[wclNetTool sharedTools]request:GET urlString:[MoreUrlInterface URL_OrderList_String] parameters:params finished:^(id responseObject, NSError *error) {
        if ([self checkHttpResponseResultStatus:responseObject]) {
            if ([responseObject[@"data"]count]>0) {
                modelArray = [orderModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                for (orderModel*model in modelArray) {
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
                }
                [haveDingTable reloadData];
            }
            else
            {
                [haveDingTable removeFromSuperview];
                [self createViewNoDD];
            }
        }
    }];
}

-(void)reloadAddTable
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"0" forKey:@"order_status"];
    [params setObject:@(page) forKey:@"page"];
    [[wclNetTool sharedTools]request:GET urlString:[MoreUrlInterface URL_OrderList_String] parameters:params finished:^(id responseObject, NSError *error) {
        [haveDingTable.mj_footer endRefreshing];
        if ([self checkHttpResponseResultStatus:responseObject]) {
            if ([responseObject[@"data"]count]==0&&page==1) {
                [haveDingTable removeFromSuperview];
                [self createViewNoDD];
            }
            else
            {
                NSMutableArray*array = [orderModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                for (orderModel*model in array) {
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
                }
                [modelArray addObjectsFromArray:array];
                [haveDingTable reloadData];
                
            }
        }
    }];
}
-(void)createViewNoDD    // 创建没有订单界面
{
    bgNoDingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 41 - 64)];
    [bgNoDingView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bgNoDingView];
    
    UIImageView *NoDD = [UIImageView new];
    [bgNoDingView addSubview:NoDD];
    NoDD.sd_layout
    .centerXEqualToView(bgNoDingView)
    .topSpaceToView(bgNoDingView, 120)
    .widthIs(211)
    .heightIs(220);
    [NoDD setImage:[UIImage imageNamed:@"HaveNoOrder"]];
    
    
    UIButton *clickToLookOther = [UIButton new];
    [bgNoDingView addSubview:clickToLookOther];
    
    clickToLookOther.sd_layout
    .centerXEqualToView(bgNoDingView)
    .topSpaceToView(NoDD, 20)
    .widthIs(80)
    .heightIs(35);
    [clickToLookOther.layer setCornerRadius:3];
    [clickToLookOther.layer setMasksToBounds:YES];
    [clickToLookOther setBackgroundColor:[UIColor blackColor]];
    [clickToLookOther.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [clickToLookOther setTitle:@"去逛逛" forState:UIControlStateNormal];
    [clickToLookOther addTarget:self action:@selector(goToLookClothes) forControlEvents:UIControlEventTouchUpInside];
}

-(void)goToLookClothes {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LookClothes" object:nil];
}

-(void)createHaveOrderView
{
    
    haveDingTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-64-84:SCREEN_HEIGHT - 41 - 64) style:UITableViewStyleGrouped];
    haveDingTable.dataSource = self;
    haveDingTable.delegate = self;
    haveDingTable.estimatedRowHeight = 0;
    haveDingTable.estimatedSectionHeaderHeight = 0;
    haveDingTable.estimatedSectionFooterHeight = 0;
    [haveDingTable setBackgroundColor:getUIColor(Color_myOrderBack)];
    [haveDingTable registerClass:[cashTransactionSuccessTableViewCell class] forCellReuseIdentifier:@"ordersuccess"];
    [haveDingTable registerClass:[waitForPayTableViewCell class] forCellReuseIdentifier:@"orderWaitForPay"];
    [haveDingTable registerClass:[waitForPayTableViewCell class] forCellReuseIdentifier:@"cancleorder"];
    [haveDingTable registerClass:[waitForSendTableViewCell class] forCellReuseIdentifier:@"orderWaitForSend1"];
    [haveDingTable registerClass:[HaveDoneTableViewCell class] forCellReuseIdentifier:@"orderDoneForSend"];
    haveDingTable.showsVerticalScrollIndicator = NO;
    haveDingTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:haveDingTable];
    [WCLMethodTools footerNormalRefreshWithTableView:haveDingTable completion:^{
        page +=1;
        [self reloadAddTable];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [modelArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    orderModel *model = modelArray[indexPath.section];
    
    return 90*model.childOrders.count+90;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 9;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *resCell;
    
    orderModel *model = modelArray[indexPath.section];
    if(model.status == 1) {
        waitForPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderWaitForPay" forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.model = modelArray[indexPath.section];
        cell.payFor.backgroundColor = [UIColor blackColor];
        [cell.payFor setTitle:@"去支付" forState:UIControlStateNormal];
        [cell.payFor setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.payFor addTarget:self action:@selector(waitPayClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.cancelOrder addTarget:self action:@selector(cancle:) forControlEvents:UIControlEventTouchUpInside];
        cell.cancelOrder.tag=100 + indexPath.section;
        cell.payFor.tag=101 + indexPath.section;
        cell.delegate=self;
        resCell = cell;
    } else if (model.status == 2) {
        waitForSendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderWaitForSend1" forIndexPath:indexPath];
        cell.model = modelArray[indexPath.section];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.delegate = self;
        [cell.woring addTarget:self action:@selector(tixingClick:) forControlEvents:UIControlEventTouchUpInside];
        resCell = cell;
    } else if (model.status == 3) {//已发货
        cashTransactionSuccessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ordersuccess" forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.model = modelArray[indexPath.section];
        [cell.logistics setTag:indexPath.section + 3000];
        [cell.logistics addTarget:self action:@selector(WuLiuClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.logistics setTitle:@"物流追踪" forState:UIControlStateNormal];
        
        [cell.confirm setTag:indexPath.section+1500];
        cell.confirm.backgroundColor = [UIColor blackColor];
        [cell.confirm setTitle:@"确认收货" forState:UIControlStateNormal];
        [cell.confirm addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.delegate=self;
        resCell = cell;
    }else if (model.status == 4) {
        HaveDoneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderDoneForSend" forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.nextBtn.tag = indexPath.section+4999;
        [cell.nextBtn addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.commendBtn.tag = indexPath.section + 5000;
        [cell.commendBtn addTarget:self action:@selector(commendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.model = modelArray[indexPath.section];
        resCell = cell;
        
    }
    else if (model.status == 5) {
        waitForPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cancleorder" forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.model = modelArray[indexPath.section];
        cell.payFor.tag = 500 + indexPath.section;
        [cell.payFor setTitle:@"删除订单" forState:UIControlStateNormal];
        [cell.payFor setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cell.cancelOrder.hidden=YES;
        [cell.payFor addTarget:self action:@selector(woringOrDelegateClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.delegate=self;
        resCell = cell;
        
    }
    [resCell setBackgroundColor:[UIColor whiteColor]];
    return resCell;
}
-(void)nextClick:(UIButton*)btn
{
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    orderModel *model = modelArray[btn.tag - 4999];
    //    [parameter setObject:model.orderId forKey:@"orderid"];
    //    [[BaseDomain getInstance:NO]postData:URL_NextOrder PostParams:parameter finish:^(BaseDomain *domain, Boolean success) {
    //        if ([self checkHttpResponseResultStatus:domain]) {
    //            if ([domain.dataRoot integerForKey:@"code"]==1) {
    //                NextPayForClothesVC * pvc = [[NextPayForClothesVC alloc]init];
    //                pvc.carId = [NSString stringWithFormat:@"%d",[domain.dataRoot integerForKey:@"car_id"]];
    //                pvc.allPrice = [NSString stringWithFormat:@"%.2f",[dataArray[btn.tag-4999][@"list"][0][@"price"]floatValue] * [model.clothesCount floatValue]];
    //                [self.navigationController pushViewController:pvc animated:YES];
    //            }
    //        }
    //    }];
}
-(void)commendBtnClick:(UIButton *)sender
{
    orderModel *model = modelArray[sender.tag - 5000];
    HaveDoneViewController *orderDetail = [[HaveDoneViewController alloc] init];
    //    orderDetail.orderId = model.orderId;
    //    orderDetail.canCommend = model.ifCommend;
    [self.navigationController pushViewController:orderDetail animated:YES];
}

-(void)WuLiuClick:(UIButton *)sender
{
    orderModel *model = modelArray[sender.tag - 3000];
    searchWuLiuViewController*search = [[searchWuLiuViewController alloc]init];
    search.order_sn =model.order_sn;
    [self.navigationController pushViewController:search animated:YES];
}

-(void)confirmClick:(UIButton *)sender
{
    orderModel *model = modelArray[sender.tag - 1500];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认收货吗" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *album = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:model.order_sn forKey:@"order_sn"];
        [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_Confirm_Delivery_String] parameters:params finished:^(id responseObject, NSError *error) {
            if ([self checkHttpResponseResultStatus:responseObject]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"confirm" object:nil];
            }
        }];
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:album];
    [alertController addAction:cancel];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}
-(void)tixingClick:(UIButton*)sender
{
    [self alertViewShowOfTime:@"提醒发货成功" time:1.5];
}
-(void)woringOrDelegateClick:(UIButton *)sender
{
    if (sender.tag-500>=0) {
        deleteAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除订单吗" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        deleteAlert.tag = sender.tag;
        [deleteAlert show];
        
    }
    else //200
    {
        UIAlertController*alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除订单吗" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction*cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction*queren = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            orderModel *model = modelArray[sender.tag - 200];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:model.order_sn forKey:@"order_sn"];
            [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_DeleteOrderForOrdersn_String] parameters:params finished:^(id responseObject, NSError *error) {
                if ([self checkHttpResponseResultStatus:responseObject]) {
                    [self reloadTable];
                    [self alertViewShowOfTime:@"删除成功" time:1.5];
                }
            }];
        }];
        [alert addAction:cancle];
        [alert addAction:queren];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
        
    }
}
#pragma mark - waitpayClickItemDelegate
-(void)waitPayclickItemToDetailWithOrderSn:(NSString *)ordersn withStatus:(NSInteger)status
{
    if (status == 1) {
        orderDetailViewController *orderDetail = [[orderDetailViewController alloc] init];
        orderDetail.order_sn = ordersn;
        [self.navigationController pushViewController:orderDetail animated:YES];
    }
    else if (status == 2) { // 未发货
        orderDetailForHavePayedViewController *orderDetail = [[orderDetailForHavePayedViewController alloc] init];
        //        orderDetail.orderId = model.orderId;
        [self.navigationController pushViewController:orderDetail animated:YES];
    } else if (status == 3) { //已发货
        orderDetailHaveSendViewController *orderDetail = [[orderDetailHaveSendViewController alloc] init];
        //        orderDetail.orderId = model.orderId;
        [self.navigationController pushViewController:orderDetail animated:YES];
    } else if (status == 4) { //已完成
        HaveDoneViewController *orderDetail = [[HaveDoneViewController alloc] init];
        //        orderDetail.canCommend = model.ifCommend;
        //        orderDetail.orderId = model.orderId;
        [self.navigationController pushViewController:orderDetail animated:YES];
    } else if (status == 5) { //已取消
        orderDetailViewController *orderDetail = [[orderDetailViewController alloc] init];
        orderDetail.order_sn = ordersn;
        [self.navigationController pushViewController:orderDetail animated:YES];
    }
}
#pragma mark - 订单已发货
-(void)orderCompelClickItemToDetailWithOrderSn:(NSString *)ordersn withStatus:(NSInteger)status
{
    orderDetailViewController *orderDetail = [[orderDetailViewController alloc] init];
    orderDetail.order_sn = ordersn;
    [self.navigationController pushViewController:orderDetail animated:YES];
}

#pragma mark - waitForSendClickItemDelegate
-(void)clickItemToDetailWithOrderSn:(NSString *)ordersn withStatus:(NSInteger)status
{
    //    if (status == 1) {
    orderDetailViewController *orderDetail = [[orderDetailViewController alloc] init];
    orderDetail.order_sn = ordersn;
    [self.navigationController pushViewController:orderDetail animated:YES];
    //    }
    //    else if (status == 2) { // 未发货
    //        orderDetailForHavePayedViewController *orderDetail = [[orderDetailForHavePayedViewController alloc] init];
    //        //        orderDetail.orderId = model.orderId;
    //        [self.navigationController pushViewController:orderDetail animated:YES];
    //    } else if (status == 3) { //已发货
    //        orderDetailHaveSendViewController *orderDetail = [[orderDetailHaveSendViewController alloc] init];
    //        //        orderDetail.orderId = model.orderId;
    //        [self.navigationController pushViewController:orderDetail animated:YES];
    //    } else if (status == 4) { //已完成
    //        HaveDoneViewController *orderDetail = [[HaveDoneViewController alloc] init];
    //        //        orderDetail.canCommend = model.ifCommend;
    //        //        orderDetail.orderId = model.orderId;
    //        [self.navigationController pushViewController:orderDetail animated:YES];
    //    } else if (status == 5) { //已取消
    //        orderDetailViewController *orderDetail = [[orderDetailViewController alloc] init];
    //        orderDetail.order_sn = ordersn;
    //        [self.navigationController pushViewController:orderDetail animated:YES];
    //    }
}
-(void)waitPayClick:(UIButton*)btn
{
    orderModel *model = modelArray[btn.tag - 100];
    orderDetailViewController *orderDetail = [[orderDetailViewController alloc] init];
    orderDetail.order_sn = model.order_sn;
    [self.navigationController pushViewController:orderDetail animated:YES];
}
-(void)cancle:(UIButton*)btn
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定取消订单吗" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.tag = btn.tag;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (alertView == deleteAlert) {
            orderModel *model = modelArray[alertView.tag - 500];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:model.order_sn forKey:@"order_sn"];
            [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_DeleteOrderForOrdersn_String] parameters:params finished:^(id responseObject, NSError *error) {
                if ([self checkHttpResponseResultStatus:responseObject]) {
                    [self reloadTable];
                    [self alertViewShowOfTime:@"删除成功" time:1.5];
                }
            }];
        }else {
            orderModel *model = modelArray[alertView.tag - 100];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:model.order_sn forKey:@"order_sn"];
            [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_CancleOrderForOrdersn_String] parameters:params finished:^(id responseObject, NSError *error) {
                if ([self checkHttpResponseResultStatus:responseObject]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelOrderAll" object:nil];
                    [self reloadTable];
                }
            }];
        }
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    orderModel *model = modelArray[indexPath.section];
    orderDetailViewController *orderDetail = [[orderDetailViewController alloc] init];
    orderDetail.order_sn = model.order_sn;
    [self.navigationController pushViewController:orderDetail animated:YES];
    
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
