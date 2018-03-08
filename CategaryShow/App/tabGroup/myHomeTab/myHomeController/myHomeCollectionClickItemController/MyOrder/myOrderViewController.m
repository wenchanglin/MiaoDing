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
@interface myOrderViewController ()<UITableViewDataSource, UITableViewDelegate,waitForPayDelegate>

@end

@implementation myOrderViewController
{
    UIView *bgNoDingView;   //没有订单界面底层
    UITableView *haveDingTable;  //有订单的table
    NSMutableArray *modelArray;
    NSMutableArray *dataArray;
    BaseDomain *getData;
    BOOL canceled;
//    AwTipView *tipView;
    UIAlertView *deleteAlert;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self reloadTable];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    getData = [BaseDomain getInstance:NO];
    [self.view setBackgroundColor:getUIColor(Color_myOrderBack)];
    modelArray = [NSMutableArray array];
    dataArray = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableData) name:@"PaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableData) name:@"confirm" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableData) name:@"orderDelete" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableData) name:@"cancelOrder" object:nil];
    [self getDatas];
}

-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"0" forKey:@"status"];
    [params setObject:@"1" forKey:@"page"];
    [getData getData:URL_GetOrderNew PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:getData]) {
            dataArray = [NSMutableArray arrayWithArray:[[getData.dataRoot objectForKey:@"data"] arrayForKey:@"data"]];
            
            if ([dataArray count] > 0) {
                for (NSMutableDictionary *dic in dataArray) {
                    
                    
                    orderModel *model = [orderModel new];
                    model.number = [dic stringForKey:@"order_no"];
                    model.orderId = [dic stringForKey:@"id"];
                    model.clothesName = [[[dic arrayForKey:@"list"] firstObject] stringForKey:@"goods_name"];
                    model.clothesImg = [[[dic arrayForKey:@"list"] firstObject] stringForKey:@"goods_thumb"];
                    if ([dic integerForKey:@"comment_id"] == 0) {
                        model.ifCommend = YES;
                    }else {
                        model.ifCommend = NO;
                    }
                    if ([[[[dic arrayForKey:@"list"] firstObject] stringForKey:@"size_content"] length] > 0) {
                         model.sizeContnt = [[[dic arrayForKey:@"list"] firstObject] stringForKey:@"size_content"];
                    } else {
                        model.sizeContnt = @"定制款";
                    
                    }
                    
                   
                    model.clothesPrice = [dic stringForKey:@"money"];
                    NSInteger count = 0;
                    for (NSDictionary *dice in [dic arrayForKey:@"list"]) {
                        count = [dice integerForKey:@"num"] + count;
                    }
                    model.clothesCount = [NSString stringWithFormat:@"%ld", count];
                    model.clothesStatus = [dic integerForKey:@"status"];
                    switch ([dic integerForKey:@"status"]) {
                        case 1:
                            model.clothesBuyStatus = @"待付款";
                            break;
                        case 2:
                            model.clothesBuyStatus = @"已付款";
                            break;
                        case 3:
                            model.clothesBuyStatus = @"已发货";
                            break;
                        case 4:
                            model.clothesBuyStatus = @"已完成";
                            break;
                        case -2:
                            model.clothesBuyStatus = @"已取消";
                            break;
                        default:
                            break;
                    }
                    
                    [modelArray addObject:model];
                    
                }
                
                [self createHaveOrderView];
                
                
            }else {
                [self createViewNoDD];
            }
        }
            
           
                
               
    }];
    
}


