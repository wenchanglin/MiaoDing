//
//  UpdateAddressViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/31.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "UpdateAddressViewController.h"
#import "MeasureLabelAndTextField.h"
#import "MeasurePlaceTableViewCell.h"
#import "MeasureLabelAndTextFieldModel.h"
#import "JSAddressPickerView.h"
#import "NKColorSwitch.h"
#import "LabelAndBoyOrGirl.h"
@interface UpdateAddressViewController ()<UITableViewDataSource, UITableViewDelegate,JSAddressPickerDelegate,measurePlaceDelegate,measureLabelAndTextDelegate>
@property (nonatomic,retain) JSAddressPickerView *pickerView;

@end

@implementation UpdateAddressViewController
{
    UITableView *addressTable;
    NSMutableArray *modelArray;
    NSMutableDictionary *params;
    NKColorSwitch *swithGirlOrBoy;
    BaseDomain *postData;
    UIButton *addressNomal;
    NSString *flogNomal;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    postData = [BaseDomain getInstance:NO];
    flogNomal = [_addressDic stringForKey:@"is_default"];
    params = [NSMutableDictionary dictionary];
    [params setObject:[_addressDic stringForKey:@"address"] forKey:@"address"];
    [params setObject:[_addressDic stringForKey:@"province"] forKey:@"province"];
    [params setObject:[_addressDic stringForKey:@"city"] forKey:@"city"];
    [params setObject:[_addressDic stringForKey:@"area"] forKey:@"area"];
    [params setObject:[_addressDic stringForKey:@"name"] forKey:@"name"];
    [params setObject:[_addressDic stringForKey:@"phone"] forKey:@"phone"];
    [params setObject:[_addressDic stringForKey:@"id"] forKey:@"id"];
    [self settabTitle:@"修改地址"];
    modelArray = [NSMutableArray array];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self action:@selector(handOnClick) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *arrayTitle = [NSArray arrayWithObjects:@"收货人", @"手机号码",@"所在地址", nil];
    
    NSArray *arrayDetail = [NSArray arrayWithObjects:@"请输入收货人姓名", @"请输入收货人的手机号码",  @"请输入详细地址", nil];
    
    NSArray *contentDetail = [NSArray arrayWithObjects:[_addressDic stringForKey:@"name"],[_addressDic stringForKey:@"phone"],[_addressDic stringForKey:@"address"], nil];
    
    for (int i = 0; i < [arrayTitle count]; i ++) {
        MeasureLabelAndTextFieldModel *model = [[MeasureLabelAndTextFieldModel alloc] init];
        model.titleName = arrayTitle[i];
        model.placeHolder = arrayDetail[i];
        model.ContentText = contentDetail[i];
        if ([arrayTitle[i] isEqualToString:@"所在地址"]) {
            model.province = [_addressDic stringForKey:@"province"];
            model.city=[_addressDic stringForKey:@"city"];
            model.area=[_addressDic stringForKey:@"area"];
        }
        [modelArray addObject:model];
        
        
    }
    

    
    [self createAddressTable];
}

-(void)handOnClick
{
    
    [addressTable endEditing:YES];
    
    if ([[params stringForKey:@"name"] isEqualToString:@""] || [[params stringForKey:@"phone"] isEqualToString:@""] ||[[params stringForKey:@"address"] isEqualToString:@""] ||[[params stringForKey:@"province"] isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入完整的地址信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        
        
        
        if ([_addressDic integerForKey:@"is_default"] == 1) {
            
            if ([[params stringForKey:@"phone"] length] > 11) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号格式错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            } else {
                NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
                [userD setObject:params forKey:@"Address"];
                [params setObject:@"1" forKey:@"is_default"];
                [postData postData:URL_AddressAdd PostParams:params finish:^(BaseDomain *domain, Boolean success) {
                    if ([self checkHttpResponseResultStatus:postData]) {
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"createAddress" object:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
            }
            
            
        } else {
            if ([[params stringForKey:@"phone"] length] > 11) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号格式错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            } else {
                
                NKColorSwitch *swith = [self.view viewWithTag:10000];
                
                if (swith.on) {
                    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
                    [userD setObject:params forKey:@"Address"];
                    [params setObject:@"1" forKey:@"is_default"];
                } else {
                    [params setObject:@"0" forKey:@"is_default"];
                }
                
                
                
                [postData postData:URL_AddressAdd PostParams:params finish:^(BaseDomain *domain, Boolean success) {
                    if ([self checkHttpResponseResultStatus:postData]) {
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"createAddress" object:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
                
            }

        }
        
        

    }
    
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)createAddressTable
{
    
    addressTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    if (@available(iOS 11.0, *)) {
        addressTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [addressTable registerClass:[MeasureLabelAndTextField class] forCellReuseIdentifier:NSStringFromClass([MeasureLabelAndTextField class])];
    [addressTable registerClass:[MeasurePlaceTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MeasurePlaceTableViewCell class])];
    [addressTable registerClass:[LabelAndBoyOrGirl class] forCellReuseIdentifier:NSStringFromClass([LabelAndBoyOrGirl class])];
    addressTable.dataSource = self;
    addressTable.delegate = self;
    [addressTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    addressTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:addressTable];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [modelArray count];
    } return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            return 80;
        }
        return 45;
    } return  50;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 400)];
//    [footView setBackgroundColor:[UIColor whiteColor]];
//    [footView setUserInteractionEnabled:YES];
//    
//    addressNomal = [[UIButton alloc] initWithFrame:CGRectMake(25, 15, 40, 40)];
//    
//    if ([flogNomal integerValue] == 0) {
//         [addressNomal setImage:[UIImage imageNamed:@"noChoose"] forState:UIControlStateNormal];
//    } else {
//         [addressNomal setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
//    }
//    
//   
//    
//    [addressNomal addTarget:self action:@selector(chooseNomal) forControlEvents:UIControlEventTouchUpInside];
//    [footView addSubview:addressNomal];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, 200, 30)];
//    [footView addSubview:label];
//    
//    [label setText:@"是否设置为默认"];
//    [label setFont:[UIFont systemFontOfSize:14]];
//    
//    
//    
//    
//
//    
//    
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, SCREEN_WIDTH - 40, 40)];
//    [btn setTitle:@"保存地址" forState:UIControlStateNormal];
//    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(handOnClick) forControlEvents:UIControlEventTouchUpInside];
//    [btn setBackgroundColor:[UIColor blackColor]];
//    [btn.layer setCornerRadius:3];
//    [btn.layer setMasksToBounds:YES];
//    [footView addSubview:btn];
//    return footView;
//
//}

