//
//  colorChooseTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/28.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "colorChooseTableViewCell.h"
#import "colorChooseCollectionViewCell.h"
@implementation colorChooseTableViewCell

{
    UICollectionView *color;
    NSInteger flog;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        flog = 0;
        
        [self setUp];
        
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [color reloadData];
}

-(void)setUp
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //  [flowLayout setMinimumLineSpacing:15];
    //  [flowLayout setMinimumInteritemSpacing:43];
    //  flowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width, 0);//头部
    color = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 12, SCREEN_WIDTH - 20,  (SCREEN_WIDTH - 60) / 4) collectionViewLayout:flowLayout];
    //设置代理
    color.delegate = self;
    color.dataSource = self;
    [self.contentView addSubview:color];
    color.backgroundColor = [UIColor whiteColor];
    color.showsHorizontalScrollIndicator = NO;
    //注册cell和ReusableView（相当于头部）
    [color registerClass:[colorChooseCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [color registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_colorArray count];
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
    colorChooseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell.colorImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [_colorArray[indexPath.item] stringForKey:@"img"]]]];
    [cell.colorName setText:[_colorArray[indexPath.item] stringForKey:@"name"]];
    if (indexPath.item == flog) {
        [cell.colorChoose setHidden:NO];
        [cell.colorChoose setImage:[UIImage imageNamed:@"JuXC"]];
    } else {
        [cell.colorChoose setHidden:YES];
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
    return CGSizeMake((SCREEN_WIDTH - 60) / 4,(SCREEN_WIDTH - 60)  / 4);
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
    [color reloadData];
    if ([_delegate respondsToSelector:@selector(colorClick:)]) {
        [_delegate colorClick:indexPath.item];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
