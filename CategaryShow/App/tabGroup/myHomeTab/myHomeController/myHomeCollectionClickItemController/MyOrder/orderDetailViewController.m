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
#import "myBagModel.h"
#import "payForView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "OrderAddressTableViewCell.h"
#import "Order.h"
#import "DataSigner.h"
#import "WXApi.h"
#import "PayInfoTableViewCell.h"
@interface orderDetailViewController ()<UITableViewDelegate, UITableViewDataSource, payForViewDelegate>

@end

@implementation orderDetailViewController
{
    UITableView *orderDetailTable;
    BaseDomain *getData;
    NSMutableDictionary *orderDetail;
    NSMutableArray *modelArray;
    payForView *payView;
    UIImageView *imageAlpha;
    BaseDomain *postData;
    NSInteger count;
    BOOL ZFB;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    modelArray = [NSMutableArray array];
    getData = [BaseDomain getInstance:NO];
    postData = [BaseDomain getInstance:NO];
    [self settabTitle:@"订单详情"];
    ZFB = YES;
    orderDetail = [NSMutableDictionary dictionary];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PaySuccessAction) name:@"PaySuccess" object:nil];
    
    [self getDatas];
    [self createTableView];
    // Do any additional setup after loading the view.
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_orderId forKey:@"id"];
    [getData getData:URL_GetOrderDetail PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:getData]) {
            orderDetail = [NSMutableDictionary dictionaryWithDictionary:[getData.dataRoot dictionaryForKey:@"data"]];
            [self performSelectorInBackground:@selector(thread) withObject:nil];
            for (NSDictionary *dic in [orderDetail arrayForKey:@"car_list"]) {
                myBagModel *model = [myBagModel new];
                model.clothesImg = [dic stringForKey:@"goods_thumb"];
                model.clothesName = [dic stringForKey:@"goods_name"];
                model.clothesCount = [dic stringForKey:@"num"];
                model.clothesPrice = [dic stringForKey:@"price"];
                if ([[dic stringForKey:@"size_content"] length] > 0) {
                    model.sizeOrDing = [dic stringForKey:@"size_content"];
                } else {
                    model.sizeOrDing = @"定制款";
                }
                [modelArray addObject:model];
            }
            [orderDetailTable reloadData];
            [self createLowView];
            [self createPayView];
        }
    }];
}

- (void)thread
{
    for(int i=[orderDetail integerForKey:@"last_time"];i>=0;i--)
    {
        count = i;
        // 回调主线程
        [self performSelectorOnMainThread:@selector(mainThread) withObject:nil waitUntilDone:YES];
        sleep(1);
    }
}

- (void)mainThread
{
    
    [orderDetail setObject:[NSString stringWithFormat:@"%ld", count] forKey:@"last_time"];
    [orderDetailTable reloadData];
    if (count==0) {
        [self.navigationController popViewControllerAnimated:YES];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:_orderId forKey:@"id"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"orderDelete" object:nil userInfo:dic];
        
    }
}

-(void)createTableView
{
    
    orderDetailTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH , SCREEN_HEIGHT - 84 - 49) style:UITableViewStyleGrouped];
    if (@available(iOS 11.0, *)) {
        orderDetailTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
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
    if ([orderDetail integerForKey:@"last_time"] < 0) {
        
        UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64 - 49, SCREEN_WIDTH, 49)];
        [self.view addSubview:deleteButton];
        [deleteButton setBackgroundColor:getUIColor(Color_DZClolor)];
        [deleteButton setTitle:@"删除订单" forState:UIControlStateNormal];
        [deleteButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [deleteButton addTarget:self action:@selector(deleteOrder) forControlEvents:UIControlEventTouchUpInside];
        
    } else {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT -64- 49, SCREEN_WIDTH, 49)];
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
    }
    
}

-(void)deleteOrder
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_orderId forKey:@"order_id"];
    [getData getData:URL_DeleteOrder PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:getData]) {
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
        [params setObject:_orderId forKey:@"order_id"];
        [getData getData:URL_CancelOrder PostParams:params finish:^(BaseDomain *domain, Boolean success) {
            
            if ([self checkHttpResponseResultStatus:getData]) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelOrderAll" object:nil];
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
    payView.price = [orderDetail  stringForKey:@"money"];
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
    if (ZFB) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:_orderId forKey:@"order_id"];
        [params setObject:@"1" forKey:@"pay_type"];
        NSString *appScheme = @"CloudFactory";
        [postData postData:URL_APAY PostParams:params finish:^(BaseDomain *domain, Boolean success) {
            
            NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
            [userd setObject:[domain.dataRoot stringForKey:@"pay_code"] forKey:@"payId"];
            [[AlipaySDK defaultService] payOrder:[domain.dataRoot stringForKey:@"data"] fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
                
                
            }];
            
            
        }];

    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:_orderId forKey:@"order_id"];
        [params setObject:@"2" forKey:@"pay_type"];
        
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

