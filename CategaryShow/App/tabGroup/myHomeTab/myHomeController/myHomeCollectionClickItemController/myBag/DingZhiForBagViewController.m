//
//  DingZhiForBagViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/11/2.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "DingZhiForBagViewController.h"
#import "BagDingTableViewCell.h"
#import "ClothDetailModel.h"
#import "ClothesFroPay.h"
#import "PayForClothesViewController.h"
#import "ComoanySaleDDDtailViewCell.h"
@interface DingZhiForBagViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation DingZhiForBagViewController
{
    UITableView *clothesDetailTable;
    NSMutableArray *modelArray;
    BaseDomain *postData;
    UIButton *buttonFront;
    UIButton *buttonBehind;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的购物袋-单个商品-订单详情"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"我的购物袋-单个商品-订单详情"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    postData = [BaseDomain getInstance:NO];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self settabTitle:@"订单详情"];
    [self getDatas];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"3" forKey:@"phone_type"];
    [params setObject:[_dataDic stringForKey:@"id"] forKey:@"car_id"];
    [postData getData:URL_GetBagDingZhiDetail PostParams:params finish:^(BaseDomain *domain, Boolean success) {
       
        if ([self checkHttpResponseResultStatus:domain]) {
            NSLog(@"%@", domain.dataRoot);
            
            
            
            
            _dataDic = [NSMutableDictionary dictionaryWithDictionary:[domain.dataRoot objectForKey:@"data"]];
            [self createTableView];
            [self createTableViewHead];
            
            modelArray = [NSMutableArray array];
            
            
            NSMutableArray *arrayTitle1;
            
            arrayTitle1 = [NSMutableArray arrayWithArray:[[_dataDic stringForKey:@"spec_content"] componentsSeparatedByString:@";"]];
            
            
            
            NSMutableArray *arrayTitle2;
            arrayTitle2 = [NSMutableArray arrayWithArray:[[_dataDic stringForKey:@"diy_content"] componentsSeparatedByString:@";"]];
            
            [arrayTitle1 addObjectsFromArray:arrayTitle2];
            
            
            NSMutableArray *titleResult = [NSMutableArray array];
            NSMutableArray *detailResult = [NSMutableArray array];
            for (int i = 0; i < [arrayTitle1 count]; i ++) {
                [titleResult addObject:[[arrayTitle1[i] componentsSeparatedByString:@":"] firstObject]];
                [detailResult addObject:[[arrayTitle1[i] componentsSeparatedByString:@":"] lastObject]];
                
            }
            
            for (int i = 0; i < [titleResult count]; i ++) {
                ClothDetailModel *model = [[ClothDetailModel alloc] init];
                model.detailName = titleResult[i];
                model.detailContent = detailResult[i];
                [modelArray addObject:model];
            }

            
        }
        
    }];
}

#pragma mark - createView

