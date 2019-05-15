//
//  myClothesBagViewController.m
//  CategaryShow
//
//  Created by APPLE on 16/8/31.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "myClothesBagViewController.h"
#import "myBagModel.h"
#import "myBagTableViewCell.h"
#import "AppDelegate.h"
#import "JYHNavigationController.h"
#import "ToBuyCompanyClothes(SecondPlan)ViewController.h"
#import "BuyDesignerClothesViewController.h"
#import "ClothesFroPay.h"
#import "PayForClothesViewController.h"
#import "DingZhiForBagViewController.h"
#import "perentOrderViewController.h"
#import "mySavedClothesCollectionViewCell.h"
#import "DesignersClothesViewController.h"
#import "DiyClothesDetailViewController.h"
#import "DesignerClothesDetailViewController.h"
#import "DesignerClothesDetailViewController.h"
#import "MorePeiJianView.h"
#import "mySavedModel.h"
#import "RecommendToYouHeadView.h"
@interface myClothesBagViewController ()<UITableViewDataSource, UITableViewDelegate,myBagTableViewCellDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation myClothesBagViewController
{
    UIView *bgNoDingView;   //没有订单界面底层
    UITableView *hadClothesView;  //有订单table
    UIView *lowBgView;    //最下方栏目
    NSMutableArray *chooseOrNot;  //是否选择数组
    NSMutableArray *modelArray;
    UIButton *buttonToPay;
    UILabel *chooseCount;   //已选数量
    UILabel *choosePrice;  //总价
    UIButton *allChoose;   //全选
    NSInteger ifAllChoose;
    UIButton *rightBarBtn;
    BOOL ifUpdate;
    NSMutableArray *clothesArray;
    NSMutableArray *suggestModelArray;
    UICollectionView *suggestCollection;
    NSMutableArray *suggestDataArray;
    NSMutableArray*morePeiJianArr;
    UIAlertView*alerts;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.rdv_tabBarController.tabBarHidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settabTitle:@"我的购物袋"];
    self.view.backgroundColor=[UIColor whiteColor];
    morePeiJianArr =[NSMutableArray array];
    clothesArray = [NSMutableArray array];
    chooseOrNot = [NSMutableArray array];
    suggestDataArray = [NSMutableArray array];
    ifUpdate = NO;
    ifAllChoose = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downOrderSuccessAction) name:@"downOrderSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(turnToOrderAction) name:@"turnToOrder" object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(realToOrder) name:@"realToOrder" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateNum) name:@"updateNum" object:nil];
    modelArray = [NSMutableArray array];
    suggestModelArray = [NSMutableArray array];
    
    [self getDataS];
}
-(void)updateNum{
    [modelArray removeAllObjects];
    [self getDataS];
}
-(void)realToOrder
{
    perentOrderViewController *perentOrder = [[perentOrderViewController alloc] init];
    [self.navigationController pushViewController:perentOrder animated:YES];
}
-(void)createSuggestGet
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"2" forKey:@"num"];
    [[wclNetTool sharedTools]request:GET urlString:[MoreUrlInterface URL_ShoppingCartRecommendGoods_String] parameters:params finished:^(id responseObject, NSError *error) {
//        WCLLog(@"%@",responseObject);
        if ([self checkHttpResponseResultStatus:responseObject]) {
            suggestModelArray = [mySavedModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [suggestCollection reloadData];
        }
    }];
}

-(void)turnToOrderAction
{
    //    perentOrderViewController *perentOrder = [[perentOrderViewController alloc] init];
    //    [self.navigationController pushViewController:perentOrder animated:YES];
    paySuccessViewController *paySuccess = [[paySuccessViewController alloc] init];
    [self.navigationController pushViewController:paySuccess animated:YES];
}

-(void)downOrderSuccessAction
{
    [modelArray removeAllObjects];
    [clothesArray removeAllObjects];
    [self getDataS];
}

