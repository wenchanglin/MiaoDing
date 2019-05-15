//
//  clothesForSaveViewController.m
//  CategaryShow
//
//  Created by APPLE on 16/8/31.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "clothesForSaveViewController.h"
#import "myCollectModel.h"
#import "mySavedClothesCollectionViewCell.h"
#import "ToBuyCompanyClothes(SecondPlan)ViewController.h"
#import "DesignersClothesViewController.h"
#import "DiyClothesDetailViewController.h"
#import "DesignerClothesDetailViewController.h"
#import "saveTableViewCell.h"
@interface clothesForSaveViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>//<UITableViewDelegate, UITableViewDataSource>

@end

@implementation clothesForSaveViewController
{
    UITableView *haveSaveTable;
    UICollectionView *haveSaveCollection;
    NSMutableArray *modelArray;
    NSInteger page;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //我的收藏-商品
    page =1;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    modelArray = [NSMutableArray array];
    
    
    [self createGetData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    if (haveSaveTable) {
         [self reloadData];
    }
   
}

-(void)reloadData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(MyCollectTypeShopping) forKey:@"type"];
    [params setObject:@(page) forKey:@"page"];
    [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_MyCollect_String] parameters:params finished:^(id responseObject, NSError *error) {
        [haveSaveCollection.mj_footer endRefreshing];
        if ([self checkHttpResponseResultStatus:responseObject]) {
                NSMutableArray*arr = [myCollectModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"collections"]];
                [modelArray addObjectsFromArray:arr];
                [haveSaveCollection reloadData];
        }
    }];
}

-(void)createGetData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(MyCollectTypeShopping)forKey:@"type"];
    [params setObject:@"1" forKey:@"page"];
    [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_MyCollect_String] parameters:params finished:^(id responseObject, NSError *error) {
        if ([self checkHttpResponseResultStatus:responseObject]) {
            if ([responseObject[@"data"][@"collections"]count]>0) {
                modelArray= [myCollectModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"collections"]];
                [self createHaveSave];

            }
            else
            {
                [haveSaveTable removeFromSuperview];
                [self createNoSave];
            }
        }
    }];

}

-(void)createNoSave
{
   UIView *bgNoDingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgNoDingView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgNoDingView];
    
    UIImageView *NoDD = [UIImageView new];
    [bgNoDingView addSubview:NoDD];
    NoDD.sd_layout
    .centerXEqualToView(bgNoDingView)
    .topSpaceToView(bgNoDingView, (SCREEN_HEIGHT - 64 - 50 ) / 2 - 110  - 35)
    .widthIs(211)
    .heightIs(220);
    [NoDD setImage:[UIImage imageNamed:@"haveNoSave"]];
    
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

    
}

-(void)goToLookClothes
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LookClothes" object:nil];
}

-(void)createHaveSave
{
    UICollectionViewFlowLayout *flowLayout1=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout1 setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout1.minimumLineSpacing = 0;
    //        flowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width, 0);//头部
    haveSaveCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH , [ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT  - 88 - 60:SCREEN_HEIGHT  - 64 - 40) collectionViewLayout:flowLayout1];
    if (@available(iOS 11.0, *)) {
        haveSaveCollection.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    haveSaveCollection.showsHorizontalScrollIndicator = NO;
    //设置代理
    haveSaveCollection.delegate = self;
    haveSaveCollection.dataSource = self;
    [self.view addSubview:haveSaveCollection];
    haveSaveCollection.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    //注册cell和ReusableView（相当于头部）
    
    [haveSaveCollection registerClass:[mySavedClothesCollectionViewCell class] forCellWithReuseIdentifier:@"mysaveClothes"];
    [haveSaveCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    [WCLMethodTools footerAutoGifRefreshWithTableView:haveSaveCollection completion:^{
        page +=1;
        [self reloadData];
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [modelArray count];
    
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
    [cell setBackgroundColor:[UIColor colorWithHexString:@"#EDEDED"]];
    cell.model2 = modelArray[indexPath.item];
    [cell sizeToFit];

    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH / 2-6 , (SCREEN_WIDTH / 2 - 6)+73.8);//-6
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
    myCollectModel *model = modelArray[indexPath.item];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(model.rid) forKey:@"id"];
    [dic setObject:model.name forKey:@"name"];
    [dic setObject:model.img forKey:@"thumb"];
    [dic setObject:@(model.type) forKey:@"type"];
    if (model.goods_type == 1) {
        DiyClothesDetailViewController *toButy = [[DiyClothesDetailViewController alloc] init];
        toButy.goodDic =dic;
        [self.navigationController pushViewController:toButy animated:YES];
    } else {
        DesignerClothesDetailViewController *designerClothes = [[DesignerClothesDetailViewController alloc] init];
        designerClothes.good_id = [NSString stringWithFormat:@"%@",@(model.rid)];
        [self.navigationController pushViewController:designerClothes animated:YES];

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
