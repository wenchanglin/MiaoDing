//
//  clothesForSaveViewController.m
//  CategaryShow
//
//  Created by APPLE on 16/8/31.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "clothesForSaveViewController.h"
#import "mySavedModel.h"
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
    BaseDomain *getData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //我的收藏-商品
    getData = [BaseDomain getInstance:NO];
    page =1;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    modelArray = [NSMutableArray array];
    
    
    [self createGetData];
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
    [params setObject:@"2" forKey:@"type"];
    [params setObject:@(page) forKey:@"page"];
    [getData getData:URL_SaveList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:getData]) {
            [haveSaveCollection.mj_footer endRefreshing];
            [haveSaveCollection.mj_header endRefreshing];
            if ([[getData.dataRoot arrayForKey:@"data"] count] == 0&&page==1) {
                [haveSaveTable removeFromSuperview];
                [self createNoSave];
            }
            else if ([[getData.dataRoot arrayForKey:@"data"] count] == 0&&page!=1)
            {
                [haveSaveCollection.mj_footer endRefreshingWithNoMoreData];
                [haveSaveCollection reloadData];
            }
            else {
                for (NSDictionary *dis in [getData.dataRoot arrayForKey:@"data"] ) {
                    mySavedModel *model = [[mySavedModel alloc] init];
                    model.clothesPrice = [dis stringForKey:@"price2"];
                    model.clothesName = [dis stringForKey:@"name"];
                    model.clothesImg = [dis stringForKey:@"thumb"];
                    model.goodId = [dis stringForKey:@"cid"];
                    model.type = [dis stringForKey:@"goods_type"];
                    model.subName = [dis stringForKey:@"sub_name"];
                    [modelArray addObject:model];
                }
                
                [haveSaveTable reloadData];
            }
            
        }
        
    }];
    
}

-(void)createGetData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"2" forKey:@"type"];
    [params setObject:@"1" forKey:@"page"];
    [getData getData:URL_SaveList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:getData]) {
            [haveSaveCollection.mj_header endRefreshing];

            if ([[getData.dataRoot arrayForKey:@"data"] count] == 0) {
                [self createNoSave];
            } else {
                [modelArray removeAllObjects];
                for (NSDictionary *dis in [getData.dataRoot arrayForKey:@"data"] ) {
                    mySavedModel *model = [[mySavedModel alloc] init];
                    model.clothesPrice = [dis stringForKey:@"price2"];
                    model.clothesName = [dis stringForKey:@"name"];
                    model.clothesImg = [dis stringForKey:@"thumb"];
                    model.goodId = [dis stringForKey:@"cid"];
                    model.type = [dis stringForKey:@"goods_type"];
                    model.subName = [dis stringForKey:@"sub_name"];
                    [modelArray addObject:model];
                }
                
                [self createHaveSave];
            }
            
        }
        
    }];
}

-(void)createNoSave
{
   UIView *bgNoDingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
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

//-(void)createHaveSave
//{
//    haveSaveTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50) style:UITableViewStyleGrouped];
//    if (@available(iOS 11.0, *)) {
//        haveSaveTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
//
//    haveSaveTable.delegate = self;
//    haveSaveTable.dataSource = self;
//    [haveSaveTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    [haveSaveTable registerClass:[saveTableViewCell class] forCellReuseIdentifier:@"save"];
//    [self.view addSubview:haveSaveTable];
//}

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return [modelArray count];
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 1;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 104;
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    saveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"save" forIndexPath:indexPath];
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    cell.model = modelArray[indexPath.section];
//    return cell;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0.001;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return [[UIView alloc] init];
//}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    return [[UIView alloc] init];
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 8;
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    mySavedModel *model = modelArray[indexPath.section];
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        [dic setObject:model.goodId forKey:@"id"];
//        [dic setObject:model.clothesName forKey:@"name"];
//        [dic setObject:model.clothesImg forKey:@"thumb"];
//        [dic setObject:model.type forKey:@"type"];
//        if ([model.type integerValue]== 1) {
//
//            DiyClothesDetailViewController *toButy = [[DiyClothesDetailViewController alloc] init];
//            toButy.goodDic =dic;
//            [self.navigationController pushViewController:toButy animated:YES];
//
//        } else {
//            DesignerClothesDetailViewController *designerClothes = [[DesignerClothesDetailViewController alloc] init];
//            designerClothes.good_id = model.goodId;
//
//            [self.navigationController pushViewController:designerClothes animated:YES];
//
//        }
//}