-(void)createTableView    //createtable
{
    if (@available(iOS 11.0, *)) {
        clothesDetailTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    clothesDetailTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH,IsiPhoneX?SCREEN_HEIGHT-74-84:SCREEN_HEIGHT - 64  - 50) style:UITableViewStylePlain];
    clothesDetailTable.delegate = self;
    clothesDetailTable.dataSource = self;
    [clothesDetailTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
   [clothesDetailTable registerClass:[ComoanySaleDDDtailViewCell class] forCellReuseIdentifier:NSStringFromClass([ComoanySaleDDDtailViewCell class])];
    [self.view addSubview:clothesDetailTable];
    
    UIView *priceLowView = [[UIView alloc] initWithFrame:CGRectMake(0,IsiPhoneX?SCREEN_HEIGHT-74-84:SCREEN_HEIGHT-64 - 50, SCREEN_WIDTH / 3, 50)];
    [priceLowView setBackgroundColor:getUIColor(Color_loginBackViewColor)];
    [self.view addSubview:priceLowView];
    

    UILabel *priceDetail = [UILabel new];
    [priceLowView addSubview:priceDetail];
    [priceDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(priceLowView.mas_centerX).with.offset(20);
        make.centerY.equalTo(priceLowView.mas_centerY);
        make.height.equalTo(@20);
        
    }];
    [priceDetail setText:[NSString stringWithFormat:@"¥%.2f", [[_dataDic stringForKey:@"price"] floatValue]]];
    
    [priceDetail setFont:Font_14];
    
    
    UILabel *priceTitle = [UILabel new];
    [priceLowView addSubview:priceTitle];
    priceTitle.sd_layout
    .centerYEqualToView(priceLowView)
    .rightSpaceToView(priceDetail,0)
    .widthIs(40)
    .autoHeightRatio(20);
    [priceTitle setText:@"合计:"];
    [priceTitle setFont:Font_14];
    
    UIButton *buttonSave = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 3,IsiPhoneX?SCREEN_HEIGHT-84-74: SCREEN_HEIGHT-64 - 50, SCREEN_WIDTH / 3 , 50)];
    [buttonSave setBackgroundColor:getUIColor(Color_DZClolor)];
    [self.view addSubview:buttonSave];
    [buttonSave addTarget:self action:@selector(saveTheClothes) forControlEvents:UIControlEventTouchUpInside];
    [buttonSave.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [buttonSave setTitle:@"加入购物袋" forState:UIControlStateNormal];
    
    
    UIButton *buttonBuy = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 3 * 2,IsiPhoneX?SCREEN_HEIGHT-84-74:SCREEN_HEIGHT -64- 50, SCREEN_WIDTH / 3 , 50)];
    [buttonBuy setBackgroundColor:getUIColor(Color_TKClolor)];
    [self.view addSubview:buttonBuy];
    [buttonBuy addTarget:self action:@selector(payForClothes) forControlEvents:UIControlEventTouchUpInside];
    [buttonBuy.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [buttonBuy setTitle:@"立即购买" forState:UIControlStateNormal];
    
}

-(void)FrontClick
{
    [buttonFront setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonBehind setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    for (int i = 0; i < [[_dataDic arrayForKey:@"img_list"] count]; i ++) {
        UIImageView *image = [self.view viewWithTag:100 + i];
        if ([[[[_dataDic arrayForKey:@"img_list"] objectAtIndex:i] stringForKey:@"position_id"] isEqualToString:@"2"]) {
            [image setHidden:YES];
        }else if ([[[[_dataDic arrayForKey:@"img_list"] objectAtIndex:i] stringForKey:@"position_id"] isEqualToString:@"3"]) {
            [image setHidden:YES];
        } else {
            [image setHidden:NO];
        }
    }
}

-(void)behindClick
{
    [buttonFront setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [buttonBehind setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    for (int i = 0; i < [[_dataDic arrayForKey:@"img_list"] count]; i ++) {
        UIImageView *image = [self.view viewWithTag:100 + i];
        if ([[[[_dataDic arrayForKey:@"img_list"] objectAtIndex:i] stringForKey:@"position_id"] isEqualToString:@"1"]) {
            [image setHidden:YES];
        }else if ([[[[_dataDic arrayForKey:@"img_list"] objectAtIndex:i] stringForKey:@"position_id"] isEqualToString:@"3"]) {
            [image setHidden:YES];
        } else {
            [image setHidden:NO];
        }
    }
}


-(void)payForClothes
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[_dataDic stringForKey:@"goods_id"] forKey:@"goods_id"];
    [params setObject:[_dataDic stringForKey:@"goods_type"] forKey:@"goods_type"];
    [params setObject:[_dataDic stringForKey:@"price"] forKey:@"price"];
    [params setObject:[_dataDic stringForKey:@"goods_name"] forKey:@"goods_name"];
    [params setObject:[_dataDic stringForKey:@"goods_thumb"] forKey:@"goods_thumb"];
    [params setObject:@"1" forKey:@"type"];
    
    [params setObject:[_dataDic stringForKey:@"spec_ids"] forKey:@"spec_ids"];

    [params setObject:[_dataDic stringForKey:@"diy_content"] forKey:@"diy_content"];
        
    
    
    
    [params setObject:[_dataDic stringForKey:@"spec_content"] forKey:@"spec_content"];
    [params setObject:[_dataDic stringForKey:@"num"] forKey:@"num"];
    [postData postData:URL_AddClothesCar PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:postData]) {
            [MobClick event:@"place_order" label:[NSString stringWithFormat:@"%@--%@",[SelfPersonInfo getInstance].cnPersonUserName,[_dataDic stringForKey:@"goods_name"]]];
            ClothesFroPay *model = [ClothesFroPay new];
            model.clothesImage = [_dataDic stringForKey:@"goods_thumb"];
            model.clothesCount = [_dataDic stringForKey:@"num"];
            model.clothesName = [_dataDic stringForKey:@"goods_name"];
            model.clothesPrice = [_dataDic stringForKey:@"price"];
            
            NSMutableArray *array = [NSMutableArray arrayWithObjects:model, nil];
            PayForClothesViewController *clothesPay = [[PayForClothesViewController alloc] init];
            clothesPay.arrayForClothes = array;
            clothesPay.carId = [[postData.dataRoot objectForKey:@"data"] stringForKey:@"car_id"];
            clothesPay.allPrice = [_dataDic stringForKey:@"price"];
            [self.navigationController pushViewController:clothesPay animated:YES];
        }
        
    }];
    

}