-(void)PaySuccessAction
{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"turnToOrder" object:nil];
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







//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if (section == 1) {
//        
//        if ([orderDetail integerForKey:@"last_time"] < 0) {
//            return nil;
//        } else {
//            UIView *LowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 43)];
//            [LowView setBackgroundColor:[UIColor whiteColor]];
//            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH -20, 1)];
//            [lineView setBackgroundColor:getUIColor(Color_myOrderBack)];
//            [LowView addSubview:lineView];
//            
//            
//            
//            UIButton *payFor = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20 - 68 - 10, 8, 68, 28)];
//            [payFor setTitle:@"付款" forState:UIControlStateNormal];
//            [payFor addTarget:self action:@selector(payForClick) forControlEvents:UIControlEventTouchUpInside];
//            [payFor.titleLabel setFont:[UIFont systemFontOfSize:12]];
//            [payFor.layer setCornerRadius:1];
//            [payFor.layer setMasksToBounds:YES];
//            [payFor setTitleColor:getUIColor(Color_myOrderPayForAndPrice) forState:UIControlStateNormal];
//            [payFor.layer setBorderColor:getUIColor(Color_myOrderPayForAndPrice).CGColor];
//            [payFor.layer setBorderWidth:1];
//            [LowView addSubview:payFor];
//            
//            return LowView;
//
//        }
//        
//        
//    } else return nil;
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 33)];
        [topView setBackgroundColor:[UIColor whiteColor]];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 32, SCREEN_WIDTH -20, 1)];
        [lineView setBackgroundColor:getUIColor(Color_myOrderBack)];
        [topView addSubview:lineView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, SCREEN_WIDTH - 30, 20)];
        [label setText:[NSString stringWithFormat:@"订单编号:%@", [orderDetail stringForKey:@"order_no"]]];
        [label setFont:Font_12];
        
        
        UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 7, 65, 20)];
        
        if ([orderDetail integerForKey:@"last_time"] < 0) {
             [stateLabel setText:@"已取消"];
        } else {
             [stateLabel setText:@"待付款"];
        }
        
        
       
        [stateLabel setTextAlignment:NSTextAlignmentRight];
        [topView addSubview:stateLabel];
        [stateLabel setFont:Font_13];
        
        [topView addSubview:label];
        return topView;

    } else return [UIView new];
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
        return 33;
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
    return 112;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *reCell ;
    
    if (indexPath.section == 0) {
        MyOrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderDetail" forIndexPath:indexPath];

        if ([orderDetail integerForKey:@"last_time"] < 0) {
            [cell.orderStatus setText:@"已取消"];
        } else {
            [cell.orderStatus setText:[NSString stringWithFormat:@"请在%d分%d秒内完成支付,超时订单自动关闭",[orderDetail integerForKey:@"last_time"] / 60,[orderDetail integerForKey:@"last_time"]%60]];
        }
        

        [cell.orderCreateTime setText:[NSString stringWithFormat:@"%@",[orderDetail stringForKey:@"c_time"]]];
        [cell.orderPayTime setText:@"支付时间:"];
        reCell = cell;
    }else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            OrderAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderDetailAddress" forIndexPath:indexPath];
            [cell.lineView setHidden:NO];
            [cell.userName setText:[orderDetail stringForKey:@"name"]];
            [cell.userPhone setText:[orderDetail stringForKey:@"phone"]];
            [cell.userAddress setText:[NSString stringWithFormat:@"%@%@%@%@",[orderDetail stringForKey:@"province"],[orderDetail stringForKey:@"city"],[orderDetail stringForKey:@"area"],[orderDetail stringForKey:@"address"] ]];
            
            reCell = cell;
        } else {
            PayInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payInfo" forIndexPath:indexPath];
            
            if ([orderDetail integerForKey:@"last_time"] < 0) {
                 [cell.payType setText:@" 已取消"];
            } else {
                 [cell.payType setText:@" 待付款"];
            }
           
            
            [cell.couponMoney setText:[NSString stringWithFormat:@"￥%@", [orderDetail stringForKey:@"ticket_money"]]];
            [cell.payMoney setText:[NSString stringWithFormat:@"¥%@",  [orderDetail stringForKey:@"money"]]];
            reCell = cell;
        }
       
    } else {
        MyOrderDetailListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderDetailList" forIndexPath:indexPath];
        myBagModel *model = modelArray[indexPath.row];
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
