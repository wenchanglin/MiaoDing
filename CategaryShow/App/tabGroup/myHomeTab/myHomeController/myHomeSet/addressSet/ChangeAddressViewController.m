//
//  ChangeAddressViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/31.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "ChangeAddressViewController.h"
#import "addAddressViewController.h"
#import "ClothesForPayAddressTableViewCell.h"
#import "AddressModel.h"
#import "addressSetFirstViewViewController.h"
@interface ChangeAddressViewController ()<UITableViewDelegate, UITableViewDataSource>


@end

@implementation ChangeAddressViewController
{
    UIImageView *noAddressImage;
    UILabel *noAddressWoring;
    UIButton *addAddressBut;
    BaseDomain *getData;
    UITableView *addressTable;
    NSMutableArray *modelArray;
}

-(void)viewWillAppear:(BOOL)animated
{
    modelArray = [NSMutableArray array];
    getData =[BaseDomain getInstance:NO];
    [self reloadAddress];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settabTitle:@"更改地址"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [button setTitle:@"管理" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self action:@selector(managerClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)managerClick
{
    addressSetFirstViewViewController *address = [[addressSetFirstViewViewController alloc] init];
    [self.navigationController pushViewController:address animated:YES];
}

-(void)reloadAddress
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [getData getData:URL_AddressGet PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:getData]) {
            
            if ([[getData.dataRoot arrayForKey:@"data"] count] >0) {
                [modelArray removeAllObjects];
                for (NSDictionary *dic in [getData.dataRoot arrayForKey:@"data"]) {
                    
                    AddressModel* model = [AddressModel new];
                    model.userAddress = [NSString stringWithFormat:@"%@%@%@%@", [dic stringForKey:@"province"],[dic stringForKey:@"city"],[dic stringForKey:@"area"],[dic stringForKey:@"address"]];
                    model.userPhone = [dic stringForKey:@"phone"];
                    model.userName = [dic stringForKey:@"name"];
                    model.addressId = [dic stringForKey:@"id"];
                    model.addressDefault = [dic stringForKey:@"is_default"];
                    model.province = [dic stringForKey:@"province"];
                    model.city = [dic stringForKey:@"city"];
                    model.area = [dic stringForKey:@"area"];
                    model.detaiArea = [dic stringForKey:@"address"];
                    
                    if ([[dic stringForKey:@"is_default"] isEqualToString:@"1"]) {
                        NSMutableDictionary *addDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                        [addDic removeObjectForKey:@"zip_code"];
                        NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
                        [userd setObject:addDic forKey:@"Address"];
                    }
                    
                    [modelArray addObject:model];
                }
                
                if (addressTable) {
                    [addressTable reloadData];
                } else {
                    [self createTable];
                    
                }
                
            } else {
                [self createAddressView];
            }
            
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [modelArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

-(void)createTable
{
    
    addressTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    if (@available(iOS 11.0, *)) {
        addressTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    addressTable.dataSource = self;
    addressTable.delegate = self;
    [addressTable registerClass:[ClothesForPayAddressTableViewCell class] forCellReuseIdentifier:@"clothesToPayAddress"];
    
    
    [self.view addSubview:addressTable];
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return  70;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressModel *model = modelArray[indexPath.row];
    ClothesForPayAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"clothesToPayAddress" forIndexPath:indexPath];
    cell.model = model;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


-(void)createAddressView
{
    noAddressImage = [UIImageView new];
    [self.view addSubview:noAddressImage];
    
    noAddressImage.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view,SCREEN_HEIGHT / 2 - 100)
    .heightIs(80)
    .widthEqualToHeight(1);
    [noAddressImage setImage:[UIImage imageNamed:@"address"]];
    
    noAddressWoring = [UILabel new];
    [self.view addSubview:noAddressWoring];
    noAddressWoring.sd_layout
    .centerXEqualToView(noAddressImage)
    .topSpaceToView(noAddressImage,10)
    .widthIs(SCREEN_WIDTH)
    .heightIs(20);
    [noAddressWoring setText:@"您还没有收货地址"];
    [noAddressWoring setFont:[UIFont systemFontOfSize:14]];
    [noAddressWoring setTextAlignment:NSTextAlignmentCenter];
    addAddressBut = [UIButton new];
    [self.view addSubview:addAddressBut];
    
    addAddressBut.sd_layout
    .centerXEqualToView(noAddressImage)
    .topSpaceToView(noAddressWoring,30)
    .widthIs(120)
    .heightIs(30);
    [addAddressBut setTitle:@"新建地址" forState:UIControlStateNormal];
    [addAddressBut setBackgroundColor:getUIColor(Color_measureTableTitle)];
    [addAddressBut.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [addAddressBut addTarget:self action:@selector(addAddressClick) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)addAddressClick
{
    addAddressViewController *addAddress = [[addAddressViewController alloc] init];
    [self.navigationController pushViewController:addAddress animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressModel *model = modelArray[indexPath.row];
    NSMutableDictionary *modelDIc= [NSMutableDictionary dictionary];
    [modelDIc setObject:model forKey:@"model"];
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"AddressChange" object:nil userInfo:modelDIc];
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