-(void)saveTheClothes
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[_dataDic stringForKey:@"goods_id"] forKey:@"goods_id"];
    [params setObject:[_dataDic stringForKey:@"goods_type"] forKey:@"goods_type"];
    [params setObject:[_dataDic stringForKey:@"price"] forKey:@"price"];
    [params setObject:[_dataDic stringForKey:@"goods_name"] forKey:@"goods_name"];
    [params setObject:[_dataDic stringForKey:@"goods_thumb"] forKey:@"goods_thumb"];
    [params setObject:@"2" forKey:@"type"];
    
    [params setObject:[_dataDic stringForKey:@"spec_ids"] forKey:@"spec_ids"];
    
    
    
    [params setObject:[_dataDic stringForKey:@"diy_content"] forKey:@"diy_content"];

    [params setObject:[_dataDic stringForKey:@"spec_content"] forKey:@"spec_content"];
//    [params setObject:[_dataDic stringForKey:@"num"] forKey:@"num"];
    [postData postData:URL_AddClothesCar PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:postData]) {
            [MobClick event:@"add_cart" label:[NSString stringWithFormat:@"%@--%@",[SelfPersonInfo getInstance].cnPersonUserName,[_dataDic stringForKey:@"goods_name"]]];
            [self alertViewShowOfTime:@"加入购物车成功" time:1.5];
        }
        
    }];
    
}

