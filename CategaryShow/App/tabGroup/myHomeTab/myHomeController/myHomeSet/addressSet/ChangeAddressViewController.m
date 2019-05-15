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
    [self reloadAddress];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self settabTitle:@"更改地址"];
    getData =[BaseDomain getInstance:NO];
    modelArray = [NSMutableArray array];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [button setTitle:@"管理" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self action:@selector(managerClick) forControlEvents:UIControlEventTouchUpInside];
    //修改leftitem返回键
    UIBarButtonItem *item =   [[UIBarButtonItem alloc]initWithImage:[self reSizeImage:[UIImage imageNamed:@"backLeftWhite"] toSize:CGSizeMake(9, 16)] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    self.navigationItem.leftBarButtonItem = item;
    //    [self createTable];
    [self reloadAddress];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadAddress) name:@"deleteAddress" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAddress) name:@"createAddress" object:nil];
    
}

-(void)fanhui
{
    //    WCLLog(@"你点击了我");
    if (modelArray.count==1) {
        AddressModel *model = modelArray[0];
        NSMutableDictionary *modelDIc= [NSMutableDictionary dictionary];
        [modelDIc setObject:model forKey:@"model"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"AddressChange" object:nil userInfo:modelDIc];
    }
    else if(modelArray.count>1)
    {
        for (AddressModel* model in modelArray) {
            if ([_addressid isEqualToString:[NSString stringWithFormat:@"%@",@(model.ID)]]) {
                NSMutableDictionary *modelDIc= [NSMutableDictionary dictionary];
                [modelDIc setObject:model forKey:@"model"];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"AddressChange" object:nil userInfo:modelDIc];
            }
        }
    }
    else
    {
        AddressModel* model = [AddressModel new];
        model.address = @"您还没有收货地址，点击添加";
        model.phone =@"";
        model.accept_name = @"";
        model.ID =0;
        model.is_default = 0;
        model.province = @"";
        model.city = @"";
        model.area = @"";
        NSMutableDictionary *modelDIc= [NSMutableDictionary dictionary];
        [modelDIc setObject:model forKey:@"model"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"AddressChange" object:nil userInfo:modelDIc];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)managerClick
{
    addressSetFirstViewViewController *address = [[addressSetFirstViewViewController alloc] init];
    [self.navigationController pushViewController:address animated:YES];
}

-(void)reloadAddress
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"page"];
    [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_GetAddressList_String] parameters:params finished:^(id responseObject, NSError *error) {
        WCLLog(@"%@",responseObject);
        if ([self checkHttpResponseResultStatus:responseObject]) {
            [modelArray removeAllObjects];
            if ([[responseObject arrayForKey:@"data"] count] >0) {
                for (NSDictionary *dic in [responseObject arrayForKey:@"data"]) {
                    AddressModel* model = [AddressModel new];
                    model.address = [NSString stringWithFormat:@"%@%@%@%@", [dic stringForKey:@"province"],[dic stringForKey:@"city"],[dic stringForKey:@"area"],[dic stringForKey:@"address"]];
                    model.phone = [dic stringForKey:@"phone"];
                    model.accept_name = [dic stringForKey:@"accept_name"];
                    model.ID = [[dic stringForKey:@"id"]integerValue];
                    model.is_default = [[dic stringForKey:@"is_default"]integerValue];
                    model.province = [dic stringForKey:@"province"];
                    model.city = [dic stringForKey:@"city"];
                    model.area = [dic stringForKey:@"area"];                    
                    if ([[dic stringForKey:@"is_default"] isEqualToString:@"1"]) {
                        NSMutableDictionary *addDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                        [addDic removeObjectForKey:@"zip_code"];
                        NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
                        [userd setObject:addDic forKey:@"Address"];
                    }
                    
                    [modelArray addObject:model];
                }
                
                if (addressTable) {
                    noAddressWoring.hidden=YES;
                    noAddressImage.hidden=YES;
                    addAddressBut.hidden=YES;
                    [addressTable reloadData];
                } else {
                    [self createTable];
                    
                }
                
            } else {
                [addressTable removeFromSuperview];
                addressTable = nil;
                [self createAddressView];
            }
            
        }
    }];
    //    [getData getData:URL_AddressGet PostParams:params finish:^(BaseDomain *domain, Boolean success) {
    //        if ([self checkHttpResponseResultStatus:getData]) {
    //            [modelArray removeAllObjects];
    //            if ([[getData.dataRoot arrayForKey:@"data"] count] >0) {
    //                for (NSDictionary *dic in [getData.dataRoot arrayForKey:@"data"]) {
    //                    AddressModel* model = [AddressModel new];
    //                    model.address = [NSString stringWithFormat:@"%@%@%@%@", [dic stringForKey:@"province"],[dic stringForKey:@"city"],[dic stringForKey:@"area"],[dic stringForKey:@"address"]];
    //                    model.phone = [dic stringForKey:@"phone"];
    //                    model.accept_name = [dic stringForKey:@"name"];
    //                    model.ID = [[dic stringForKey:@"id"]integerValue];
    //                    model.is_default = [[dic stringForKey:@"is_default"]integerValue];
    //                    model.province = [dic stringForKey:@"province"];
    //                    model.city = [dic stringForKey:@"city"];
    //                    model.area = [dic stringForKey:@"area"];
    ////                    model.detaiArea = [dic stringForKey:@"address"];
    //
    //                    if ([[dic stringForKey:@"is_default"] isEqualToString:@"1"]) {
    //                        NSMutableDictionary *addDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    //                        [addDic removeObjectForKey:@"zip_code"];
    //                        NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    //                        [userd setObject:addDic forKey:@"Address"];
    //                    }
    //
    //                    [modelArray addObject:model];
    //                }
    //
    //                if (addressTable) {
    //                    noAddressWoring.hidden=YES;
    //                    noAddressImage.hidden=YES;
    //                    addAddressBut.hidden=YES;
    //                    [addressTable reloadData];
    //                } else {
    //                    [self createTable];
    //
    //                }
    //
    //            } else {
    //                [addressTable removeFromSuperview];
    //                addressTable = nil;
    //                [self createAddressView];
    //            }
    //
    //        }
    //    }];
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
