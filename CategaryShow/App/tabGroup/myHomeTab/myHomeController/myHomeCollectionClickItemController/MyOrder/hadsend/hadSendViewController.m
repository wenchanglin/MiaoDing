//
//  hadSendViewController.m
//  CategaryShow
//
//  Created by APPLE on 16/9/17.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "hadSendViewController.h"
#import "cashTransactionSuccessTableViewCell.h"
#import "orderModel.h"




#import "orderDetailHaveSendViewController.h"
@interface hadSendViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation hadSendViewController
{
    UIView *bgNoDingView;   //没有订单界面底层
    UITableView *haveDingTable;  //有订单的table
    NSMutableArray *modelArray;
    NSMutableArray *dataArray;
    BaseDomain *getData;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    getData = [BaseDomain getInstance:NO];
    [self.view setBackgroundColor:getUIColor(Color_myOrderBack)];
    modelArray = [NSMutableArray array];
    dataArray = [NSMutableArray array];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableData) name:@"PaySuccess" object:nil];
    
    //    [self createViewNoDD];
   
    [self getDatas];
    // Do any additional setup after loading the view.
}

-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"3" forKey:@"status"];
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
                    
                    model.clothesBuyStatus = @"已发货";
                    
                    
                    [modelArray addObject:model];
                    
                }
                
                [self createHaveOrderView];
                
            } else {
                [self createViewNoDD];
            }
        }
        
    }];
    
}


-(void)reloadTableData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"3" forKey:@"status"];
    [getData getData:URL_GetOrder PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:getData]) {
            dataArray = [NSMutableArray arrayWithArray:[getData.dataRoot arrayForKey:@"data"]];
            [modelArray removeAllObjects];

            if ([dataArray count] > 0) {
                
                for (NSMutableDictionary *dic in dataArray) {
                    
                    
                    orderModel *model = [orderModel new];
                    model.number = [dic stringForKey:@"order_no"];
                    model.orderId = [dic stringForKey:@"id"];
                    model.clothesName = [[[dic arrayForKey:@"list"] firstObject] stringForKey:@"goods_name"];
                    model.clothesImg = [[[dic arrayForKey:@"list"] firstObject] stringForKey:@"goods_thumb"];
                    model.clothesPrice = [dic stringForKey:@"money"];
                    NSInteger count = 0;
                    if ([[[[dic arrayForKey:@"list"] firstObject] stringForKey:@"size_content"] length] > 0) {
                        model.sizeContnt = [[[dic arrayForKey:@"list"] firstObject] stringForKey:@"size_content"];
                    } else {
                        model.sizeContnt = @"定制款";
                        
                    }
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
    bgNoDingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , SCREEN_HEIGHT - 41 - 64)];
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
    haveDingTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, IsiPhoneX?SCREEN_HEIGHT-64-84:SCREEN_HEIGHT - 41 - 64) style:UITableViewStyleGrouped];
    haveDingTable.dataSource = self;
    haveDingTable.delegate = self;
    [haveDingTable setBackgroundColor:getUIColor(Color_myOrderBack)];
    [haveDingTable registerClass:[cashTransactionSuccessTableViewCell class] forCellReuseIdentifier:@"ordersuccess"];
    
    
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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 9;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *resCell;
    
    
    
    cashTransactionSuccessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ordersuccess" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.model = modelArray[indexPath.section];
    [cell.logistics setTag:indexPath.section + 1000];
    [cell.logistics addTarget:self action:@selector(WuLiuClick:) forControlEvents:UIControlEventTouchUpInside];
    resCell = cell;
   
    [resCell setBackgroundColor:[UIColor whiteColor]];
    return resCell;
}
-(void)WuLiuClick:(UIButton *)sender
{
    orderModel *model = modelArray[sender.tag - 1000];
    orderDetailHaveSendViewController *orderDetail = [[orderDetailHaveSendViewController alloc] init];
    orderDetail.orderId = model.orderId;
    [self.navigationController pushViewController:orderDetail animated:YES];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    orderModel *model = modelArray[indexPath.section];
    
    orderDetailHaveSendViewController *orderDetail = [[orderDetailHaveSendViewController alloc] init];
    orderDetail.orderId = model.orderId;
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
