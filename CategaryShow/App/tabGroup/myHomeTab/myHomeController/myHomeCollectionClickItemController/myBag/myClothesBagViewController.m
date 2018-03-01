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
    BaseDomain *getData;
    BaseDomain *postData;
    BaseDomain *getSuggestClothes;
    NSMutableArray *suggestModelArray;
    UICollectionView *suggestCollection;
    NSMutableArray *suggestDataArray;
}

-(void)viewWillAppear:(BOOL)animated
{
     [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    
}
//-(void)reloadView
//{
//    [modelArray removeAllObjects];
//    [clothesArray removeAllObjects];
//    [chooseOrNot removeAllObjects];
//    [self.view setBackgroundColor:[UIColor whiteColor]];
//    for (UIView *view in self.view.subviews) {
//        [view removeFromSuperview];
//    }
//    
//    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
//    
//    [getData getData:URL_MyPayBag PostParams:parms finish:^(BaseDomain *domain, Boolean success) {
//        if ([self checkHttpResponseResultStatus:getData]) {
//            
//            if ([[getData.dataRoot arrayForKey:@"data"] count] == 0) {
//                
//                
//                [self.view setBackgroundColor:[UIColor whiteColor]];
//                [self createViewNoDD];
//            } else {
//                [self.view setBackgroundColor:getUIColor(Color_myOrderBack)];
//                for (NSDictionary *dic in [getData.dataRoot arrayForKey:@"data"]) {
//                    [chooseOrNot addObject:@"yes"];
//                    
//                    
//                    myBagModel *model = [[myBagModel alloc] init];
//                    model.clothesCount = [dic stringForKey:@"num"];
//                    model.clothesImg = [dic stringForKey:@"goods_thumb"];
//                    model.clothesName = [dic stringForKey:@"goods_name"];
//                    model.clothesPrice = [dic stringForKey:@"price"];
//                    model.bagId = [dic stringForKey:@"id"];
//                    model.ifChoose = @"yes";
//                    model.good_id = [dic stringForKey:@"goods_id"];
//                    model.good_type = [dic stringForKey:@"goods_type"];
//                    if ([dic integerForKey:@"goods_type"] == 2) {
//                        model.sizeOrDing = [dic stringForKey:@"size_content"];
//                    } else {
//                        model.sizeOrDing = @"定制款";
//                    }
//                    [modelArray addObject:model];
//                    
//                    ClothesFroPay *model1 = [[ClothesFroPay alloc] init];
//                    model1.clothesImage = [dic stringForKey:@"goods_thumb"];
//                    model1.clothesCount = [dic stringForKey:@"num"];
//                    model1.clothesName = [dic stringForKey:@"goods_name"];
//                    model1.clothesPrice = [dic stringForKey:@"price"];
//                    model1.clotheMaxCount = [dic stringForKey:@"suk_num"];
//                    if ([dic integerForKey:@"goods_type"] == 2) {
//                        model1.clotheType = [dic stringForKey:@"size_content"];
//                    } else {
//                        model1.clotheType = @"定制款";
//                    }
//                    [clothesArray addObject:model1];
//                    
//                }
//                
//                [self createHaveClothesView];
//                [self createLowView];
//            }
//        }
//        
//        
//    }];
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的购物袋";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    getData = [BaseDomain getInstance:NO];
    postData = [BaseDomain getInstance:NO];
    getSuggestClothes = [BaseDomain getInstance:NO];
    clothesArray = [NSMutableArray array];
    chooseOrNot = [NSMutableArray array];
    suggestDataArray = [NSMutableArray array];
    ifUpdate = NO;
    ifAllChoose = 0;
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [self.view addSubview:titleView];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downOrderSuccessAction) name:@"downOrderSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(turnToOrderAction) name:@"turnToOrder" object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(realToOrder) name:@"realToOrder" object:nil];
    
    modelArray = [NSMutableArray array];
    suggestModelArray = [NSMutableArray array];
    
    
    
    
    
    [self createSuggestGet];
    [self getDataS];
    // Do any additional setup after loading the view.
}

