//
//  waitForSendViewController.m
//  CategaryShow
//
//  Created by APPLE on 16/9/17.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "waitForSendViewController.h"

#import "orderModel.h"

#import "waitForSendTableViewCell.h"

#import "orderDetailForHavePayedViewController.h"

@interface waitForSendViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation waitForSendViewController
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
    [params setObject:@"2" forKey:@"status"];
    [params setObject:@"1" forKey:@"page"];
    [getData getData:URL_GetOrderNew PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:getData]) {
            dataArray = [NSMutableArray arrayWithArray:[[getData.dataRoot objectForKey:@"data"] arrayForKey:@"data"]];
            
            if ([ dataArray count] > 0) {
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
                    
                    model.clothesBuyStatus = @"待发货";
                    
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
    [params setObject:@"2" forKey:@"status"];
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
    bgNoDingView = [[UIView alloc] initWithFrame:CGRectMake(0,NavHeight, SCREEN_WIDTH, IsiPhoneX?SCREEN_HEIGHT-64-84:SCREEN_HEIGHT - 41 - 64)];
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
    haveDingTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, IsiPhoneX?SCREEN_HEIGHT-64-84:SCREEN_HEIGHT - 41 - 64) style:UITableViewStyleGrouped];
    haveDingTable.dataSource = self;
    haveDingTable.delegate = self;
    [haveDingTable setBackgroundColor:getUIColor(Color_myOrderBack)];
    
    
    [haveDingTable registerClass:[waitForSendTableViewCell class] forCellReuseIdentifier:@"orderWaitForSend"];
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
    
    
    
        waitForSendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderWaitForSend" forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.model = modelArray[indexPath.section];
        [cell.woring addTarget:self action:@selector(woringClick) forControlEvents:UIControlEventTouchUpInside];
        return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    orderModel *model = modelArray[indexPath.section];
    
    
    orderDetailForHavePayedViewController *orderDetail = [[orderDetailForHavePayedViewController alloc] init];
    orderDetail.orderId = model.orderId;
    [self.navigationController pushViewController:orderDetail animated:YES];
    
    
}

-(void)woringClick
{
//    NSArray *buttons = [NSArray arrayWithObjects:@"确定", nil] ;
//    
//    
//    STAlertView *alert = [[STAlertView alloc] initWithTitle:@"提示"image:[UIImage imageNamed:@""] message:@"由于订单过多，商家发货可能会晚一两天，我们已经帮您催促，请耐心等待，对您造成的困扰感到很抱歉!"buttonTitles:buttons];
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
//        
//        
//    }];
//    [alert show:YES];
    
    
    UIAlertView *alertShow = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提醒厂家发货发送消息成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertShow show];
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