-(void)chooseNomal
{
    if ([flogNomal integerValue] == 0) {
        [addressNomal setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
        flogNomal = @"1";
    } else {
        [addressNomal setImage:[UIImage imageNamed:@"noChoose"] forState:UIControlStateNormal];
        flogNomal = @"0";
    }
}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *reCell;
    
    
    if (indexPath.section == 0) {
        MeasureLabelAndTextFieldModel *model = modelArray[indexPath.row];
        if ([model.titleName isEqualToString:@"所在地址"] ){
            Class currentClass = [MeasurePlaceTableViewCell class];
            MeasurePlaceTableViewCell *cell = nil;
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
            cell.delegate = self;
            cell.model = model;
            reCell = cell;
        }else {
            Class currentClass = [MeasureLabelAndTextField class];
            MeasureLabelAndTextField *cell = nil;
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
            cell.model = model;
            cell.delegate = self;
            cell.tag = indexPath.row +5;
            reCell = cell;
        }
    } else {
        MeasureLabelAndTextFieldModel *model = [MeasureLabelAndTextFieldModel new];
        model.titleName = @"设为默认";
        Class currentClass = [LabelAndBoyOrGirl class];
        LabelAndBoyOrGirl *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
        [cell.swithGirlOrBoy setTag:10000];
        
        cell.model = model;
        reCell = cell;
    }
    
    [reCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return reCell;
}

-(void)textDetail:(NSString *)detail :(NSInteger)index
{
    if (index == 5) {
        [params setObject:detail forKey:@"name"];
    } else if (index == 6) {
        [params setObject:detail forKey:@"phone"];
    }
}

-(void)placeDetail:(NSString *)detail
{
    [params setObject:detail forKey:@"address"];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        [addressTable endEditing:YES];
        if (self.pickerView) {
            self.pickerView.hidden = NO;
            return;
        }
        self.pickerView = [[JSAddressPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.pickerView updateAddressAtProvince:@"福建省" city:@"厦门市" town:@"集美区"];
        self.pickerView.delegate = self;
        self.pickerView.font = [UIFont boldSystemFontOfSize:14];
        [self.view addSubview:self.pickerView];
    }
}

- (void)JSAddressCancleAction:(id)senter {
    self.pickerView.hidden = YES;
}

- (void)JSAddressPickerRerurnBlockWithProvince:(NSString *)province city:(NSString *)city town:(NSString *)town {
    self.pickerView.hidden = YES;
    NSLog(@"%@  %@  %@",province,city,town);
    MeasureLabelAndTextFieldModel *model = [[MeasureLabelAndTextFieldModel alloc] init];
    model.titleName = @"所在地址";
    model.province = province;
    model.city=city;
    model.area=town;
    
    model.placeHolder = @"请输入详细地址";
    
    [params setObject:province forKey:@"province"];
    [params setObject:city forKey:@"city"];
    [params setObject:town forKey:@"area"];
    
    [modelArray replaceObjectAtIndex:2 withObject:model];
    [addressTable reloadData];
    
}

- (void)setPickerView:(JSAddressPickerView *)pickerView {
    if (!_pickerView) {
        
    }
    _pickerView = pickerView;
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