-(void)createHaveSave
{
    UICollectionViewFlowLayout *flowLayout1=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout1 setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout1.minimumLineSpacing = 0;
    //        flowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width, 0);//头部
    haveSaveCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH , SCREEN_HEIGHT - 64 - 49) collectionViewLayout:flowLayout1];
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
    NSMutableArray *headerImages = [NSMutableArray array];
    for (int i = 1; i <= 60; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
        [headerImages addObject:image];
    }
    __weak clothesForSaveViewController *weakSelf = self;

    MJRefreshGifHeader * header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf createGetData];
        });
        
    }];
    header.stateLabel.hidden = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setImages:@[headerImages[0]] forState:MJRefreshStateIdle];
    [header setImages:headerImages duration:1 forState:MJRefreshStateRefreshing];
    haveSaveCollection.mj_header = header;
    MJRefreshAutoGifFooter * footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            page += 1;
            [weakSelf reloadData];
            
        });
    }];
    footer.stateLabel.hidden =YES;
    footer.refreshingTitleHidden = YES;
    [footer setImages:@[headerImages[0]] forState:MJRefreshStateIdle];
    [footer setImages:headerImages duration:1 forState:MJRefreshStateRefreshing];
    haveSaveCollection.mj_footer = footer;
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
    cell.model = modelArray[indexPath.item];
    [cell sizeToFit];

    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    
    return CGSizeMake(SCREEN_WIDTH / 2-6 , 266);//-6
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
    mySavedModel *model = modelArray[indexPath.item];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:model.goodId forKey:@"id"];
    [dic setObject:model.clothesName forKey:@"name"];
    [dic setObject:model.clothesImg forKey:@"thumb"];
    [dic setObject:model.type forKey:@"type"];
    if ([model.type integerValue]== 1) {
//        ToBuyCompanyClothes_SecondPlan_ViewController *toBuy = [[ToBuyCompanyClothes_SecondPlan_ViewController alloc] init];
//        toBuy.goodDic = dic;
//        [self.navigationController pushViewController:toBuy animated:YES];
        
        DiyClothesDetailViewController *toButy = [[DiyClothesDetailViewController alloc] init];
        toButy.goodDic =dic;
        [self.navigationController pushViewController:toButy animated:YES];
        
    } else {
        
//        DesignersClothesViewController *designerClothes = [[DesignersClothesViewController alloc] init];
//        designerClothes.imageUrl = model.clothesImg;
//        designerClothes.good_Id = model.goodId;
//        [self.navigationController pushViewController:designerClothes animated:YES];
        
//        designerModel *dmodel = [[designerModel alloc] init];
//        dmodel.clothesImage = [dic stringForKey:@"img"];
//        dmodel.titlename = [dic stringForKey:@"name"];
//        dmodel.good_Id = [dic stringForKey:@"goods_id"];
//        dmodel.desginer_Id = [dic stringForKey:@"uid"];
//        dmodel.detailClothesImg = [dic stringForKey:@"thumb"];
//        dmodel.designerHead = [dic stringForKey:@"avatar"];
//        dmodel.remark = [dic stringForKey:@"remark"];
//        dmodel.designerName = [dic stringForKey:@"username"];
//        dmodel.p_time = [dic stringForKey:@"p_time"];
//        dmodel.tag = [dic stringForKey:@"tag"];
//        dmodel.introduce = [dic stringForKey:@"introduce"];
        
        
        DesignerClothesDetailViewController *designerClothes = [[DesignerClothesDetailViewController alloc] init];
        designerClothes.good_id = model.goodId;
        
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
