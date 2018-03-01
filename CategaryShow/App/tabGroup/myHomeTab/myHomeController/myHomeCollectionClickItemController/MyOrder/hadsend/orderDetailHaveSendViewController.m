//
//  orderDetailHaveSendViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/27.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "orderDetailHaveSendViewController.h"
#import "MyOrderDetailTableViewCell.h"
#import "MyOrderDetailListTableViewCell.h"
#import "myBagModel.h"
#import "OrderAddressTableViewCell.h"
#import "PayInfoTableViewCell.h"
#import "searchWuLiuViewController.h"
#import "OrderHavePayTableViewCell.h"
@interface orderDetailHaveSendViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation orderDetailHaveSendViewController
{
    UITableView *orderDetailTable;
    BaseDomain *getData;
    NSMutableDictionary *orderDetail;
    NSMutableArray *modelArray;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    modelArray = [NSMutableArray array];
    getData = [BaseDomain getInstance:NO];
    self.title = @"订单详情";
    orderDetail = [NSMutableDictionary dictionary];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [topView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:topView];
    
    [self.view setBackgroundColor:getUIColor(Color_myOrderBack)];
    [self getDatas];
    [self createTableView];
    // Do any additional setup after loading the view.
}

-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_orderId forKey:@"id"];
    [getData getData:URL_GetOrderDetail PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:getData]) {
            
            orderDetail = [NSMutableDictionary dictionaryWithDictionary:[getData.dataRoot dictionaryForKey:@"data"]];
            
            
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
            
            
        }
        
    }];
}

-(void)createTableView
{
    orderDetailTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 74, SCREEN_WIDTH, SCREEN_HEIGHT - 84) style:UITableViewStyleGrouped];
    orderDetailTable.dataSource = self;
    orderDetailTable.delegate = self;
    [orderDetailTable setBackgroundColor:getUIColor(Color_myOrderBack)];
    orderDetailTable.showsVerticalScrollIndicator = NO;
    orderDetailTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [orderDetailTable registerClass:[OrderHavePayTableViewCell class] forCellReuseIdentifier:@"orderDetail"];
    [orderDetailTable registerClass:[MyOrderDetailListTableViewCell class] forCellReuseIdentifier:@"orderDetailList"];
    [orderDetailTable registerClass:[OrderAddressTableViewCell class] forCellReuseIdentifier:@"orderDetailAddress"];
    [orderDetailTable registerClass:[PayInfoTableViewCell class] forCellReuseIdentifier:@"orderDetailPayInfo"];
    
    
    
    [self.view addSubview:orderDetailTable];
}

-(void)worningClick
{
    searchWuLiuViewController *search = [[searchWuLiuViewController alloc] init];
    search.ems_com = [orderDetail stringForKey:@"ems_com"];
    search.ems_no = [orderDetail stringForKey:@"ems_no"];
    search.ems_com_name = [orderDetail stringForKey:@"ems_com_name"];
    [self.navigationController pushViewController:search animated:YES];
}