-(void)reloadTableData
{
    [modelArray removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"0" forKey:@"status"];
    [params setObject:@"1" forKey:@"page"];
    [getData getData:URL_GetOrderNew PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:getData]) {
            dataArray = [NSMutableArray arrayWithArray:[[getData.dataRoot objectForKey:@"data"] arrayForKey:@"data"]];
             
            if (dataArray > 0) {
                for (NSMutableDictionary *dic in dataArray) {
                    
                    
                    orderModel *model = [orderModel new];
                    model.number = [dic stringForKey:@"order_no"];
                    model.orderId = [dic stringForKey:@"id"];
                    model.clothesName = [[[dic arrayForKey:@"list"] firstObject] stringForKey:@"goods_name"];
                    model.clothesImg = [[[dic arrayForKey:@"list"] firstObject] stringForKey:@"goods_thumb"];
                    model.sizeContnt = [[[dic arrayForKey:@"list"] firstObject] stringForKey:@"size_content"];
                    model.clothesPrice = [dic stringForKey:@"money"];
                    NSInteger count = 0;
                    for (NSDictionary *dice in [dic arrayForKey:@"list"]) {
                        count = [dice integerForKey:@"num"] + count;
                    }
                    if ([[[[dic arrayForKey:@"list"] firstObject] stringForKey:@"size_content"] length] > 0) {
                        model.sizeContnt = [[[dic arrayForKey:@"list"] firstObject] stringForKey:@"size_content"];
                    } else {
                        model.sizeContnt = @"定制款";
                        
                    }
                    
                    if ([dic integerForKey:@"comment_id"] == 0) {
                        model.ifCommend = YES;
                    }else {
                        model.ifCommend = NO;
                    }
                    
                    model.clothesCount = [NSString stringWithFormat:@"%ld", count];
                    model.clothesStatus = [dic integerForKey:@"status"];
                    switch ([dic integerForKey:@"status"]) {
                        case 1:
                            model.clothesBuyStatus = @"待付款";
                            break;
                        case 2:
                            model.clothesBuyStatus = @"已付款";
                            break;
                        case 3:
                            model.clothesBuyStatus = @"已发货";
                            break;
                        case 4:
                            model.clothesBuyStatus = @"已完成";
                            break;
                        case -2:
                            model.clothesBuyStatus = @"已取消";
                            break;
                        default:
                            break;
                    }
                    
                    [modelArray addObject:model];
                    
                }
                
                [haveDingTable reloadData];
                
                
            } else {
                [haveDingTable removeFromSuperview];
                [self createViewNoDD];
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
    haveDingTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 41 - 64) style:UITableViewStyleGrouped];
    haveDingTable.dataSource = self;
    haveDingTable.delegate = self;
    [haveDingTable setBackgroundColor:getUIColor(Color_myOrderBack)];
    [haveDingTable registerClass:[cashTransactionSuccessTableViewCell class] forCellReuseIdentifier:@"ordersuccess"];
    [haveDingTable registerClass:[waitForPayTableViewCell class] forCellReuseIdentifier:@"orderWaitForPay"];
    [haveDingTable registerClass:[waitForSendTableViewCell class] forCellReuseIdentifier:@"orderWaitForSend"];
    [haveDingTable registerClass:[HaveDoneTableViewCell class] forCellReuseIdentifier:@"orderDoneForSend"];
    haveDingTable.showsVerticalScrollIndicator = NO;
    haveDingTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:haveDingTable];
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
    UITableViewCell *resCell;
    
    orderModel *model = modelArray[indexPath.section];
    if (model.clothesStatus == 3) {
        cashTransactionSuccessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ordersuccess" forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.model = modelArray[indexPath.section];
        [cell.logistics setTag:indexPath.section + 1000];
        [cell.logistics addTarget:self action:@selector(WuLiuClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.confirm setTag:indexPath.section+1500];
        [cell.confirm addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
        resCell = cell;
    }else if(model.clothesStatus == 1) {
        waitForPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderWaitForPay" forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.model = modelArray[indexPath.section];
        cell.tag = 100 + indexPath.section;
        cell.delegate = self;
        resCell = cell;
    } else if (model.clothesStatus == 2) {
        waitForSendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderWaitForSend" forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.woring setTag:indexPath.section + 500];
        [cell.woring addTarget:self action:@selector(woringOrDelegateClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.model = modelArray[indexPath.section];
        
        resCell = cell;
    } else if (model.clothesStatus == -2) {
        waitForSendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderWaitForSend" forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.woring.tag = indexPath.section + 500;
        cell.model = modelArray[indexPath.section];
        
        [cell.woring addTarget:self action:@selector(woringOrDelegateClick:) forControlEvents:UIControlEventTouchUpInside];
        resCell = cell;

    }else if (model.clothesStatus == 4) {
        HaveDoneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderDoneForSend" forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.commendBtn.tag = indexPath.section + 5000;
        [cell.commendBtn addTarget:self action:@selector(commendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.model = modelArray[indexPath.section];
        
     
        resCell = cell;
        
    }
    [resCell setBackgroundColor:[UIColor whiteColor]];
    return resCell;
}

-(void)commendBtnClick:(UIButton *)sender
{
    orderModel *model = modelArray[sender.tag - 5000];
     HaveDoneViewController *orderDetail = [[HaveDoneViewController alloc] init];
    orderDetail.orderId = model.orderId;
    orderDetail.canCommend = model.ifCommend;
    [self.navigationController pushViewController:orderDetail animated:YES];
}

-(void)WuLiuClick:(UIButton *)sender
{
    orderModel *model = modelArray[sender.tag - 1000];
    orderDetailHaveSendViewController *orderDetail = [[orderDetailHaveSendViewController alloc] init];
    orderDetail.orderId = model.orderId;
    [self.navigationController pushViewController:orderDetail animated:YES];
}

-(void)confirmClick:(UIButton *)sender
{
    orderModel *model = modelArray[sender.tag - 1500];
    orderDetailHaveSendViewController *orderDetail = [[orderDetailHaveSendViewController alloc] init];
    orderDetail.orderId = model.orderId;
    [self.navigationController pushViewController:orderDetail animated:YES];
}

-(void)woringOrDelegateClick:(UIButton *)sender
{
    orderModel *model = modelArray[sender.tag - 500];

    
    if (model.clothesStatus == 2) {
        [self alertViewShowOfTime:@"提醒卖家发货成功" time:1.5];

    } else {
        
        
        deleteAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定取消订单吗" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        deleteAlert.tag = sender.tag;
        [deleteAlert show];
        
        
        
    }
}

-(void)deleteOrder:(NSNotification *)noti
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:[noti.userInfo stringForKey:@"id"] forKey:@"order_id"];
    
    
    [self showAlert];
    
    [getData getData:URL_CancelOrder PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:getData]) {
            
        }
        
    }];
}

