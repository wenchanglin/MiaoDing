//
//  waitForPayViewController.m
//  CategaryShow
//
//  Created by APPLE on 16/9/17.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "waitForPayViewController.h"

#import "orderModel.h"
#import "waitForPayTableViewCell.h"

#import "orderDetailViewController.h"


@interface waitForPayViewController ()<UITableViewDataSource, UITableViewDelegate,waitForPayDelegate>

@end

@implementation waitForPayViewController
{
    UIView *bgNoDingView;   //没有订单界面底层
    UITableView *haveDingTable;  //有订单的table
    NSMutableArray *modelArray;
    NSMutableArray *dataArray;
    NSInteger page;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:getUIColor(Color_myOrderBack)];
    modelArray = [NSMutableArray array];
    dataArray = [NSMutableArray array];
    page=1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"PaySuccess" object:nil];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"orderDelete" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"cancelOrder" object:nil];
    [self getDatas];
}


-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"order_status"];
    [params setObject:@"1" forKey:@"page"];
    [[wclNetTool sharedTools]request:GET urlString:[MoreUrlInterface URL_OrderList_String] parameters:params finished:^(id responseObject, NSError *error) {
        if ([responseObject[@"data"]count]>0) {
            modelArray = [orderModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            NSMutableArray*contentArr = [NSMutableArray array];
            for (orderModel*model in modelArray) {
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
    }];

}



-(void)reloadTable
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"order_status"];
    [params setObject:@"1" forKey:@"page"];
    [[wclNetTool sharedTools]request:GET urlString:[MoreUrlInterface URL_OrderList_String] parameters:params finished:^(id responseObject, NSError *error) {
        if ([self checkHttpResponseResultStatus:responseObject]) {
            if ([responseObject[@"data"]count]>0) {
                modelArray = [orderModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                NSMutableArray*contentArr = [NSMutableArray array];
                for (orderModel*model in modelArray) {
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
    [params setObject:@"1" forKey:@"order_status"];
    [params setObject:@(page) forKey:@"page"];
    [[wclNetTool sharedTools]request:GET urlString:[MoreUrlInterface URL_OrderList_String] parameters:params finished:^(id responseObject, NSError *error) {
        if ([self checkHttpResponseResultStatus:responseObject]) {
            [haveDingTable.mj_footer endRefreshing];
                if ([responseObject[@"data"]count]==0&&page==1) {
                    [haveDingTable removeFromSuperview];
                    [self createViewNoDD];
                }
                else
                {
                    NSMutableArray*array = [orderModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                    NSMutableArray*contentArr = [NSMutableArray array];
                    for (orderModel*model in array) {
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
    bgNoDingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-64-84:SCREEN_HEIGHT - 41 - 64)];
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
    haveDingTable = [[UITableView alloc] initWithFrame:CGRectMake(13, NavHeight, SCREEN_WIDTH - 26, [ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-64-84:SCREEN_HEIGHT - 41 - 64) style:UITableViewStyleGrouped];
    haveDingTable.dataSource = self;
    haveDingTable.delegate = self;
    haveDingTable.estimatedRowHeight = 0;
    haveDingTable.estimatedSectionHeaderHeight = 0;
    haveDingTable.estimatedSectionFooterHeight = 0;
    [haveDingTable setBackgroundColor:getUIColor(Color_myOrderBack)];
    [haveDingTable registerClass:[waitForPayTableViewCell class] forCellReuseIdentifier:@"orderWaitForPay"];
    haveDingTable.showsVerticalScrollIndicator = NO;
    haveDingTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:haveDingTable];
    [WCLMethodTools footerAutoGifRefreshWithTableView:haveDingTable completion:^{
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
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    return cell;
}

-(void)waitPayClick:(UIButton*)btn
{
    orderModel *model = modelArray[btn.tag - 101];
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

-(void)waitPayclickItemToDetailWithOrderSn:(NSString *)ordersn withStatus:(NSInteger)status
{
    orderDetailViewController *orderDetail = [[orderDetailViewController alloc] init];
    orderDetail.order_sn = ordersn;
    [self.navigationController pushViewController:orderDetail animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [MobClick endLogPageView:@"等待付款"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"等待付款"];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
         orderModel *model = modelArray[alertView.tag - 100];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:model.order_sn forKey:@"order_sn"];
        [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_CancleOrderForOrdersn_String]  parameters:params finished:^(id responseObject, NSError *error) {
            if ([self checkHttpResponseResultStatus:responseObject]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelOrder" object:nil];
                [self reloadTable];
            }
        }];
       
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
