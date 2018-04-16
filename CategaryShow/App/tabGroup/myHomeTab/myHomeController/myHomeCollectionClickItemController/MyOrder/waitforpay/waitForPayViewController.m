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
    BaseDomain *getData;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    getData = [BaseDomain getInstance:NO];
    [self.view setBackgroundColor:getUIColor(Color_myOrderBack)];
    modelArray = [NSMutableArray array];
    dataArray = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableData) name:@"PaySuccess" object:nil];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableData) name:@"orderDelete" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableData) name:@"cancelOrderAll" object:nil];
    [self getDatas];
}


-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"status"];
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
                    model.clothesPrice = [dic stringForKey:@"money"];
                    if ([[[[dic arrayForKey:@"list"] firstObject] stringForKey:@"size_content"] length] > 0) {
                        model.sizeContnt = [[[dic arrayForKey:@"list"] firstObject] stringForKey:@"size_content"];
                    } else {
                        model.sizeContnt = @"定制款";
                        
                    }
                    NSInteger count = 0;
                    for (NSDictionary *dice in [dic arrayForKey:@"list"]) {
                        count = [dice integerForKey:@"num"] + count;
                    }
                    model.clothesCount = [NSString stringWithFormat:@"%ld", count];
                    model.clothesStatus = [dic integerForKey:@"status"];
                    model.clothesBuyStatus = @"等待付款";
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
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"status"];
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
    bgNoDingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, IsiPhoneX?SCREEN_HEIGHT-64-84:SCREEN_HEIGHT - 41 - 64)];
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
    haveDingTable = [[UITableView alloc] initWithFrame:CGRectMake(13, NavHeight, SCREEN_WIDTH - 26, IsiPhoneX?SCREEN_HEIGHT-64-84:SCREEN_HEIGHT - 41 - 64) style:UITableViewStyleGrouped];
    haveDingTable.dataSource = self;
    haveDingTable.delegate = self;
    [haveDingTable setBackgroundColor:getUIColor(Color_myOrderBack)];
    
    [haveDingTable registerClass:[waitForPayTableViewCell class] forCellReuseIdentifier:@"orderWaitForPay"];
    
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
    return 9;
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
    

    waitForPayTableViewCell *resCell = [tableView dequeueReusableCellWithIdentifier:@"orderWaitForPay" forIndexPath:indexPath];
    [resCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    resCell.model = modelArray[indexPath.section];
    resCell.tag = 100 + indexPath.section;
    resCell.delegate = self;
    [resCell setBackgroundColor:[UIColor whiteColor]];
    return resCell;
}



-(void)clickItem:(NSInteger)item :(NSInteger)type
{
    
    orderModel *model = modelArray[item - 100];
    
    if (type == 1) {
        
//        NSArray *buttons = [NSArray arrayWithObjects:@"确定", @"取消", nil] ;
//        
//        
//        STAlertView *alert = [[STAlertView alloc] initWithTitle:@"提示"image:[UIImage imageNamed:@""] message:@"确定删除订单吗？"buttonTitles:buttons];
//        
//        alert.hideWhenTapOutside = YES;
//        [alert setDidShowHandler:^{
//            NSLog(@"显示了");
//        }];
//        [alert setDidHideHandler:^{
//            NSLog(@"消失了");
//        }];
//        [alert setActionHandler:^(NSInteger index) {
//            
//            if (index == 0) {
//                NSMutableDictionary *params = [NSMutableDictionary dictionary];
//                [params setObject:model.orderId forKey:@"order_id"];
//                [getData getData:URL_CancelOrder PostParams:params finish:^(BaseDomain *domain, Boolean success) {
//                    
//                    if ([self checkHttpResponseResultStatus:getData]) {
//                        [self reloadTable];
//                    }
//                    
//                }];
//            }
//            
//        }];
//        [alert show:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除订单吗" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alert.tag = item;
        [alert show];
        
        
        
    } else if (type == 2) {
        orderDetailViewController *orderDetail = [[orderDetailViewController alloc] init];
        orderDetail.orderId = model.orderId;
        [self.navigationController pushViewController:orderDetail animated:YES];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"等待付款"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"等待付款"];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
         orderModel *model = modelArray[alertView.tag - 100];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:model.orderId forKey:@"order_id"];
        [getData getData:URL_CancelOrder PostParams:params finish:^(BaseDomain *domain, Boolean success) {

            if ([self checkHttpResponseResultStatus:getData]) {
                [MobClick endEvent:@"cancel_order" label:[NSString stringWithFormat:@"用户%@取消了订单%@",[SelfPersonInfo getInstance].cnPersonUserName,model.clothesName]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelOrder" object:nil];
                [self reloadTable];
                
            }
            
        }];
    }
}


-(void)reloadTable
{
    [modelArray removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"status"];
    [getData getData:URL_GetOrder PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:getData]) {
            dataArray = [NSMutableArray arrayWithArray:[getData.dataRoot arrayForKey:@"data"]];
            
            if ([dataArray count] > 0) {
                for (NSMutableDictionary *dic in dataArray) {
                    
                    
                    orderModel *model = [orderModel new];
                    model.number = [dic stringForKey:@"order_no"];
                    model.orderId = [dic stringForKey:@"id"];
                    model.clothesName = [[[dic arrayForKey:@"list"] firstObject] stringForKey:@"goods_name"];
                    model.clothesImg = [[[dic arrayForKey:@"list"] firstObject] stringForKey:@"goods_thumb"];
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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    orderModel *model = modelArray[indexPath.section];
    orderDetailViewController *orderDetail = [[orderDetailViewController alloc] init];
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
