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
}
- (void)viewDidLoad {
    [super viewDidLoad];
    postData = [BaseDomain getInstance:NO];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self settabTitle:@"订单详情"];
    [self createTableView];
    [self createTableViewHead];
    modelArray = [NSMutableArray array];
   
    rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton setImage:[UIImage imageNamed:@"bagRight"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(goInBag) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSMutableArray *arrayTitle;
    NSMutableArray *arrayDetail;
    if (_diyArray == nil) {
        
        arrayTitle = [NSMutableArray arrayWithArray:[_goodArray valueForKey:@"spec_name"]];
        arrayDetail = [NSMutableArray arrayWithArray:[_goodArray valueForKey:@"name"]];
        
       
        
        if (_xiuZiDic != nil) {
            [arrayTitle addObject:@"法式袖扣"];
            [arrayDetail addObject:[_xiuZiDic stringForKey:@"name"]];
        }
    } else {
        arrayTitle = [NSMutableArray arrayWithArray:[_goodArray valueForKey:@"spec_name"]];
        
        arrayDetail = [NSMutableArray arrayWithArray:[_goodArray valueForKey:@"name"]];
        
        if (_xiuZiDic != nil) {
            [arrayTitle addObject:@"法式袖扣"];
            [arrayDetail addObject:[_xiuZiDic stringForKey:@"name"]];
        }
        
        NSArray *arrayTitle1 = [_diyDetailArray valueForKey:@"a_name"];
        [arrayTitle addObjectsFromArray:arrayTitle1];
        NSArray *arrayDetail1 = [_diyDetailArray valueForKey:@"name"];
        [arrayDetail addObjectsFromArray:arrayDetail1];
    }
    
//    [arrayTitle addObject:@"版型"];
//    [arrayTitle addObject:@"面料"];
    
//    [arrayDetail addObject:[_banMian stringForKey:@"banxing"]];
//    [arrayDetail addObject:[_banMian stringForKey:@"mianliao"]];
    
    for (int i = 0; i < [arrayTitle count]; i ++) {
        ClothDetailModel *model = [[ClothDetailModel alloc] init];
        model.detailName = arrayTitle[i];
        model.detailContent = arrayDetail[i];
        [modelArray addObject:model];
    }
    
    
    // Do any additional setup after loading the view.
}


-(void)goInBag
{
    myClothesBagViewController *myBag = [[myClothesBagViewController alloc] init];
    [self.navigationController pushViewController:myBag animated:YES];

}

#pragma mark - createView

-(void)createTableView    //createtable
{
    if (@available(iOS 11.0, *)) {
       clothesDetailTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    clothesDetailTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 64  - 50) style:UITableViewStylePlain];
    clothesDetailTable.delegate = self;
    clothesDetailTable.dataSource = self;
    [clothesDetailTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [clothesDetailTable registerClass:[ComoanySaleDDDtailViewCell class] forCellReuseIdentifier:NSStringFromClass([ComoanySaleDDDtailViewCell class])];
    [self.view addSubview:clothesDetailTable];
    
    UIView *priceLowView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT -64-50, SCREEN_WIDTH / 3, 50)];
    [priceLowView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:priceLowView];
    
    
    UILabel *priceDetail = [UILabel new];
    [priceLowView addSubview:priceDetail];
    [priceDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(priceLowView.mas_centerX).with.offset(20);
        make.centerY.equalTo(priceLowView.mas_centerY);
        make.height.equalTo(@20);
    }];
    [priceDetail setText:[NSString stringWithFormat:@"¥%.2f", [_price floatValue]]];
    
    [priceDetail setFont:Font_14];
    
    
    UILabel *priceTitle = [UILabel new];
    [priceLowView addSubview:priceTitle];
    priceTitle.sd_layout
    .centerYEqualToView(priceLowView)
    .rightSpaceToView(priceDetail,0)
    .widthIs(40)
    .autoHeightRatio(20);
    [priceTitle setText:@"合计:"];
    [priceTitle setFont:[UIFont systemFontOfSize:14]];
    

    UIButton *buttonSave = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 3, SCREEN_HEIGHT -64- 50, SCREEN_WIDTH / 3 , 50)];
    [buttonSave setBackgroundColor:getUIColor(Color_DZClolor)];
    [self.view addSubview:buttonSave];
    [buttonSave addTarget:self action:@selector(saveTheClothes) forControlEvents:UIControlEventTouchUpInside];
    [buttonSave.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [buttonSave setTitle:@"加入购物袋" forState:UIControlStateNormal];
    
    
    UIButton *buttonBuy = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 3 * 2, SCREEN_HEIGHT-64 - 50, SCREEN_WIDTH / 3 , 50)];
    [buttonBuy setBackgroundColor:getUIColor(Color_TKClolor)];
    [self.view addSubview:buttonBuy];
    [buttonBuy addTarget:self action:@selector(payForClothes) forControlEvents:UIControlEventTouchUpInside];
    [buttonBuy.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [buttonBuy setTitle:@"立即购买" forState:UIControlStateNormal];
    
}


