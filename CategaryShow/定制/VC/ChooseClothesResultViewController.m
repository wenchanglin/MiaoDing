//
//  ChooseClothesResultViewController.m
//  CategaryShow
//
//  Created by APPLE on 16/8/30.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "ChooseClothesResultViewController.h"
#import "ComoanySaleDDDtailViewCell.h"
#import "ClothDetailModel.h"
#import "ClothesFroPay.h"
#import "PayForClothesViewController.h"
#import "myClothesBagViewController.h"
#import "PurchaseCarAnimationTool.h"
#import "newDiyAllDataModel.h"
@interface ChooseClothesResultViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ChooseClothesResultViewController
{
    UITableView *clothesDetailTable;
    NSMutableArray *modelArray;
    BaseDomain *postData;
    UIButton *buttonFront;
    UIButton *buttonBehind;
    UIButton *rightButton;
    NSMutableDictionary*allDataDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    postData = [BaseDomain getInstance:NO];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    allDataDic = [NSMutableDictionary dictionary];
    [self settabTitle:@"订单详情"];
    modelArray = [NSMutableArray array];
    if (@available(iOS 11.0, *)) {
        clothesDetailTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton setImage:[UIImage imageNamed:@"bagRight"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(goInBag) forControlEvents:UIControlEventTouchUpInside];
    allDataDic = _paramsClothes.mutableCopy;
    [allDataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:@"goods_id"]) {
            [allDataDic removeObjectForKey:key];
        }else if ([key isEqualToString:@"mianliao"])
        {
            [allDataDic removeObjectForKey:key];
        }
        else if ([key isEqualToString:@"class_id"])
        {
            [allDataDic removeObjectForKey:key];
        }
        else if ([key isEqualToString:@"must_display_part_ids"])
        {
            [allDataDic removeObjectForKey:key];
        }
    }];
    [_goodDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        ClothDetailModel *model = [[ClothDetailModel alloc] init];
        model.detailName = key;
        model.sonModels = obj;
        [modelArray addObject:model];
    }];
    [allDataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        ClothDetailModel *model = [[ClothDetailModel alloc] init];
        threeDataModel*model3 = [threeDataModel new];
        if ([key isEqualToString:@"banxing"]) {//1版型2绣花位置3绣花字体4绣花颜色
            key = @"版型";
            model.detailName = key;
            model.sonModels = obj;
        }
        else if([key isEqualToString:@"position"])
        {
            key=@"绣花位置";
            model.detailName = key;
            model.sonModels = obj;
        }
        else if([key isEqualToString:@"color"])
        {
            key=@"绣花颜色";
            model.detailName = key;
            model.sonModels = obj;
        }
        else if([key isEqualToString:@"font"])
        {
            key=@"绣花字体";
            model.detailName = key;
            model.sonModels = obj;
        }
        else if ([key isEqualToString:@"mianliao2"])
        {
            key=@"面料";
            model3.part_name=obj;
            model3.android_max=@"";
            model.detailName=key;
            model.sonModels=model3;
        }
        if ([key isEqualToString:@"re_marks"])
        {
            key =@"绣花文字";
            model3.part_name=[[allDataDic dictionaryForKey:@"re_marks"]stringForKey:@"name"];
            model3.android_max=@"";
            model.detailName=key;
            model.sonModels=model3;
        }
        
        [modelArray addObject:model];
    }];
    [self createTableView];
    [self createTableViewHead];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)goInBag
{
    myClothesBagViewController *myBag = [[myClothesBagViewController alloc] init];
    [self.navigationController pushViewController:myBag animated:YES];

}

#pragma mark - createView