-(void)getDataS
{
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms setObject:@"1" forKey:@"page"];
    [[wclNetTool sharedTools]request:GET urlString:[MoreUrlInterface URL_ShoppingCartList_String] parameters:parms finished:^(id responseObject, NSError *error) {
        if ([self checkHttpResponseResultStatus:responseObject]) {
            if ([responseObject[@"data"]count]==0) {
                [self createViewNoDD];
                [self createSuggestGet];//推荐商品
            }
            else
            {
                modelArray = [myBagModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                [chooseOrNot removeAllObjects];
                for (myBagModel*model2 in modelArray) {
                    NSMutableArray*contentArr = [NSMutableArray array];
                    NSMutableArray*contentArr2 = [NSMutableArray array];
                    if ([model2.category_id integerValue]==2) {
                        for (skuModel*model3 in model2.sku) {
                            NSString*string2 =[NSString stringWithFormat:@"%@:%@",model3.type,model3.value];
                            [contentArr addObject:string2];
                        }
                        NSString*string1 = [contentArr componentsJoinedByString:@";"];
                        [chooseOrNot addObject:@"yes"];
                        model2.ifChoose=@"yes";
                        model2.sizeOrDing = string1;
                    }
                   else
                   {
                       for (partModel*model3 in model2.part) {
                           NSString*string2 =[NSString stringWithFormat:@"%@:%@",model3.part_name,model3.part_value];
                           [contentArr2 addObject:string2];
                       }
                       NSString*string3 = [contentArr2 componentsJoinedByString:@";"];
                       [chooseOrNot addObject:@"yes"];
                       model2.ifChoose=@"yes";
                       model2.sizeOrDing = string3;
                   }
                }
                
                [self createHaveClothesView];
                [self createLowView];
            }
        }
    }];
    
}

-(void)createViewNoDD    // 创建没有订单界面
{
    
    [rightBarBtn setHidden:YES];
    bgNoDingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgNoDingView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgNoDingView];
    
    UIImageView *NoDD = [UIImageView new];
    [NoDD setImage:[UIImage imageNamed:@"Mine_emptyBag"]];
    [bgNoDingView addSubview:NoDD];
    NoDD.sd_layout
    .centerXEqualToView(bgNoDingView)
    .topSpaceToView(bgNoDingView,[ShiPeiIphoneXSRMax isIPhoneX]?128:50)
    .widthIs(73)
    .heightIs(76);
    
    UILabel*placeLabel = [UILabel new];
    placeLabel.textAlignment=NSTextAlignmentCenter;
    placeLabel.text=@"你的购物车空空如也~";
    placeLabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:14];
    placeLabel.textColor=[UIColor colorWithHexString:@"#666666"];
    [bgNoDingView addSubview:placeLabel];
    placeLabel.sd_layout.centerXEqualToView(bgNoDingView).topSpaceToView(NoDD, 20).widthIs(SCREEN_WIDTH-20).heightIs(20);
    
    UIButton *clickToLookOther = [UIButton new];
    [bgNoDingView addSubview:clickToLookOther];
    [clickToLookOther.layer setCornerRadius:3];
    [clickToLookOther.layer setMasksToBounds:YES];
    [clickToLookOther addTarget:self action:@selector(goToLookClothes) forControlEvents:UIControlEventTouchUpInside];
    [clickToLookOther.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [clickToLookOther setBackgroundColor:[UIColor blackColor]];
    [clickToLookOther setTitle:@"去逛逛" forState:UIControlStateNormal];
    clickToLookOther.sd_layout.centerXEqualToView(bgNoDingView).topSpaceToView(placeLabel, 20).widthIs(80)
    .heightIs(35);
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumLineSpacing = 0;
    suggestCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-(SCREEN_WIDTH / 2 - 6)-223: SCREEN_HEIGHT - (SCREEN_WIDTH / 2 - 6)-184, SCREEN_WIDTH, [ShiPeiIphoneXSRMax isIPhoneX]?(SCREEN_WIDTH / 2 - 6)+113.8:(SCREEN_WIDTH / 2 - 6)+113.8) collectionViewLayout:flowLayout];
    if (@available(iOS 11.0, *)) {
        suggestCollection.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    suggestCollection.delegate = self;
    suggestCollection.dataSource = self;
    suggestCollection.scrollEnabled=NO;
    [bgNoDingView addSubview:suggestCollection];
    suggestCollection.backgroundColor = [UIColor whiteColor];//colorWithHexString:@"#EDEDED"
    //注册cell和ReusableView（相当于头部）
    [suggestCollection registerClass:[mySavedClothesCollectionViewCell class] forCellWithReuseIdentifier:@"mysaveClothes"];
    [suggestCollection registerClass:[RecommendToYouHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    
    
}
#pragma mark --UICollectionViewDelegateFlowLayout

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [suggestModelArray count];
    
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"mysaveClothes";
    mySavedClothesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];//colorWithHexString:@"#EDEDED"
    cell.model = suggestModelArray[indexPath.item];
    [cell sizeToFit];
    
    
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
     UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView" forIndexPath:indexPath];
    return headerView;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 45);
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH/2)-6, (SCREEN_WIDTH / 2 - 6)+73.8);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    mySavedModel *model = suggestModelArray[indexPath.item];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:model.ID forKey:@"id"];
    
    if ([model.category_id integerValue]== 1) {
        DiyClothesDetailViewController *toButy = [[DiyClothesDetailViewController alloc] init];
        toButy.goodDic = dic;
        [self.navigationController pushViewController:toButy animated:YES];
    } else {
        
        
        DesignerClothesDetailViewController *designerClothes = [[DesignerClothesDetailViewController alloc] init];
        designerClothes.goodDic = suggestModelArray[indexPath.item];
        designerModel*model2 = [designerModel new];
        model2.ID=[model.ID integerValue];
            designerClothes.model = model2;
        designerClothes.good_id =model.category_id;
        [self.navigationController pushViewController:designerClothes animated:YES];
        
    }
    
}