-(void)payForClothes
{
    
    [_paramsClothes setObject:@"1" forKey:@"goods_type"];
    [_paramsClothes setObject:@"1" forKey:@"type"];
    
    
    if (_diyArray != nil) {
        
        [_paramsClothes setObject:[_diyArray componentsJoinedByString:@";"] forKey:@"diy_content"];
        
    }
    [_paramsClothes setObject:@"1" forKey:@"num"];
    [postData postData:URL_AddClothesCar PostParams:_paramsClothes finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:postData]) {
            ClothesFroPay *model = [ClothesFroPay new];
            if ([_paramsClothes stringForKey:@"mian_img"].length > 0) {
                model.clothesImage = [_paramsClothes stringForKey:@"mian_img"];
            } else {
                 model.clothesImage = [_paramsClothes stringForKey:@"goods_thumb"];
            }
           
            model.clothesCount = @"1";
            model.clothesName = [_goodDic stringForKey:@"name"];
            model.clothesPrice = _price;
            model.clotheMaxCount = @"100";
            NSMutableArray *array = [NSMutableArray arrayWithObjects:model, nil];
            PayForClothesViewController *clothesPay = [[PayForClothesViewController alloc] init];
            clothesPay.dateId = _dateId;
            clothesPay.dingDate = _dingDate;
            clothesPay.arrayForClothes = array;
            clothesPay.carId = [[postData.dataRoot objectForKey:@"data"] stringForKey:@"car_id"];
            clothesPay.allPrice = _price;
            [self.navigationController pushViewController:clothesPay animated:YES];
        }
        
    }];
    
//    NSMutableArray *array = [NSMutableArray arrayWithObjects:model, nil];
//    PayForClothesViewController *clothesPay = [[PayForClothesViewController alloc] init];
//    clothesPay.arrayForClothes = array;
//    [self.navigationController pushViewController:clothesPay animated:YES];
    
}

-(void)saveTheClothes
{
    
    

    [_paramsClothes setObject:@"1" forKey:@"goods_type"];

    [_paramsClothes setObject:@"2" forKey:@"type"];

    [_paramsClothes setObject:@"1" forKey:@"num"];
    
    if (_ifTK) {
        [_paramsClothes setObject:@"1" forKey:@"is_scan"];
    } else {
        [_paramsClothes setObject:@"0" forKey:@"is_scan"];
    }
    
    [postData postData:URL_AddClothesCar PostParams:_paramsClothes finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:postData]) {
            
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - 60, ScreenHeight / 2 - 60, 120, 120)];
            [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [_paramsClothes stringForKey:@"goods_thumb"]]]];
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addCarSuccess" object:nil];
            [[PurchaseCarAnimationTool shareTool]startAnimationandView:image andRect:image.frame andFinisnRect:CGPointMake(ScreenWidth - 30, 35) andFinishBlock:^(BOOL finisn){
//                UIView *tabbarBtn = self.tabBarController.tabBar.subviews[3];
                [PurchaseCarAnimationTool shakeAnimation:rightButton];
                
//                 [self alertViewShowOfTime:@"加入购物车成功" time:1.5];
            }];
//
            
           
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
        
        
        for (int i = 0; i< [_goodArray  count]; i ++) {
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 150, 30, 300, 327)];
            [image setTag:100 + i];
            [headView addSubview:image];
            [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [[_goodArray objectAtIndex:i] stringForKey:@"img_c"]]]];
        }
        
        for (int i = 0; i < [_goodArray count]; i ++) {
            UIImageView *image = [headView viewWithTag:100 + i];
            if ([[[_goodArray objectAtIndex:i] stringForKey:@"position_id"] isEqualToString:@"2"]||[[[_goodArray objectAtIndex:i] stringForKey:@"position_id"] isEqualToString:@"3"]) {
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
        UIImageView *image = [self.view viewWithTag:100 + i];
        if ([[[_goodArray objectAtIndex:i] stringForKey:@"position_id"] isEqualToString:@"2"]) {
            [image setHidden:YES];
        }else if ([[[_goodArray objectAtIndex:i] stringForKey:@"position_id"] isEqualToString:@"3"]) {
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
        UIImageView *image = [self.view viewWithTag:100 + i];
        if ([[[_goodArray objectAtIndex:i] stringForKey:@"position_id"] isEqualToString:@"1"]) {
            [image setHidden:YES];
        }else if ([[[_goodArray objectAtIndex:i] stringForKey:@"position_id"] isEqualToString:@"3"]) {
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
