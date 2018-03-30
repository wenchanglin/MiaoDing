//
//  HaveDoneViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/11/29.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "HaveDoneViewController.h"
#import "MyOrderDetailTableViewCell.h"
#import "MyOrderDetailListTableViewCell.h"
#import "myBagModel.h"
#import "OrderAddressTableViewCell.h"
#import "PayInfoTableViewCell.h"
#import "searchWuLiuViewController.h"
#import "OrderHavePayTableViewCell.h"
#import "commentViewController.h"
@interface HaveDoneViewController ()<UITableViewDelegate, UITableViewDataSource>


@end

@implementation HaveDoneViewController

{
    UITableView *orderDetailTable;
    BaseDomain *getData;
    NSMutableDictionary *orderDetail;
    NSMutableArray *modelArray;
    UIButton *commendButton;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    modelArray = [NSMutableArray array];
    getData = [BaseDomain getInstance:NO];
    [self settabTitle:@"订单详情"];
    orderDetail = [NSMutableDictionary dictionary];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successComm) name:@"commentSuccess" object:nil];
    [self.view setBackgroundColor:getUIColor(Color_myOrderBack)];
    [self getDatas];
    [self createTableView];
    // Do any additional setup after loading the view.
}

-(void)successComm
{
    [commendButton removeFromSuperview];
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
    orderDetailTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH , SCREEN_HEIGHT - 153) style:UITableViewStyleGrouped];
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
    
    if (_canCommend) {
        commendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT -64- 49, SCREEN_WIDTH, 49)];
        [self.view addSubview:commendButton];
        [commendButton setBackgroundColor:getUIColor(Color_DZClolor)];
        [commendButton setTitle:@"立即评价" forState:UIControlStateNormal];
        [commendButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [commendButton addTarget:self action:@selector(commendButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

-(void)commendButtonClick
{
    commentViewController *comment = [[commentViewController alloc] init];
    comment.goodsDic = [[orderDetail arrayForKey:@"car_list"] firstObject];
    
    comment.orderId = _orderId;
    [self.navigationController pushViewController:comment animated:YES];
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
        [stateLabel setText:@"已完成"];
        [stateLabel setTextAlignment:NSTextAlignmentRight];
        [topView addSubview:stateLabel];
        [stateLabel setFont:Font_13];
        
        [topView addSubview:label];
        return topView;
        
    } else return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 7;
    }else if(section == 2) {
        return 33;
    }else return 0.001;
}



-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
   
  
     if(section == 0) {
        return 7;
     } else if (section == 1) {
         return 7;
         
     }
    return 0.001;
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
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