-(void)goToLookClothes {
    
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LookClothes" object:nil];
    
}


-(void)createHaveClothesView
{
    
    rightBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightBarBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [rightBarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBarBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
    [rightBarBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    hadClothesView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight + 9, SCREEN_WIDTH , SCREEN_HEIGHT - 64 - 9 - 49) style:UITableViewStylePlain];
    hadClothesView.delegate = self;
    hadClothesView.dataSource = self;
    [hadClothesView registerClass:[myBagTableViewCell class] forCellReuseIdentifier:@"clothesList"];
    [hadClothesView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    hadClothesView.showsVerticalScrollIndicator = NO;
    hadClothesView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [hadClothesView setBackgroundColor:getUIColor(Color_myOrderBack)];
    [self.view addSubview:hadClothesView];
}

-(void)createLowView
{
    lowBgView = [UIView new];
    [self.view addSubview:lowBgView];
    lowBgView.sd_layout
    .leftEqualToView(self.view)
    .bottomSpaceToView(self.view,[ShiPeiIphoneXSRMax isIPhoneX]?22:0)
    .widthIs(SCREEN_WIDTH)
    .heightIs(49);
    [lowBgView setBackgroundColor:[UIColor whiteColor]];
    
    allChoose = [UIButton new];
    [lowBgView addSubview:allChoose];
    
    allChoose.sd_layout
    .leftSpaceToView(lowBgView, 15)
    .centerYEqualToView(lowBgView)
    .heightIs(16)
    .widthIs(16);
    [allChoose setBackgroundImage:[UIImage imageNamed:@"noChoose"] forState:UIControlStateNormal];
    [allChoose addTarget:self action:@selector(allChooseClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    chooseCount = [UILabel new];
    [lowBgView addSubview:chooseCount];
    chooseCount.sd_layout
    .leftSpaceToView(allChoose,16)
    .centerYEqualToView(lowBgView)
    .heightIs(16)
    .widthIs(100);
    [chooseCount setFont:[UIFont systemFontOfSize:14]];
    
    
    
    
    buttonToPay = [UIButton new];
    [lowBgView addSubview:buttonToPay];
    buttonToPay.sd_layout
    .rightEqualToView(lowBgView)
    .centerYEqualToView(lowBgView)
    .heightIs(49)
    .widthIs(SCREEN_WIDTH / 4);
    [buttonToPay setBackgroundColor:getUIColor(Color_myBagToPayButton)];
    [buttonToPay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonToPay.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [buttonToPay setTitle:@"下单" forState:UIControlStateNormal];
    [buttonToPay addTarget:self action:@selector(clickPay) forControlEvents:UIControlEventTouchUpInside];
    
    choosePrice = [UILabel new];
    [lowBgView addSubview:choosePrice];
    
    //    choosePrice.sd_layout
    //    .rightSpaceToView(buttonToPay, 20)
    //    .centerYEqualToView(lowBgView)
    //    .heightIs(16)
    //    .widthIs(65);
    
    [choosePrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(buttonToPay.mas_left).with.offset(-20);
        make.centerY.equalTo(lowBgView);
        make.height.equalTo(@16);
    }];
    
    [choosePrice setFont:Font_14];
    [choosePrice setTextColor:[UIColor blackColor]];
    [choosePrice setTextAlignment:NSTextAlignmentRight];
    
    
    
    UILabel *priceTitle = [UILabel new];
    [lowBgView addSubview:priceTitle];
    priceTitle.sd_layout
    .rightSpaceToView(choosePrice,5)
    .centerYEqualToView(lowBgView)
    .heightIs(16)
    .widthIs(40);
    [priceTitle setFont:[UIFont systemFontOfSize:14]];
    [priceTitle setText:@"总计:"];
    
    
    [self lowViewReload];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [modelArray count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    myBagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"clothesList" forIndexPath:indexPath];
    cell.model = modelArray[indexPath.row];
    cell.updateIfOrNot = ifUpdate;
    cell.tag = indexPath.row + 10;
    if (indexPath.row == [modelArray count] - 1) {
        [cell.lineView setHidden:YES];
    } else {
        [cell.lineView setHidden:NO];
    }
    cell.delegate = self;
    if (ifUpdate) {
        [cell.addCount setHidden:NO];
        [cell.cutCount setHidden:NO];
        [cell.addCount setTag:indexPath.row + 5];
        [cell.cutCount setTag:indexPath.row + 500];
        [cell.addCount addTarget:self action:@selector(addCountClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.cutCount addTarget:self action:@selector(cutCountClick:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [cell.addCount setHidden:YES];
        [cell.cutCount setHidden:YES];
        [cell.addCount setTag:indexPath.row + 5];
        [cell.cutCount setTag:indexPath.row + 500];
        [cell.addCount removeTarget:self action:@selector(addCountClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.cutCount removeTarget:self action:@selector(cutCountClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!ifUpdate) {
        myBagModel *model = modelArray[indexPath.row];
        if ([model.category_id integerValue] == 2) {
            DesignerClothesDetailViewController *toBuy = [[DesignerClothesDetailViewController alloc] init];
            designerModel*model2=  [designerModel new];
            model2.ID = [model.goods_id integerValue];
            model2.name = model.goods_name;
            model2.ad_img = model.goods_img;
            model2.content = model.sizeOrDing;
            toBuy.model=model2;
            [self.navigationController pushViewController:toBuy animated:YES];
        } else {
            DiyClothesDetailViewController *toButy = [[DiyClothesDetailViewController alloc] init];
            toButy.goodDic = @{@"id":model.goods_id}.mutableCopy;
            self.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:toButy animated:YES];
        }
    }
    
    
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        myBagModel *model= modelArray[indexPath.section];
        [modelArray removeObjectAtIndex:indexPath.row];
        [chooseOrNot removeObjectAtIndex:indexPath.row];
        [self reloadAllView];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:model.cart_id forKey:@"cart_id"];
        [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_DeleteOneOrMoreShopsFromShopping_Car_String] parameters:params finished:^(id responseObject, NSError *error) {
            if ([self checkHttpResponseResultStatus:responseObject]) {
                if ([modelArray count] == 0) {
                    [self.view setBackgroundColor:[UIColor whiteColor]];
                    for (UIView *view in self.view.subviews) {
                        [view removeFromSuperview];
                    }
                    [self createViewNoDD];
                }
            }
        }];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {

    }

}
-(void)addCountClick:(UIButton *)sender
{
    
    myBagModel *model = modelArray[sender.tag - 5];
    model.goods_num = model.goods_num + 1;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:model.cart_id forKey:@"cart_id"];
    [params setObject:@(model.goods_num) forKey:@"buy_num"];
    [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_ChangeCarNum_String] parameters:params finished:^(id responseObject, NSError *error) {
        //        WCLLog(@"+%@",responseObject);
        
    }];
    
    [self reloadAllView];
    
}

-(void)cutCountClick:(UIButton *)sender
{
    myBagModel *model = modelArray[sender.tag - 500];
    if (model.goods_num > 1) {
        model.goods_num =  model.goods_num  - 1;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:model.cart_id forKey:@"cart_id"];
        [params setObject:@(model.goods_num) forKey:@"buy_num"];
        [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_ChangeCarNum_String] parameters:params finished:^(id responseObject, NSError *error) {
            //            WCLLog(@"-%@",responseObject);
        }];
    }
    
    [self reloadAllView];
}

-(void)rightBtnClick
{
    if (ifUpdate) {
        ifUpdate = NO;
        [rightBarBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [buttonToPay setTitle:@"下单" forState:UIControlStateNormal];
    } else {
        ifUpdate = YES;
        [rightBarBtn setTitle:@"完成" forState:UIControlStateNormal];
        [buttonToPay setTitle:@"删除" forState:UIControlStateNormal];
    }
    
    [self reloadAllView];
}

-(void)clickPay
{
    if (ifUpdate) {//多条商品删除
        NSString *carIds;
        NSArray *modelTemp = [NSArray arrayWithArray:modelArray];
        NSArray *array = [NSArray arrayWithArray:chooseOrNot];
        for (int i = 0; i < [array count]; i ++) {
            myBagModel *model = modelTemp[i];
            if ([array[i] isEqualToString:@"yes"]) {
                if ([carIds length] > 0) {
                    carIds = [NSString stringWithFormat:@"%@,%@", carIds, model.cart_id];
                } else {
                    carIds = model.cart_id;
                }
            }
        }
        if (carIds.length==0) {
            [self alertViewShowOfTime:@"请选择商品再删除" time:1.2];
            return;
        }
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:carIds forKey:@"cart_id"];
        [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_DeleteOneOrMoreShopsFromShopping_Car_String] parameters:params finished:^(id responseObject, NSError *error) {
            if ([self checkHttpResponseResultStatus:responseObject]) {
                [modelArray removeAllObjects];
                [chooseOrNot removeAllObjects];
                [clothesArray removeAllObjects];
                NSMutableDictionary *parms1 = [NSMutableDictionary dictionary];
                [[wclNetTool sharedTools]request:GET urlString:[MoreUrlInterface URL_ShoppingCartList_String] parameters:parms1 finished:^(id responseObject, NSError *error) {
                    if ([self checkHttpResponseResultStatus:responseObject]) {
                        if ([responseObject[@"data"]count]==0) {
                            [hadClothesView removeFromSuperview];
                            [self createViewNoDD];
                            [self createSuggestGet];//推荐商品
                        }
                        else
                        {
                            modelArray = [myBagModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                            NSMutableArray*contentArr = [NSMutableArray array];
                            for (myBagModel*model2 in modelArray) {
                                if ([model2.category_id integerValue]==2) {
                                    for (skuModel*model3 in model2.sku) {
                                        NSString*string2 =[NSString stringWithFormat:@"%@:%@",model3.type,model3.value];
                                        [contentArr addObject:string2];
                                    }
                                    NSString*string1 = [contentArr componentsJoinedByString:@";"];
                                    [chooseOrNot addObject:@"yes"];
                                    model2.ifChoose=@"yes";
                                    model2.sizeOrDing = string1;
                                }
                                else
                                {
                                    for (partModel*model3 in model2.part) {
                                        NSString*string2 =[NSString stringWithFormat:@"%@:%@",model3.part_name,model3.part_value];
                                        [contentArr addObject:string2];
                                    }
                                    NSString*string1 = [contentArr componentsJoinedByString:@";"];
                                    [chooseOrNot addObject:@"yes"];
                                    model2.ifChoose=@"yes";
                                    model2.sizeOrDing = string1;
                                }
                            }
                            [self reloadAllView];
                        }}}];
            }
        }];
    } else {
        NSString *carIds;
        NSArray *modelTemp = [NSArray arrayWithArray:modelArray];
        NSArray *array = [NSArray arrayWithArray:chooseOrNot];
        NSInteger count = 0;
        for (int i = 0; i < [array count]; i ++) {
            myBagModel *model = modelTemp[i];
            if ([array[i] isEqualToString:@"yes"]) {
                count += 1;
                if ([carIds length] > 0) {
                    carIds = [NSString stringWithFormat:@"%@,%@", carIds, model.cart_id];
                } else {
                    carIds = model.cart_id;
                }
            }
        }
        if (count==0) {
            [self alertViewShowOfTime:@"请选择商品" time:1.2];
            return;
        }
        PayForClothesViewController *pay = [[PayForClothesViewController alloc] init];
        pay.carId = carIds;
        pay.allPrice = [choosePrice.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
        [self.navigationController pushViewController:pay animated:YES];
        
    }
}

-(void)clickMoreLabel:(NSInteger)item//点击更多
{
   
    myBagModel*model =modelArray[item];
    if ([model.category_id integerValue]==2) {
     [MorePeiJianView showWithData:model.sku withTitle:@"更多配件" isChengPing:[model.category_id integerValue]  withDoneBlock:^(NSString * _Nonnull string) {
     }];
     }
     else
     {
     [MorePeiJianView showWithData:model.part withTitle:@"更多配件" isChengPing:[model.category_id integerValue] withDoneBlock:^(NSString * _Nonnull string) {
     }];
     }
 }
-(void)clickButton:(NSInteger)item
{
    if ([chooseOrNot[item - 10] isEqualToString:@"yes"]) {
        [chooseOrNot replaceObjectAtIndex:item - 10 withObject:@"no"];
        myBagModel *model = modelArray[item - 10];
        model.ifChoose = @"no";
    } else {
        [chooseOrNot replaceObjectAtIndex:item - 10 withObject:@"yes"];
        myBagModel *model = modelArray[item - 10];
        model.ifChoose = @"yes";
    }
    [self reloadAllView];
}
-(void)allChooseClick
{
    if (ifAllChoose == 0) {
        for (int i = 0; i < [chooseOrNot count]; i ++) {
            [chooseOrNot replaceObjectAtIndex:i withObject:@"yes"];
            myBagModel *model = modelArray[i];
            model.ifChoose = @"yes";
        }
    } else {
        for (int i = 0; i < [chooseOrNot count]; i ++) {
            [chooseOrNot replaceObjectAtIndex:i withObject:@"no"];
            myBagModel *model = modelArray[i];
            model.ifChoose = @"no";
        }
    }
    
    
    
    [self reloadAllView];
    
}


-(void)reloadAllView
{
    [hadClothesView reloadData];
    
    [self lowViewReload];
}


-(void)lowViewReload
{
    CGFloat pirce = 0;
    NSInteger count = 0;
    for (int i = 0; i < [chooseOrNot count]; i ++) {
        myBagModel *model = modelArray[i];
        if ([chooseOrNot[i] isEqualToString:@"yes"]) {
            pirce = pirce + [model.price floatValue] * model.goods_num;
            count ++;
        }
    }
    [choosePrice setText:[NSString stringWithFormat:@"¥%.2f",pirce]];
    [chooseCount setText:[NSString stringWithFormat:@"已选(%ld)", count]];
    if (count == [chooseOrNot count]) {
        [allChoose setBackgroundImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
        ifAllChoose = 1;
    } else {
        [allChoose setBackgroundImage:[UIImage imageNamed:@"noChoose"] forState:UIControlStateNormal];
        ifAllChoose = 0;
    }
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