-(void)realToOrder
{
    perentOrderViewController *perentOrder = [[perentOrderViewController alloc] init];
    [self.navigationController pushViewController:perentOrder animated:YES];
}
-(void)createSuggestGet
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [getSuggestClothes getData:URL_SuggestClothes PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:getSuggestClothes]) {
            
            for (NSDictionary *dis in [[getSuggestClothes.dataRoot objectForKey:@"data"] arrayForKey:@"data"] ) {
                suggestDataArray = [NSMutableArray arrayWithArray:[[getSuggestClothes.dataRoot objectForKey:@"data"] arrayForKey:@"data"]];
                mySavedModel *model = [[mySavedModel alloc] init];
                model.clothesPrice = [dis stringForKey:@"price2"];
                model.clothesName = [dis stringForKey:@"name"];
                model.clothesImg = [dis stringForKey:@"thumb"];
                model.goodId = [dis stringForKey:@"goods_id"];
                model.type = [dis stringForKey:@"type"];
                [suggestModelArray addObject:model];
            }

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
    [chooseOrNot removeAllObjects];
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [getData getData:URL_MyPayBag PostParams:parms finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:getData]) {
            
            if ([[getData.dataRoot arrayForKey:@"data"] count] == 0) {
                
                for (UIView *view in [self.view subviews]) {
                    [view removeFromSuperview];
                }
                
                [self.view setBackgroundColor:[UIColor whiteColor]];
                [self createViewNoDD];
            } else {
                [self.view setBackgroundColor:getUIColor(Color_myOrderBack)];
                for (NSDictionary *dic in [getData.dataRoot arrayForKey:@"data"]) {
                    [chooseOrNot addObject:@"yes"];
                    myBagModel *model = [[myBagModel alloc] init];
                    model.clothesCount = [dic stringForKey:@"num"];
                    model.clothesImg = [dic stringForKey:@"goods_thumb"];
                    model.clothesName = [dic stringForKey:@"goods_name"];
                    model.clothesPrice = [dic stringForKey:@"price"];
                    model.bagId = [dic stringForKey:@"id"];
                    model.ifChoose = @"yes";
                    model.can_use_card = [dic integerForKey:@"can_use_card"];
                    model.good_id = [dic stringForKey:@"goods_id"];
                    model.good_type = [dic stringForKey:@"goods_type"];
                    if ([dic integerForKey:@"goods_type"] == 2) {
                        model.sizeOrDing = [dic stringForKey:@"size_content"];
                    } else {
                        
                    }
                    [modelArray addObject:model];
                    
                    ClothesFroPay *model1 = [[ClothesFroPay alloc] init];
                    model1.clothesImage = [dic stringForKey:@"goods_thumb"];
                    model1.clothesCount = [dic stringForKey:@"num"];
                    model1.clothesName = [dic stringForKey:@"goods_name"];
                    model1.clothesPrice = [dic stringForKey:@"price"];
                    model1.can_use_card = [dic integerForKey:@"can_use_card"];
                    [clothesArray addObject:model1];
                    
                }
                
                [self createHaveClothesView];
                [self createLowView];
            }
        }
        
        
    }];

}

