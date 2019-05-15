//
//  XingTiDataViewController.m
//  CategaryShow
//
//  Created by 文长林 on 2019/4/30.
//  Copyright © 2019 Mr.huang. All rights reserved.
//

#import "XingTiDataViewController.h"
#import "myXingTiDatasCollectionCell.h"
#import "LiangTiOneRowReusableView.h"
#import "LiangTiTwoRowReusableView.h"
@interface XingTiDataViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UIImageView*headImageView;
@property(nonatomic,strong)UILabel*noteLabel1;
@end

@implementation XingTiDataViewController
{
    UICollectionView *clothesCollection;
    NSMutableArray *modelArray;
    NSString*haveRecommand;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    modelArray =[NSMutableArray array];
    [self settabTitle:@"形体数据"];
    [self getDatas];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)createCollectionView
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
        make.edges.equalTo(self.view);
    }];
    clothesCollection.backgroundColor = [UIColor whiteColor];//[UIColor colorWithHexString:@"#EDEDED"];
    [clothesCollection registerClass:[myXingTiDatasCollectionCell class] forCellWithReuseIdentifier:@"myXingTiDatasCollectionCell"];
    [clothesCollection registerClass:[LiangTiOneRowReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"oneHeader"];
    [clothesCollection registerClass:[LiangTiTwoRowReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"twoFooter"];

}
-(void)getDatas
{
    [[wclNetTool sharedTools]request:GET urlString:[MoreUrlInterface URL_XingTiDatas_String] parameters:@{}.mutableCopy finished:^(id responseObject, NSError *error) {
//        WCLLog(@"%@",responseObject);
        if ([self checkHttpResponseResultStatus:responseObject]) {
            haveRecommand = responseObject[@"recommend"];
            if ([responseObject[@"data"]count]>1) {
                modelArray = [responseObject[@"data"]mutableCopy];
                if (!clothesCollection) {
                    [self createCollectionView];
                }
                else
                {
                    [clothesCollection reloadData];
                }
            }
            else
            {
                [clothesCollection removeFromSuperview];
                [self createNOView];
            }
        }
    }];
}
-(void)createNOView
{
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY).offset(-60);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(81);
        make.width.mas_equalTo(102);
    }];
    [self.noteLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView.mas_bottom).offset(30);
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-35);
    }];
}
-(UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [UIImageView new];
        _headImageView.contentMode=UIViewContentModeScaleAspectFill;
        _headImageView.layer.masksToBounds=YES;
        _headImageView.image=[UIImage imageNamed:@"xingtiplace"];
        [self.view addSubview:_headImageView];
    }
    return _headImageView;
}
-(UILabel *)noteLabel1
{
    if (!_noteLabel1) {
        _noteLabel1= [UILabel new];
        _noteLabel1.textAlignment=NSTextAlignmentCenter;
        _noteLabel1.font=[UIFont systemFontOfSize:11];
        _noteLabel1.text =@"根据您的形体数据，未找到合适的成衣，请尝试妙定量体定制";
        _noteLabel1.textColor = [UIColor colorWithHexString:@"#7E818C"];
        [self.view addSubview:_noteLabel1];
    }
    return _noteLabel1;
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
    myXingTiDatasCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myXingTiDatasCollectionCell" forIndexPath:indexPath];
    NSString*keys = [modelArray[indexPath.item]stringForKey:@"key"];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@：",keys];
    NSString*values = [modelArray[indexPath.item]stringForKey:@"value"];
    if ([keys hasPrefix:@"体"]) {
        cell.valueLabel.text = [NSString stringWithFormat:@"%@kg",values];
    }
    else
    {
    cell.valueLabel.text = [NSString stringWithFormat:@"%@cm",values];
    }

    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (haveRecommand.length<1) {
            return CGSizeMake(SCREEN_WIDTH, 222);
        }
        else
        {
            return CGSizeZero;
        }
    }else{
        return CGSizeZero;
    }
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        if (haveRecommand.length>1) {
            return CGSizeMake(SCREEN_WIDTH, 200);
        }
        else
        {
        return CGSizeZero;
        }
    }else{
        return CGSizeZero;
    }
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *supplementaryView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        LiangTiOneRowReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"oneHeader" forIndexPath:indexPath];
        if(modelArray.count>1)
        {
            headerView.noteLabel2.hidden=NO;
        }
        else
        {
            headerView.noteLabel2.hidden=YES;
        }
        supplementaryView=headerView;
    }
    else
    {
        LiangTiTwoRowReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"twoFooter" forIndexPath:indexPath];
        NSArray*arr =[haveRecommand componentsSeparatedByString:@"/"];
        [headerView.firstBtn setTitle:[arr firstObject] forState:UIControlStateNormal];
        [headerView.twoBtn setTitle:[arr lastObject] forState:UIControlStateNormal];
        supplementaryView=headerView;

    }
    return supplementaryView;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH / 2 - 6, 45);
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
