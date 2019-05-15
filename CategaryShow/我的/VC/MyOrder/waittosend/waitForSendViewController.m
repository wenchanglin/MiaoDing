//
//  waitForSendViewController.m
//  CategaryShow
//
//  Created by APPLE on 16/9/17.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "waitForSendViewController.h"

#import "orderModel.h"
#import "searchWuLiuViewController.h"
#import "waitForSendTableViewCell.h"
#import "cashTransactionSuccessTableViewCell.h"
#import "orderDetailForHavePayedViewController.h"
#import "orderDetailViewController.h"
@interface waitForSendViewController ()<UITableViewDataSource, UITableViewDelegate,waitForSendClickItemDelegate,orderCompelDelegate>

@end

@implementation waitForSendViewController
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
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"PaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTable) name:@"confirm" object:nil];
    page=1;
    [self getDatas];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"2" forKey:@"order_status"];
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
                [self createHaveOrderView];
            }
            else
            {
                [self createViewNoDD];
            }
        }
    }];
}
-(void)reloadAddTable
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"2" forKey:@"order_status"];
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

-(void)reloadTable
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"2" forKey:@"order_status"];
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


-(void)createViewNoDD    // 创建没有订单界面
{
    bgNoDingView = [[UIView alloc] initWithFrame:CGRectMake(0,NavHeight, SCREEN_WIDTH, [ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-64-84:SCREEN_HEIGHT - 41 - 64)];
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
    haveDingTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-64-84:SCREEN_HEIGHT - 41 - 64) style:UITableViewStyleGrouped];
    haveDingTable.dataSource = self;
    haveDingTable.delegate = self;
    haveDingTable.estimatedRowHeight = 0;
    haveDingTable.estimatedSectionHeaderHeight = 0;
    haveDingTable.estimatedSectionFooterHeight = 0;
    [haveDingTable setBackgroundColor:getUIColor(Color_myOrderBack)];
    [haveDingTable registerClass:[waitForSendTableViewCell class] forCellReuseIdentifier:@"orderWaitForSend"];
    [haveDingTable registerClass:[cashTransactionSuccessTableViewCell class] forCellReuseIdentifier:@"ordersuccess1"];
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
    return 182;
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
    orderModel*model = modelArray[indexPath.section];

    if(model.status==2)
    {
        waitForSendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderWaitForSend" forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.delegate=self;
        cell.model=model;
        [cell.woring addTarget:self action:@selector(woringClick) forControlEvents:UIControlEventTouchUpInside];
        return  cell;
    }
    else if (model.status==3)
    {
        cashTransactionSuccessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ordersuccess1" forIndexPath:indexPath];
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
       return cell;
    }
    else
        return [UITableViewCell new];
}
-(void)orderCompelClickItemToDetailWithOrderSn:(NSString *)ordersn withStatus:(NSInteger)status
{
    orderDetailViewController *orderDetail = [[orderDetailViewController alloc] init];
    orderDetail.order_sn = ordersn;
    [self.navigationController pushViewController:orderDetail animated:YES];
}

-(void)clickItemToDetailWithOrderSn:(NSString *)ordersn withStatus:(NSInteger)status
{
    orderDetailViewController *orderDetail = [[orderDetailViewController alloc] init];
    orderDetail.order_sn = ordersn;
    [self.navigationController pushViewController:orderDetail animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    orderModel *model = modelArray[indexPath.section];
    orderDetailViewController *orderDetail = [[orderDetailViewController alloc] init];
    orderDetail.order_sn = model.order_sn;
    [self.navigationController pushViewController:orderDetail animated:YES];
}

-(void)woringClick
{
    UIAlertView *alertShow = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提醒厂家发货发送消息成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertShow show];
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
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:album];
    [alertController addAction:cancel];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
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
