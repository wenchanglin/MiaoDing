//
//  changeDiySecondViewController.m
//  CategaryShow
//
//  Created by 文长林 on 2018/12/29.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import "changeDiySecondViewController.h"
#import "DiyClothesDetailViewController.h"
#import "changeDiyCollectionViewCell.h"
#import "chageDiyModel.h"
#import "DesignerClothesDetailViewController.h"
#import "JYHNavigationController.h"
@interface changeDiySecondViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation changeDiySecondViewController
{
    UICollectionView *clothesCollection;
    UIButton *seleBtn;
    UIView *titleView;
    UIView *lineView;
    
    NSMutableArray *detailArray;
    NSInteger page;
    NSMutableArray *modelArray;
    BOOL isfanhui;
    NSInteger FLFlog;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];

}
-(void)viewWillDisappear:(BOOL)animated
{
    if (isfanhui) {
        [clothesCollection mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo([ShiPeiIphoneXSRMax isIPhoneX]?123:99);
            make.left.right.equalTo(self.view);
            make.bottom.mas_equalTo([ShiPeiIphoneXSRMax isIPhoneX]?-84:-49);
        }];
    }
   
}

-(void)viewDidAppear:(BOOL)animated
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:getUIColor(Color_clothDiyBack)];
    modelArray = [NSMutableArray array];
    detailArray=[NSMutableArray array];
    isfanhui=NO;
    page = 1;
    FLFlog = 0;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shezhiFrame) name:@"fangun" object:nil];
    [self getDatas];

   
}
-(void)shezhiFrame
{
//    isfanhui=NO;
    
    [clothesCollection mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NavHeight);
        make.left.right.bottom.equalTo(self.view);
    }];
}


-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(self.shopID) forKey:@"use_goodsid"];
    [params setObject:self.feileiString forKey:@"goods_name"];
    [params setObject:@(page) forKey:@"page"];
    [[wclNetTool sharedTools]request:POST urlString:URL_GetDingZhiDetail parameters:params finished:^(id responseObject, NSError *error) {
//        WCLLog(@"%@",responseObject);
        [clothesCollection.mj_header endRefreshing];
        if ([self checkHttpResponseResultStatus:responseObject]) {
            [modelArray removeAllObjects];
            [detailArray removeAllObjects];
            [clothesCollection removeFromSuperview];
            detailArray = [responseObject[@"goodsid"]mutableCopy];
            modelArray = [chageDiyModel mj_objectArrayWithKeyValuesArray:responseObject[@"goodsid"]];
            [self viewCreate];
        }
    }];
    
}

-(void)viewCreate
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumLineSpacing = 0;
    clothesCollection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    //设置代理
    clothesCollection.delegate = self;
    clothesCollection.dataSource = self;
    clothesCollection.showsVerticalScrollIndicator = NO;
    [self.view addSubview:clothesCollection];
    [clothesCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NavHeight);
        make.left.right.bottom.equalTo(self.view);
    }];
    clothesCollection.backgroundColor = [UIColor whiteColor];//[UIColor colorWithHexString:@"#EDEDED"];
    [clothesCollection registerClass:[changeDiyCollectionViewCell class] forCellWithReuseIdentifier:@"changecell"];
    [WCLMethodTools headerRefreshWithTableView:clothesCollection completion:^{
        page=1;
       
        if (isfanhui) {
            [clothesCollection mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo([ShiPeiIphoneXSRMax isIPhoneX]?123:99);
                make.left.right.equalTo(self.view);
                make.bottom.mas_equalTo([ShiPeiIphoneXSRMax isIPhoneX]?-84:-49);

            }];
            [self headgetDatas];
            
        }
        else
        {

            [self getDatas];
        }
    }];
    [WCLMethodTools footerAutoGifRefreshWithTableView:clothesCollection completion:^{
        [self reloadAddData];
    }];
}
-(void)headgetDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(self.shopID) forKey:@"use_goodsid"];
    [params setObject:self.feileiString forKey:@"goods_name"];
    [params setObject:@(page) forKey:@"page"];
    [[wclNetTool sharedTools]request:POST urlString:URL_GetDingZhiDetail parameters:params finished:^(id responseObject, NSError *error) {
        //        WCLLog(@"%@",responseObject);
        [clothesCollection.mj_header endRefreshing];
        if ([self checkHttpResponseResultStatus:responseObject]) {
            [modelArray removeAllObjects];
            [detailArray removeAllObjects];
//            [clothesCollection removeFromSuperview];
            detailArray = [responseObject[@"goodsid"]mutableCopy];
            modelArray = [chageDiyModel mj_objectArrayWithKeyValuesArray:responseObject[@"goodsid"]];
//            [self viewCreate];
            [clothesCollection reloadData];
        }
    }];
    
}

-(void)reloadAddData
{
    page ++;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(self.shopID) forKey:@"use_goodsid"];
    [params setObject:self.feileiString forKey:@"goods_name"];
    [params setObject:@(page) forKey:@"page"];
    [[wclNetTool sharedTools]request:POST urlString:URL_GetDingZhiDetail parameters:params finished:^(id responseObject, NSError *error) {
        //        WCLLog(@"%@",responseObject);
        [clothesCollection.mj_footer endRefreshing];
        if([self checkHttpResponseResultStatus:responseObject])
        {
            NSMutableArray*arr = [chageDiyModel mj_objectArrayWithKeyValuesArray:responseObject[@"goodsid"]];
            [detailArray addObjectsFromArray:responseObject[@"goodsid"]];
            [modelArray addObjectsFromArray:arr];
            [clothesCollection reloadData];
        }
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
    changeDiyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"changecell" forIndexPath:indexPath];
    cell.itemIdex = indexPath.item;
    chageDiyModel *model = modelArray[indexPath.item];
    cell.model = model;
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH / 2 - 6, (SCREEN_WIDTH / 2 - 6)+73.8);//
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
    DiyClothesDetailViewController *toButy = [[DiyClothesDetailViewController alloc] init];
    JYHNavigationController *nav = [[JYHNavigationController alloc]initWithRootViewController:toButy];
    toButy.goodDic = [NSMutableDictionary dictionaryWithDictionary:detailArray[indexPath.item]];
    toButy.vcString = @"changeDiySecondViewController";
    isfanhui=YES;
    [self presentViewController:nav animated:NO completion:nil];//tobuy

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