-(void)createTableView    //createtable
{
  
    clothesDetailTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-88-74:SCREEN_HEIGHT - 64  - 50) style:UITableViewStylePlain];
    clothesDetailTable.delegate = self;
    clothesDetailTable.dataSource = self;
    [clothesDetailTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [clothesDetailTable registerClass:[ComoanySaleDDDtailViewCell class] forCellReuseIdentifier:NSStringFromClass([ComoanySaleDDDtailViewCell class])];
    [self.view addSubview:clothesDetailTable];
    
    UIView *priceLowView = [[UIView alloc] initWithFrame:CGRectMake(0,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-88-74:SCREEN_HEIGHT -64-50, SCREEN_WIDTH / 3, 50)];
    [priceLowView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:priceLowView];
    
    
    UILabel *priceDetail = [UILabel new];
    [priceLowView addSubview:priceDetail];
    [priceDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(priceLowView.mas_centerX).with.offset(20);
        make.centerY.equalTo(priceLowView.mas_centerY);
        make.height.equalTo(@20);
    }];
    [priceDetail setText:[NSString stringWithFormat:@"%@",[_price stringForKey:@"price"]]];
    priceDetail.textColor= [UIColor colorWithHexString:@"#222222"];
    [priceDetail setFont:[UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:16]];
    
    
    UILabel *priceTitle = [UILabel new];
    [priceLowView addSubview:priceTitle];
    priceTitle.sd_layout
    .centerYEqualToView(priceLowView)
    .rightSpaceToView(priceDetail,0)
    .widthIs(40)
    .autoHeightRatio(20);
    [priceTitle setText:@"合计:"];
    [priceTitle setFont:[UIFont systemFontOfSize:14]];
    

    UIButton *buttonSave = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 3,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-88-74: SCREEN_HEIGHT -64- 50, SCREEN_WIDTH / 3 ,50)];
    [buttonSave setBackgroundColor:getUIColor(Color_DZClolor)];
    [self.view addSubview:buttonSave];
    [buttonSave addTarget:self action:@selector(saveTheClothes) forControlEvents:UIControlEventTouchUpInside];
    [buttonSave.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [buttonSave setTitle:@"加入购物袋" forState:UIControlStateNormal];
    
    
    UIButton *buttonBuy = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 3 * 2,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-88-74:SCREEN_HEIGHT-64 - 50, SCREEN_WIDTH / 3 ,50)];
    [buttonBuy setBackgroundColor:getUIColor(Color_TKClolor)];
    [self.view addSubview:buttonBuy];
    [buttonBuy addTarget:self action:@selector(payForClothes) forControlEvents:UIControlEventTouchUpInside];
    [buttonBuy.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [buttonBuy setTitle:@"立即购买" forState:UIControlStateNormal];
    
}


-(void)payForClothes
{
    
    NSMutableString*string = [[NSMutableString alloc]init];
    threeDataModel*banxingmodel = [_paramsClothes objectForKey:@"banxing"];
    [string appendString:[NSString stringWithFormat:@"%@,",@(banxingmodel.part_id)]];
    threeDataModel*positionmodel = [_paramsClothes objectForKey:@"position"];
    [string appendString:[NSString stringWithFormat:@"%@,",@(positionmodel.part_id)]];
    threeDataModel*colormodel = [_paramsClothes objectForKey:@"color"];
    [string appendString:[NSString stringWithFormat:@"%@,",@(colormodel.part_id)]];
    threeDataModel*fontmodel = [_paramsClothes objectForKey:@"font"];
    [string appendString:[NSString stringWithFormat:@"%@",@(fontmodel.part_id)]];
    NSMutableDictionary*parrment = [NSMutableDictionary dictionary];
    [parrment setObject:string forKey:@"special_mark_part_ids"];
    [parrment setObject:[_paramsClothes stringForKey:@"must_display_part_ids"] forKey:@"must_display_part_ids"];
    [parrment setObject:@"1" forKey:@"goods_num"];
    [parrment setObject:@(ShoppingCarTypeBuy) forKey:@"type"];
    [parrment setObject:[_paramsClothes stringForKey:@"goods_id"] forKey:@"goods_id"];
    [parrment setObject:[_paramsClothes stringForKey:@"mianliao"] forKey:@"fabric_id"];
    [parrment setObject:[[_paramsClothes dictionaryForKey:@"re_marks"]stringForKey:@"name"] forKey:@"re_marks"];
    [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_AddShoppingCar_String] parameters:parrment finished:^(id responseObject, NSError *error) {
        WCLLog(@"%@",responseObject);
        if ([self checkHttpResponseResultStatus:responseObject]) {
            PayForClothesViewController *clothesPay = [[PayForClothesViewController alloc] init];
            clothesPay.carId = [responseObject stringForKey:@"cart_id"];
            clothesPay.allPrice = [_price stringForKey:@"price"];
            [self.navigationController pushViewController:clothesPay animated:YES];
        }
    }];
   
    
}