-(void)conFirmClick
{
    
//    NSArray *buttons = [NSArray arrayWithObjects:@"确定", @"取消", nil] ;
//    
//    
//    STAlertView *alert = [[STAlertView alloc] initWithTitle:@"提示"image:[UIImage imageNamed:@""] message:@"确认收货吗？"buttonTitles:buttons];
//    
//    alert.hideWhenTapOutside = YES;
//    [alert setDidShowHandler:^{
//        NSLog(@"显示了");
//    }];
//    [alert setDidHideHandler:^{
//        NSLog(@"消失了");
//    }];
//    [alert setActionHandler:^(NSInteger index) {
//        
//        if (index == 0) {
//            NSMutableDictionary *params = [NSMutableDictionary dictionary];
//            [params setObject:_orderId forKey:@"order_id"];
//            [getData getData:URL_ConfirmOrder PostParams:params finish:^(BaseDomain *domain, Boolean success) {
//                
//                if ([self checkHttpResponseResultStatus:getData]) {
//                    
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"confirm" object:nil];
//                    [self.navigationController popViewControllerAnimated:YES];
//                    
//                }
//                
//            }];
//        }
//        
//    }];
//    
//    [alert show:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认收货吗" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:_orderId forKey:@"order_id"];
        [getData getData:URL_ConfirmOrder PostParams:params finish:^(BaseDomain *domain, Boolean success) {

            if ([self checkHttpResponseResultStatus:getData]) {

                [[NSNotificationCenter defaultCenter] postNotificationName:@"confirm" object:nil];
                [self.navigationController popViewControllerAnimated:YES];

            }
            
        }];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.001;
    }else if(section == 2) {
        return 33;
    }else return 0.001;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        UIView *LowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 43)];
        [LowView setBackgroundColor:[UIColor whiteColor]];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        [lineView setBackgroundColor:getUIColor(Color_myOrderBack)];
        [LowView addSubview:lineView];
        
        
        
        UIButton *confirm = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 68, 8, 68, 28)];
        [confirm setTitle:@"确认收货" forState:UIControlStateNormal];
        [confirm addTarget:self action:@selector(conFirmClick) forControlEvents:UIControlEventTouchUpInside];
        [confirm.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [confirm.layer setCornerRadius:1];
        [confirm.layer setMasksToBounds:YES];
        [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirm setBackgroundColor:[UIColor blackColor]];
        [LowView addSubview:confirm];
        
        
        UIButton *worningSendClothes = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 68 - 68 - 10, 8, 68, 28)];
        [worningSendClothes setTitle:@"查看物流" forState:UIControlStateNormal];
        [worningSendClothes addTarget:self action:@selector(worningClick) forControlEvents:UIControlEventTouchUpInside];
        [worningSendClothes.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [worningSendClothes.layer setCornerRadius:3];
        [worningSendClothes.layer setMasksToBounds:YES];
        [worningSendClothes setTitleColor:getUIColor(Color_buyColor) forState:UIControlStateNormal];
        [worningSendClothes.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [worningSendClothes.layer setBorderWidth:1];
        [LowView addSubview:worningSendClothes];
        
        
        return LowView;
        
    } else return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 43;
    } else if(section == 0) {
        return 7;
    }else
        return 7;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1) {
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 33)];
        [topView setBackgroundColor:[UIColor whiteColor]];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 32, SCREEN_WIDTH -20, 1)];
        [lineView setBackgroundColor:getUIColor(Color_myOrderBack)];
        [topView addSubview:lineView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, SCREEN_WIDTH - 30, 20)];
        [label setText:[NSString stringWithFormat:@"订单编号：%@", [orderDetail stringForKey:@"order_no"]]];
        [label setFont:[UIFont systemFontOfSize:13]];
        
        
        UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 7, 65, 20)];
        [stateLabel setText:@"已发货"];
        [stateLabel setTextAlignment:NSTextAlignmentRight];
        [topView addSubview:stateLabel];
        [stateLabel setFont:Font_13];
        
        [topView addSubview:label];
        return topView;
        
    } else return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *reCell ;
    
    if (indexPath.section == 0) {
        OrderHavePayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderDetail" forIndexPath:indexPath];
        
        
        [cell.orderCreateTime setText:[NSString stringWithFormat:@"%@",[orderDetail stringForKey:@"c_time"]]];
        [cell.orderPayTime setText:[NSString stringWithFormat:@"%@",[orderDetail stringForKey:@"p_time"]]];
        reCell = cell;
    } else if (indexPath.section == 2){
        MyOrderDetailListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderDetailList" forIndexPath:indexPath];
        myBagModel *model = modelArray[indexPath.row];
        cell.model = model;
        reCell = cell;
        
    } else if (indexPath.section == 1) {
        UITableViewCell *CellLow;
        if (indexPath.row == 0) {
            OrderAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderDetailAddress" forIndexPath:indexPath];
            [cell.userName setText:[orderDetail stringForKey:@"name"]];
            [cell.userPhone setText:[orderDetail stringForKey:@"phone"]];
            [cell.userAddress setText:[NSString stringWithFormat:@"%@%@%@%@",[orderDetail stringForKey:@"province"],[orderDetail stringForKey:@"city"],[orderDetail stringForKey:@"area"],[orderDetail stringForKey:@"address"] ]];
            CellLow = cell;
        } else {
            PayInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderDetailPayInfo" forIndexPath:indexPath];
            
            if ([orderDetail integerForKey:@"pay_type"] == 1) {
                [cell.payType setText:@"支付宝"];
            } else {
                [cell.payType setText:@"微信"];
            }
            [cell.couponMoney setText:[NSString stringWithFormat:@"￥%@", [orderDetail stringForKey:@"ticket_money"]]];
            [cell.payMoney setText:[NSString stringWithFormat:@"¥%@",  [orderDetail stringForKey:@"money"]]];
            CellLow = cell;
        }
        
        reCell = CellLow;
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