-(void)createTableViewHead  //create the head for table
{
//    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,367.5)];
//    for (int i = 0; i< [[_dataDic arrayForKey:@"img_list"]  count]; i ++) {
//        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 150, 0, 300, 327)];
//        [image setTag:100 + i];
//        [headView addSubview:image];
//        if ([[[[_dataDic arrayForKey:@"img_list"] objectAtIndex:i] stringForKey:@"position_id"] integerValue] == 1) {
//            [image setHidden:NO];
//            
//        } else {
//             [image setHidden:YES];
//        }
//        [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [[[_dataDic arrayForKey:@"img_list"] objectAtIndex:i] stringForKey:@"img_c"]]]];
//    }
//    
//    UILabel *lable = [UILabel new];
//    [headView addSubview:lable];
//    lable.sd_layout
//    .leftSpaceToView(headView,15)
//    .rightSpaceToView(headView,15)
//    .topSpaceToView(headView,327)
//    .heightIs(40);
//    [lable setText:[_dataDic stringForKey:@"goods_name"]];
//    [lable setFont:[UIFont boldSystemFontOfSize:16]];
//    
//    clothesDetailTable.tableHeaderView = headView;
    
    if ([_dataDic integerForKey:@"is_scan"] == 1) {
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT - 100 - 49)];
        
        UIImageView *defaultimg = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH , SCREEN_HEIGHT - 140 - 49)];
        
        [defaultimg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [_dataDic stringForKey:@"goods_thumb"]]]];
        [headView addSubview:defaultimg];
        [defaultimg setContentMode:UIViewContentModeScaleAspectFill];
        [defaultimg.layer setMasksToBounds:YES];
        UILabel *lable = [UILabel new];
        [headView addSubview:lable];
        lable.sd_layout
        .leftEqualToView(headView)
        .rightEqualToView(headView)
        .bottomEqualToView(headView)
        .heightIs(40);
        [lable setTextAlignment:NSTextAlignmentCenter];
        [lable setText:[_dataDic stringForKey:@"goods_name"]];
        [lable setFont:[UIFont boldSystemFontOfSize:16]];
        
        UILabel *labelLine = [UILabel new];
        [headView addSubview:labelLine];
        labelLine.sd_layout
        .leftEqualToView(headView)
        .rightEqualToView(headView)
        .bottomSpaceToView(headView, 5)
        .heightIs(1);
        [labelLine setBackgroundColor:getUIColor(Color_background)];
        
        clothesDetailTable.tableHeaderView = headView;
        
    } else {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,397.5)];
        
        buttonFront = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 50, 5, 40, 20)];
        [buttonFront addTarget:self action:@selector(FrontClick) forControlEvents:UIControlEventTouchUpInside];
        [buttonFront.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [buttonFront setTitle:@"正面" forState:UIControlStateNormal];
        [headView addSubview:buttonFront];
        [buttonFront setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        buttonBehind = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 + 10, 5, 40, 20)];
        [buttonBehind.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [buttonBehind addTarget:self action:@selector(behindClick) forControlEvents:UIControlEventTouchUpInside];
        [buttonBehind setTitle:@"反面" forState:UIControlStateNormal];
        [buttonBehind setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [headView addSubview:buttonBehind];
        
        
        for (int i = 0; i< [[_dataDic arrayForKey:@"img_list"]  count]; i ++) {
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 150, 30, 300, 327)];
            [image setTag:100 + i];
            [headView addSubview:image];
            [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [[[_dataDic arrayForKey:@"img_list"] objectAtIndex:i] stringForKey:@"img_c"]]]];
        }
        
        for (int i = 0; i < [[_dataDic arrayForKey:@"img_list"] count]; i ++) {
            UIImageView *image = [headView viewWithTag:100 + i];
            if ([[[[_dataDic arrayForKey:@"img_list"] objectAtIndex:i] stringForKey:@"position_id"] isEqualToString:@"2"]||[[[[_dataDic arrayForKey:@"img_list"] objectAtIndex:i] stringForKey:@"position_id"] isEqualToString:@"3"]) {
                [image setHidden:YES];
            } else {
                [image setHidden:NO];
            }
        }
        
        
        UILabel *lable = [UILabel new];
        [headView addSubview:lable];
        lable.sd_layout
        .leftEqualToView(headView)
        .rightEqualToView(headView)
        .bottomEqualToView(headView)
        .heightIs(40);
        [lable setTextAlignment:NSTextAlignmentCenter];
        [lable setText:[_dataDic stringForKey:@"goods_name"]];
        [lable setFont:[UIFont boldSystemFontOfSize:16]];
        
        UILabel *labelLine = [UILabel new];
        [headView addSubview:labelLine];
        labelLine.sd_layout
        .leftEqualToView(headView)
        .rightEqualToView(headView)
        .bottomSpaceToView(headView, 5)
        .heightIs(1);
        [labelLine setBackgroundColor:getUIColor(Color_background)];
        
        clothesDetailTable.tableHeaderView = headView;
    }
}

#pragma mark - delegate and dataSoure



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [modelArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class currentClass = [ComoanySaleDDDtailViewCell class];
    ClothDetailModel *model = modelArray[indexPath.row];
    return [clothesDetailTable cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class currentClass = [ComoanySaleDDDtailViewCell class];
    ComoanySaleDDDtailViewCell *cell = nil;
    ClothDetailModel *model = modelArray[indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
    cell.model = model;
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    ///////////////////////////////////////////////////////////////////////
    return cell;
    
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