-(void)saveTheClothes
{
    
    
    NSMutableString*string = [[NSMutableString alloc]init];
    threeDataModel*banxingmodel = [_paramsClothes objectForKey:@"banxing"];
    [string appendString:[NSString stringWithFormat:@"%@,",@(banxingmodel.part_id)]];
    threeDataModel*positionmodel = [_paramsClothes objectForKey:@"position"];
    [string appendString:[NSString stringWithFormat:@"%@,",@(positionmodel.part_id)]];
    threeDataModel*colormodel = [_paramsClothes objectForKey:@"color"];
    [string appendString:[NSString stringWithFormat:@"%@,",@(colormodel.part_id)]];
    threeDataModel*fontmodel = [_paramsClothes objectForKey:@"font"];
    [string appendString:[NSString stringWithFormat:@"%@",@(fontmodel.part_id)]];
    NSMutableDictionary*parrment = [NSMutableDictionary dictionary];
    [parrment setObject:string forKey:@"special_mark_part_ids"];
    [parrment setObject:[_paramsClothes stringForKey:@"must_display_part_ids"] forKey:@"must_display_part_ids"];
    [parrment setObject:@"1" forKey:@"goods_num"];
    [parrment setObject:@(ShoppingCarTypeAdd) forKey:@"type"];
    [parrment setObject:[_paramsClothes stringForKey:@"goods_id"] forKey:@"goods_id"];
    [parrment setObject:[_paramsClothes stringForKey:@"mianliao"] forKey:@"fabric_id"];
    [parrment setObject:[[_paramsClothes dictionaryForKey:@"re_marks"]stringForKey:@"name"] forKey:@"re_marks"];
    [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_AddShoppingCar_String] parameters:parrment finished:^(id responseObject, NSError *error) {
        WCLLog(@"%@",responseObject);
        if ([self checkHttpResponseResultStatus:responseObject]) {
            [self alertViewShowOfTime:@"添加购物车成功" time:1.5];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addCarSuccess" object:nil];
        }
    }];
}

-(void)createTableViewHead  //create the head for table
{
    
    if (_ifTK) {
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT - 100 - 49)];
        
        UIImageView *defaultimg = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH , SCREEN_HEIGHT - 140 - 49)];
        
        [defaultimg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, _defaultImg]]];
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
        [lable setText:[_goodDic stringForKey:@"name"]];
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
    
        for (int i = 0; i< [_goodArray count]; i ++) {
            @autoreleasepool {
                secondDataModel *model = _goodArray[i];
                threeDataModel*model2 = model.son.firstObject;
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 150, 30, 300, 327)];
                [image setTag:100 + i];
                [headView addSubview:image];
                [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model2.android_max]]];
            }
           
        }
       
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            for (int i = 0; i < [_goodArray count]; i ++) {
                @autoreleasepool {
                    UIImageView *image = [headView viewWithTag:100 + i];
                    secondDataModel*model2 = _goodArray[i];
                    if (model2.img_mark==2) {
                        [image setHidden:YES];
                    }
                    else if (model2.img_mark==3)
                    {
                        [image setHidden:YES];
                    }
                    else {
                        [image setHidden:NO];
                    }
                }
            }
        });
        
        
        UILabel *lable = [UILabel new];
        [headView addSubview:lable];
        lable.sd_layout
        .leftEqualToView(headView)
        .rightEqualToView(headView)
        .bottomEqualToView(headView)
        .heightIs(40);
        [lable setTextAlignment:NSTextAlignmentCenter];
        [lable setText:[_goodDic stringForKey:@"name"]];
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

-(void)FrontClick
{
    [buttonFront setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonBehind setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    for (int i = 0; i < [_goodArray count]; i ++) {
        secondDataModel*model2 = _goodArray[i];
        UIImageView *image = [self.view viewWithTag:100 + i];
        if (model2.img_mark==2) {
            [image setHidden:YES];
        }else if (model2.img_mark==3) {
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
    
    for (int i = 0; i < [_goodArray count]; i ++) {
        secondDataModel*model2 = _goodArray[i];
        UIImageView *image = [self.view viewWithTag:100 + i];
        if (model2.img_mark==1) {
            [image setHidden:YES];
        }else if (model2.img_mark==3) {
            [image setHidden:YES];
        } else {
            [image setHidden:NO];
        }
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