-(void)getDataS
{
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    
    [getData getData:URL_MyPayBag PostParams:parms finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:getData]) {
            
            if ([[getData.dataRoot arrayForKey:@"data"] count] == 0) {
                
                
                 [self.view setBackgroundColor:[UIColor whiteColor]];
                [self createViewNoDD];
            } else {
                 [self.view setBackgroundColor:getUIColor(Color_myOrderBack)];
                for (NSDictionary *dic in [getData.dataRoot arrayForKey:@"data"]) {
                    [chooseOrNot addObject:@"yes"];
                    
                    
                    myBagModel *model = [[myBagModel alloc] init];
                    model.clothesCount = [dic stringForKey:@"num"];
                    model.clothesImg = [dic stringForKey:@"goods_thumb"];
                    model.clothesName = [dic stringForKey:@"goods_name"];
                    model.clothesPrice = [dic stringForKey:@"price"];
                    model.bagId = [dic stringForKey:@"id"];
                    model.ifChoose = @"yes";
                    model.good_id = [dic stringForKey:@"goods_id"];
                    model.good_type = [dic stringForKey:@"goods_type"];
                    if ([dic integerForKey:@"goods_type"] == 2) {
                        model.sizeOrDing = [dic stringForKey:@"size_content"];
                    } else {
                        model.sizeOrDing = @"定制款";
                    }
                    model.can_use_card = [dic integerForKey:@"can_use_card"];
                    [modelArray addObject:model];
                    
                    ClothesFroPay *model1 = [[ClothesFroPay alloc] init];
                    model1.clothesImage = [dic stringForKey:@"goods_thumb"];
                    model1.clothesCount = [dic stringForKey:@"num"];
                    model1.clothesName = [dic stringForKey:@"goods_name"];
                    model1.clothesPrice = [dic stringForKey:@"price"];
                    model1.clotheMaxCount = [dic stringForKey:@"suk_num"];
                    if ([dic integerForKey:@"goods_type"] == 2) {
                        model1.clotheType = [dic stringForKey:@"size_content"];
                    } else {
                        model1.clotheType = @"定制款";
                    }
                    model1.can_use_card = [dic integerForKey:@"can_use_card"];
                    [clothesArray addObject:model1];
                    
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
    [self.view addSubview:bgNoDingView];
    
    UIImageView *NoDD = [UIImageView new];
    [bgNoDingView addSubview:NoDD];
    NoDD.sd_layout
    .centerXEqualToView(bgNoDingView)
    .topSpaceToView(bgNoDingView, 128)
    .widthIs(211)
    .heightIs(220);
    [NoDD setImage:[UIImage imageNamed:@"Mine_emptyBag"]];
  
    UIButton *clickToLookOther = [UIButton new];
    [bgNoDingView addSubview:clickToLookOther];
    
    clickToLookOther.sd_layout
    .centerXEqualToView(bgNoDingView)
    .topSpaceToView(NoDD, 20)
    .widthIs(80)
    .heightIs(35);
    [clickToLookOther.layer setCornerRadius:3];
    [clickToLookOther.layer setMasksToBounds:YES];
    [clickToLookOther addTarget:self action:@selector(goToLookClothes) forControlEvents:UIControlEventTouchUpInside];
    [clickToLookOther.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [clickToLookOther setBackgroundColor:[UIColor blackColor]];
    [clickToLookOther setTitle:@"去逛逛" forState:UIControlStateNormal];
    
    
    
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumLineSpacing = 0;
    //        flowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width, 0);//头部
    suggestCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(10, SCREEN_HEIGHT - (SCREEN_HEIGHT - 100) / 3, SCREEN_WIDTH - 20, (SCREEN_HEIGHT - 100) / 3) collectionViewLayout:flowLayout];
    
    //设置代理
    suggestCollection.delegate = self;
    suggestCollection.dataSource = self;
    [bgNoDingView addSubview:suggestCollection];
    
    suggestCollection.backgroundColor = [UIColor whiteColor];
    suggestCollection.layer.masksToBounds = NO;
   
    //注册cell和ReusableView（相当于头部）
    [suggestCollection registerClass:[mySavedClothesCollectionViewCell class] forCellWithReuseIdentifier:@"mysaveClothes"];
    [suggestCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    
    
}

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
    [cell setBackgroundColor:[UIColor whiteColor]];
    cell.model = suggestModelArray[indexPath.item];
    [cell sizeToFit];
    
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    
    return CGSizeMake((SCREEN_WIDTH - 30) / 2, (SCREEN_HEIGHT - 100) / 3);
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
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:suggestDataArray[indexPath.item]];
    [dic setObject:model.goodId forKey:@"id"];
   
    if ([model.type integerValue]== 1) {
        DiyClothesDetailViewController *toButy = [[DiyClothesDetailViewController alloc] init];

        toButy.goodDic = dic;
        [self.navigationController pushViewController:toButy animated:YES];
    } else {
//        DesignersClothesViewController *designerClothes = [[DesignersClothesViewController alloc] init];
//        designerClothes.imageUrl = model.clothesImg;
//        designerClothes.good_Id = model.goodId;
//        [self.navigationController pushViewController:designerClothes animated:YES];
        
        DesignerClothesDetailViewController *designerClothes = [[DesignerClothesDetailViewController alloc] init];
        designerClothes.goodDic = suggestDataArray[indexPath.item];
        //    designerClothes.model = model;
        designerClothes.good_id =model.goodId;
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
    [rightBarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBarBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
    [rightBarBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    hadClothesView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 9, SCREEN_WIDTH , SCREEN_HEIGHT - 64 - 9 - 49) style:UITableViewStylePlain];
    hadClothesView.delegate = self;
    hadClothesView.dataSource = self;
    [hadClothesView registerClass:[myBagTableViewCell class] forCellReuseIdentifier:@"clothesList"];
    [hadClothesView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    hadClothesView.showsVerticalScrollIndicator = NO;
    hadClothesView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [hadClothesView setBackgroundColor:getUIColor(Color_myOrderBack)];
//    hadClothesView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:hadClothesView];
}

-(void)createLowView
{
    lowBgView = [UIView new];
    [self.view addSubview:lowBgView];
    lowBgView.sd_layout
    .leftEqualToView(self.view)
    .bottomEqualToView(self.view)
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
    [allChoose setImage:[UIImage imageNamed:@"noChoose"] forState:UIControlStateNormal];
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



-(void)addCountClick:(UIButton *)sender
{
    
    myBagModel *model = modelArray[sender.tag - 5];
    model.clothesCount = [NSString stringWithFormat:@"%ld", [model.clothesCount integerValue] + 1];
    
    myBagModel *model1 = clothesArray[sender.tag - 5];
    model1.clothesCount = [NSString stringWithFormat:@"%ld", [model1.clothesCount integerValue] + 1];
    
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:model.bagId forKey:@"car_id"];
    [params setObject:model.clothesCount forKey:@"num"];
    [postData postData:URL_UpdateClothesCarNum PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
    }];
    
    [self reloadAllView];
    
}

-(void)cutCountClick:(UIButton *)sender
{
    myBagModel *model = modelArray[sender.tag - 500];
    myBagModel *model1 = clothesArray[sender.tag - 500];
    if ([model.clothesCount integerValue] > 1) {
         model.clothesCount = [NSString stringWithFormat:@"%ld", [model.clothesCount integerValue] - 1];
         model1.clothesCount = [NSString stringWithFormat:@"%ld", [model1.clothesCount integerValue] - 1];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:model.bagId forKey:@"car_id"];
        [params setObject:model.clothesCount forKey:@"num"];
        [postData postData:URL_UpdateClothesCarNum PostParams:params finish:^(BaseDomain *domain, Boolean success) {
            
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
    if (ifUpdate) {
        NSString *carIds;
        NSArray *modelTemp = [NSArray arrayWithArray:modelArray];
        NSArray *array = [NSArray arrayWithArray:chooseOrNot];
        for (int i = 0; i < [array count]; i ++) {
            myBagModel *model = modelTemp[i];
            if ([array[i] isEqualToString:@"yes"]) {
                if ([carIds length] > 0) {
                    carIds = [NSString stringWithFormat:@"%@,%@", carIds, model.bagId];
                } else {
                    carIds = model.bagId;
                }
            }
        }
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:carIds forKey:@"car_id"];
        [postData postData:URL_DeleteMyPayBag PostParams:params finish:^(BaseDomain *domain, Boolean success) {
            if ([self checkHttpResponseResultStatus:domain]) {
                [modelArray removeAllObjects];
                [chooseOrNot removeAllObjects];
                [clothesArray removeAllObjects];
                NSMutableDictionary *parms1 = [NSMutableDictionary dictionary];
                [getData getData:URL_MyPayBag PostParams:parms1 finish:^(BaseDomain *domain, Boolean success) {
                    if ([self checkHttpResponseResultStatus:getData]) {
                        
                        if ([[getData.dataRoot arrayForKey:@"data"] count] == 0) {
                            for (UIView *view in self.view.subviews) {
                                [view removeFromSuperview];
                            }
                            [self createViewNoDD];
                            [self.view setBackgroundColor:[UIColor whiteColor]];
                        } else {
                            [self.view setBackgroundColor:getUIColor(Color_myOrderBack)];
                            for (NSDictionary *dic in [getData.dataRoot arrayForKey:@"data"]) {
                                [chooseOrNot addObject:@"yes"];
                                myBagModel *model = [[myBagModel alloc] init];
                                model.clothesCount = [dic stringForKey:@"num"];
                                model.clothesImg = [dic stringForKey:@"goods_thumb"];
                                model.clothesName = [dic stringForKey:@"goods_name"];
                                model.clothesPrice = [dic stringForKey:@"price"];
                                model.bagId = [dic stringForKey:@"id"];
                                model.ifChoose = @"yes";
                                model.good_id = [dic stringForKey:@"goods_id"];
                                model.good_type = [dic stringForKey:@"goods_type"];
                                if ([dic integerForKey:@"goods_type"] == 2) {
                                    model.sizeOrDing = [dic stringForKey:@"size_content"];
                                } else {
                                    model.sizeOrDing = @"定制款";
                                }
                                [modelArray addObject:model];
                                
                                
                                ClothesFroPay *model1 = [[ClothesFroPay alloc] init];
                                model1.clothesImage = [dic stringForKey:@"goods_thumb"];
                                model1.clothesCount = [dic stringForKey:@"num"];
                                model1.clothesName = [dic stringForKey:@"goods_name"];
                                model1.clothesPrice = [dic stringForKey:@"price"];
                                model1.clotheMaxCount = [dic stringForKey:@"suk_num"];
                                if ([dic integerForKey:@"goods_type"] == 2) {
                                    model1.clotheType = [dic stringForKey:@"size_content"];
                                } else {
                                    model1.clotheType = @"定制款";
                                }
                                
                                [clothesArray addObject:model1];

                            }
                            
                            [self reloadAllView];
                        }
                    }
                }];
            }
        }];
    } else {
        NSString *carIds;
        NSArray *modelTemp = [NSArray arrayWithArray:modelArray];
        NSArray *array = [NSArray arrayWithArray:chooseOrNot];
        NSMutableArray *arrClothes = [NSMutableArray array];
        for (int i = 0; i < [array count]; i ++) {
            myBagModel *model = modelTemp[i];
            if ([array[i] isEqualToString:@"yes"]) {
                [arrClothes addObject:clothesArray[i]];
                if ([carIds length] > 0) {
                    carIds = [NSString stringWithFormat:@"%@,%@", carIds, model.bagId];
                } else {
                    carIds = model.bagId;
                    
                    
                }
            }
        }
        PayForClothesViewController *pay = [[PayForClothesViewController alloc] init];
        pay.carId = carIds;
        pay.arrayForClothes = arrClothes;
        pay.allPrice = [choosePrice.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
        [self.navigationController pushViewController:pay animated:YES];
        
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!ifUpdate) {
        myBagModel *model = modelArray[indexPath.row];
        if ([model.good_type integerValue] == 2) {
            DesignerClothesDetailViewController *toBuy = [[DesignerClothesDetailViewController alloc] init];
            toBuy.good_id = model.good_id;
            
            [self.navigationController pushViewController:toBuy animated:YES];
        } else {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:model.bagId forKey:@"car_id"];
            [params setObject:@"5" forKey:@"phone_type"];
            [getData getData:URL_GetBagDingZhiDetail PostParams:params finish:^(BaseDomain *domain, Boolean success) {
                if ([self checkHttpResponseResultStatus:domain]) {
                    DingZhiForBagViewController *dingzhiBag = [[DingZhiForBagViewController alloc] init];
                    dingzhiBag.dataDic =[NSMutableDictionary dictionaryWithDictionary:[getData.dataRoot dictionaryForKey:@"data"]];
                    [self.navigationController pushViewController:dingzhiBag animated:YES];
                }
            }];
        }
    }
    
    
    
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
            pirce = pirce + [model.clothesPrice floatValue] * [model.clothesCount integerValue];
            count ++;
        }
    }
    [choosePrice setText:[NSString stringWithFormat:@"¥%.2f",pirce]];
    [chooseCount setText:[NSString stringWithFormat:@"已选(%ld)", count]];
    if (count == [chooseOrNot count]) {
        [allChoose setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
        ifAllChoose = 1;
    } else {
       
        [allChoose setImage:[UIImage imageNamed:@"noChoose"] forState:UIControlStateNormal];
        ifAllChoose = 0;
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
        // Delete the row from the data source.
        [self reloadAllView];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:model.bagId forKey:@"car_id"];
        [postData postData:URL_DeleteMyPayBag PostParams:params finish:^(BaseDomain *domain, Boolean success) {
            if ([self checkHttpResponseResultStatus:domain]) {
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
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
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
