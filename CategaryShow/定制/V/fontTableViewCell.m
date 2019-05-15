    //
//  fontTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/28.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "fontTableViewCell.h"
#import "newDiyAllDataModel.h"
#import "fontChooseCollectionViewCell.h"
@implementation fontTableViewCell
{
    UICollectionView *font;
    NSInteger flog;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        flog=0;
        _fontArray = [NSMutableArray array];
        [self setUp];

    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [font reloadData];
}

-(void)setUp
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    font = [[UICollectionView alloc]initWithFrame:CGRectMake(0, -10, SCREEN_WIDTH,  (SCREEN_WIDTH - 60) / 4+35) collectionViewLayout:flowLayout];
    //设置代理
    font.delegate = self;
    font.dataSource = self;
    [self.contentView addSubview:font];
    font.backgroundColor = [UIColor whiteColor];
    font.showsHorizontalScrollIndicator = NO;
    //注册cell和ReusableView（相当于头部）
    [font registerClass:[fontChooseCollectionViewCell class] forCellWithReuseIdentifier:@"fontChooseCollectionViewCell"];
    [font registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_fontArray count];
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"fontChooseCollectionViewCell";
    threeDataModel*model = _fontArray[indexPath.item];
    fontChooseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell.fontImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model.part_img]]];
    [cell.fontLabel setText:model.part_name];
    if (indexPath.item == flog) {
        [cell.fontChoose setHidden:NO];
        [cell.fontChoose setImage:[UIImage imageNamed:@"fontChoose"]];
    } else {
        [cell.fontChoose setHidden:YES];
    }
    [cell sizeToFit];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake(self.frame.size.width / 2-61,62);
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
    [font reloadData];
    if ([_delegate respondsToSelector:@selector(fontChoose:)]) {
        [_delegate fontChoose:indexPath.item];
    }
}

@end
