//
//  addressSetFirstViewViewController.m
//  CategaryShow
//
//  Created by APPLE on 16/9/10.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "addressSetFirstViewViewController.h"
#import "addAddressViewController.h"
#import "ClothesForPayAddressTableViewCell.h"
#import "AddressModel.h"
#import "UpdateAddressViewController.h"
#import "OrderAddressTableViewCell.h"
#import "addressAddTableViewCell.h"
#import "LabelAndBoyOrGirl.h"
@interface addressSetFirstViewViewController ()<UITableViewDelegate, UITableViewDataSource,AddressAddDelegate>

@end

@implementation addressSetFirstViewViewController
{
    UIImageView *noAddressImage;
    UILabel *noAddressWoring;
    UIButton *addAddressBut;
    BaseDomain *getData;
    BaseDomain *postData;
    UITableView *addressTable;
    NSMutableArray *modelArray;
    NSMutableArray *detailArray;
    UIButton *buttonAdd;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    modelArray = [NSMutableArray array];
    detailArray = [NSMutableArray array];
    getData =[BaseDomain getInstance:NO];
    postData = [BaseDomain getInstance:NO];
    [self settabTitle:@"收货地址"];
    [self reloadAddress];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAddress) name:@"createAddress" object:nil];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)reloadAddress
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"page"];
    [[wclNetTool sharedTools]request:GET urlString:[MoreUrlInterface URL_GetAddressList_String] parameters:params finished:^(id responseObject, NSError *error) {
         if ([responseObject[@"data"] count] >0) {
         [modelArray removeAllObjects];
         detailArray = [NSMutableArray arrayWithArray:responseObject[@"data"]];
         for (NSDictionary *dic in responseObject[@"data"]) {
             WCLLog(@"%@",dic);

         AddressModel* model = [AddressModel mj_objectWithKeyValues:dic];
         model.address = [NSString stringWithFormat:@"%@%@%@%@", [dic stringForKey:@"province"],[dic stringForKey:@"city"],[dic stringForKey:@"area"],[dic stringForKey:@"address"]];
         model.is_default = [[dic stringForKey:@"is_default"] integerValue];
         
         
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
         
         [addressTable removeFromSuperview];
         addressTable = nil;
         [buttonAdd removeFromSuperview];
         [self createAddressView];
         }
         
        
    }];
 
            
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [modelArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

-(void)createTable
{
    addressTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) style:UITableViewStyleGrouped];
    if (@available(iOS 11.0, *)) {
        addressTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    addressTable.dataSource = self;
    addressTable.delegate = self;
    [addressTable registerClass:[addressAddTableViewCell class] forCellReuseIdentifier:@"clothesToPayAddress"];
    
    [self.view addSubview:addressTable];

    
    buttonAdd = [[UIButton alloc] initWithFrame:CGRectMake(0,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-64-92:SCREEN_HEIGHT -64- 49, SCREEN_WIDTH, 49)];
    [self.view addSubview:buttonAdd];
    [buttonAdd setBackgroundColor:getUIColor(Color_DZClolor)];
    [buttonAdd setTitle:@"新增地址" forState:UIControlStateNormal];
    [buttonAdd.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [buttonAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonAdd addTarget:self action:@selector(addAddressClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  110;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressModel *model = modelArray[indexPath.section];
    addressAddTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"clothesToPayAddress" forIndexPath:indexPath];
    cell.tag = indexPath.section + 10;
    cell.delegate = self;
    cell.model = model;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)clickChooseAddress:(NSInteger)item
{
    AddressModel *model = modelArray[item];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(model.ID) forKey:@"id"];
    [[wclNetTool sharedTools]request:POST urlString:URL_ChooseAddress parameters:params finished:^(id responseObject, NSError *error) {
        if ([self checkHttpResponseResultStatus:responseObject]) {
            [self reloadAddress];
        }
    }];
}

-(void)clickUpdateAddress:(NSInteger)item
{
    UpdateAddressViewController *updataAdd = [[UpdateAddressViewController alloc] init];
    updataAdd.addressDic = detailArray[item];
    
    [self.navigationController pushViewController:updataAdd animated:YES];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AddressModel *model= modelArray[indexPath.section];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@(model.ID) forKey:@"id"];
        [[wclNetTool sharedTools]request:POST urlString:URL_AddressDelete parameters:params finished:^(id responseObject, NSError *error) {
            if ([responseObject[@"code"]integerValue]==10000) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteAddress" object:nil];
                [self reloadAddress];
            }
        }];
       
        
       
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
