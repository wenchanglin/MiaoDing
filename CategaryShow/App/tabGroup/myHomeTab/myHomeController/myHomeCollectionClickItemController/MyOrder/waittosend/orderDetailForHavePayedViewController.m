//
//  orderDetailForHavePayedViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/27.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "orderDetailForHavePayedViewController.h"

#import "MyOrderDetailTableViewCell.h"
#import "MyOrderDetailListTableViewCell.h"
#import "myBagModel.h"
#import "OrderAddressTableViewCell.h"
#import "PayInfoTableViewCell.h"
#import "OrderHavePayTableViewCell.h"
@interface orderDetailForHavePayedViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation orderDetailForHavePayedViewController

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
    [self settabTitle:@"订单详情"];
    orderDetail = [NSMutableDictionary dictionary];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [topView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:topView];
    
    [self.view setBackgroundColor:getUIColor(Color_myOrderBack)];
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
    orderDetailTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 84) style:UITableViewStyleGrouped];
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
    [orderDetailTable registerClass:[OrderHavePayTableViewCell class] forCellReuseIdentifier:@"orderDetail"];
    [orderDetailTable registerClass:[MyOrderDetailListTableViewCell class] forCellReuseIdentifier:@"orderDetailList"];
    [orderDetailTable registerClass:[OrderAddressTableViewCell class] forCellReuseIdentifier:@"orderDetailAddress"];
    [orderDetailTable registerClass:[PayInfoTableViewCell class] forCellReuseIdentifier:@"orderDetailPayInfo"];
    [self.view addSubview:orderDetailTable];
}

-(void)worningClick
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提醒厂家发货发送消息成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
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
        [label setFont:Font_12];
        
        
        UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 7, 65, 20)];
        [stateLabel setText:@"待发货"];
        [stateLabel setTextAlignment:NSTextAlignmentRight];
        [topView addSubview:stateLabel];
        [stateLabel setFont:Font_13];
        
        [topView addSubview:label];
        return topView;
        
    } else return [UIView new];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 7;
    }else if(section == 2) {
        return 33;
    }else return 7;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        UIView *LowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 43)];
        [LowView setBackgroundColor:[UIColor whiteColor]];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH -20, 1)];
        [lineView setBackgroundColor:getUIColor(Color_myOrderBack)];
        [LowView addSubview:lineView];
        
        
        UIButton *worningSendClothes = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 68, 8, 68, 28)];
        [worningSendClothes setTitle:@"提醒发货" forState:UIControlStateNormal];
        [worningSendClothes addTarget:self action:@selector(worningClick) forControlEvents:UIControlEventTouchUpInside];
        [worningSendClothes.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [worningSendClothes.layer setCornerRadius:1];
        [worningSendClothes.layer setMasksToBounds:YES];
        [worningSendClothes setTitleColor:getUIColor(Color_buyColor) forState:UIControlStateNormal];
        [worningSendClothes.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [worningSendClothes.layer setBorderWidth:1];
        [LowView addSubview:worningSendClothes];
        
        return LowView;

    } else return [UIView new];
}



-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 43;
    } else if(section == 0) {
        return 0;
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
        } else {
             return 100;
        }
    }return 112;
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
            [cell.payMoney setText:[NSString stringWithFormat:@"￥%@",  [orderDetail stringForKey:@"money"]]];
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