-(void)showAlert
{
//    tipView=[[AwTipView alloc]initWithTipStyle:AwTipViewStyleAnnularDeterminate inView:self.view title:nil message:@"正在为您服务.." posY:0];
//   
//    tipView.dimBackground=YES;
//    [tipView showAnimated:YES];
}

//- (void)doSomeWorkWithProgressWith:(UIView *)view {
//    canceled = NO;
//    // This just increases the progress indicator in a loop.
//    float progress = 0.0f;
//    while (progress < 1.0f) {
//        if (canceled) break;
//        progress += 0.01f;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // Instead we could have also passed a reference to the HUD
//            // to the HUD to myProgressTask as a method parameter.
//            AwTipView *tipView=[AwTipView HUDForView:view];
//            //            NSLog(@"%@",@(progress));
//            tipView.progress = progress;
//        });
//        usleep(50000);
//    }
//}

-(void)clickItem:(NSInteger)item :(NSInteger)type
{
    
    orderModel *model = modelArray[item - 100];
    
    if (type == 1) {
        

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定取消订单吗" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alert.tag = item;
        [alert show];
        
    } else if (type == 2) {
        orderDetailViewController *orderDetail = [[orderDetailViewController alloc] init];
        orderDetail.orderId = model.orderId;
        [self.navigationController pushViewController:orderDetail animated:YES];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (alertView == deleteAlert) {
            orderModel *model = modelArray[alertView.tag - 500];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            
            [params setObject:model.orderId forKey:@"order_id"];
            [self showAlert];
            [getData getData:URL_DeleteOrder PostParams:params finish:^(BaseDomain *domain, Boolean success) {
                
                if ([self checkHttpResponseResultStatus:getData]) {
                    [self reloadTable];
                    [self alertViewShowOfTime:@"删除成功" time:1.5];
                    
                }
                
            }];
        } else {
            orderModel *model = modelArray[alertView.tag - 100];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:model.orderId forKey:@"order_id"];
            [getData getData:URL_CancelOrder PostParams:params finish:^(BaseDomain *domain, Boolean success) {
                
                if ([self checkHttpResponseResultStatus:getData]) {
                    
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
    
    if (model.clothesStatus == 1) {
        orderDetailViewController *orderDetail = [[orderDetailViewController alloc] init];
        orderDetail.orderId = model.orderId;
        [self.navigationController pushViewController:orderDetail animated:YES];
    } else if (model.clothesStatus == 2) { // 未发货
        orderDetailForHavePayedViewController *orderDetail = [[orderDetailForHavePayedViewController alloc] init];
        orderDetail.orderId = model.orderId;
        [self.navigationController pushViewController:orderDetail animated:YES];
    } else if (model.clothesStatus == 3) { //已发货
        orderDetailHaveSendViewController *orderDetail = [[orderDetailHaveSendViewController alloc] init];
        orderDetail.orderId = model.orderId;
        [self.navigationController pushViewController:orderDetail animated:YES];
    } else if (model.clothesStatus == 4) { //已完成
        HaveDoneViewController *orderDetail = [[HaveDoneViewController alloc] init];
        orderDetail.canCommend = model.ifCommend;
        orderDetail.orderId = model.orderId;
        [self.navigationController pushViewController:orderDetail animated:YES];
    } else if (model.clothesStatus == -2) {
        orderDetailViewController *orderDetail = [[orderDetailViewController alloc] init];
        orderDetail.orderId = model.orderId;
        [self.navigationController pushViewController:orderDetail animated:YES];
    }
    
}

-(void)reloadTable
{
    [modelArray removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"0" forKey:@"status"];
    [params setObject:@"1" forKey:@"page"];
    [getData getData:URL_GetOrderNew PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:getData]) {
            dataArray = [NSMutableArray arrayWithArray:[[getData.dataRoot objectForKey:@"data"] arrayForKey:@"data"]];
            
            if ([dataArray count] > 0) {
                for (NSMutableDictionary *dic in dataArray) {
                    
                    
                    orderModel *model = [orderModel new];
                    model.number = [dic stringForKey:@"order_no"];
                    model.orderId = [dic stringForKey:@"id"];
                    model.clothesName = [[[dic arrayForKey:@"list"] firstObject] stringForKey:@"goods_name"];
                    model.clothesImg = [[[dic arrayForKey:@"list"] firstObject] stringForKey:@"goods_thumb"];
                    model.sizeContnt = [[[dic arrayForKey:@"list"] firstObject] stringForKey:@"size_content"];
                    model.clothesPrice = [dic stringForKey:@"money"];
                    NSInteger count = 0;
                    for (NSDictionary *dice in [dic arrayForKey:@"list"]) {
                        count = [dice integerForKey:@"num"] + count;
                    }
                    
                    if ([[[[dic arrayForKey:@"list"] firstObject] stringForKey:@"size_content"] length] > 0) {
                        model.sizeContnt = [[[dic arrayForKey:@"list"] firstObject] stringForKey:@"size_content"];
                    } else {
                        model.sizeContnt = @"定制款";
                        
                    }
                    
                    if ([dic integerForKey:@"comment_id"] == 0) {
                        model.ifCommend = YES;
                    }else {
                        model.ifCommend = NO;
                    }
                    model.clothesCount = [NSString stringWithFormat:@"%ld", count];
                    model.clothesStatus = [dic integerForKey:@"status"];
                    switch ([dic integerForKey:@"status"]) {
                        case 1:
                            model.clothesBuyStatus = @"待付款";
                            break;
                        case 2:
                            model.clothesBuyStatus = @"已付款";
                            break;
                        case 3:
                            model.clothesBuyStatus = @"已发货";
                            break;
                        case 4:
                            model.clothesBuyStatus = @"已完成";
                            break;
                        case -2:
                            model.clothesBuyStatus = @"已取消";
                            break;
                        default:
                            break;
                    }
                    
                    [modelArray addObject:model];
                    
                }
                
                [haveDingTable reloadData];
            } else {
                [haveDingTable removeFromSuperview];
                [self createViewNoDD];
            }
            
            
                
        }
        
        
        
    }];
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
