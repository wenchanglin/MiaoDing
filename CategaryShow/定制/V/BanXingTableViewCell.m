//
//  BanXingTableViewCell.m
//  CategaryShow
//
//  Created by 文长林 on 2018/3/11.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import "BanXingTableViewCell.h"
#import "positionCollectionViewCell.h"
@implementation BanXingTableViewCell
{
    UICollectionView *banxing;
    NSInteger flog;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        flog = 0;
        _banXingArray = [NSMutableArray array];
        [self setUp];
        
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [banxing reloadData];
}

-(void)setUp
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //    [flowLayout setMinimumLineSpacing:15];
    //    [flowLayout setMinimumInteritemSpacing:43];
    //        flowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width, 0);//头部
    banxing = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 12, SCREEN_WIDTH - 20,  (SCREEN_WIDTH - 60) / 4-10) collectionViewLayout:flowLayout];
    
    //设置代理
    banxing.delegate = self;
    banxing.dataSource = self;
    [self.contentView addSubview:banxing];
    banxing.backgroundColor = [UIColor whiteColor];
    //注册cell和ReusableView（相当于头部）
    
    [banxing registerClass:[positionCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
//    [banxing registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_banXingArray count];
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    positionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell.positionImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [_banXingArray[indexPath.item] stringForKey:@"img_min"]]]];
//    [cell.nameLabel setText:[_banXingArray[indexPath.item] stringForKey:@"name"]];
//    cell.backgroundColor = [UIColor cyanColor];
    [cell sizeToFit];
    
    if (indexPath.item == flog) {
        [cell.chooseImage  setImage:[UIImage imageNamed:@"JuXC"]];
    } else {
        [cell.chooseImage  setImage:[UIImage imageNamed:@"JuX"]];
    }

    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake((SCREEN_WIDTH - 60) / 4+10,(SCREEN_WIDTH - 60)  / 4-10);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0,0, 0);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    flog = indexPath.item;
    [banxing reloadData];
    
    if ([_delegate respondsToSelector:@selector(banXingClick:)]) {
        [_delegate banXingClick:indexPath.item];
    }
}
@end
